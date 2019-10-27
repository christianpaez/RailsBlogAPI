require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it "should validate presence of required field" do
    should validate_presence_of(:email)
    should validate_presence_of(:name)
    should validate_presence_of(:auth_token) 
    end

    it "should validate relationships" do
      should have_many(:posts)
    end
  end
end
