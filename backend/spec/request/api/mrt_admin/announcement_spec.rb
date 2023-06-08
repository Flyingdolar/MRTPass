require 'rails_helper'
require './spec/support/authorized_helper'
require 'simplecov'
SimpleCov.start
RSpec.configure do |c|
    c.include AuthorizedHelper
end


RSpec.describe "Api::MrtAdmin::Announcement", type: :request do
    before do
        Member.create(account:"admin",password:"123456",nickname:"admin",role:"admin")
        Member.create(account:"mrt_admin",password:"123456",nickname:"北捷管理員",role:"mrt_admin")
        Member.create(account:"user1",password:"123456",nickname:"user#344003",role:"user")
        Announcement.create(topic:"test",context:"123",member_id:1)
        Announcement.create(topic:"test2",context:"789",member_id:1)
    end

    describe "GET /api/mrt_admin/announcement" do
        example "succeed to get announcement list" do
            get "/api/mrt_admin/announcement"
            expect(response).to have_http_status(200)
            expect(JSON.parse(response.body)).to eq(
                JSON.parse( 
                {
                    "status": "success",
                    "error": false,
                    "message": "succeed to get announcement list",
                    "data": [Announcement.find(1),Announcement.find(2)]
                }.to_json
                )
            )
        end
    end


    describe "GET /api/mrt_admin/announcement/1" do
        example "succeed to get announcement" do
            get "/api/mrt_admin/announcement/1"
            expect(response).to have_http_status(200)
            expect(JSON.parse(response.body)).to eq(
                JSON.parse( 
                {
                    "status": "success",
                    "error": false,
                    "message": "succeed to get announcement",
                    "data": Announcement.find(1)
                }.to_json
                )
            )
        end
    end


    describe "POST /api/mrt_admin/announcement" do
        example "succeed to create announcement(admin)" do
            post "/sign_in",params:{account:"admin",password:"123456"}
            post "/api/mrt_admin/announcement",params:{topic:"create",context:"12354484683265"}
            expect(response).to have_http_status(200)
            expect(JSON.parse(response.body)).to eq(
                JSON.parse( 
                {
                    "status": "success",
                    "error": false,
                    "message": "succeed to create announcement",
                    "data": Announcement.last
                }.to_json
                )
            )
        end

        example "succeed to create announcement(mrt_admin)" do
            post "/sign_in",params:{account:"mrt_admin",password:"123456"}
            post "/api/mrt_admin/announcement",params:{topic:"create",context:"12354484683265"}
            expect(response).to have_http_status(200)
            expect(JSON.parse(response.body)).to eq(
                JSON.parse( 
                {
                    "status": "success",
                    "error": false,
                    "message": "succeed to create announcement",
                    "data": Announcement.last
                }.to_json
                )
            )
        end

        example "failed to create announcement(topic is empty)" do
            post "/sign_in",params:{account:"admin",password:"123456"}
            post "/api/mrt_admin/announcement",params:{context:"12354484683265"}
            expect(response).to have_http_status(400)
            expect(JSON.parse(response.body)).to eq(
                JSON.parse( 
                {
                    "status": "error",
                    "error": true,
                    "message": "failed to create announcement",
                    "data": {
                        "topic": [
                            "can't be blank"
                        ]
                    }
                }.to_json
                )
            )
        end

        example "failed to create announcement(context is empty)" do
            post "/sign_in",params:{account:"admin",password:"123456"}
            post "/api/mrt_admin/announcement",params:{topic:"create"}
            expect(response).to have_http_status(400)
            expect(JSON.parse(response.body)).to eq(
                JSON.parse( 
                {
                    "status": "error",
                    "error": true,
                    "message": "failed to create announcement",
                    "data": {
                        "context": [
                            "can't be blank"
                        ]
                    }
                }.to_json
                )
            )
        end

        example "failed to create announcement(not login)" do
            post "/api/mrt_admin/announcement",params:{topic:"create",context:"123456"}
            expect_unauthorized(response)
        end

        example "failed to create announcement(Unauthorized)" do
            post "/sign_in",params:{account:"user1",password:"123456"}
            post "/api/mrt_admin/announcement",params:{topic:"create",context:"123456"}
            expect_not_permitted(response)
        end
    end


    describe "PATCH /api/mrt_admin/announcement/1" do
        example "succeed to update announcement(admin)" do
            post "/sign_in",params:{account:"admin",password:"123456"}
            patch "/api/mrt_admin/announcement/1",params:{topic:"create",context:"12354484683265"}
            expect(response).to have_http_status(200)
            expect(JSON.parse(response.body)).to eq(
                JSON.parse( 
                {
                    "status": "success",
                    "error": false,
                    "message": "succeed to update announcement",
                    "data": Announcement.first
                }.to_json
                )
            )
        end

        example "succeed to update announcement(mrt_admin)" do
            post "/sign_in",params:{account:"mrt_admin",password:"123456"}
            patch "/api/mrt_admin/announcement/1",params:{topic:"create",context:"12354484683265"}
            expect(response).to have_http_status(200)
            expect(JSON.parse(response.body)).to eq(
                JSON.parse( 
                {
                    "status": "success",
                    "error": false,
                    "message": "succeed to update announcement",
                    "data": Announcement.first
                }.to_json
                )
            )
        end

        example "failed to update announcement(topic is empty)" do
            post "/sign_in",params:{account:"admin",password:"123456"}
            patch "/api/mrt_admin/announcement/1",params:{topic:"",context:"12354484683265"}
            expect(response).to have_http_status(400)
            expect(JSON.parse(response.body)).to eq(
                JSON.parse( 
                {
                    "status": "error",
                    "error": true,
                    "message": "failed to update announcement",
                    "data": {
                        "topic": [
                            "can't be blank"
                        ]
                    }
                }.to_json
                )
            )
        end

        example "failed to update announcement(context is empty)" do
            post "/sign_in",params:{account:"admin",password:"123456"}
            patch "/api/mrt_admin/announcement/1",params:{topic:"create",context:""}
            expect(response).to have_http_status(400)
            expect(JSON.parse(response.body)).to eq(
                JSON.parse( 
                {
                    "status": "error",
                    "error": true,
                    "message": "failed to update announcement",
                    "data": {
                        "context": [
                            "can't be blank"
                        ]
                    }
                }.to_json
                )
            )
        end

        example "failed to update announcement(not login)" do
            patch "/api/mrt_admin/announcement/1",params:{topic:"create",context:"123456"}
            expect_unauthorized(response)
        end

        example "failed to create announcement(Unauthorized)" do
            post "/sign_in",params:{account:"user1",password:"123456"}
            patch "/api/mrt_admin/announcement/1",params:{topic:"create",context:"123456"}
            expect_not_permitted(response)
        end
    end


    describe "DELETE /api/mrt_admin/announcement/2" do
        example "succeed to delete announcement(admin)" do
            post "/sign_in",params:{account:"admin",password:"123456"}
            delete "/api/mrt_admin/announcement/1"
            expect(response).to have_http_status(200)
            expect(JSON.parse(response.body)).to eq(
                JSON.parse( 
                {
                    "status": "success",
                    "error": false,
                    "message": "succeed to delete announcement",
                    "data": {}
                }.to_json
                )
            )
        end

        example "succeed to delete announcement(mrt_admin)" do
            post "/sign_in",params:{account:"mrt_admin",password:"123456"}
            delete "/api/mrt_admin/announcement/1"
            expect(response).to have_http_status(200)
            expect(JSON.parse(response.body)).to eq(
                JSON.parse( 
                {
                    "status": "success",
                    "error": false,
                    "message": "succeed to delete announcement",
                    "data": {}
                }.to_json
                )
            )
        end

        example "failed to update announcement(not login)" do
            delete "/api/mrt_admin/announcement/1"
            expect_unauthorized(response)
        end

        example "failed to create announcement(Unauthorized)" do
            post "/sign_in",params:{account:"user1",password:"123456"}
            delete "/api/mrt_admin/announcement/1"
            expect_not_permitted(response)
        end
    end
end