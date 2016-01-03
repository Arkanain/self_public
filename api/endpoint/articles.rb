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
          requires :article, type: Hash do
            requires :title, type: String
            requires :text, type: String
          end
        end

        post do
          authorized!

          article = ::Article.create!(params[:article])

          present article
        end

        desc 'Update article'
        params do
          requires :id, type: Integer
          requires :article, type: Hash do
            optional :title, type: String
            optional :text, type: String
          end
        end

        put ':id' do
          authorized!

          article = ::Article.find(params[:id])

          permission_denied!(article, :write)

          article.update!(params[:article])
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
      end
    end
  end
end