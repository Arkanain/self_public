class ArticlesController < ApplicationController
  skip_before_filter :authenticate_user!, only: [:index]
  load_and_authorize_resource

  def create
    @article.user = current_user

    if @article.save
      redirect_to articles_path
    else
      render :new
    end
  end

  def update
    @article.update_attributes(params[:article])

    if @article.valid?
      redirect_to articles_path
    else
      render :edit
    end
  end

  def destroy
    respond_to do |format|
      format.js do
        @article.destroy

        @articles = Article.all

        render layout: false
      end
    end
  end
end