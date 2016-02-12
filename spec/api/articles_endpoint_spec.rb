require 'rails_helper'

describe Api::Endpoint::Articles do
  def app
    Api::Base
  end

  let(:admin) { create(:admin) }
  let(:writer) { create(:writer) }
  let(:admin_article) { create(:article, user: admin) }
  let(:writer_article) { create(:article, user: writer) }
  let(:new_article_params) { attributes_for(:article) }

  context 'as guest' do
    it 'should return list of articles' do
      2.times { create(:article, user: admin) }

      get 'api/articles'

      expect(response.successful?).to be_truthy
      expect(body.length).to eq(2)
    end

    it 'should not create new article' do
      post 'api/articles', new_article_params
      expect(response.client_error?).to be_truthy
    end

    it 'should get single article' do
      get "api/articles/#{admin_article.id}"

      expect(response.successful?).to be_truthy
      expect(body['title']).to eq(admin_article.title)
    end

    it 'should not update single article' do
      put "api/articles/#{admin_article.id}", new_article_params

      expect(response.client_error?).to be_truthy
    end

    it 'should not delete single article' do
      delete "api/articles/#{admin_article.id}"

      expect(response.client_error?).to be_truthy
    end
  end

  context 'as admin' do
    before(:each) do
      api_sign_in(admin)
    end

    it 'should get list of articles' do
      2.times { create(:article, user: admin) }

      get 'api/articles'

      expect(response.successful?).to be_truthy
      expect(body.length).to eq(2)
    end

    it 'should get single article' do
      get "api/articles/#{admin_article.id}"

      expect(response.successful?).to be_truthy
      expect(body['title']).to eq(admin_article.title)
    end

    it 'should create new article' do
      post 'api/articles', new_article_params

      expect(response.successful?).to be_truthy
      expect(body['title']).to eq(new_article_params[:title])
    end

    it 'should update single article' do
      put "api/articles/#{admin_article.id}", new_article_params

      expect(response.successful?).to be_truthy
      expect(body['title']).to eq(new_article_params[:title])
    end

    it 'should delete single article' do
      delete "api/articles/#{admin_article.id}"

      expect(response.successful?).to be_truthy
    end
  end

  context 'as writer' do
    before(:each) do
      api_sign_in(writer)
    end

    it 'should get list of articles' do
      2.times { create(:article, user: admin) }

      get 'api/articles'

      expect(response.successful?).to be_truthy
      expect(body.length).to eq(2)
    end

    it 'should get single article' do
      get "api/articles/#{admin_article.id}"

      expect(response.successful?).to be_truthy
      expect(body['title']).to eq(admin_article.title)
    end

    it 'should create single article' do
      post 'api/articles', new_article_params

      expect(response.successful?).to be_truthy
      expect(body['title']).to eq(new_article_params[:title])
    end

    it 'should update his own article' do
      put "api/articles/#{writer_article.id}", new_article_params

      expect(response.successful?).to be_truthy
      expect(body['title']).to eq(new_article_params[:title])
    end

    it 'should not update not his own article' do
      put "api/articles/#{admin_article.id}", new_article_params

      expect(response.server_error?).to be_truthy
    end

    it 'should delete his own article' do
      delete "api/articles/#{writer_article.id}"

      expect(response.successful?).to be_truthy
    end

    it 'should not delete not his own article' do
      delete "api/articles/#{admin_article.id}"

      expect(response.server_error?).to be_truthy
    end
  end
end