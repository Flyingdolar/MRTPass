require 'rails_helper'
require './spec/support/authorized_helper'

RSpec.describe "Account", type: :request do
    before do
        @member=Member.create(account:"123123@gmail.com",password:"example",nickname:"handsome boy",role:"user")
    end

    describe "POST /sign_in" do
        example "succeed to login" do
            post "/sign_in",params:{account:"123123@gmail.com",password:"example"}
            expect(response).to have_http_status(200)
            expect(JSON.parse(response.body)).to eq(
                JSON.parse( 
                  {
                    "status": "success",
                    "error": false,
                    "message": "succeed to login",
                    "data": Member.first
                  }.to_json
                )
              )      
        end
        
        example "account doesn't exit" do
            post "/sign_in",params:{account:"123@gmail.com"}
            expect(response).to have_http_status(400)
            expect(JSON.parse(response.body)).to eq(
                JSON.parse( 
                  {
                    "status": "error",
                    "error": true,
                    "message": "failed to login",
                    "data": "This account doesn't exist."
                  }.to_json
                )
              )      
        end 

        example "password error" do
            post "/sign_in",params:{account:"123123@gmail.com",password:"123"}
            expect(response).to have_http_status(400)
            expect(JSON.parse(response.body)).to eq(
                JSON.parse( 
                  {
                    "status": "error",
                    "error": true,
                    "message": "failed to login",
                    "data": "Password error."
                  }.to_json
                )
              )      
        end 

        example "already login" do
            post "/sign_in",params:{account:"123123@gmail.com",password:"example"}
            post "/sign_in",params:{account:"123123@gmail.com",password:"123"}
            expect(response).to have_http_status(403)
            expect(JSON.parse(response.body)).to eq(
                JSON.parse( 
                  {
                    "status": "error",
                    "error": true,
                    "message": "failed to login",
                    "data": "Already logged in (handsome boy)."
                  }.to_json
                )
              )      
        end 
    end      


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

        example "failed to sign up(account be taken)" do
            post "/sign_up",params:{account:"123123@gmail.com",password:"example"}
            expect(response).to have_http_status(400)
            expect(JSON.parse(response.body)).to eq(
                JSON.parse( 
                  {
                    "status": "error",
                    "error": true,
                    "message": "failed to create account",
                    "data": {
                        "error": {
                            "account": [
                                "has already been taken"
                            ]
                        }
                    }
                  }.to_json
                )
              )
        end

        example "failed to sign up(account empty)" do
            post "/sign_up",params:{password:"example"}
            expect(response).to have_http_status(400)
            expect(JSON.parse(response.body)).to eq(
                JSON.parse( 
                  {
                    "status": "error",
                    "error": true,
                    "message": "failed to create account",
                    "data": {
                        "error": {
                            "account": [
                                "can't be blank"
                            ]
                        }
                    }
                  }.to_json
                )
              )
        end

        example "failed to sign up(password empty)" do
            post "/sign_up",params:{account:"123321@gmail.com"}
            expect(response).to have_http_status(400)
            expect(JSON.parse(response.body)).to eq(
                JSON.parse( 
                  {
                    "status": "error",
                    "error": true,
                    "message": "failed to create account",
                    "data": {
                        "error": {
                            "password": [
                                "can't be blank"
                            ]
                        }
                    }
                  }.to_json
                )
              )
        end
    end

    
end
