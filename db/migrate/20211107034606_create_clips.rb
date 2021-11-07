class CreateClips < ActiveRecord::Migration[5.2]
  def change
    create_table :clips do |t|
      t.boolean :is_finished
      t.boolean :is_published
      t.string :video_filename
      t.string :clip_starttime
      t.string :clip_endtime

      t.boolean :is_podcast
      t.datetime :podcast_pub_datetime
      t.string :podcast_title
      t.text :podcast_desc
      t.string :podcast_teaser_filename
      t.string :podcast_teaser_starttime
      t.string :podcast_teaser_endtime

      t.boolean :is_youtube
      t.datetime :youtube_pub_datetime
      t.string :youtube_title
      t.text :youtube_desc
      t.string :youtube_thumbnail_text

      t.timestamps
    end
  end
end
