FactoryBot.define do
  factory :clip do
    is_finished { false }
    is_published { false }
    sequence :video_filename do |n|
      Faker::File.file_name(dir: 'foo/bar', name: "video-#{n}", ext: 'mp4')
    end
    clip_starttime { "#{Faker::Number.leading_zero_number(digits: 2)}:#{Faker::Number.leading_zero_number(digits: 2)}:#{Faker::Number.leading_zero_number(digits: 2)}" }
    clip_endtime { "#{Faker::Number.leading_zero_number(digits: 2)}:#{Faker::Number.leading_zero_number(digits: 2)}:#{Faker::Number.leading_zero_number(digits: 2)}" }

    is_podcast { true }
    podcast_pub_datetime { Faker::Time.backward(days: 5, period: :evening) } #=> "2014-09-18 12:30:59 -0700"
    podcast_title { Faker::Book.title }
    podcast_desc { Faker::Lorem.words(number: 40) }
    sequence :podcast_teaser_filename do |n|
      Faker::File.file_name(dir: 'foo/bar', name: "teaser-#{n}", ext: 'mp4')
    end
    podcast_teaser_starttime { "#{Faker::Number.leading_zero_number(digits: 2)}:#{Faker::Number.leading_zero_number(digits: 2)}:#{Faker::Number.leading_zero_number(digits: 2)}" }
    podcast_teaser_endtime { "#{Faker::Number.leading_zero_number(digits: 2)}:#{Faker::Number.leading_zero_number(digits: 2)}:#{Faker::Number.leading_zero_number(digits: 2)}" }

    is_youtube { true }
    youtube_pub_datetime { Faker::Time.backward(days: 5, period: :evening) }
    youtube_title { Faker::Book.title }
    youtube_desc { Faker::Lorem.words(number: 40) }
    youtube_thumbnail_text { Faker::Lorem.words(number: 10) }
  end
end