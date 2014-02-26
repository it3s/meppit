require "spec_helper"

feature "frontpage", :js => true do
  background { visit root_path }

  scenario { expect(page.status_code).to eq 200 }
  scenario { expect(page).to have_selector '#header' }
  scenario { expect(page).to have_selector '.footer' }

  scenario { expect(page).to have_selector '#login_button' }
  scenario { expect(page).to have_selector '.video' }
  scenario { expect(page).to have_selector '.flexslider[data-components=flexslider]' }
end

feature 'Sign in' do # , :js => true do
  background { visit root_path }
  given(:user) { FactoryGirl.create(:user) }
  given(:password) { FactoryGirl.build(:user).password }

  shared_examples_for 'login' do |expected_response|
    scenario 'log in and expect json response'do
      click_link 'Login'
      within '#login-form' do
        fill_in 'E-mail', :with => user.email
        fill_in 'Password', :with => password
        click_button "Log In"
      end
      expect(page).to have_content(expected_response)
    end
  end

  context 'correct credentials' do
    given(:expected_response) { {:redirect => root_path}.to_json }
    it_behaves_like 'login'
  end

  context 'blank fields' do
    given(:expected_response) { {:errors => "Fields can't be blank"}.to_json }
    given(:password) { '' }
    it_behaves_like 'login'
  end

  context 'wrong credentials' do
    given(:expected_response) { {:errors => "E-mail or Password invalid"}.to_json }
    given(:password) { 'wrong-pass' }
    it_behaves_like 'login'
  end

  context 'pending user' do
    given(:user) { FactoryGirl.create(:pending_user) }
    given(:expected_response) { {:errors => "Activation pending"}.to_json }
    it_behaves_like 'login'
  end
end
