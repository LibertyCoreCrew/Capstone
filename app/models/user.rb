class User < ActiveRecord::Base
    has_secure_password
    
    attr_accessor :name, :password
    
=begin
    attr_accessor :username

    validates :username, presence: true, uniqueness: true
    

     
    before_save :encrypt_password
    
    def has_password?(submitted_password)
        encrypted_password == encrypt(submitted_password)
    end
    
    def self.authenticate(submitted_password)
        
        return nil if user.nil?
        return user if user.has_password?(submitted_password)
    end
    
    private
        def encrypt_password
            self.salt - Digest::SHA2.hexdigest("#{Time.now.utc}--#{password}") if self.new_record?
            self.encrypted_password = encrypt(password)
        end
        
        def encrypt(pass)
            Digest::SHA2.hexdigest("#{self.salt}--#{pass}")
        end

=end  

end
