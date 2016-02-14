require 'rails_helper'

describe 'User' do
  let(:admin) { create(:admin) }
  let(:new_user_params) { attributes_for(:writer) }

  context 'as admin' do
    before(:each) do
      capybara_sign_in(admin)
    end

    it 'should see list of users' do
      visit users_path

      expect(page).to have_content(admin.first_name)
      expect(page).to have_content(admin.last_name)
      expect(page).to have_link('View', count: 1)
      expect(page).to have_link('Edit', count: 1)
      expect(page).to have_link('Delete', count: 0)
    end

    it 'should create new user' do
      visit users_path

      click_link('Add User')

      expect(page).to have_content('New User')

      fill_in 'First name', with: new_user_params[:first_name]
      fill_in 'Last name', with: new_user_params[:last_name]
      fill_in 'Email', with: new_user_params[:email]
      select('writer', from: 'Role')
      fill_in 'Password', with: new_user_params[:password]
      fill_in 'Password confirmation', with: new_user_params[:password]

      click_button 'Create User'

      expect(page).to have_content(new_user_params[:first_name])
      expect(page).to have_content(new_user_params[:last_name])
      expect(page).to have_content(new_user_params[:email])
      expect(page).to have_link('Edit')
      expect(page).to have_link('Back')
    end

    it 'should edit user' do
      visit users_path

      first(:link, 'Edit').click

      expect(page).to have_content('Edit User')

      fill_in 'First name', with: new_user_params[:first_name]
      fill_in 'Last name', with: new_user_params[:last_name]

      click_button 'Update User'

      expect(page).to have_content(new_user_params[:first_name])
      expect(page).to have_content(new_user_params[:last_name])
      expect(page).to have_content(admin.email)
      expect(page).to have_link('Edit')
      expect(page).to have_link('Back')
    end

    it 'should delete user', js: true do
      writer = create(:writer)

      visit users_path

      page.accept_confirm do
        first(:link, 'Delete').click
      end

      expect(page).not_to have_content(writer.email)
    end
  end
end