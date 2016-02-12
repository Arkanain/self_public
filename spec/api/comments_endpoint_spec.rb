require 'rails_helper'

describe Api::Endpoint::Comments do
  def app
    Api::Base
  end

  let(:admin) { create(:admin) }
  let(:writer) { create(:writer) }
  let(:article) { create(:article, user: writer) }
  let(:writer_comment) { create(:comment, user: writer, article: article) }
  let(:admin_comment) { create(:comment, user: admin, article: article) }
  let(:new_comment_params) { attributes_for(:comment) }

  context 'as guest' do
    it 'should not create comment' do
      post "api/articles/#{article.id}/comments", new_comment_params

      expect(response.client_error?).to be_truthy
    end

    it 'should not delete comment' do
      delete "api/articles/#{article.id}/comments/#{writer_comment.id}"

      expect(response.client_error?).to be_truthy
    end
  end

  context 'as admin' do
    before(:each) do
      api_sign_in(admin)
    end

    it 'should create comment' do
      post "api/articles/#{article.id}/comments", new_comment_params

      expect(response.successful?).to be_truthy
      expect(body.length).to eq(1)
      expect(body.last['text']).to eq(new_comment_params[:text])
      expect(body.last['user']['id']).to eq(admin.id)
    end

    it 'should delete comment' do
      delete "api/articles/#{article.id}/comments/#{writer_comment.id}"

      expect(response.successful?).to be_truthy
      expect(body.length).to eq(0)
    end
  end

  context 'as writer' do
    before(:each) do
      api_sign_in(writer)
    end

    it 'should create comment' do
      post "api/articles/#{article.id}/comments", new_comment_params

      expect(response.successful?).to be_truthy
      expect(body.length).to eq(1)
      expect(body.last['text']).to eq(new_comment_params[:text])
      expect(body.last['user']['id']).to eq(writer.id)
    end

    it 'should delete his own comment' do
      delete "api/articles/#{article.id}/comments/#{writer_comment.id}"

      expect(response.successful?).to be_truthy
      expect(body.length).to eq(0)
    end

    it 'should not delete not his own comment' do
      delete "api/articles/#{article.id}/comments/#{admin_comment.id}"

      expect(response.server_error?).to be_truthy
      expect(body.length).to eq(1)
    end
  end
end