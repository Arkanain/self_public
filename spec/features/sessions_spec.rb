require 'rails_helper'

feature 'Session' do
  let(:admin) { create(:admin) }
  let!(:article) { create(:article, user: admin) }

  it 'signs me in' do
    capybara_sign_in(admin)

    expect(page).to have_current_path(root_path)
    expect(page).to have_content(admin.email)
    expect(page).to have_content(article.title)
  end

  it 'signs me out' do
    capybara_sign_in(admin)

    visit articles_path

    expect(page).to have_content(admin.email)
    expect(page).to have_content(article.title)

    click_link('Sign out')

    expect(page).to have_content(article.title)
  end
end