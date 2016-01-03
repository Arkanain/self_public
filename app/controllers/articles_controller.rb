class ArticlesController < ApplicationController
  skip_before_filter :authenticate_user!
  load_resource

  def index
    @articles = Article.all
  end

  def create
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