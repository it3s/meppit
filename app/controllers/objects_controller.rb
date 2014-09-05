class ObjectsController < ApplicationController
  before_action :find_object,              except: [:index, :new, :create, :search_by_name]
  before_action :build_instance,           only:   [:new, :create]
  before_action :validate_additional_info, only:   [:create, :update]

  def index
    instance_variable_set "@#{controller_name}_collection", object_collection
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
  end

  def create
    save_object current_object, cleaned_params
  end

  def show
  end

  def edit
  end

  def update
    save_object current_object, cleaned_params
  end

  def search_by_name
    search_result = model.search_by_name params[:term]
    render json: search_result.map { |obj| {value: obj.name, id: obj.id} }
  end

  protected

    def model
      controller_name.classify.constantize
    end

    def object_sym
      controller_name.singularize.underscore.to_sym
    end

    def current_object
      instance_variable_get "@#{object_sym}"
    end

    def find_object
      instance_variable_set "@#{object_sym}", model.find(params[:id])
    end

    def build_instance
      instance_variable_set "@#{object_sym}", model.new
    end

    def filters
      @filters ||= OpenStruct.new({
          sort_by:       params.fetch(:sort_by, 'name'),
          visualization: params.fetch(:visualization, 'list'),
        }.merge( params[:tags] ? {tags: params[:tags].split(',')} : {} )
      )
    end

    def object_collection
      qs = model
      qs = qs.with_tags filters.tags if filters.tags
      qs = qs.order filters.sort_by == 'created_at' ? 'created_at desc': filters.sort_by
      qs.page(params[:page]).per(params[:per])
    end

    def cleaned_params
      @cleaned_params ||= params.require(object_sym).permit(:name, :description).tap do |whitelisted|
        whitelisted[:contacts]  = cleaned_contacts params[object_sym]
        whitelisted[:tags] = cleaned_tags params[object_sym]
        whitelisted[:additional_info] = cleaned_additional_info params[object_sym]
        whitelisted[:relations_attributes] = cleaned_relations_attributes(params[object_sym]) if params[object_sym][:relations_attributes]
      end
    end

    def validate_additional_info
      unless cleaned_params[:additional_info].nil? || cleaned_params[:additional_info].is_a?(Hash)
        err = {additional_info: [I18n.t('additional_info.invalid')]}
        render json: {errors: err}, status: :unprocessable_entity
      end
    end

    def add_mapping_to(target_model)
      target_ref = target_model.name.underscore
      if target = target_model.find_by(id: params[target_ref.to_sym])
        _mapping, msg = create_mapping target
        count_method = :"#{target_ref.pluralize}_count"
        render json: {flash: flash_xhr(msg), count: current_object.send(count_method)}
      else
        msg = t("#{controller_name}.add_#{target_ref}.invalid")
        render json: {flash: flash_xhr(msg)}, status: :unprocessable_entity
      end
    end

    def create_mapping(target)
      add_method = :"add_#{target.class.name.underscore}"
      mapping = current_object.send add_method, target
      msg_type = mapping.id ? 'added' : 'exists'
      [mapping, t("#{controller_name}.#{add_method}.#{msg_type}", target: target.name)]
    end
end
