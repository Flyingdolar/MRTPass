require 'rails_helper'
require 'simplecov'
SimpleCov.start

RSpec.describe "Api::MrtAdmin::TimeTables", type: :request do
  describe "GET /index" do
    example "coverage" do
      get "/api/mrt_admin/time_table"
    end
  end
end
