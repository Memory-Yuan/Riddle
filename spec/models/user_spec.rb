require 'rails_helper'

describe User do
    before do
        @user = User.new(name: "Example User",
                         email: "user@example.com",
                         password: "example",
                         password_confirmation: "example")
    end
    
    subject { @user }
    
    it { should respond_to(:name) } #respond_to，在Ruby應該要加上問號，RSpec不加
    it { should respond_to(:email) }
    it { should respond_to(:password_digest) }
    it { should respond_to(:password) }
    it { should respond_to(:password_confirmation) }
    it { should respond_to(:remember_token) }
    it { should respond_to(:authenticate) }
    it { should respond_to(:admin) }
    
    it { should be_valid }
    it { should_not be_admin }
        #只要是Ruby可以返回boolean的方法foo?，就可以變成be_foo在測試中使用        

    describe "with admin attribute set to true" do
        before do
            @user.save!
            @user.toggle!(:admin)  #把admin變成true
        end
        
        it { should be_admin }
    end

    describe "when name is not present" do
        before { @user.name = " " }  #將name設為空的
        it { should_not be_valid }    #應該要不通過valid
    end
    
    describe "when email is not present" do
        before { @user.email = " " }  #將email設為空的
        it { should_not be_valid }     #應該要不通過valid
    end
    
    describe "when name is too long" do
        before { @user.name = "a" * 51 }  #長度限制50，51會超過
        it { should_not be_valid }
    end
    
    describe "when email format is invalid" do
        it "should be invalid" do
            addresses = %w[user@foo,com
                           user_at_foo.org
                           example.user@foo.
                           foo@bar_baz.com
                           foo@bar+baz.com]
            addresses.each do |invalid_address|
                @user.email = invalid_address
                expect(@user).not_to be_valid
            end
        end
    end
    
    describe "when email format is valid" do
        it "should be valid" do
            addresses = %w[user@foo.COM
                           A_US-ER@f.b.org
                           frst.lst@foo.jp
                           a+b@baz.cn]
            addresses.each do |valid_address|
                @user.email = valid_address
                expect(@user).to be_valid
            end
        end
    end
    
    describe "when email address is already used" do
        before do
            user_with_same_email = @user.dup  #copy一個跟user一樣資料的user
            user_with_same_email.email = @user.email.upcase
            user_with_same_email.save
        end
        it { should_not be_valid }
    end
    
    describe "when email address with mixed case" do
        let(:mixed_case_email) { "Foo@ExAMPle.CoM" }
        
        it "should be saved as all lower_case" do
            @user.email = mixed_case_email
            @user.save
            expect(@user.reload.email).to eq mixed_case_email.downcase
        end
    end
    
    describe "when password is not present" do
        before do
            @user = User.new(name: "Example User", email: "user@example.com",
                             password: " ", password_confirmation: " ")
        end
        it { should_not be_valid }
    end
    
    describe "when password doesn't match confirmation" do
        before { @user.password_confirmation = "mismatch" }
        it { should_not be_valid }
    end
    
    describe "with a password that's too short" do
        before { @user.password = @user.password_confirmation = "a" * 5 }
        it { should be_invalid }
    end
    
    describe "return value of authenticate method" do
        before { @user.save }
        let(:found_user) { User.find_by(email: @user.email) }
        
        describe "with valid password" do
            it { should eq found_user.authenticate(@user.password) }
        end
        
        describe "with invalid password" do
            let(:user_for_invalid_password) { found_user.authenticate("invalidpwd") }
            it { should_not eq user_for_invalid_password }
            specify { expect(user_for_invalid_password).to be_falsey }
                #specify 等於 it，這裡只是為了語意通順。be_falsey不可以用be_false，已經改名了
        end
    end
    
    describe "remember token" do
        before { @user.save }
        its(:remember_token) { should_not be_blank }
            #等同於 it { expect(@user.remember_token).not_to be_blank }
    end
end
