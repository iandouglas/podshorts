require 'rails_helper'

RSpec.describe ClipsController, type: :request do
    describe 'add page' do 
        it 'happy path, loads page for creating a clip' do
            visit new_clip_path

            expect(page).to have_field('Processing finished?', checked: false)
            expect(page).to have_field('Finished publishing?', checked: false)
            expect(page).to have_field('Do Podcast processing?', checked: true)
            expect(page).to have_field('Do YouTube processing?', checked: true)

            fill_in 'Video Filename', with: 'field 1'
            fill_in 'Clip Start', with: 'field 2'
            fill_in 'Clip End', with: 'field 3'

            fill_in 'Podcast Publication Date', with: '2021-11-01 02:00:00'
            fill_in 'Podcast Title', with: 'field 4'
            fill_in 'Podcast Desc', with: 'field 5'
            fill_in 'Podcast Teaser Filename', with: 'field 6'
            fill_in 'Teaser Start', with: 'field 7'
            fill_in 'Teaser End', with: 'field 8'

            fill_in 'YouTube Publication Date', with: '2021-11-01 02:00:00'
            fill_in 'YouTube Title', with: 'field 9'
            fill_in 'YouTube Desc', with: 'field 10'
            fill_in 'YouTube Thumbnail Text', with: 'field 11'

            click_button 'Create Clip'

            expect(current_path).to eq(root_path)

            # load the edit page
            clip = Clip.last
            visit edit_clip_path(clip.id)

            expect(page).to have_field('Video Filename', with: clip.video_filename)
       end
    end
end