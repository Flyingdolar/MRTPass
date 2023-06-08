require 'rails_helper'
require 'simplecov'
SimpleCov.start
RSpec.describe "Api::MrtAdmin::Losts", type: :request do
  describe "GET /index" do
    example "coverage" do
      get "/api/mrt_admin/lost"
    end
  end
end
