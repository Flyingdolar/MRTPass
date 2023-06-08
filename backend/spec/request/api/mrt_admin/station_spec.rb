require 'rails_helper'
require './spec/support/authorized_helper'
require 'simplecov'
SimpleCov.start
RSpec.configure do |c|
    c.include AuthorizedHelper
end


RSpec.describe "Api::MrtAdmin::Station", type: :request do
    before do
        Member.create(account:"admin",password:"123456",nickname:"admin",role:"admin")
        Member.create(account:"mrt_admin",password:"123456",nickname:"北捷管理員",role:"mrt_admin")
        Member.create(account:"user1",password:"123456",nickname:"user#344003",role:"user")
        Station.create(x_Pos:25.0207,y_Pos:121.5282,exit_Num:5,name:"台電大樓")
        Station.create(x_Pos:25.0264,y_Pos:121.5229,exit_Num:9,name:"古亭")
        Station.create(x_Pos:25.0327,y_Pos:121.5183,exit_Num:7,name:"中正紀念堂")
        Station.create(x_Pos:25.0355,y_Pos:121.5109,exit_Num:4,name:"小南門")
        StationNo.create(linecolor:"G",number:8 ,station_id:1)
        StationNo.create(linecolor:"G",number:9 ,station_id:2)
        StationNo.create(linecolor:"O",number:5 ,station_id:2)
        StationNo.create(linecolor:"G",number:11,station_id:3)
        StationNo.create(linecolor:"R",number:8 ,station_id:3)
        StationNo.create(linecolor:"G",number:10,station_id:4)
        Line.create(linecolor:"BR",name:"文湖線",colorcode:"#c48c31")
        Line.create(linecolor: "R",name:"淡水信義線",colorcode:"#e3002c")
        Line.create(linecolor: "G",name:"松山新店線",colorcode:"#008659")
        Line.create(linecolor: "O",name:"中和新蘆線",colorcode:"#f8b61c")
        Line.create(linecolor:"BL",name:"板南線",colorcode:"#0070bd")
    end

    describe "POST /api/mrt_admin/station" do
        example "succeed to create station on 1 line(input 2 No. but the 2nd is duplication)" do
            post "/sign_in",params:{account:"mrt_admin",password:"123456"}
            post "/api/mrt_admin/station",params:{name:"我家",x_Pos:23.1,y_Pos:120.1,exit_Num:2,linecolor_1:"O",number_1:2,linecolor_2:"G",number_2:11}
            expect(response).to have_http_status(200)
            expect(JSON.parse(response.body)).to eq(
                JSON.parse( 
                {
                    "status": "success",
                    "error": false,
                    "message": "succeed to create station on 1 line",
                    "data": {
                        station:Station.last,
                        linecolor_1:"O",
                        number_1:2
                    }
                }.to_json
                )
            )
            expect(StationNo.find(7).linecolor).to eq("O")
            expect(StationNo.find(7).number).to eq(2)
        end

        example "succeed to create station on 1 line(input 2 No. but the 2nd line not exist)" do
            post "/sign_in",params:{account:"mrt_admin",password:"123456"}
            post "/api/mrt_admin/station",params:{name:"我家",x_Pos:23.1,y_Pos:120.1,exit_Num:2,linecolor_1:"O",number_1:2,linecolor_2:"QQQQ",number_2:5}
            expect(response).to have_http_status(200)
            expect(JSON.parse(response.body)).to eq(
                JSON.parse( 
                {
                    "status": "success",
                    "error": false,
                    "message": "succeed to create station on 1 line",
                    "data": {
                        station:Station.last,
                        linecolor_1:"O",
                        number_1:2
                    }
                }.to_json
                )
            )
            expect(StationNo.find(7).linecolor).to eq("O")
            expect(StationNo.find(7).number).to eq(2)
        end

        example "succeed to create station on 1 line(only input 1 No.)" do
            post "/sign_in",params:{account:"mrt_admin",password:"123456"}
            post "/api/mrt_admin/station",params:{name:"我家",x_Pos:23.1,y_Pos:120.1,exit_Num:2,linecolor_1:"O",number_1:2}
            expect(response).to have_http_status(200)
            expect(JSON.parse(response.body)).to eq(
                JSON.parse( 
                {
                    "status": "success",
                    "error": false,
                    "message": "succeed to create station on 1 line",
                    "data": {
                        station:Station.last,
                        linecolor_1:"O",
                        number_1:2
                    }
                }.to_json
                )
            )
            expect(StationNo.find(7).linecolor).to eq("O")
            expect(StationNo.find(7).number).to eq(2)
        end

        example "succeed to create station on 2 line" do
            post "/sign_in",params:{account:"mrt_admin",password:"123456"}
            post "/api/mrt_admin/station",params:{name:"我家",x_Pos:23.1,y_Pos:120.1,exit_Num:2,linecolor_1:"O",number_1:2,linecolor_2:"G",number_2:3}
            expect(response).to have_http_status(200)
            expect(JSON.parse(response.body)).to eq(
                JSON.parse( 
                {
                    "status": "success",
                    "error": false,
                    "message": "succeed to create station on 2 line",
                    "data": {
                        station:Station.last,
                        linecolor_1:"O",
                        number_1:2,
                        linecolor_2:"G",
                        number_2:3
                    }
                }.to_json
                )
            )
            expect(StationNo.find(7).linecolor).to eq("O")
            expect(StationNo.find(7).number).to eq(2)
            expect(StationNo.find(8).linecolor).to eq("G")
            expect(StationNo.find(8).number).to eq(3)
        end

        example "failed to create station(Station No. has been taken)" do
            post "/sign_in",params:{account:"mrt_admin",password:"123456"}
            post "/api/mrt_admin/station",params:{name:"我家",x_Pos:23.1,y_Pos:120.1,exit_Num:2,linecolor_1:"G",number_1:11}
            expect(response).to have_http_status(400)
            expect(JSON.parse(response.body)).to eq(
                JSON.parse( 
                {
                    "status": "error",
                    "error": true,
                    "message": "failed to create station",
                    "data": "Station No. has been taken or blank."
                }.to_json
                )
            )
            expect(Station.last).to eq(Station.find(4))
        end

        example "failed to create station(input 2 No. but the 1st line not exist)" do
            post "/sign_in",params:{account:"mrt_admin",password:"123456"}
            post "/api/mrt_admin/station",params:{name:"我家",x_Pos:23.1,y_Pos:120.1,exit_Num:2,linecolor_1:"GGGGG",number_1:11,linecolor_2:"BL",number_2:1}
            expect(response).to have_http_status(400)
            expect(JSON.parse(response.body)).to eq(
                JSON.parse( 
                {
                    "status": "error",
                    "error": true,
                    "message": "failed to create station",
                    "data": "Line GGGGG isn't exist."
                }.to_json
                )
            )
            expect(Station.last).to eq(Station.find(4))
        end

        example "failed to create station(input 2 No. but the 1st is duplication)" do
            post "/sign_in",params:{account:"mrt_admin",password:"123456"}
            post "/api/mrt_admin/station",params:{name:"我家",x_Pos:23.1,y_Pos:120.1,exit_Num:2,linecolor_1:"G",number_1:11,linecolor_2:"BL",number_2:1}
            expect(response).to have_http_status(400)
            expect(JSON.parse(response.body)).to eq(
                JSON.parse( 
                {
                    "status": "error",
                    "error": true,
                    "message": "failed to create station",
                    "data": "Station No. has been taken or blank."
                }.to_json
                )
            )
            expect(Station.last).to eq(Station.find(4))
        end

        example "failed to create station(input 0 No.)" do
            post "/sign_in",params:{account:"mrt_admin",password:"123456"}
            post "/api/mrt_admin/station",params:{name:"我家",x_Pos:23.1,y_Pos:120.1,exit_Num:2}
            expect(response).to have_http_status(400)
            expect(JSON.parse(response.body)).to eq(
                JSON.parse( 
                {
                    "status": "error",
                    "error": true,
                    "message": "failed to create station",
                    "data": "Station No. has been taken or blank."
                }.to_json
                )
            )
            expect(Station.last).to eq(Station.find(4))
        end

        example "failed to create station(not complete filled)" do
            post "/sign_in",params:{account:"mrt_admin",password:"123456"}
            post "/api/mrt_admin/station",params:{name:"我家",exit_Num:2,linecolor_1:"G",number_1:11}
            expect(response).to have_http_status(400)
            expect(JSON.parse(response.body)).to eq(
                JSON.parse( 
                {
                    "status": "error",
                    "error": true,
                    "message": "failed to create station",
                    "data": {
                        x_Pos:["can't be blank"],
                        y_Pos:["can't be blank"]
                    }
                }.to_json
                )
            )
        end

        example "failed to create station(not login)" do
            post "/api/mrt_admin/station",params:{name:"我家",exit_Num:2,linecolor_1:"G",number_1:11}
            expect_unauthorized(response)
        end

        example "failed to create station(Unauthorized)" do
            post "/sign_in",params:{account:"user1",password:"123456"}
            post "/api/mrt_admin/station",params:{name:"我家",exit_Num:2,linecolor_1:"G",number_1:11}
            expect_not_permitted(response)
        end
    end

    describe "GET /api/mrt_admin/station" do
        example "succeed to get station list" do
            get "/api/mrt_admin/station"
            expect(response).to have_http_status(200)
            expect(JSON.parse(response.body)).to eq(
                JSON.parse( 
                {
                    "status": "success",
                    "error": false,
                    "message": "succeed to get station list",
                    "data": Station.all
                }.to_json
                )
            )
        end
    end

    describe "GET /api/mrt_admin/station/2" do
        example "succeed to get station" do
            get "/api/mrt_admin/station/2"
            expect(response).to have_http_status(200)
            expect(JSON.parse(response.body)).to eq(
                JSON.parse( 
                {
                    "status": "success",
                    "error": false,
                    "message": "succeed to get station",
                    "data": {
                        station:Station.find(2),
                        stationno:[StationNo.find(2),StationNo.find(3)]
                    }
                }.to_json
                )
            )
        end
    end

    describe "GET /api/mrt_admin/line_station" do
        example "succeed to get G line station" do
            get "/api/mrt_admin/line_station",params:{linecolor:"G"}
            expect(response).to have_http_status(200)
            expect(JSON.parse(response.body)).to eq(
                JSON.parse( 
                {
                    "status": "success",
                    "error": false,
                    "message": "succeed to get G line station",
                    "data": [{station:Station.find(1),linecolor:"G",number:8},
                        {station:Station.find(2),linecolor:"G",number:9},
                        {station:Station.find(4),linecolor:"G",number:10},
                        {station:Station.find(3),linecolor:"G",number:11}]
                }.to_json
                )
            )
        end
    end

    describe "PATCH /api/mrt_admin/station/2" do
        example "succeed update station information(input 0 No.)" do
            post "/sign_in",params:{account:"mrt_admin",password:"123456"}
            patch "/api/mrt_admin/station/2",params:{name:"我家",x_Pos:23.1,y_Pos:120.1,exit_Num:2}
            expect(response).to have_http_status(200)
            expect(JSON.parse(response.body)).to eq(
                JSON.parse( 
                {
                    "status": "success",
                    "error": false,
                    "message": "succeed to update station information",
                    "data": Station.find(2)
                }.to_json
                )
            )
        end

        example "succeed update station information(input 1 No. but duplication)" do
            post "/sign_in",params:{account:"mrt_admin",password:"123456"}
            patch "/api/mrt_admin/station/2",params:{name:"我家",x_Pos:23.1,y_Pos:120.1,exit_Num:2,linecolor_1:"G",number:9}
            expect(response).to have_http_status(200)
            expect(JSON.parse(response.body)).to eq(
                JSON.parse( 
                {
                    "status": "success",
                    "error": false,
                    "message": "succeed to update station information",
                    "data": Station.find(2)
                }.to_json
                )
            )
        end

        example "succeed update station information(input 2 No. but both duplication)" do
            post "/sign_in",params:{account:"mrt_admin",password:"123456"}
            patch "/api/mrt_admin/station/2",params:{name:"我家",x_Pos:23.1,y_Pos:120.1,exit_Num:2,linecolor_1:"G",number_1:9,linecolor_2:"R",number_2:8}
            expect(response).to have_http_status(200)
            expect(JSON.parse(response.body)).to eq(
                JSON.parse( 
                {
                    "status": "success",
                    "error": false,
                    "message": "succeed to update station information",
                    "data": Station.find(2)
                }.to_json
                )
            )
        end

        example "succeed to update station information and No(input 1 No.)" do
            post "/sign_in",params:{account:"mrt_admin",password:"123456"}
            patch "/api/mrt_admin/station/2",params:{name:"我家",x_Pos:23.1,y_Pos:120.1,exit_Num:2,linecolor_1:"G",number_1:100}
            expect(response).to have_http_status(200)
            expect(JSON.parse(response.body)).to eq(
                JSON.parse( 
                {
                    "status": "success",
                    "error": false,
                    "message": "succeed to update station information and No",
                    "data": {
                        station:Station.find(2),
                        stationno:StationNo.where(station_id:2)
                    }
                }.to_json
                )
            )
        end

        example "succeed to update station information and No(input 2 No. but 1st duplication)" do
            post "/sign_in",params:{account:"mrt_admin",password:"123456"}
            patch "/api/mrt_admin/station/2",params:{name:"我家",x_Pos:23.1,y_Pos:120.1,exit_Num:2,linecolor_1:"G",number_1:10,linecolor_2:"R",number_2:100}
            expect(response).to have_http_status(200)
            expect(JSON.parse(response.body)).to eq(
                JSON.parse( 
                {
                    "status": "success",
                    "error": false,
                    "message": "succeed to update station information and No",
                    "data": {
                        station:Station.find(2),
                        stationno:StationNo.where(station_id:2)
                    }
                }.to_json
                )
            )
            expect(StationNo.where(station_id:2)).to eq([StationNo.last])
        end

        example "succeed to update station information and No(input 2 No. but 2nd duplication)" do
            post "/sign_in",params:{account:"mrt_admin",password:"123456"}
            patch "/api/mrt_admin/station/2",params:{name:"我家",x_Pos:23.1,y_Pos:120.1,exit_Num:2,linecolor_1:"G",number_1:100,linecolor_2:"R",number_2:8}
            expect(response).to have_http_status(200)
            expect(JSON.parse(response.body)).to eq(
                JSON.parse( 
                {
                    "status": "success",
                    "error": false,
                    "message": "succeed to update station information and No",
                    "data": {
                        station:Station.find(2),
                        stationno:StationNo.where(station_id:2)
                    }
                }.to_json
                )
            )
            expect(StationNo.where(station_id:2)).to eq([StationNo.last])
        end

        example "succeed to update station information and No(input 2 No. and no duplication)" do
            post "/sign_in",params:{account:"mrt_admin",password:"123456"}
            patch "/api/mrt_admin/station/2",params:{name:"我家",x_Pos:23.1,y_Pos:120.1,exit_Num:2,linecolor_1:"G",number_1:100,linecolor_2:"R",number_2:80}
            expect(response).to have_http_status(200)
            expect(JSON.parse(response.body)).to eq(
                JSON.parse( 
                {
                    "status": "success",
                    "error": false,
                    "message": "succeed to update station information and No",
                    "data": {
                        station:Station.find(2),
                        stationno:StationNo.where(station_id:2)
                    }
                }.to_json
                )
            )
            expect(StationNo.where(station_id:2)).to eq([StationNo.find(7),StationNo.find(8)])
        end

        example "failed to update station(not complete filled)" do
            post "/sign_in",params:{account:"mrt_admin",password:"123456"}
            patch "/api/mrt_admin/station/2",params:{name:"",x_Pos:23.1,y_Pos:120.1,exit_Num:2,linecolor_1:"G",number_1:100,linecolor_2:"R",number_2:80}
            expect(response).to have_http_status(400)
            expect(JSON.parse(response.body)).to eq(
                JSON.parse( 
                {
                    "status": "error",
                    "error": true,
                    "message": "failed to update station",
                    "data": {
                        name:["can't be blank"]
                    }
                }.to_json
                )
            )
        end

        example "failed to update station(not login)" do
            patch "/api/mrt_admin/station/2",params:{name:"我家",x_Pos:23.1,y_Pos:120.1,exit_Num:2}
            expect_unauthorized(response)
        end

        example "failed to update station(Unauthorized)" do
            post "/sign_in",params:{account:"user1",password:"123456"}
            patch "/api/mrt_admin/station/2",params:{name:"我家",x_Pos:23.1,y_Pos:120.1,exit_Num:2}
            expect_not_permitted(response)
        end
    end

    describe "DELETE /api/mrt_admin/station/2" do
        example "succeed to delete station" do
            post "/sign_in",params:{account:"mrt_admin",password:"123456"}
            delete "/api/mrt_admin/station/2"
            expect(response).to have_http_status(200)
            expect(JSON.parse(response.body)).to eq(
                JSON.parse( 
                {
                    "status": "success",
                    "error": false,
                    "message": "succeed to delete station",
                    "data": {}
                }.to_json
                )
            )
            expect(StationNo.where(station_id:2)).to eq([])
            expect(StationInfo.where(station_id:2)).to eq([])
        end

        example "failed to delete station(not login)" do
            delete "/api/mrt_admin/station/2"
            expect_unauthorized(response)
        end

        example "failed to delete station(Unauthorized)" do
            post "/sign_in",params:{account:"user1",password:"123456"}
            delete "/api/mrt_admin/station/2"
            expect_not_permitted(response)
        end
    end
end