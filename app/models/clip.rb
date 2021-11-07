class Clip < ApplicationRecord
    validates :video_filename, presence: true
    validates :clip_starttime, presence: true
    validates :clip_endtime, presence: true # 00:00:00
end
