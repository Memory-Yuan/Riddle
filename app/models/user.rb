class User < ActiveRecord::Base
    before_save { self.email = email.downcase } #有的資料庫無法區分大小寫，所以為了確保唯一，只好存進去之前都轉成小寫
#    before_save { email.downcase! }  #也可以這樣寫
    before_create :create_remember_token
    
    validates :name, presence: true, length: { maximum: 50 }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
    validates :email, presence: true, 
                     format: { with: VALID_EMAIL_REGEX },
                     uniqueness: { case_sensitive: false }  #不區分大小寫
    has_secure_password  #相當神奇的一行，只要資料庫有password_digest，他就會驗證身分，自動創建password和password_confirmation屬性
    validates :password, length: { minimum: 6 }
    
    def User.new_remember_token
        SecureRandom.urlsafe_base64
    end

    def User.hash(token)
        Digest::SHA1.hexdigest(token.to_s)
    end
    
    private
        def create_remember_token
            self.remember_token = User.hash(User.new_remember_token)
        end
    
end
