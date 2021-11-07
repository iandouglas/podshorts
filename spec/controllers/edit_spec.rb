require 'rails_helper'

RSpec.describe ClipsController, type: :request do
    describe 'edit page' do 
        it 'happy path, loads page for a clip id successfully' do
            clip = create(:clip)

            visit edit_clip_path(clip.id)

            expect(page).to have_field('Processing finished?', checked: false)
            expect(page).to have_field('Finished publishing?', checked: false)

            expect(page).to have_field('Video Filename', with: clip.video_filename)
            expect(page).to have_field('Clip Start', with: clip.clip_starttime)
            expect(page).to have_field('Clip End', with: clip.clip_endtime)

            expect(page).to have_field('Do Podcast processing?', checked: true)
            # expect(page).to have_field('Podcast Publication Date', with: clip.podcast_pub_datetime)
            expect(page).to have_field('Podcast Title', with: clip.podcast_title)
            expect(page).to have_field('Podcast Desc', with: clip.podcast_desc)
            expect(page).to have_field('Podcast Teaser Filename', with: clip.podcast_teaser_filename)
            expect(page).to have_field('Teaser Start', with: clip.podcast_teaser_starttime)
            expect(page).to have_field('Teaser End', with: clip.podcast_teaser_endtime)

            expect(page).to have_field('Do YouTube processing?', checked: true)
            # expect(page).to have_field('YouTube Publication Date', with: clip.youtube_pub_datetime)
            expect(page).to have_field('YouTube Title', with: clip.youtube_title)
            expect(page).to have_field('YouTube Desc', with: clip.youtube_desc)
            expect(page).to have_field('YouTube Thumbnail Text', with: clip.youtube_thumbnail_text)
       end

       it 'happy path, loads page for a clip id successfully' do
            clip = create(:clip)
            visit edit_clip_path(clip.id)
            expect(page).to have_field('YouTube Title', with: clip.youtube_title)

            # change that field
            new_title = "hypervisor was here"
            fill_in 'YouTube Title', with: new_title
            click_button 'Update Clip'

            # reload the edit page
            visit edit_clip_path(clip.id)
            expect(page).to have_field('YouTube Title', with: new_title)
       end
    end
end