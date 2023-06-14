require 'rails_helper'
require './spec/support/authorized_helper'
require 'simplecov'
SimpleCov.start
RSpec.configure do |c|
    c.include AuthorizedHelper
end
RSpec.describe "Api::MrtAdmin::Comments", type: :request do
  before do
    Member.create(account:"admin",password:"123456",nickname:"admin",role:"admin")
    Member.create(account:"mrt_admin",password:"123456",nickname:"北捷管理員",role:"mrt_admin")
    Member.create(account:"user1",password:"123456",nickname:"user#344003",role:"user")
    Info.create(name:"阿里媽媽",photo:"123",address:"水源市場",type_:"Common",Des:"好吃")
    Info.create(name:"阿里爸爸",photo:"123",address:"水源市場",type_:"Common",Des:"好吃")
    Comment.create(comment:"123321",score:5,member_id:2,info_id:1,photo:filepath)
    Comment.create(comment:"123321",score:2,member_id:3,info_id:1,photo:filepath)
    Comment.create(comment:"123321",score:3,member_id:1,info_id:1,photo:filepath)
  end

  let(:filepath) { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', '1.jpg'), 'image/jpg') }
  let(:invalid_filepath) { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', '2.txt'), 'text/plain') }

  describe "POST /api/member/info/:info_id/comment" do
    example "succeed to create comment" do
      post "/sign_in",params:{account:"user1",password:"123456"}
      post "/api/member/info/2/comment",params:{comment:"nice",score:5,photo:filepath}
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq(
          JSON.parse( 
            {
              "status": "success",
              "error": false,
              "message": "succeed to create comment",
              "data": Comment.last
            }.to_json
          )
        ) 
    end

    example "failed to create comment(photo format error)" do
      post "/sign_in",params:{account:"user1",password:"123456"}
      post "/api/member/info/2/comment",params:{comment:"nice",score:5,photo:invalid_filepath}
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body)).to eq(
          JSON.parse( 
            {
              "status": "error",
              "error": true,
              "message": "failed to create comment",
              "data": {
                photo:["You are not allowed to upload \"txt\" files, allowed types: jpg, jpeg, png"]
              }
            }.to_json
          )
        ) 
    end

    example "failed to create comment(not complete filled)" do
      post "/sign_in",params:{account:"user1",password:"123456"}
      post "/api/member/info/2/comment",params:{comment:"nice"}
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body)).to eq(
          JSON.parse( 
            {
              "status": "error",
              "error": true,
              "message": "failed to create comment",
              "data": {
                score:["can't be blank"]
              }
            }.to_json
          )
        ) 
    end

    example "failed to create comment(already comment in this info)" do
      post "/sign_in",params:{account:"user1",password:"123456"}
      post "/api/member/info/1/comment",params:{comment:"nice",score:5,photo:filepath}
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body)).to eq(
          JSON.parse( 
            {
              "status": "error",
              "error": true,
              "message": "failed to create comment",
              "data": "Each account can only leave one comment on a single attraction."
            }.to_json
          )
        ) 
    end

    example "failed to create comment(not login)" do
      post "/api/member/info/2/comment",params:{photo:filepath,comment:"123321",score:5}
      expect_unauthorized(response)
    end
  end


  describe "GET /api/member/info/1/comment" do
    example "succeed to get comment list" do
      get "/api/member/info/1/comment"
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq(
          JSON.parse( 
            {
              "status": "success",
              "error": false,
              "message": "succeed to get info_1 comment list",
              "data": [{name:"北捷管理員",comment:Comment.find(1)},
                {name:"user#344003",comment:Comment.find(2)},
                {name:"admin",comment:Comment.find(3)}]
            }.to_json
          )
        ) 
    end

    example "succeed to get comment list(but blank)" do
      get "/api/member/info/2/comment"
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq(
          JSON.parse( 
            {
              "status": "success",
              "error": false,
              "message": "succeed to get info_2 comment list",
              "data": []
            }.to_json
          )
        ) 
    end
  end


  describe "GET /api/member/info/1/comment/1" do
    example "succeed to get comment" do
      get "/api/member/info/1/comment/1"
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq(
          JSON.parse( 
            {
              "status": "success",
              "error": false,
              "message": "succeed to get comment",
              "data": Comment.find(1)
            }.to_json
          )
        ) 
    end
  end


  describe "PATCH /api/member/info/1/comment/1" do
    example "succeed to update comment" do
      post "/sign_in",params:{account:"user1",password:"123456"}
      patch "/api/member/info/1/comment/2",params:{comment:"bad",score:1} 
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq(
          JSON.parse( 
            {
              "status": "success",
              "error": false,
              "message": "succeed to update comment",
              "data": Comment.find(2)
            }.to_json
          )
        ) 
    end

    example "failed to update comment" do
      post "/sign_in",params:{account:"user1",password:"123456"}
      patch "/api/member/info/1/comment/2",params:{comment:"bad",score:nil} 
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body)).to eq(
          JSON.parse( 
            {
              "status": "error",
              "error": true,
              "message": "failed to update comment",
              "data": {
                score:["can't be blank"]
              }
            }.to_json
          )
        ) 
    end

    example "failed to update comment(photo format error)" do
      post "/sign_in",params:{account:"user1",password:"123456"}
      patch "/api/member/info/1/comment/2",params:{comment:"nice",score:5,photo:invalid_filepath}
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body)).to eq(
          JSON.parse( 
            {
              "status": "error",
              "error": true,
              "message": "failed to update comment",
              "data": {
                photo:["You are not allowed to upload \"txt\" files, allowed types: jpg, jpeg, png"]
              }
            }.to_json
          )
        ) 
    end

    example "failed to update comment(not self comment)" do
      post "/sign_in",params:{account:"admin",password:"123456"}
      patch "/api/member/info/1/comment/2",params:{comment:"bad",score:nil} 
      expect_not_permitted(response)
    end

    example "failed to update comment(not login)" do
      patch "/api/member/info/1/comment/2" 
      expect_unauthorized(response)
    end

  end

  describe "DELETE /api/member/info/1/comment/:id" do
    example "succeed to delete comment(self comment)" do
      post "/sign_in",params:{account:"user1",password:"123456"}
      delete "/api/member/info/1/comment/2" 
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq(
          JSON.parse( 
            {
              "status": "success",
              "error": false,
              "message": "succeed to delete comment",
              "data": {}
            }.to_json
          )
        ) 
    end

    example "succeed to delete comment(admin)" do
      post "/sign_in",params:{account:"admin",password:"123456"}
      delete "/api/member/info/1/comment/2" 
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq(
          JSON.parse( 
            {
              "status": "success",
              "error": false,
              "message": "succeed to delete comment",
              "data": {}
            }.to_json
          )
        ) 
    end

    example "failed to delete comment(other's comment)" do
      post "/sign_in",params:{account:"mrt_admin",password:"123456"}
      delete "/api/member/info/1/comment/2" 
      expect_not_permitted(response)
    end

    example "failed to delete comment(not login)" do
      delete "/api/member/info/1/comment/2" 
      expect_unauthorized(response)
    end
  end

  
end
