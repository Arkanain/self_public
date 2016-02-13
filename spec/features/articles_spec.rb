require 'rails_helper'

describe 'Article' do
  let(:admin) { create(:admin) }
  let(:writer) { create(:writer) }
  let!(:admin_article) { create(:article, user: admin) }
  let!(:writer_article) { create(:article, user: writer) }
  let(:new_article_params) { attributes_for(:article) }

  shared_examples 'a user' do
    it 'should see new article page' do
      visit articles_path

      click_link('Add Article')

      expect(page).to have_content('New Article')
    end

    it 'should create article' do
      visit new_article_path

      expect(page).to have_content('New Article')

      fill_in 'Title', with: new_article_params[:title]
      fill_in 'Text', with: new_article_params[:text]

      click_button 'Create Article'

      expect(page).to have_content(new_article_params[:title])
      expect(page).to have_content(new_article_params[:text])
      expect(page).to have_link('Back')
    end

    it 'should show first article in the list' do
      visit articles_path

      first(:link, 'View').click

      expect(page).to have_content(admin_article.title)
      expect(page).to have_content(admin_article.text)
      expect(page).to have_link('Back')
    end

    it 'should update article' do
      visit articles_path

      first(:link, 'Edit').click

      fill_in 'Title', with: new_article_params[:title]
      fill_in 'Text', with: new_article_params[:text]

      click_button 'Update Article'

      expect(page).to have_content(new_article_params[:title])
      expect(page).to have_content(new_article_params[:text])
      expect(page).to have_link('Back')
    end
  end

  context 'as admin' do
    before(:each) do
      capybara_sign_in(admin)
    end

    it_behaves_like 'a user'

    it 'should see articles index page' do
      visit articles_path

      expect(page).to have_content(admin.email)
      expect(page).to have_content(admin_article.title)
      expect(page).to have_link('View', count: 2)
      expect(page).to have_link('Edit', count: 2)
      expect(page).to have_link('Delete', count: 2)
    end

    it 'should delete article', js: true do
      visit articles_path

      page.accept_confirm do
        first(:link, 'Delete').click
      end

      expect(page).not_to have_content(admin_article.title)
    end
  end

  context 'as writer' do
    before(:each) do
      capybara_sign_in(writer)
    end

    it_behaves_like 'a user'

    it 'should see articles index page' do
      visit articles_path

      expect(page).to have_content(writer.email)
      expect(page).to have_content(admin_article.title)
      expect(page).to have_link('View', count: 2)
      expect(page).to have_link('Edit', count: 1)
      expect(page).to have_link('Delete', count: 1)
    end

    it 'should delete article', js: true do
      visit articles_path

      page.accept_confirm do
        first(:link, 'Delete').click
      end

      expect(page).not_to have_content(writer_article.title)
    end
  end
end