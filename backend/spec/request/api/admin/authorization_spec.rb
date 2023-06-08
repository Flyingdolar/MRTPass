require 'rails_helper'
require './spec/support/authorized_helper'
require 'simplecov'
SimpleCov.start
RSpec.configure do |c|
    c.include AuthorizedHelper
end


RSpec.describe "Api::Admin::Authorization", type: :request do
    before do
        Member.create(account:"admin",password:"123456",nickname:"admin",role:"admin")
        Member.create(account:"mrt_admin_1",password:"123456",nickname:"北捷管理員",role:"mrt_admin")
        Member.create(account:"mrt_admin_2",password:"123456",nickname:"古亭管理員",role:"mrt_admin")
        Member.create(account:"user1",password:"123456",nickname:"user#344003",role:"user")
        Member.create(account:"user2",password:"123456",nickname:"user#344004",role:"user")
    end

    describe "GET /api/admin/authorization" do
        example "succeed to get member list" do
            post "/sign_in",params:{account:"admin",password:"123456"}
            get "/api/admin/authorization"
            expect(response).to have_http_status(200)
            expect(JSON.parse(response.body)).to eq(
                JSON.parse( 
                {
                    "status": "success",
                    "error": false,
                    "message": "succeed to get member list",
                    "data": [Member.find(2),Member.find(3),Member.find(4),Member.find(5)]
                }.to_json
                )
            )
        end

        example "failed to get member list(not login)" do
            get "/api/admin/authorization"
            expect_unauthorized(response)
        end

        example "failed to get member list(mrt_admin)" do
            post "/sign_in",params:{account:"mrt_admin_1",password:"123456"}
            get "/api/admin/authorization"
            expect_not_permitted(response)
        end

        example "failed to get member list(user)" do
            post "/sign_in",params:{account:"user1",password:"123456"}
            get "/api/admin/authorization"
            expect_not_permitted(response)
        end
    end


    describe "GET /api/admin/authorization/:id" do
        example "succeed to get member list" do
            post "/sign_in",params:{account:"admin",password:"123456"}
            get "/api/admin/authorization/2"
            expect(response).to have_http_status(200)
            expect(JSON.parse(response.body)).to eq(
                JSON.parse( 
                {
                    "status": "success",
                    "error": false,
                    "message": "succeed to get member",
                    "data": Member.find(2)
                }.to_json
                )
            )
        end

        example "failed to get member list" do
            post "/sign_in",params:{account:"admin",password:"123456"}
            get "/api/admin/authorization/1"
            expect(response).to have_http_status(400)
            expect(JSON.parse(response.body)).to eq(
                JSON.parse( 
                {
                    "status": "error",
                    "error": true,
                    "message": "failed to get member",
                    "data": "Member 1 is admin."
                }.to_json
                )
            )
        end

        example "failed to get member list(not login)" do
            get "/api/admin/authorization/2"
            expect_unauthorized(response)
        end

        example "failed to get member list(mrt_admin)" do
            post "/sign_in",params:{account:"mrt_admin_1",password:"123456"}
            get "/api/admin/authorization/2"
            expect_not_permitted(response)
        end

        example "failed to get member list(user)" do
            post "/sign_in",params:{account:"user1",password:"123456"}
            get "/api/admin/authorization/2"
            expect_not_permitted(response)
        end
    end


    describe "PATCH /api/admin/authorization/:id" do
        example "succeed to update member information" do
            post "/sign_in",params:{account:"admin",password:"123456"}
            patch "/api/admin/authorization/2",params:{password:"1234567",nickname:"yoyo",role:"user"}
            expect(response).to have_http_status(200)
            expect(JSON.parse(response.body)).to eq(
                JSON.parse( 
                {
                    "status": "success",
                    "error": false,
                    "message": "succeed to update member information",
                    "data": Member.find(2)
                }.to_json
                )
            )
            post "/sign_out"
            post "/sign_in",params:{account:"mrt_admin_1",password:"1234567"}
            expect(response).to have_http_status(200)
            post "/api/mrt_admin/station",params:{name:"我家",exit_Num:2,linecolor_1:"G",number_1:11}
            expect_not_permitted(response)
        end

        example "failed to update member information" do
            post "/sign_in",params:{account:"admin",password:"123456"}
            patch "/api/admin/authorization/2",params:{password:"1234567",nickname:"",role:"user"}
            expect(response).to have_http_status(400)
            expect(JSON.parse(response.body)).to eq(
                JSON.parse( 
                {
                    "status": "error",
                    "error": true,
                    "message": "failed to update member information",
                    "data": {
                        nickname:["can't be blank"]
                    }
                }.to_json
                )
            )
        end

        example "failed to update member information(is admin)" do
            post "/sign_in",params:{account:"admin",password:"123456"}
            patch "/api/admin/authorization/1",params:{password:"1234567",nickname:"",role:"user"}
            expect(response).to have_http_status(400)
            expect(JSON.parse(response.body)).to eq(
                JSON.parse( 
                {
                    "status": "error",
                    "error": true,
                    "message": "failed to update member information",
                    "data": "Member 1 is admin."
                }.to_json
                )
            )
        end

        example "failed to update member information(not login)" do
            patch "/api/admin/authorization/2",params:{password:"1234567",nickname:"",role:"user"}
            expect_unauthorized(response)
        end

        example "failed to update member information(mrt_admin)" do
            post "/sign_in",params:{account:"mrt_admin_1",password:"123456"}
            patch "/api/admin/authorization/2",params:{password:"1234567",nickname:"",role:"user"}
            expect_not_permitted(response)
        end

        example "failed to update member information(user)" do
            post "/sign_in",params:{account:"user1",password:"123456"}
            patch "/api/admin/authorization/2",params:{password:"1234567",nickname:"",role:"user"}
            expect_not_permitted(response)
        end
    end

    describe "DELETE /api/admin/authorization/:id" do
        example "succeed to delete member" do
            post "/sign_in",params:{account:"admin",password:"123456"}
            delete "/api/admin/authorization/2"
            expect(response).to have_http_status(200)
            expect(JSON.parse(response.body)).to eq(
                JSON.parse( 
                {
                    "status": "success",
                    "error": false,
                    "message": "succeed to delete member",
                    "data": {}
                }.to_json
                )
            )
        end

        example "failed to delete member" do
            post "/sign_in",params:{account:"admin",password:"123456"}
            delete "/api/admin/authorization/1"
            expect(response).to have_http_status(400)
            expect(JSON.parse(response.body)).to eq(
                JSON.parse( 
                {
                    "status": "error",
                    "error": true,
                    "message": "failed to delete member",
                    "data": "Member 1 is admin."
                }.to_json
                )
            )
        end

        example "failed to delete member(not login)" do
            delete "/api/admin/authorization/2"
            expect_unauthorized(response)
        end

        example "failed to delete member(mrt_admin)" do
            post "/sign_in",params:{account:"mrt_admin_1",password:"123456"}
            delete "/api/admin/authorization/2"
            expect_not_permitted(response)
        end

        example "failed to delete member(user)" do
            post "/sign_in",params:{account:"user1",password:"123456"}
            delete "/api/admin/authorization/2"
            expect_not_permitted(response)
        end
    end

end