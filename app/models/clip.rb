class Clip < ApplicationRecord
    validates :video_filename, presence: true
end
