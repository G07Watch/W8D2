class User < ApplicationRecord
    validates :email, uniqueness: true
    validates :email, presence: true

end

#  def change
#     create_table :shortened_urls do |t|
#       t.string :long_url, null: false
#       t.string :short_url
#       t.integer :user_id, null: false

#       t.timestamps
#     end
#     add_index :shortened_urls, :user_id
#   end