require "spec_helper"

feature "frontpage"  do
  background { visit root_path }

  scenario { expect(page.status_code).to eq 200 }
  scenario { expect(page).to have_selector '#header' }
  scenario { expect(page).to have_selector '.footer' }

  scenario { expect(page).to have_selector '.signup' }
  scenario { expect(page).to have_selector '.login' }
  scenario { expect(page).to have_selector '.marketing-section' }
  scenario { expect(page).to have_selector '.featured-maps' }
  scenario { expect(page).to have_selector '.partners' }
  scenario { expect(page).to have_selector '.flexslider[data-components=flexslider]' }
end

feature 'Sign in' do
  background { visit root_path }
  given(:user) { FactoryGirl.create(:user) }
  given(:password) { FactoryGirl.build(:user).password }

  shared_examples_for 'login' do |expected_response|
    scenario 'log in and expect json response'do
      click_link I18n.t('header.side_menu.login')
      within '#login-form' do
        fill_in I18n.t('sessions.form.login.email'), :with => user.email
        fill_in I18n.t('sessions.form.login.password'), :with => password
        click_button I18n.t('sessions.form.login.submit')
      end
      expect(page).to have_content(expected_response)
    end
  end

  context 'correct credentials' do
    given(:expected_response) { {:redirect => root_path}.to_json }
    it_behaves_like 'login'
  end

  context 'blank fields' do
    given(:expected_response) { {:errors => I18n.t('sessions.create.blank')}.to_json }
    given(:password) { '' }
    it_behaves_like 'login'
  end

  context 'wrong credentials' do
    given(:expected_response) { {:errors => I18n.t('sessions.create.invalid')}.to_json }
    given(:password) { 'wrong-pass' }
    it_behaves_like 'login'
  end

  context 'pending user' do
    given(:user) { FactoryGirl.create(:pending_user) }
    given(:expected_response) { {:errors => I18n.t('sessions.create.pending')}.to_json }
    it_behaves_like 'login'
  end
end
