require 'rails_helper'

RSpec.describe ClipsController, type: :request do
    describe 'edit page' do 
        it 'happy path, loads page for a clip id successfully' do
            clip = create(:clip)

            visit edit_clip_path(clip.id)

            save_and_open_page
            expect(page).to have_field('Video Filename', with: clip.video_filename)
            expect(page).to have_field('Processing finished?', checked: false)
            expect(page).to have_field('Do Podcast processing?', checked: true)
        end
    end
end