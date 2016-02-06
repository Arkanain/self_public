require 'rails_helper'

describe ArticlesController do
  let(:admin) { create(:admin) }
  let(:writer) { create(:writer) }
  let!(:article) { create(:article, user: admin) }

  context 'as guest' do
    it 'should get list of articles' do
      get :index

      expect(response).to render_template(:index)
      expect(assigns[:articles].length).to eq(1)
    end

    it 'should not create article' do
      post :create, article: attributes_for(:article)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'should not update article' do
      put :update, id: article, article: { title: 'Changed Title' }

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'should not delete article' do
      delete :destroy, id: article

      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context 'as admin' do
    before(:each) do
      sign_in(:user, admin)
    end

    it 'should get list of articles' do
      get :index

      expect(response).to render_template(:index)
      expect(assigns[:articles].length).to eq(1)
    end

    it 'should create article' do
      new_article = attributes_for(:article)
      post :create, article: new_article

      expect(assigns[:article].title).to eq(new_article[:title])
      expect(assigns[:article].user_id).to eq(admin.id)
      expect(response).to redirect_to(article_path(assigns[:article]))
    end

    it 'should update article' do
      put :update, id: article, article: { title: 'Changed Title' }

      expect(assigns[:article].title).to eq('Changed Title')
      expect(assigns[:article].user_id).to eq(admin.id)
      expect(response).to redirect_to(article_path(assigns[:article]))
    end

    it 'should delete article' do
      new_article = create(:article, user: admin)

      expect(Article.count).to eq(2)

      delete :destroy, id: new_article, format: :js

      expect(Article.count).to eq(1)
      expect(Article.first.title).to eq(article.title)
    end

    it 'should render new if params invalid' do
      new_article = attributes_for(:article).except(:title)
      post :create, article: new_article

      expect(response).to render_template(:new)
    end

    it 'should render edit if params invalid' do
      put :update, id: article, article: { title: '' }

      expect(response).to render_template(:edit)
    end
  end

  context 'as writer' do
    before(:each) do
      sign_in(:user, writer)
    end

    it 'should get list of articles' do
      get :index

      expect(response).to render_template(:index)
      expect(assigns[:articles].length).to eq(1)
    end

    it 'should create his own article' do
      new_article = attributes_for(:article)
      post :create, article: new_article

      expect(assigns[:article].title).to eq(new_article[:title])
      expect(assigns[:article].user_id).to eq(writer.id)
      expect(response).to redirect_to(article_path(assigns[:article]))
    end

    it 'should update his own article' do
      new_article = create(:article, user: writer)
      put :update, id: new_article, article: { title: 'New Writer Title' }

      expect(assigns[:article].title).to eq('New Writer Title')
      expect(assigns[:article].user_id).to eq(writer.id)
      expect(response).to redirect_to(article_path(assigns[:article]))
    end

    it 'should delete his own article' do
      new_article = create(:article, user: writer)

      expect(Article.count).to eq(2)

      delete :destroy, id: new_article, format: :js

      expect(Article.count).to eq(1)
      expect(Article.first.title).to eq(article.title)
    end

    it 'should render new if params invalid' do
      new_article = attributes_for(:article).except(:title)
      post :create, article: new_article

      expect(response).to render_template(:new)
    end

    it 'should render edit if params invalid' do
      new_article = create(:article, user: writer)

      put :update, id: new_article, article: { title: '' }

      expect(response).to render_template(:edit)
    end

    it 'should not update not his own article' do
      put :update, id: article, article: { title: 'New Writer Title' }

      expect(response).to be_forbidden
      expect(response.body).to match("You don't have permission to access to this page")
    end

    it 'should not delete not his own article' do
      delete :destroy, id: article, format: :js

      expect(response).to be_forbidden
    end
  end
end