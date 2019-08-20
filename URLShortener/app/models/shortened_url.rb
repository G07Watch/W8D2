class ShortenedUrl < ApplicationRecord 
    validates :long_url, presence: true 
    validates :user_id, presence: true

end