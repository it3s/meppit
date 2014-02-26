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

  scenario 'login with correct credentials' do
    click_link 'Login'
    within '#login-form' do
      fill_in 'E-mail', :with => user.email
      fill_in 'Password', :with => password
      click_button "Log In"
    end
    expect(page).to have_content({:redirect => root_path}.to_json)
  end

  scenario 'login with blank field' do
    click_link 'Login'
    within '#login-form' do
      fill_in 'E-mail', :with => ''
      fill_in 'Password', :with => ''
      click_button "Log In"
    end
    expect(page).to have_content({:errors => "Fields can't be blank"}.to_json)
  end

  scenario 'login with wrong credentials' do
    click_link 'Login'
    within '#login-form' do
      fill_in 'E-mail', :with => user.email
      fill_in 'Password', :with => 'wrong-pass'
      click_button "Log In"
    end
    expect(page).to have_content({:errors => "E-mail or Password invalid"}.to_json)
  end

  scenario 'login with pending user' do
    user = FactoryGirl.create(:pending_user)
    click_link 'Login'
    within '#login-form' do
      fill_in 'E-mail', :with => user.email
      fill_in 'Password', :with => password
      click_button "Log In"
    end
    expect(page).to have_content({:errors => "Activation pending"}.to_json)
  end
end
