require 'rails_helper'
require './spec/support/authorized_helper'
require 'simplecov'
require 'timecop'

SimpleCov.start
RSpec.configure do |c|
    c.include AuthorizedHelper
end

RSpec.describe "Api::MrtAdmin::TimeTables", type: :request do
  before do
    Member.create(account:"admin",password:"123456",nickname:"admin",role:"admin")
    Member.create(account:"mrt_admin",password:"123456",nickname:"北捷管理員",role:"mrt_admin")
    Member.create(account:"user1",password:"123456",nickname:"user#344003",role:"user")
    Station.create(x_Pos:24.9579,y_Pos:121.5376,exit_Num:1,name:"新店")
    Station.create(x_Pos:25.0207,y_Pos:121.5282,exit_Num:5,name:"台電大樓")
    Station.create(x_Pos:25.0264,y_Pos:121.5229,exit_Num:9,name:"古亭")
    Station.create(x_Pos:25.0501,y_Pos:121.5777,exit_Num:5,name:"松山")
    Station.create(x_Pos:24.9900,y_Pos:121.5092,exit_Num:4,name:"南勢角")
    Station.create(x_Pos:25.0219,y_Pos:121.4113,exit_Num:3,name:"迴龍")
    Station.create(x_Pos:25.0916,y_Pos:121.4645,exit_Num:3,name:"蘆洲")
    StationNo.create(linecolor:"G",number:1 ,station_id:1)
    StationNo.create(linecolor:"G",number:8 ,station_id:2)
    StationNo.create(linecolor:"G",number:9 ,station_id:3)
    StationNo.create(linecolor:"G",number:19,station_id:4)
    StationNo.create(linecolor:"O",number:1 ,station_id:5)
    StationNo.create(linecolor:"O",number:5 ,station_id:3)
    StationNo.create(linecolor:"O",number:21,station_id:6)
    StationNo.create(linecolor:"O",number:54,station_id:7)
    TimeTable.create(time:"10:00",line:"O",end:1 ,station_id:3,No:1)
    TimeTable.create(time:"10:05",line:"O",end:1 ,station_id:3,No:2)
    TimeTable.create(time:"10:03",line:"O",end:21,station_id:3,No:3)
    TimeTable.create(time:"10:06",line:"O",end:21,station_id:3,No:4)
    TimeTable.create(time:"10:02",line:"O",end:54,station_id:3,No:5)
    TimeTable.create(time:"10:07",line:"O",end:54,station_id:3,No:6)
    TimeTable.create(time:"10:01",line:"G",end:1 ,station_id:3,No:7)
    TimeTable.create(time:"10:06",line:"G",end:1 ,station_id:3,No:8)
    TimeTable.create(time:"10:01",line:"G",end:8 ,station_id:3,No:9)
    TimeTable.create(time:"10:06",line:"G",end:19,station_id:3,No:10)
    TimeTable.create(time:"10:03",line:"G",end:1 ,station_id:2,No:11)
    TimeTable.create(time:"10:04",line:"G",end:19,station_id:2,No:12)
    Line.create(linecolor: "G",name:"松山新店線",colorcode:"#008659")
    Line.create(linecolor: "O",name:"中和新蘆線",colorcode:"#f8b61c")
  end
  describe "POST /api/mrt_admin/station/2/time_table" do
    example "succeed to create timetable" do
      post "/sign_in",params:{account:"mrt_admin",password:"123456"}
      post "/api/mrt_admin/station/2/time_table",params:{time:"12:00",line:"G",end:1,No:1234}
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq(
          JSON.parse( 
          {
              "status": "success",
              "error": false,
              "message": "succeed to create timetable",
              "data": TimeTable.last
          }.to_json
          )
      )
    end

    example "failed to create timetable(time format error)" do
      post "/sign_in",params:{account:"mrt_admin",password:"123456"}
      post "/api/mrt_admin/station/2/time_table",params:{time:"29:00",line:"G",end:1,No:1234}
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body)).to eq(
          JSON.parse( 
          {
              "status": "error",
              "error": true,
              "message": "failed to create timetable",
              "data": {
                time:["time format error"]
              }
          }.to_json
          )
      )
    end

    example "failed to create timetable(not complete filled)" do
      post "/sign_in",params:{account:"mrt_admin",password:"123456"}
      post "/api/mrt_admin/station/2/time_table",params:{line:"G",end:1}
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body)).to eq(
          JSON.parse( 
          {
              "status": "error",
              "error": true,
              "message": "failed to create timetable",
              "data": {
                time:["can't be blank"],
                No:["can't be blank"]
              }
          }.to_json
          )
      )
    end

    example "failed to create timetable(This station and terminal station not at same line)" do
      post "/sign_in",params:{account:"mrt_admin",password:"123456"}
      post "/api/mrt_admin/station/2/time_table",params:{line:"O",end:5,time:"21:00",No:12345}
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body)).to eq(
          JSON.parse( 
          {
              "status": "error",
              "error": true,
              "message": "failed to create timetable",
              "data": "This station and terminal station not at same line."
          }.to_json
          )
      )
    end

    example "failed to create timetable(Terminal station doesn't exist)" do
      post "/sign_in",params:{account:"mrt_admin",password:"123456"}
      post "/api/mrt_admin/station/2/time_table",params:{line:"K",end:1}
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body)).to eq(
          JSON.parse( 
          {
              "status": "error",
              "error": true,
              "message": "failed to create timetable",
              "data": "Terminal station doesn't exist."
          }.to_json
          )
      )
    end

    example "failed to create timetable(not login)" do
      post "/api/mrt_admin/station/2/time_table",params:{line:"G",end:1}    
      expect_unauthorized(response)
    end

    example "failed to create timetable(Unauthorized)" do
      post "/sign_in",params:{account:"user1",password:"123456"}
      post "/api/mrt_admin/station/2/time_table",params:{line:"G",end:1}   
      expect_not_permitted(response)
    end
  end


  describe "GET /api/mrt_admin/station/3/time_table" do
    example "succeed to get timetable list" do
      get "/api/mrt_admin/station/3/time_table"
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq(
          JSON.parse( 
          {
              "status": "success",
              "error": false,
              "message": "succeed to get timetable list",
              "data": [{timetable:TimeTable.find(1),to:"南勢角",line:"中和新蘆線"},
                {timetable:TimeTable.find(7),to:"新店",line:"松山新店線"},
                {timetable:TimeTable.find(9),to:"台電大樓",line:"松山新店線"},
                {timetable:TimeTable.find(5),to:"蘆洲",line:"中和新蘆線"},
                {timetable:TimeTable.find(3),to:"迴龍",line:"中和新蘆線"},
                {timetable:TimeTable.find(2),to:"南勢角",line:"中和新蘆線"},
                {timetable:TimeTable.find(4),to:"迴龍",line:"中和新蘆線"},
                {timetable:TimeTable.find(8),to:"新店",line:"松山新店線"},
                {timetable:TimeTable.find(10),to:"松山",line:"松山新店線"},
                {timetable:TimeTable.find(6),to:"蘆洲",line:"中和新蘆線"}]
          }.to_json
          )
      )
    end

    example "succeed to get timetable list" do
      get "/api/mrt_admin/station/2/time_table"
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq(
          JSON.parse( 
          {
              "status": "success",
              "error": false,
              "message": "succeed to get timetable list",
              "data": [{timetable:TimeTable.find(11),to:"新店",line:"松山新店線"},
                {timetable:TimeTable.find(12),to:"松山",line:"松山新店線"}]
          }.to_json
          )
      )
    end

    example "succeed to get timetable list" do
      get "/api/mrt_admin/station/1/time_table"
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq(
          JSON.parse( 
          {
              "status": "success",
              "error": false,
              "message": "succeed to get timetable list",
              "data": []
          }.to_json
          )
      )
    end
  end


  describe "GET /api/mrt_admin/station/3/time_table/1" do
    example "succeed to get timetable" do
      get "/api/mrt_admin/station/3/time_table/1"
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq(
          JSON.parse( 
          {
              "status": "success",
              "error": false,
              "message": "succeed to get timetable",
              "data": TimeTable.first
          }.to_json
          )
      )
    end
  end


  describe "PATCH /api/mrt_admin/station/3/time_table/1" do
    example "succeed to update timetable" do
      post "/sign_in",params:{account:"mrt_admin",password:"123456"}
      patch "/api/mrt_admin/station/3/time_table/1",params:{time:"12:00",line:"G",end:1,No:1234}
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq(
          JSON.parse( 
          {
              "status": "success",
              "error": false,
              "message": "succeed to update timetable",
              "data": TimeTable.first
          }.to_json
          )
      )
      expect(TimeTable.first.No).to eq(1234)
      expect(TimeTable.last).to eq(TimeTable.find(12))
    end

    example "failed to update timetable(time format error)" do
      post "/sign_in",params:{account:"mrt_admin",password:"123456"}
      patch "/api/mrt_admin/station/3/time_table/1",params:{time:"29:00",line:"G",end:1,No:"1234"}
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body)).to eq(
          JSON.parse( 
          {
              "status": "error",
              "error": true,
              "message": "failed to update timetable",
              "data": {
                time:["time format error"]
              }
          }.to_json
          )
      )
    end

    example "failed to update timetable(not complete filled)" do
      post "/sign_in",params:{account:"mrt_admin",password:"123456"}
      patch "/api/mrt_admin/station/3/time_table/1",params:{line:"G",end:1,No:"",time:""}
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body)).to eq(
          JSON.parse( 
          {
              "status": "error",
              "error": true,
              "message": "failed to update timetable",
              "data": {
                time:["can't be blank"],
                No:["can't be blank"]
              }
          }.to_json
          )
      )
    end

    example "failed to update timetable(This station and terminal station not at same line)" do
      post "/sign_in",params:{account:"mrt_admin",password:"123456"}
      patch "/api/mrt_admin/station/2/time_table/11",params:{line:"O",end:5,time:"21:00",No:"12345"}
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body)).to eq(
          JSON.parse( 
          {
              "status": "error",
              "error": true,
              "message": "failed to update timetable",
              "data": "This station and terminal station not at same line."
          }.to_json
          )
      )
    end

    example "failed to update timetable(Terminal station doesn't exist)" do
      post "/sign_in",params:{account:"mrt_admin",password:"123456"}
      patch "/api/mrt_admin/station/3/time_table/1",params:{line:"K",end:1}
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body)).to eq(
          JSON.parse( 
          {
              "status": "error",
              "error": true,
              "message": "failed to update timetable",
              "data": "Terminal station doesn't exist."
          }.to_json
          )
      )
    end

    example "failed to update timetable(not login)" do
      patch "/api/mrt_admin/station/3/time_table/1",params:{line:"G",end:1}    
      expect_unauthorized(response)
    end

    example "failed to update timetable(Unauthorized)" do
      post "/sign_in",params:{account:"user1",password:"123456"}
      patch "/api/mrt_admin/station/3/time_table/1",params:{line:"G",end:1}   
      expect_not_permitted(response)
    end
  end


  describe "DELETE /api/mrt_admin/station/3/time_table/1" do
    example "succeed to delete timetable" do
      post "/sign_in",params:{account:"mrt_admin",password:"123456"}
      delete "/api/mrt_admin/station/3/time_table/1"
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq(
          JSON.parse( 
          {
              "status": "success",
              "error": false,
              "message": "succeed to delete timetable",
              "data": {}
          }.to_json
          )
      )
      expect(TimeTable.first).to eq(TimeTable.find(2))
    end

    example "failed to delete timetable(not login)" do
      delete "/api/mrt_admin/station/3/time_table/1" 
      expect_unauthorized(response)
    end

    example "failed to delete timetable(Unauthorized)" do
      post "/sign_in",params:{account:"user1",password:"123456"}
      delete "/api/mrt_admin/station/3/time_table/1"
      expect_not_permitted(response)
    end
  end


  describe "GET /api/mrt_admin/station/3/time_table_search" do
    example "succeed to get timetable_search_result" do
      desired_time = Time.new(2023, 6, 10, 9, 59, 32)
      Timecop.freeze(desired_time) do
        get "/api/mrt_admin/station/3/time_table_search"
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)).to eq(
            JSON.parse( 
            {
                "status": "success",
                "error": false,
                "message": "succeed to get timetable_search_result",
                "data": [{line:"O",end:1,No:1,name:"往南勢角",spend_time:"0分30秒",time:"10:00"},
                  {line:"O",end:21,No:3,name:"往迴龍",spend_time:"3分30秒",time:"10:03"},
                  {line:"O",end:54,No:5,name:"往蘆洲",spend_time:"2分30秒",time:"10:02"},
                  {line:"G",end:1,No:7,name:"往新店",spend_time:"1分30秒",time:"10:01"},
                  {line:"G",end:8,No:9,name:"往台電大樓",spend_time:"1分30秒",time:"10:01"},
                  {line:"G",end:19,No:10,name:"往松山",spend_time:"6分30秒",time:"10:06"}
                ]
            }.to_json
            )
        )
      end
    end

    example "succeed to get timetable_search_result" do
      desired_time = Time.new(2023, 6, 10, 10, 2, 1)
      Timecop.freeze(desired_time) do
        get "/api/mrt_admin/station/3/time_table_search"
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)).to eq(
            JSON.parse( 
            {
                "status": "success",
                "error": false,
                "message": "succeed to get timetable_search_result",
                "data": [{line:"O",end:1,No:2,name:"往南勢角",spend_time:"3分0秒",time:"10:05"},
                  {line:"O",end:21,No:3,name:"往迴龍",spend_time:"1分0秒",time:"10:03"},
                  {line:"O",end:54,No:6,name:"往蘆洲",spend_time:"5分0秒",time:"10:07"},
                  {line:"G",end:1,No:8,name:"往新店",spend_time:"4分0秒",time:"10:06"},
                  {line:"G",end:19,No:10,name:"往松山",spend_time:"4分0秒",time:"10:06"}
                ]
            }.to_json
            )
        )
      end
    end
  end
end
