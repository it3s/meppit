class ImportsController < ApplicationController

  before_action :require_login,   except: [:example]
  before_action :find_import,     only:   [:edit]
  before_action :is_current_user, only:   [:edit]


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
    send_data example_csv , filename: t("import.example_filename")
  end

  private

    def example_csv
      values = Import.csv_headers.map { |key| t "import.example_value.#{key}" }
      "#{ Import.csv_headers.join(',') }\n#{ values.join(',') }"
    end

    def import_params
      {source: params[:import][:source], user: current_user}
    end

    def find_import
      @import = Import.find params[:id]
    end

    def is_current_user
      redirect_to(root_path, notice: t('access_denied')) if @import.user != current_user
    end

end
