module Api
  module Endpoint
    class Comments < Api::Base
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
