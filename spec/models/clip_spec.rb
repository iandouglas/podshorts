require 'rails_helper'

RSpec.describe Clip, type: :model do
  describe 'validators' do
    it { should validate_presence_of :video_filename }
  end
end
