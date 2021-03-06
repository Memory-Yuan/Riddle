require 'rails_helper'

describe "Authentication" do
    subject { page }

    describe "signin page" do
        before { visit signin_path }
        it { should have_content('Sign in') }
        it { should have_title(full_title('Sign in')) }
        
        describe "sign in" do
            describe "with invalid information" do
                before { click_button "Sign in" }
                
                it { should have_title(full_title('Sign in')) }
                it { should have_selector('div.alert-danger') }
                it { should_not have_link('Profile') }
                it { should_not have_link('Setting') }
                
                describe "after visiting another page" do
                    before { click_link "Home" }
                    it { should_not have_selector('div.alert-danger') }
                end
            end
            
            describe "with valid information" do
                let(:user) { FactoryGirl.create(:user) }
                before { sign_in user }
                
                it { should have_title(full_title(user.name)) }
                it { should have_link('Users', href: users_path) }
                it { should have_link('Profile', href: user_path(user)) }
                it { should have_link('Setting', href: edit_user_path(user)) }
                it { should have_link('Sign out', href: signout_path) }
                it { should_not have_link('Sign in', href: signin_path) }
                
                describe "followed by sign out" do
                    before { click_link "Sign out" }
                    it { should have_link('Sign in') }
                end
            end
        end
    end
    
    describe "authorization" do
        describe "for non-signed-in users" do
            let(:user) { FactoryGirl.create(:user) }

            describe "when attempting to visit edit page" do
                before { visit edit_user_path(user) }
                it { should have_title(full_title('Sign in')) }
                
                describe "after signing in" do
                    before do
                        fill_in "Email",    with: user.email
                        fill_in "Password", with: user.password
                        click_button "Sign in"
                    end
                    it { should have_title(full_title('Edit user')) }
                    
                    describe "and then signing in again" do
                        before do
                            click_link 'Sign out'
                            visit signin_path
                            fill_in "Email",    with: user.email
                            fill_in "Password", with: user.password
                            click_button "Sign in"
                        end
                        
                        it { should have_title(full_title(user.name)) }
                    end
                    
                end
            end

            describe "submitting a PATCH request to the Users#update action" do
                before { patch user_path(user) }
                specify { expect(response).to redirect_to(signin_path) }
            end
            
            describe "when attempting to visit the user index page" do
                before { visit users_path }
                it { should have_title(full_title('Sign in')) }
            end
        end
        
        describe "as wrong user" do
            let(:user) { FactoryGirl.create(:user) }
            let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
            before { sign_in wrong_user, no_capybara: true }
            
            describe "submitting a GET request to the User#edit action" do
                before { get edit_user_path(user) }
                specify { expect(response.body).not_to match(full_title('Edit user')) }
                specify { expect(response).to redirect_to(root_url) }
            end
            
            describe "submitting a PATCH request to the Users#update action" do
                before { patch user_path(user) }
                specify { expect(response).to redirect_to(root_url) }
            end
        end
        
        describe "as non-admin user" do
            let(:user) { FactoryGirl.create(:user) }
            let(:non_admin) { FactoryGirl.create(:user) }
            
            before { sign_in non_admin, no_capybara: true }
            
            describe "submitting a DELETE request to the Users#destroy action" do
                before { delete user_path(user) }
                specify { expect(response).to redirect_to(root_path) }
            end
        end
    end
end