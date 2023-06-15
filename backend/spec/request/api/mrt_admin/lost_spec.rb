require 'rails_helper'
require './spec/support/authorized_helper'
require 'simplecov'
SimpleCov.start
RSpec.configure do |c|
    c.include AuthorizedHelper
end
RSpec.describe "Api::MrtAdmin::Losts", type: :request do
  before do
    Member.create(account:"admin",password:"123456",nickname:"admin",role:"admin")
    Member.create(account:"mrt_admin",password:"123456",nickname:"北捷管理員",role:"mrt_admin")
    Member.create(account:"user1",password:"123456",nickname:"user#344003",role:"user")
    Lost.create(item:"雨傘",photo:filepath,time:"2023/06/10 9:00",location:"古亭站",lost_Attr:"拾獲",member_id:2)
    Lost.create(item:"1000元新台幣",time:"2023/06/08 19:00",location:"忠孝復興站",lost_Attr:"遺失",member_id:2)
  end
  let(:filepath) { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', '1.jpg'), 'image/jpg') }
  let(:invalid_filepath) { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', '2.txt'), 'text/plain') }

  describe "POST /api/mrt_admin/lost" do
    example "succeed to create lost" do
      post "/sign_in",params:{account:"mrt_admin",password:"123456"}
      post "/api/mrt_admin/lost",params:{item:"蘋果手機一台",photo:filepath,time:"2023/06/09 20:37",location:"未知",lost_Attr:"遺失"}
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq(
        JSON.parse( 
        {
            "status": "success",
            "error": false,
            "message": "succeed to create lost",
            "data": Lost.last
        }.to_json
        )
      )
    end

    example "failed to create lost(photo format error)" do
      post "/sign_in",params:{account:"mrt_admin",password:"123456"}
      post "/api/mrt_admin/lost",params:{item:"蘋果手機一台",photo:invalid_filepath,time:"2023/06/09 20:37",location:"未知",lost_Attr:"遺失"}
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body)).to eq(
        JSON.parse( 
        {
            "status": "error",
            "error": true,
            "message": "failed to create lost",
            "data": {
              photo:["You are not allowed to upload \"txt\" files, allowed types: jpg, jpeg, png"]
            }
        }.to_json
        )
      )
    end

    example "failed to create lost(not complete filled)" do
      post "/sign_in",params:{account:"mrt_admin",password:"123456"}
      post "/api/mrt_admin/lost",params:{time:"2023/06/09 20:37",location:"未知",lost_Attr:"遺失"}
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body)).to eq(
        JSON.parse( 
        {
            "status": "error",
            "error": true,
            "message": "failed to create lost",
            "data": {
              item:["can't be blank"]
            }
        }.to_json
        )
      )
    end

    example "failed to create lost(not login)" do
      post "/api/mrt_admin/lost",params:{item:"蘋果手機一台",photo:filepath,time:"2023/06/09 20:37",location:"未知",lost_Attr:"遺失"}
      expect_unauthorized(response)
    end

    example "failed to create lost(Unauthorized)" do
      post "/sign_in",params:{account:"user1",password:"123456"}
      post "/api/mrt_admin/lost",params:{item:"蘋果手機一台",photo:filepath,time:"2023/06/09 20:37",location:"未知",lost_Attr:"遺失"}
      expect_not_permitted(response)
    end

  end

  describe "GET /api/mrt_admin/lost" do
    example "succeed to get lost list" do
      get "/api/mrt_admin/lost"
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq(
        JSON.parse( 
        {
            "status": "success",
            "error": false,
            "message": "succeed to get lost list",
            "data": Lost.all
        }.to_json
        )
      )
    end
  end

  describe "GET /api/mrt_admin/lost/1" do
    example "succeed to get lost" do
      get "/api/mrt_admin/lost/1"
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq(
        JSON.parse( 
        {
            "status": "success",
            "error": false,
            "message": "succeed to get lost",
            "data": Lost.first
        }.to_json
        )
      )
    end
  end

  describe "PATCH /api/mrt_admin/lost/1" do
    example "succeed to update lost" do
      post "/sign_in",params:{account:"mrt_admin",password:"123456"}
      patch "/api/mrt_admin/lost/1",params:{item:"蘋果手機一台",photo:filepath,time:"2023/06/09 20:37",location:"未知",lost_Attr:"遺失"}
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq(
        JSON.parse( 
        {
            "status": "success",
            "error": false,
            "message": "succeed to update lost",
            "data": Lost.first
        }.to_json
        )
      )
    end

    example "failed to update lost(photo format error)" do
      post "/sign_in",params:{account:"mrt_admin",password:"123456"}
      patch "/api/mrt_admin/lost/1",params:{item:"蘋果手機一台",photo:invalid_filepath,time:"2023/06/09 20:37",location:"未知",lost_Attr:"遺失"}
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body)).to eq(
        JSON.parse( 
        {
            "status": "error",
            "error": true,
            "message": "failed to update lost",
            "data": {
              photo:["You are not allowed to upload \"txt\" files, allowed types: jpg, jpeg, png"]
            }
        }.to_json
        )
      )
    end

    example "failed to update lost(not complete filled)" do
      post "/sign_in",params:{account:"mrt_admin",password:"123456"}
      patch "/api/mrt_admin/lost/1",params:{item:"",time:"2023/06/09 20:37",location:"未知",lost_Attr:"遺失"}
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body)).to eq(
        JSON.parse( 
        {
            "status": "error",
            "error": true,
            "message": "failed to update lost",
            "data": {
              item:["can't be blank"]
            }
        }.to_json
        )
      )
    end

    example "failed to update lost(not login)" do
      patch "/api/mrt_admin/lost/1",params:{item:"蘋果手機一台",photo:filepath,time:"2023/06/09 20:37",location:"未知",lost_Attr:"遺失"}
      expect_unauthorized(response)
    end

    example "failed to update lost(Unauthorized)" do
      post "/sign_in",params:{account:"user1",password:"123456"}
      patch "/api/mrt_admin/lost/1",params:{item:"蘋果手機一台",photo:filepath,time:"2023/06/09 20:37",location:"未知",lost_Attr:"遺失"}
      expect_not_permitted(response)
    end

  end

  describe "DELETE /api/mrt_admin/lost/1" do
    example "succeed to delete lost" do
      post "/sign_in",params:{account:"mrt_admin",password:"123456"}
      delete "/api/mrt_admin/lost/1"
      expect(JSON.parse(response.body)).to eq(
        JSON.parse( 
        {
            "status": "success",
            "error": false,
            "message": "succeed to delete lost",
            "data": {}
        }.to_json
        )
      )
      expect(Lost.first).to eq(Lost.find(2))
    end

    example "failed to delete lost(not login)" do
      delete "/api/mrt_admin/lost/1"
      expect_unauthorized(response)
    end

    example "failed to delete lost(Unauthorized)" do
      post "/sign_in",params:{account:"user1",password:"123456"}
      delete "/api/mrt_admin/lost/1"
      expect_not_permitted(response)
    end
  end

end
