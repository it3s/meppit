class TagsController < ApplicationController
  def search
    render :json => search_tags
  end

  private

    def search_tags
      Tag.search(params[:term]).map(&:tag)
    end
end
