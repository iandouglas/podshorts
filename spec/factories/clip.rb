FactoryBot.define do
  factory :clip do
    is_finished { false }
    is_published { false }
    sequence :video_filename do |n|
      Faker::File.file_name(dir: 'foo/bar', name: "video-#{n}", ext: 'mp4')
    end
    clip_starttime { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now).strftime('%H:%M:%S') }
    clip_endtime { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now).strftime('%H:%M:%S') }

    is_podcast { true }
    podcast_pub_datetime { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) } #=> "2014-09-18 12:30:59 -0700"
    podcast_title { Faker::Book.title }
    podcast_desc { Faker::Lorem.words(number: 40) }
    sequence :podcast_teaser_filename do |n|
      Faker::File.file_name(dir: 'foo/bar', name: "teaser-#{n}", ext: 'mp4')
    end
    podcast_teaser_starttime { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now).strftime('%H:%M:%S') }
    podcast_teaser_endtime { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now).strftime('%H:%M:%S') }

    is_youtube { true }
    youtube_pub_datetime { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) }
    youtube_title { Faker::Book.title }
    youtube_desc { Faker::Lorem.words(number: 40) }
    youtube_thumbnail_text { Faker::Lorem.words(number: 10) }
  end
end