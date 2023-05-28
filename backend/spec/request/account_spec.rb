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

    
    describe "POST /sign_in" do
        example "succeed to login(login nil)" do
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

        example "succeed to login(last login false)" do
            Login.create(isLogin:false)
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

        example "succeed to login(session nil)" do
            Login.create(isLogin:true)
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


    describe "GET /session" do
        example "succeed to get session" do
            get "/session"
            expect(response).to have_http_status(200)
            expect(JSON.parse(response.body)).to eq(
                JSON.parse( 
                  {
                    "status": "success",
                    "error": false,
                    "message": "succeed to get session",
                    "data": {isLogin:false}
                  }.to_json
                )
              )
            post "/sign_in",params:{account:"123123@gmail.com",password:"example"}     
            get "/session"
            expect(response).to have_http_status(200)
            expect(JSON.parse(response.body)).to eq(
                JSON.parse( 
                  {
                    "status": "success",
                    "error": false,
                    "message": "succeed to get session",
                    "data": {
                        isLogin:true,
                        member: Member.first
                    }
                  }.to_json
                )
              )    
            Login.create(isLogin:false)
            get "/session"
            expect(response).to have_http_status(200)
            expect(JSON.parse(response.body)).to eq(
                JSON.parse( 
                  {
                    "status": "success",
                    "error": false,
                    "message": "succeed to get session",
                    "data": {isLogin:false}
                  }.to_json
                )
              )
        end

        example "failed to get session" do
            post "/sign_in",params:{account:"123123@gmail.com",password:"example"}
            Session.destroy_all
            get "/session"
            expect(response).to have_http_status(400)
            expect(JSON.parse(response.body)).to eq(
                JSON.parse( 
                  {
                    "status": "error",
                    "error": true,
                    "message": "failed to get session",
                    "data": "This is no session log."
                  }.to_json
                )
              )
        end
    end


    describe "POST /sign_out" do
        example "succeed to logout" do
        post "/sign_in",params:{account:"123123@gmail.com",password:"example"}    
        post "/sign_out"
        expect(response).to have_http_status(200)
            expect(JSON.parse(response.body)).to eq(
                JSON.parse( 
                  {
                    "status": "success",
                    "error": false,
                    "message": "succeed to logout",
                    "data": {}
                  }.to_json
                )
              )
        end

        example "failed to logout" do
            post "/sign_out"
            expect(response).to have_http_status(401)
            expect(JSON.parse(response.body)).to eq(
                JSON.parse( 
                  {
                    "status": "error",
                    "error": true,
                    "message": "failed to logout",
                    "data": "Already logged out."
                  }.to_json
                )
              )
            Login.create(isLogin:false)
            post "/sign_out"
            expect(response).to have_http_status(401)
            expect(JSON.parse(response.body)).to eq(
                JSON.parse( 
                  {
                    "status": "error",
                    "error": true,
                    "message": "failed to logout",
                    "data": "Already logged out."
                  }.to_json
                )
              )
        end

    end

    describe "PATCH /update" do
      example "succeed to update account information" do
        post "/sign_in",params:{account:"123123@gmail.com",password:"example"}  
        patch "/update",params:{nickname:"handsome guy",picture:filepath}
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)).to eq(
          JSON.parse( 
            {
              "status": "success",
              "error": false,
              "message": "succeed to update account information",
              "data": Member.first
            }.to_json
          )
        )
      end

      example "failed to update account information(picture format error)" do
        post "/sign_in",params:{account:"123123@gmail.com",password:"example"}  
        patch "/update",params:{nickname:"handsome guy",picture:invalid_filepath}
        expect(response).to have_http_status(400)
        expect(JSON.parse(response.body)).to eq(
          JSON.parse( 
            {
              "status": "error",
              "error": true,
              "message": "failed to update account information",
              "data": {
                "picture": [
                    "You are not allowed to upload \"txt\" files, allowed types: jpg, jpeg, png"
                ]
              }
            }.to_json
          )
        )
      end

      example "failed to update account information(not login)" do
        patch "/update",params:{nickname:"handsome guy",picture:filepath}
        expect_unauthorized(response)
      end
    end

    describe "PATCH /password" do
      example "succeed to update password" do
        post "/sign_in",params:{account:"123123@gmail.com",password:"example"}
        patch "/password",params:{old_password:"example",new_password:"123456",confirmation:"123456"}
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)).to eq(
          JSON.parse( 
            {
              "status": "success",
              "error": false,
              "message": "succeed to update password",
              "data": Member.first
            }.to_json
          )
        )
        post "/sign_out"
        post "/sign_in",params:{account:"123123@gmail.com",password:"123456"}
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

      example "failed to update password(old password error.)" do
        post "/sign_in",params:{account:"123123@gmail.com",password:"example"}
        patch "/password",params:{old_password:"example123",new_password:"123456",confirmation:"123456"}
        expect(response).to have_http_status(400)
        expect(JSON.parse(response.body)).to eq(
          JSON.parse( 
            {
              "status": "error",
              "error": true,
              "message": "failed to update password",
              "data": "Old password error."
            }.to_json
          )
        )
      end

      example "failed to update password(The password confirmation does not match the new password.)" do
        post "/sign_in",params:{account:"123123@gmail.com",password:"example"}
        patch "/password",params:{old_password:"example",new_password:"1234567",confirmation:"123456"}
        expect(response).to have_http_status(400)
        expect(JSON.parse(response.body)).to eq(
          JSON.parse( 
            {
              "status": "error",
              "error": true,
              "message": "failed to update password",
              "data": "The password confirmation does not match the new password."
            }.to_json
          )
        )
      end

      example "failed to update password(new password is empty)" do
        post "/sign_in",params:{account:"123123@gmail.com",password:"example"}
        patch "/password",params:{old_password:"example",new_password:"",confirmation:""}
        expect(response).to have_http_status(400)
        expect(JSON.parse(response.body)).to eq(
          JSON.parse( 
            {
              "status": "error",
              "error": true,
              "message": "failed to update password",
              "data": {
                "password": [
                    "can't be blank"
                ]
            }
            }.to_json
          )
        )
      end

      example "failed to update password(not login)" do
        patch "/password",params:{old_password:"example",new_password:"123456",confirmation:"123456"}
        expect_unauthorized(response)
      end
    end
    

end
