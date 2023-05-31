require 'rails_helper'
require './spec/support/authorized_helper'

RSpec.configure do |c|
  c.include AuthorizedHelper
end

RSpec.describe "Account", type: :request do
  before do
      @member=Member.create(account:"123123@gmail.com",password:"example",nickname:"handsome boy",role:"user")
  end

  let(:filepath) { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', '1.jpg'), 'image/jpg') }
  let(:invalid_filepath) { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', '2.txt'), 'text/plain') }
  

  describe "POST /sign_up" do
      example "succeed to sign up" do
          post "/sign_up",params:{account:"123456@gmail.com",password:"example"}
          expect(response).to have_http_status(200)
          expect(JSON.parse(response.body)).to eq(
              JSON.parse( 
                {
                  "status": "success",
                  "error": false,
                  "message": "succeed to created account",
                  "data": Member.last
                }.to_json
              )
            )
          post "/sign_in",params:{account:"123456@gmail.com",password:"example"}
          expect(response).to have_http_status(200)
          expect(JSON.parse(response.body)).to eq(
              JSON.parse( 
                {
                  "status": "success",
                  "error": false,
                  "message": "succeed to login",
                  "data": Member.last
                }.to_json
              )
            )            
      end
    end
  end

RSpec.describe "Api::MrtAdmin::Infos", type: :request do

  describe "POST /common/create" do
    example "succeed to create common info" do

      post "/api/mrt_admin/common", params: {
        name: "白帝城",
        photo: "none",
        address: "gongguang",
        Des: "重慶麻辣燙",
        linecolor1: "g",
        number1: 1
      }

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq(
        {
          "status" => "success",
          "error" => false,
          "message" => "successfully created trans_info",
          "data" => {
            "info" => Info.last.as_json,
            "stationinfo" => Stationinfo.last.as_json
          }
        }
      )
    end
  end
end
