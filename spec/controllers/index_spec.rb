require 'rails_helper'

RSpec.describe ClipsController, type: :request do

  describe 'show all clips' do
    it 'shows all clips' do
      # build some dummy data, 5 clips
      clips = create_list(:clip, 5)

      # fetch page
      visit root_path

      # expect 5 clips on page
      
      expect(page).to have_css("li", count: 5)
      clips.each do |clip|
        expect(page).to have_content(clip.video_filename)
      end
    end
  end
end