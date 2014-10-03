require 'rails_helper'

describe "User pages" do
    let(:base_title) {"Riddle"}
    subject { page }
    describe "signup page" do
        before { visit signup_path }
        it { should have_content('Sign up') }
        it { should have_title("#{base_title} | Sign up") }
    end
end
