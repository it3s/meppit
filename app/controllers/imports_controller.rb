class ImportsController < ApplicationController

  before_action :require_login, except: [:example]
  before_action :find_import,   only:   [:edit]

  def create
    @import = Import.new import_params

    if @import.valid? && @import.save
      render json: {redirect: edit_import_path(@import)}
    else
      render json: {errors: @import.errors.messages}, status: :unprocessable_entity
    end
  end

  def edit
  end

  def example
    send_data csv_example , filename: t("import.example_filename")
  end

  private

    def csv_example
      # TODO this is a mock, move this to model and implement properly
      ['name', 'description', 'tags', 'contacts', 'additional_info'].join(',')
    end

    def import_params
      {source: params[:import][:source], user: current_user}
    end

    def find_import
      @import = Import.find params[:id]
    end
end
