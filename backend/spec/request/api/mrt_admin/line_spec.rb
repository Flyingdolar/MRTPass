require 'rails_helper'
require './spec/support/authorized_helper'
require 'simplecov'
SimpleCov.start
RSpec.configure do |c|
    c.include AuthorizedHelper
end
RSpec.describe "Api::MrtAdmin::Lines", type: :request do
  before do
    Member.create(account:"admin",password:"123456",nickname:"admin",role:"admin")
    Member.create(account:"mrt_admin",password:"123456",nickname:"北捷管理員",role:"mrt_admin")
    Member.create(account:"user1",password:"123456",nickname:"user#344003",role:"user")
    Line.create(linecolor:"BR",name:"文湖線",colorcode:"#c48c31")
    Line.create(linecolor: "R",name:"淡水信義線",colorcode:"#e3002c")
    Line.create(linecolor: "G",name:"松山新店線",colorcode:"#008659")
    Line.create(linecolor: "O",name:"中和新蘆線",colorcode:"#f8b61c")
    Line.create(linecolor:"BL",name:"板南線",colorcode:"#0070bd")
    Line.create(linecolor:"Y",name:"環狀線",colorcode:"#ffdb00")
    Line.create(linecolor:"LG",name:"小碧潭支線",colorcode:"#cfdb00")
    Line.create(linecolor:"LR",name:"新北投支線",colorcode:"#fd92a3")
    Station.create(x_Pos:25.0207,y_Pos:121.5282,exit_Num:5,name:"台電大樓")
    Station.create(x_Pos:25.0264,y_Pos:121.5229,exit_Num:9,name:"古亭")
    StationNo.create(linecolor:"G",number:8 ,station_id:1)
    StationNo.create(linecolor:"G",number:9 ,station_id:2)
    StationNo.create(linecolor:"O",number:5 ,station_id:2)

  end
  describe "GET /api/mrt_admin/line" do
    example "succeed to get line list" do
      get "/api/mrt_admin/line"
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq(
        JSON.parse( 
        {
            "status": "success",
            "error": false,
            "message": "succeed to get line list",
            "data": Line.all
        }.to_json
        )
      )
    end
  end


  describe "GET /api/mrt_admin/line/2" do
    example "succeed to get line" do
      get "/api/mrt_admin/line/2"
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq(
        JSON.parse( 
        {
            "status": "success",
            "error": false,
            "message": "succeed to get line",
            "data": Line.find(2)
        }.to_json
        )
      )
    end
  end


  describe "POST /api/mrt_admin/line" do
    example "succeed to create line" do
      post "/sign_in",params:{account:"mrt_admin",password:"123456"}
      post "/api/mrt_admin/line",params:{linecolor:"QQQ",name:"測試",colorcode:"#f000ff"}
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq(
        JSON.parse( 
        {
            "status": "success",
            "error": false,
            "message": "succeed to create line",
            "data": Line.last
        }.to_json
        )
      )
    end

    example "failed to create line(not complete filled)" do
      post "/sign_in",params:{account:"mrt_admin",password:"123456"}
      post "/api/mrt_admin/line",params:{linecolor:"QQQ",colorcode:"#f000ff"}
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body)).to eq(
        JSON.parse( 
        {
            "status": "error",
            "error": true,
            "message": "failed to create line",
            "data": {
              name:["can't be blank"]
            }
        }.to_json
        )
      )
    end

    example "failed to create line(linecolor duplication)" do
      post "/sign_in",params:{account:"mrt_admin",password:"123456"}
      post "/api/mrt_admin/line",params:{linecolor:"G",name:"測試",colorcode:"#f000ff"}
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body)).to eq(
        JSON.parse( 
        {
            "status": "error",
            "error": true,
            "message": "failed to create line",
            "data": {
              linecolor:["has already been taken"]
            }
        }.to_json
        )
      )
    end

    example "failed to create line(not login)" do
      post "/api/mrt_admin/line",params:{linecolor:"G",name:"測試",colorcode:"#f000ff"}
      expect_unauthorized(response)
    end

    example "failed to create line(Unauthorized)" do
      post "/sign_in",params:{account:"user1",password:"123456"}
      post "/api/mrt_admin/line",params:{linecolor:"G",name:"測試",colorcode:"#f000ff"}
      expect_not_permitted(response)
    end
  end


  describe "PATCH /api/mrt_admin/line/1" do
    example "succeed to update line" do
      post "/sign_in",params:{account:"mrt_admin",password:"123456"}
      patch "/api/mrt_admin/line/1",params:{linecolor:"BR",name:"測試",colorcode:"#f000ff"}
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq(
        JSON.parse( 
        {
            "status": "success",
            "error": false,
            "message": "succeed to update line",
            "data": Line.first
        }.to_json
        )
      )
    end

    example "failed to update line(not complete filled)" do
      post "/sign_in",params:{account:"mrt_admin",password:"123456"}
      patch "/api/mrt_admin/line/1",params:{linecolor:"QQQ",name:"",colorcode:"#f000ff"}
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body)).to eq(
        JSON.parse( 
        {
            "status": "error",
            "error": true,
            "message": "failed to update line",
            "data": {
              name:["can't be blank"]
            }
        }.to_json
        )
      )
    end

    example "failed to update line(linecolor duplication)" do
      post "/sign_in",params:{account:"mrt_admin",password:"123456"}
      patch "/api/mrt_admin/line/1",params:{linecolor:"G",name:"測試",colorcode:"#f000ff"}
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body)).to eq(
        JSON.parse( 
        {
            "status": "error",
            "error": true,
            "message": "failed to update line",
            "data": {
              linecolor:["has already been taken"]
            }
        }.to_json
        )
      )
    end

    example "failed to update line(not login)" do
      patch "/api/mrt_admin/line/1",params:{linecolor:"G",name:"測試",colorcode:"#f000ff"}
      expect_unauthorized(response)
    end

    example "failed to update line(Unauthorized)" do
      post "/sign_in",params:{account:"user1",password:"123456"}
      patch "/api/mrt_admin/line/1",params:{linecolor:"G",name:"測試",colorcode:"#f000ff"}
      expect_not_permitted(response)
    end
  end

  describe "DELETE /api/mrt_admin/line/:id" do
    example "succeed to delete line(have station)" do
      post "/sign_in",params:{account:"mrt_admin",password:"123456"}
      delete "/api/mrt_admin/line/3"
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq(
        JSON.parse( 
        {
            "status": "success",
            "error": false,
            "message": "succeed to delete line",
            "data": {}
        }.to_json
        )
      )
      expect(Station.all).to eq([Station.find(2)])
      expect(StationNo.all).to eq([StationNo.find(3)])
    end

    example "succeed to delete line(have no station)" do
      post "/sign_in",params:{account:"mrt_admin",password:"123456"}
      delete "/api/mrt_admin/line/1"
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq(
        JSON.parse( 
        {
            "status": "success",
            "error": false,
            "message": "succeed to delete line",
            "data": {}
        }.to_json
        )
      )
      expect(Station.all).to eq([Station.find(1),Station.find(2)])
      expect(StationNo.all).to eq([StationNo.find(1),StationNo.find(2),StationNo.find(3)])
    end

    example "failed to delete line(not login)" do
      delete "/api/mrt_admin/line/1"
      expect_unauthorized(response)
    end

    example "failed to delete line(Unauthorized)" do
      post "/sign_in",params:{account:"user1",password:"123456"}
      delete "/api/mrt_admin/line/1"
      expect_not_permitted(response)
    end
  end

end
