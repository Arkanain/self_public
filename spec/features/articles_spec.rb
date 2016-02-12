require 'rails_helper'

describe 'Article' do
  let(:admin) { create(:admin) }
  let!(:article) { create(:article, user: admin) }
  let(:new_article_params) { attributes_for(:article) }

  before(:each) do
    capybara_sign_in(admin)
  end

  it 'should see articles index page' do
    visit articles_path

    expect(page).to have_content(admin.email)
    expect(page).to have_content(article.title)
    expect(page).to have_link('View', count: 1)
    expect(page).to have_link('Edit', count: 1)
    expect(page).to have_link('Delete', count: 1)
  end

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

  it 'should show article' do
    visit articles_path

    click_link 'View'

    expect(page).to have_content(article.title)
    expect(page).to have_content(article.text)
    expect(page).to have_link('Back')
  end

  it 'should update article' do
    visit articles_path

    click_link 'Edit'

    fill_in 'Title', with: new_article_params[:title]
    fill_in 'Text', with: new_article_params[:text]

    click_button 'Update Article'

    expect(page).to have_content(new_article_params[:title])
    expect(page).to have_content(new_article_params[:text])
    expect(page).to have_link('Back')
  end

  it 'should delete article', js: true do
    visit articles_path

    page.accept_confirm do
      click_link 'Delete'
    end

    expect(page).not_to have_content(article.title)
  end
end