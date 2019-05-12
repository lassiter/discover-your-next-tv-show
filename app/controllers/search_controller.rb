class SearchController < ApplicationController

  def search
    begin
      klass = Object.const_get(search_params["class"])
      case search_params["by"]
      when "slug"
        title = search_params["q"].split("-").join(" ")
        result = TvShow.where('title ILIKE ?', "%#{title}%").order(popularity: :desc).limit(1).first
        if result.nil?
          render json: { status: 404 }, status: :not_found
        else
          render json: Tmdb::TV.detail(result.id)
        end
      else
        render json: { status: 400, message: "By constraint does not exist" }, status: 400
      end
    rescue ActionController::ParameterMissing
      render json: { status: 400, message: "ParameterMissing" }, status: 400
    rescue NameError
      render json: { status: 400, message: "Class Name does not exist" }, status: 400
    end
  end

  private
  def search_params
    params.require(:q)
    params.require(:by)
    params.require(:class)
    params.permit(:q, :by, :class)
  end
end
