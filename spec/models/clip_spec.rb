require 'rails_helper'

RSpec.describe Clip, type: :model do
  describe 'validators' do
    it { should validate_presence_of :video_filename }
    it { should validate_presence_of :clip_starttime }
    it { should validate_presence_of :clip_endtime }
  end
end
