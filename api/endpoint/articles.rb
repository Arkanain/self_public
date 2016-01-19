module Api
  module Endpoint
    class Articles < Api::Base
      resource :articles do
        desc 'All articles list'
        get do
          present ::Article.all, with: Api::Entity::Article
        end

        desc 'Create new article'
        params do
          requires :title, type: String
          requires :text, type: String
        end

        post do
          authorized!

          new_params = permitted_attributes!(Api::Entity::Article)
          article = ::Article.create!(
            new_params.merge(user_id: current_user.id)
          )

          present article, with: Api::Entity::Article
        end

        desc 'Get single article'
        params do
          requires :id, type: Integer
        end

        get ':id' do
          present ::Article.find(params[:id]), with: Api::Entity::Article
        end

        desc 'Update article'
        params do
          requires :id, type: Integer
          requires :title, type: String
          requires :text, type: String
        end

        put ':id' do
          authorized!

          article = ::Article.find(params[:id])

          permission_denied!(article, :write)

          article.update!(
            permitted_attributes!(Api::Entity::Article)
          )

          present article, with: Api::Entity::Article
        end

        desc 'Delete article'
        params do
          requires :id, type: Integer
        end

        delete ':id' do
          authorized!

          article = ::Article.find(params[:id])

          permission_denied!(article, :write)

          article.destroy!

          { status: 'ok' }
        end

        route_param :article_id do
          resource :comments do
            desc 'Create comment'
            params do
              requires :text, type: String
            end

            post do
              article = ::Article.find(params[:article_id])

              new_params = permitted_attributes!(Api::Entity::Comment)
              article.comments << ::Comment.new(
                new_params.merge(user_id: current_user.id)
              )

              present article.comments, with: Api::Entity::Comment
            end

            desc 'Delete comment'
            params do
              requires :comment_id, type: Integer
            end

            delete ':comment_id' do
              article = ::Article.find(params[:article_id])
              article.comments.delete(params[:comment_id])

              present article.comments.reload, with: Api::Entity::Comment
            end
          end
        end
      end
    end
  end
end