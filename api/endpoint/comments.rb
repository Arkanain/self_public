module Api
  module Endpoint
    class Comments < Api::Base
      resource :comments do
        before do
          authorized!
        end

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
          comment = ::Comment.find(params[:comment_id])

          permission_denied!(comment, :write)

          comment.destroy!

          present article.comments, with: Api::Entity::Comment
        end
      end
    end
  end
end
