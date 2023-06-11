require 'rails_helper'
require './spec/support/authorized_helper'
require 'simplecov'
SimpleCov.start
RSpec.configure do |c|
    c.include AuthorizedHelper
end

RSpec.describe "Api::MrtAdmin::Tickets", type: :request do
  before do
    Member.create(account:"admin",password:"123456",nickname:"admin",role:"admin")
    Member.create(account:"mrt_admin",password:"123456",nickname:"北捷管理員",role:"mrt_admin")
    Member.create(account:"user1",password:"123456",nickname:"user#344003",role:"user")
    Ticket.create(upper_bound: 5.0,lower_bound: 0.0,price:20)
    Ticket.create(upper_bound: 8.0,lower_bound: 5.0,price:25)
    Ticket.create(upper_bound:11.0,lower_bound: 8.0,price:30)
    Ticket.create(upper_bound:1000.0,lower_bound:11.0,price:35)
    Station.create(x_Pos:25.0599,y_Pos:121.6160,exit_Num:2,name:"南港軟體園區")
    Station.create(x_Pos:25.0553,y_Pos:121.6175,exit_Num:7,name:"南港展覽館")
    Station.create(x_Pos:24.9982,y_Pos:121.5793,exit_Num:2,name:"動物園")
    Station.create(x_Pos:25.1678,y_Pos:121.4456,exit_Num:3,name:"淡水")
  end

  describe "GET /api/mrt_admin/ticket" do
    example "succeed to get ticket list" do
      get "/api/mrt_admin/ticket"
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq(
          JSON.parse( 
          {
              "status": "success",
              "error": false,
              "message": "succeed to get ticket list",
              "data": Ticket.all
          }.to_json
          )
      )
    end
  end

  describe "GET /api/mrt_admin/ticket/2" do
    example "succeed to get ticket" do
      get "/api/mrt_admin/ticket/2"
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq(
          JSON.parse( 
          {
              "status": "success",
              "error": false,
              "message": "succeed to get ticket",
              "data": Ticket.find(2)
          }.to_json
          )
      )
    end
  end

  describe "DELETE /api/mrt_admin/ticket" do
    example "succeed to delete all ticket" do
      post "/sign_in",params:{account:"mrt_admin",password:"123456"}
      delete "/api/mrt_admin/ticket"
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq(
          JSON.parse( 
          {
              "status": "success",
              "error": false,
              "message": "succeed to delete all ticket",
              "data": {}
          }.to_json
          )
      )
    end

    example "failed to delete all ticket(not login)" do
      delete "/api/mrt_admin/ticket"
      expect_unauthorized(response)
    end

    example "failed to delete all ticket(Unauthorized)" do
        post "/sign_in",params:{account:"user1",password:"123456"}
        delete "/api/mrt_admin/ticket"
        expect_not_permitted(response)
    end
  end


  describe "POST /api/mrt_admin/ticket" do
    example "succeed to create 3 ticket" do
      post "/sign_in",params:{account:"mrt_admin",password:"123456"}
      delete "/api/mrt_admin/ticket"
      post "/api/mrt_admin/ticket",params:{price:20,distance:0.0}
      expect(response).to have_http_status(200)
      post "/api/mrt_admin/ticket",params:{price:5,distance:5.0}
      expect(response).to have_http_status(200)
      post "/api/mrt_admin/ticket",params:{price:5,distance:8.0}
      expect(response).to have_http_status(200)
      post "/api/mrt_admin/ticket",params:{price:5,distance:9.0}
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq(
        JSON.parse( 
        {
            "status": "success",
            "error": false,
            "message": "succeed to create ticket",
            "data": Ticket.all
        }.to_json
        )
      )
    end

    example "failed to create ticket(some distance error)" do
      post "/sign_in",params:{account:"mrt_admin",password:"123456"}
      delete "/api/mrt_admin/ticket"
      post "/api/mrt_admin/ticket",params:{price:20,distance:0.0}
      expect(response).to have_http_status(200)
      post "/api/mrt_admin/ticket",params:{price:5,distance:5.0}
      expect(response).to have_http_status(200)
      post "/api/mrt_admin/ticket",params:{price:5,distance:4.0}
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body)).to eq(
        JSON.parse( 
        {
            "status": "error",
            "error": true,
            "message": "failed to create ticket",
            "data": "Distance is lower than last one."
        }.to_json
        )
      )
      expect(Ticket.all).to eq([])
    end

    example "failed to create ticket(some blank)" do
      post "/sign_in",params:{account:"mrt_admin",password:"123456"}
      delete "/api/mrt_admin/ticket"
      post "/api/mrt_admin/ticket",params:{price:20,distance:0.0}
      expect(response).to have_http_status(200)
      post "/api/mrt_admin/ticket",params:{price:5,distance:5.0}
      expect(response).to have_http_status(200)
      post "/api/mrt_admin/ticket",params:{price:5}
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body)).to eq(
        JSON.parse( 
        {
            "status": "error",
            "error": true,
            "message": "failed to create ticket",
            "data": {
              lower_bound:["can't be blank"]
            }
        }.to_json
        )
      )
      expect(Ticket.all).to eq([])
    end

    example "failed to delete all ticket(not login)" do
      post "/api/mrt_admin/ticket",params:{price:20,distance:0.0}
      expect_unauthorized(response)
    end

    example "failed to delete all ticket(Unauthorized)" do
        post "/sign_in",params:{account:"user1",password:"123456"}
        post "/api/mrt_admin/ticket",params:{price:20,distance:0.0}
        expect_not_permitted(response)
    end
  end

  describe "GET /api/mrt_admin/price_search" do
    example "succeed to return ticket price" do
      get "/api/mrt_admin/price_search" ,params:{station1:1,station2:2}
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq(
          JSON.parse( 
          {
              "status": "success",
              "error": false,
              "message": "succeed to return ticket price",
              "data": 20
          }.to_json
          )
      )
    end

    example "succeed to return ticket price" do
      get "/api/mrt_admin/price_search" ,params:{station1:1,station2:3}
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq(
          JSON.parse( 
          {
              "status": "success",
              "error": false,
              "message": "succeed to return ticket price",
              "data": 25
          }.to_json
          )
      )
    end

    example "succeed to return ticket price" do
      get "/api/mrt_admin/price_search" ,params:{station1:1,station2:4}
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq(
          JSON.parse( 
          {
              "status": "success",
              "error": false,
              "message": "succeed to return ticket price",
              "data": 35
          }.to_json
          )
      )
    end

    example "succeed to return ticket price" do
      get "/api/mrt_admin/price_search" ,params:{station1:4,station2:1}
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq(
          JSON.parse( 
          {
              "status": "success",
              "error": false,
              "message": "succeed to return ticket price",
              "data": 35
          }.to_json
          )
      )
    end

  end

end
