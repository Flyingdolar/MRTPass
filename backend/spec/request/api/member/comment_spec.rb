require 'rails_helper'
require 'simplecov'
SimpleCov.start
RSpec.describe "Api::MrtAdmin::Comments", type: :request do
  describe "GET /index" do
    example "coverage" do
      post "/api/member/info/1/comment" 
    end
  end
end
