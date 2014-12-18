class ObjectsController < ApplicationController
  before_action :find_object,              except: [:index, :new, :create, :search_by_name]
  before_action :build_instance,           only:   [:new, :create]
  before_action :validate_additional_info, only:   [:create, :update]
  before_action :build_list_filter,        only:   [:index, :tile]

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

    def build_list_filter
      _filter_params = params.fetch(:list_filter, {})
      _filter_params[:tags] = _filter_params[:tags].split(',') if _filter_params[:tags]
      @list_filter = ListFilter.new _filter_params
    end

    def object_collection
      paginate @list_filter.filter(model)
    end

    def cleaned_params
      @cleaned_params ||= params.require(object_sym).permit(:name, :description).tap do |whitelisted|
        whitelisted[:contacts]  = cleaned_contacts params[object_sym]
        whitelisted[:tags] = cleaned_tags params[object_sym]
        whitelisted[:additional_info] = cleaned_additional_info params[object_sym]
        whitelisted[:relations_attributes] = cleaned_relations_attributes(params[object_sym]) if params[object_sym][:relations_attributes]
        whitelisted[:layers_attributes] = cleaned_layers_attributes(params[object_sym]) if params[object_sym][:layers_attributes]
        whitelisted[:location] = cleaned_location(params[object_sym]) if params[object_sym][:location]
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

    def remove_mapping_to(target_model)
      target_ref = target_model.name.underscore
      if target = target_model.find_by(id: params[target_ref.to_sym])
        _mapping, msg = delete_mapping target
        count_method = :"#{target_ref.pluralize}_count"
        render json: {flash: flash_xhr(msg), count: current_object.send(count_method)}
      else
        msg = t("#{controller_name}.remove_#{target_ref}.invalid")
        render json: {flash: flash_xhr(msg)}, status: :unprocessable_entity
      end
    end

    def create_mapping(target)
      add_method = :"add_#{target.class.name.underscore}"
      mapping = current_object.send add_method, target
      msg_type = mapping.id ? 'added' : 'exists'
      [mapping, t("#{controller_name}.#{add_method}.#{msg_type}", target: target.name)]
    end

    def delete_mapping(target)
      remove_method = :"remove_#{target.class.name.underscore}"
      mapping = current_object.send remove_method, target
      msg_type = 'removed'
      [mapping, t("#{controller_name}.#{remove_method}.#{msg_type}", target: target.name)]
    end
end
