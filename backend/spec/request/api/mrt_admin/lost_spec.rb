require 'rails_helper'
require './spec/support/authorized_helper'
require 'simplecov'
SimpleCov.start
RSpec.configure do |c|
    c.include AuthorizedHelper
end
RSpec.describe "Api::MrtAdmin::Losts", type: :request do
  describe "GET /index" do
    example "coverage" do
      get "/api/mrt_admin/lost"
    end
  end
end
