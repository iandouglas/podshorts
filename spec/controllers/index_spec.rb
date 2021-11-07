require 'rails_helper'

RSpec.describe ClipsController, type: :request do

  describe 'show all clips' do
    it 'shows all clips' do
      # build some dummy data, 5 clips
      clips = create_list(:clip, 5)

      # fetch page
      visit root_path

      # expect 5 clips on page
      puts page.html.length
      expect(page).to have_content(clips[0].video_filename)
    end
  end
end