require 'rails_helper'

RSpec.describe ClipsController, type: :request do

  describe 'show all clips' do
    it 'shows all clips' do
      # build some dummy data, 5 clips
      number_of_clips = 3
      clips = create_list(:clip, number_of_clips)

      # fetch page
      visit root_path

      # expect 5 clips on page
      expect(page).to have_css("li", count: number_of_clips)
      clips.each do |clip|
        within "#clip-#{clip.id}" do
          expect(page).to have_link(clip.video_filename)
          expect(page).to have_content("start: #{clip.clip_starttime}")
          expect(page).to have_content("end: #{clip.clip_endtime}")
          expect(page).to have_content("youtube_pub_date: #{clip.podcast_pub_datetime}")
          expect(page).to have_content("podcast_pub_date: #{clip.podcast_pub_datetime}")
        end
      end
    end

    it 'redirects to an edit page when clicking a filename' do
      number_of_clips = 1
      clips = create_list(:clip, number_of_clips)

      # fetch page
      visit root_path

      click_link(clips[0].video_filename)

      expect(current_path).to eq(edit_clip_path(clips[0].id))
    end

    it 'allows user to delete an entry' do
      number_of_clips = 3
      clips = create_list(:clip, number_of_clips)

      visit root_path

      expect(page).to have_css("li", count: number_of_clips)

      mid_point = (number_of_clips/2).to_i
      expect(page).to have_content(clips[mid_point].video_filename)

      within "#clip-#{clips[mid_point].id}" do
        click_link 'delete clip'
      end

      expect(page).to have_css("li", count: number_of_clips-1)
      expect(page).to_not have_content(clips[mid_point].video_filename)
    end
  end
end