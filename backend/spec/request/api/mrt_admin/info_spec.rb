require 'rails_helper'
require './spec/support/authorized_helper'
require 'simplecov'
SimpleCov.start
RSpec.configure do |c|
  c.include AuthorizedHelper
end

RSpec.describe "Api::MrtAdmin::Info", type: :request do
  before do
    Member.create(account:"admin",password:"123456",nickname:"admin",role:"admin")
    Member.create(account:"mrt_admin",password:"123456",nickname:"北捷管理員",role:"mrt_admin")
    Member.create(account:"user1",password:"123456",nickname:"user#344003",role:"user")
    Station.create(x_Pos:24.9982,y_Pos:121.5793,exit_Num:2,name:"動物園")
    Station.create(x_Pos:25.0527,y_Pos:121.5204,exit_Num:6,name:"中山")
    Station.create(x_Pos:24.9982,y_Pos:121.5731,exit_Num:1,name:"木柵")
    Info.create(name:"阿里媽媽",photo:"123",address:"水源市場",type_:"Common",Des:"好吃")
    Info.create(name:"阿里爸爸",photo:"123",address:"水源市場",type_:"Common",Des:"好吃")
    Info.create(name:"公車278",photo:"123",address:"汀州路",type_:"Trans",Des:"好搭")
    Info.create(name:"公車895",photo:"123",address:"汀州路",type_:"Trans",Des:"好搭")
    StationInfo.create(station_id:1,info_id:1)
    StationInfo.create(station_id:1,info_id:2)
    StationInfo.create(station_id:1,info_id:3)
    StationInfo.create(station_id:1,info_id:4)
    StationInfo.create(station_id:2,info_id:1)
    StationInfo.create(station_id:2,info_id:3)
    Comment.create(comment:"123321",score:5,member_id:2,info_id:1)
    Comment.create(comment:"123321",score:2,member_id:3,info_id:1)
  end

  let(:filepath) { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', '1.jpg'), 'image/jpg') }
  let(:invalid_filepath) { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', '2.txt'), 'text/plain') }

  describe "POST /api/mrt_admin/common" do
    example "succeed to create common_info(3 station)" do
      post "/sign_in",params:{account:"user1",password:"123456"}
      post "/api/mrt_admin/common", params: {
        name: "白帝城",
        photo: filepath,
        address: "gongguang",
        Des: "重慶麻辣燙",
        station_id_1:1,
        station_id_2:2,
        station_id_3:3
      }
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq(
          JSON.parse( 
            {
              "status": "success",
              "error": false,
              "message": "succeed to create common_info",
              "data": {
                info:Info.last,
                station_id:["1","2","3"]
              }
            }.to_json
          )
        ) 
    end

    example "succeed to create common_info(2 station)" do
      post "/sign_in",params:{account:"user1",password:"123456"}
      post "/api/mrt_admin/common", params: {
        name: "白帝城",
        photo: filepath,
        address: "gongguang",
        Des: "重慶麻辣燙",
        station_id_1:1,
        station_id_2:2
      }
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq(
          JSON.parse( 
            {
              "status": "success",
              "error": false,
              "message": "succeed to create common_info",
              "data": {
                info:Info.last,
                station_id:["1","2"]
              }
            }.to_json
          )
        ) 
    end

    example "succeed to create common_info(1 station)" do
      post "/sign_in",params:{account:"user1",password:"123456"}
      post "/api/mrt_admin/common", params: {
        name: "白帝城",
        photo: filepath,
        address: "gongguang",
        Des: "重慶麻辣燙",
        station_id_1:1,
        station_id_2:""
      }
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq(
          JSON.parse( 
            {
              "status": "success",
              "error": false,
              "message": "succeed to create common_info",
              "data": {
                info:Info.last,
                station_id:["1"]
              }
            }.to_json
          )
        ) 
    end

    example "failed to create common_info(not complete filled)" do
      post "/sign_in",params:{account:"user1",password:"123456"}
      post "/api/mrt_admin/common", params: {
        name: "白帝城",
        photo: filepath,
        address: "gongguang",
        station_id_1:1,
        station_id_2:""
      }
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body)).to eq(
          JSON.parse( 
            {
              "status": "error",
              "error": true,
              "message": "failed to create common_info",
              "data": "Field not completely filled."
            }.to_json
          )
        ) 
    end

    example "failed to create common_info(not filled station id)" do
      post "/sign_in",params:{account:"user1",password:"123456"}
      post "/api/mrt_admin/common", params: {
        name: "白帝城",
        photo: filepath,
        address: "gongguang",
        Des:"重慶麻辣燙"
      }
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body)).to eq(
          JSON.parse( 
            {
              "status": "error",
              "error": true,
              "message": "failed to create common_info",
              "data": "Field not completely filled."
            }.to_json
          )
        ) 
    end

    example "failed to create common_info(not login)" do
      post "/api/mrt_admin/common", params: {
        name: "白帝城",
        photo: filepath,
        address: "gongguang",
        Des: "重慶麻辣燙",
        station_id_1:1,
        station_id_2:""
      }
      expect_unauthorized(response)
    end
  end


  describe "POST /api/mrt_admin/trans" do
    example "succeed to create trans_info(3 station)" do
      post "/sign_in",params:{account:"admin",password:"123456"}
      post "/api/mrt_admin/trans", params: {
        name: "278公車|捷運公館站",
        photo: filepath,
        address: "公館",
        Des: "捷運內湖站～捷運景美站 頭班車:0510、末班車:2240 班表:0720、0810、0840、0940、1020、1040、1120、1200、1230、1310、1410、1510、1600、1630、1700、1725、1820、1910、1945、2020",
        station_id_1:1,
        station_id_2:2,
        station_id_3:3
      }
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq(
          JSON.parse( 
            {
              "status": "success",
              "error": false,
              "message": "succeed to create trans_info",
              "data": {
                info:Info.last,
                station_id:["1","2","3"]
              }
            }.to_json
          )
        ) 
    end

    example "succeed to create common_info(2 station)" do
      post "/sign_in",params:{account:"admin",password:"123456"}
      post "/api/mrt_admin/trans", params: {
        name: "278公車|捷運公館站",
        photo: filepath,
        address: "公館",
        Des: "捷運內湖站～捷運景美站 頭班車:0510、末班車:2240 班表:0720、0810、0840、0940、1020、1040、1120、1200、1230、1310、1410、1510、1600、1630、1700、1725、1820、1910、1945、2020",
        station_id_1:1,
        station_id_2:2
      }
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq(
          JSON.parse( 
            {
              "status": "success",
              "error": false,
              "message": "succeed to create trans_info",
              "data": {
                info:Info.last,
                station_id:["1","2"]
              }
            }.to_json
          )
        ) 
    end

    example "succeed to create trans_info(1 station)" do
      post "/sign_in",params:{account:"admin",password:"123456"}
      post "/api/mrt_admin/trans", params: {
        name: "278公車|捷運公館站",
        photo: filepath,
        address: "公館",
        Des: "捷運內湖站～捷運景美站 頭班車:0510、末班車:2240 班表:0720、0810、0840、0940、1020、1040、1120、1200、1230、1310、1410、1510、1600、1630、1700、1725、1820、1910、1945、2020",
        station_id_1:1
      }
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq(
          JSON.parse( 
            {
              "status": "success",
              "error": false,
              "message": "succeed to create trans_info",
              "data": {
                info:Info.last,
                station_id:["1"]
              }
            }.to_json
          )
        ) 
    end

    example "failed to create trans_info(not complete filled)" do
      post "/sign_in",params:{account:"admin",password:"123456"}
      post "/api/mrt_admin/trans", params: {
        name: "278公車|捷運公館站",
        Des: "捷運內湖站～捷運景美站 頭班車:0510、末班車:2240 班表:0720、0810、0840、0940、1020、1040、1120、1200、1230、1310、1410、1510、1600、1630、1700、1725、1820、1910、1945、2020",
        station_id_1:1,
        station_id_2:2,
        station_id_3:3
      }
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body)).to eq(
          JSON.parse( 
            {
              "status": "error",
              "error": true,
              "message": "failed to create trans_info",
              "data": "Field not completely filled."
            }.to_json
          )
        ) 
    end

    example "failed to create trans_info(not filled station id)" do
      post "/sign_in",params:{account:"admin",password:"123456"}
      post "/api/mrt_admin/trans", params: {
        name: "278公車|捷運公館站",
        photo: filepath,
        address: "公館",
        Des: "捷運內湖站～捷運景美站 頭班車:0510、末班車:2240 班表:0720、0810、0840、0940、1020、1040、1120、1200、1230、1310、1410、1510、1600、1630、1700、1725、1820、1910、1945、2020"
      }
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body)).to eq(
          JSON.parse( 
            {
              "status": "error",
              "error": true,
              "message": "failed to create trans_info",
              "data": "Field not completely filled."
            }.to_json
          )
        ) 
    end

    example "failed to create common_info(not login)" do
      post "/api/mrt_admin/trans", params: {
        name: "278公車|捷運公館站",
        photo: filepath,
        address: "公館",
        Des: "捷運內湖站～捷運景美站 頭班車:0510、末班車:2240 班表:0720、0810、0840、0940、1020、1040、1120、1200、1230、1310、1410、1510、1600、1630、1700、1725、1820、1910、1945、2020",
        station_id_1:1
      }
      expect_unauthorized(response)
    end

    example "failed to create common_info(Unauthorized)" do
      post "/sign_in",params:{account:"user1",password:"123456"}
      post "/api/mrt_admin/trans", params: {
        name: "278公車|捷運公館站",
        photo: filepath,
        address: "公館",
        Des: "捷運內湖站～捷運景美站 頭班車:0510、末班車:2240 班表:0720、0810、0840、0940、1020、1040、1120、1200、1230、1310、1410、1510、1600、1630、1700、1725、1820、1910、1945、2020",
        station_id_1:1
      }
      expect_not_permitted(response)
    end
  end  


  describe "GET /api/mrt_admin/trans" do
    example "succeed to get trans_info list" do
      get "/api/mrt_admin/trans",params:{station_id:1}
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq(
          JSON.parse( 
            {
              "status": "success",
              "error": false,
              "message": "succeed to get trans_info list around 動物園",
              "data": [Info.find(3),Info.find(4)]
            }.to_json
          )
        ) 
        get "/api/mrt_admin/trans",params:{station_id:2}
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)).to eq(
            JSON.parse( 
              {
                "status": "success",
                "error": false,
                "message": "succeed to get trans_info list around 中山",
                "data": [Info.find(3)]
              }.to_json
            )
          ) 
    end
  end


  describe "GET /api/mrt_admin/common" do
    example "succeed to get common_info list" do
      get "/api/mrt_admin/common",params:{station_id:1}
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq(
          JSON.parse( 
            {
              "status": "success",
              "error": false,
              "message": "succeed to get common_info list around 動物園",
              "data": [{average_score:"3.5",info:Info.find(1)},{average_score:nil,info:Info.find(2)}]
            }.to_json
          )
        ) 
      get "/api/mrt_admin/common",params:{station_id:2}
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq(
          JSON.parse( 
            {
              "status": "success",
              "error": false,
              "message": "succeed to get common_info list around 中山",
              "data": [{average_score:"3.5",info:Info.find(1)}]
            }.to_json
          )
        ) 
    end
  end


  describe "GET /api/mrt_admin/trans/3" do
    example "succeed to get trans_info" do
      get "/api/mrt_admin/trans/3"
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq(
          JSON.parse( 
            {
              "status": "success",
              "error": false,
              "message": "succeed to get trans_info",
              "data": Info.find(3)
            }.to_json
          )
        ) 
    end
  end


  describe "GET /api/mrt_admin/common/1" do
    example "succeed to get common_info list" do
      get "/api/mrt_admin/common/1"
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq(
          JSON.parse( 
            {
              "status": "success",
              "error": false,
              "message": "succeed to get common_info",
              "data": {average_score:"3.5",info:Info.find(1)}
            }.to_json
          )
        ) 
    end
  end


  describe "PATCH /api/mrt_admin/trans/3" do
    example "succeed to update trans_info" do
      post "/sign_in",params:{account:"admin",password:"123456"}
      patch "/api/mrt_admin/trans/3", params: {
        name: "278公車|捷運公館站",
        photo: filepath,
        address: "公館",
        Des: "捷運內湖站～捷運景美站 頭班車:0510、末班車:2240 班表:0720、0810、0840、0940、1020、1040、1120、1200、1230、1310、1410、1510、1600、1630、1700、1725、1820、1910、1945、2020"
      }
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq(
          JSON.parse( 
            {
              "status": "success",
              "error": false,
              "message": "succeed to update trans_info",
              "data": Info.find(3)
            }.to_json
          )
        ) 
    end

    example "failed to create trans_info(not complete filled)" do
      post "/sign_in",params:{account:"admin",password:"123456"}
      patch "/api/mrt_admin/trans/3", params: {
        name: "",
        Des: "捷運內湖站～捷運景美站 頭班車:0510、末班車:2240 班表:0720、0810、0840、0940、1020、1040、1120、1200、1230、1310、1410、1510、1600、1630、1700、1725、1820、1910、1945、2020"
      }
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body)).to eq(
          JSON.parse( 
            {
              "status": "error",
              "error": true,
              "message": "failed to update trans_info",
              "data": "Field not completely filled."
            }.to_json
          )
        ) 
    end

    example "failed to create common_info(not login)" do
      patch "/api/mrt_admin/trans/3", params: {
        name: "278公車|捷運公館站",
        photo: filepath,
        address: "公館",
        Des: "捷運內湖站～捷運景美站 頭班車:0510、末班車:2240 班表:0720、0810、0840、0940、1020、1040、1120、1200、1230、1310、1410、1510、1600、1630、1700、1725、1820、1910、1945、2020"
      }
      expect_unauthorized(response)
    end

    example "failed to create common_info(Unauthorized)" do
      post "/sign_in",params:{account:"user1",password:"123456"}
      patch "/api/mrt_admin/trans/3", params: {
        name: "278公車|捷運公館站",
        photo: filepath,
        address: "公館",
        Des: "捷運內湖站～捷運景美站 頭班車:0510、末班車:2240 班表:0720、0810、0840、0940、1020、1040、1120、1200、1230、1310、1410、1510、1600、1630、1700、1725、1820、1910、1945、2020"
      }
      expect_not_permitted(response)
    end
  end


  describe "PATCH /api/mrt_admin/common/1" do
    example "succeed to update common_info" do
      post "/sign_in",params:{account:"user1",password:"123456"}
      patch "/api/mrt_admin/common/1", params: {
        name: "白帝城",
        photo: filepath,
        address: "gongguang",
        Des: "重慶麻辣燙"
      }
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq(
          JSON.parse( 
            {
              "status": "success",
              "error": false,
              "message": "succeed to update common_info",
              "data": Info.find(1)
            }.to_json
          )
        ) 
    end

    example "failed to create common_info(not complete filled)" do
      post "/sign_in",params:{account:"user1",password:"123456"}
      patch "/api/mrt_admin/common/1", params: {
        name: "白帝城",
        photo: filepath,
        address: ""
      }
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body)).to eq(
          JSON.parse( 
            {
              "status": "error",
              "error": true,
              "message": "failed to update common_info",
              "data": "Field not completely filled."
            }.to_json
          )
        ) 
    end

    example "failed to create common_info(not login)" do
      patch "/api/mrt_admin/common/1", params: {
        name: "白帝城",
        photo: filepath,
        address: "gongguang",
        Des: "重慶麻辣燙"
      }
      expect_unauthorized(response)
    end
  end
  

  describe "DELETE /api/mrt_admin/info/1" do
    example "succeed to delete info" do
        post "/sign_in",params:{account:"admin",password:"123456"}
        delete "/api/mrt_admin/info/1"
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)).to eq(
            JSON.parse( 
            {
                "status": "success",
                "error": false,
                "message": "succeed to delete info",
                "data": {}
            }.to_json
            )
        )
        expect(Info.first).to eq(Info.find(2))
    end

    example "failed to update announcement(not login)" do
        delete "/api/mrt_admin/info/1"
        expect_unauthorized(response)
    end

    example "failed to create announcement(Unauthorized)" do
        post "/sign_in",params:{account:"user1",password:"123456"}
        delete "/api/mrt_admin/info/1"
        expect_not_permitted(response)
    end
  end

end
