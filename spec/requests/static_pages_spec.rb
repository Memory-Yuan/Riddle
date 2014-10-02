require 'rails_helper'

describe "Static pages" do

    let(:base_title) {"Riddle"}
    
    describe "Home page" do
        it "should have the content 'Riddle App'" do
            visit '/'
            expect(page).to have_content('Riddle App')
        end
        
        it "should have the title 'Home'" do
            visit '/'
            expect(page).to have_title("#{base_title} | Home")
        end
    end
    
    describe "Help page" do
        it "should have the content 'Help'" do
            visit '/help'
            expect(page).to have_content('Help')
        end
        
        it "should have the title 'Help'" do
            visit '/help'
            expect(page).to have_title("#{base_title} | Help")
        end
    end
    
    describe "About page" do
        it "shoult have the content 'About Us'" do
            visit '/about'
            expect(page).to have_content('About Us')
        end
        
        it "should have the title 'About Us'" do
            visit '/about'
            expect(page).to have_title("#{base_title} | About Us")
        end
    end
    
    describe "Contact page" do
        it "shoult have the content 'Contact'" do
            visit '/contact'
            expect(page).to have_content('Contact')
        end
        
        it "should have the title 'Contact'" do
            visit '/contact'
            expect(page).to have_title("#{base_title} | Contact")
        end
    end
    
end

