class ImportsController < ApplicationController

  def example
    send_data csv_example , filename: t("import.example_filename")
  end

  private
    def csv_example
      # TODO this is a mock, move this to model and implement properly
      ['name', 'description', 'tags', 'contacts', 'additional_info'].join(',')
    end
end
