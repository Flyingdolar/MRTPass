require 'rails_helper'
require 'simplecov'
SimpleCov.start

RSpec.describe "Api::MrtAdmin::Tickets", type: :request do
  describe "GET /index" do
    example "coverage" do
      get "/api/mrt_admin/ticket"
    end
  end
end
