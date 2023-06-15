class Api::MrtAdmin::StationController < ApplicationController
    
    def create
        check,@member=check_mrt_admin
        if check
            @station=Station.new(station_params)
            if !@station.save
                render :json => {
                    status: "error",
                    error: true,
                    message: "failed to create station",
                    data: @station.errors
                }.to_json, :status => 400
            else 
                l1=no_params[:linecolor_1]
                n1=no_params[:number_1]
                l2=no_params[:linecolor_2]
                n2=no_params[:number_2]
                if !check_is_dupliction(l1,n1)
                    if t1=Line.find_by(linecolor:l1)
                        @no1=StationNo.new(linecolor:l1,number:n1,station_id:@station.id)
                        @no1.save
                        if !check_is_dupliction(l2,n2)
                            if t2=Line.find_by(linecolor:l2)
                                @no2=StationNo.new(linecolor:l2,number:n2,station_id:@station.id)
                                @no2.save
                                render :json => {
                                    status: "success",
                                    error: false,
                                    message: "succeed to create station on 2 line",
                                    data: {
                                        station:@station,
                                        linecolor_1:@no1.linecolor,
                                        number_1:@no1.number,
                                        linecolor_2:@no2.linecolor,
                                        number_2:@no2.number
                                    }
                                }.to_json, :status => 200
                            else
                                render :json => {
                                    status: "success",
                                    error: false,
                                    message: "succeed to create station on 1 line",
                                    data: {
                                        station:@station,
                                        linecolor_1:@no1.linecolor,
                                        number_1:@no1.number
                                    }
                                }.to_json, :status => 200
                            end
                        else
                            render :json => {
                                status: "success",
                                error: false,
                                message: "succeed to create station on 1 line",
                                data: {
                                    station:@station,
                                    linecolor_1:@no1.linecolor,
                                    number_1:@no1.number
                                }
                            }.to_json, :status => 200
                        end
                    else
                        @station.destroy
                        render :json => {
                            status: "error",
                            error: true,
                            message: "failed to create station",
                            data: "Line #{l1} isn't exist."
                        }.to_json, :status => 400
                    end
                else
                    @station.destroy
                    render :json => {
                        status: "error",
                        error: true,
                        message: "failed to create station",
                        data: "Station No. has been taken or blank."
                    }.to_json, :status => 400
                end
            end
        end    
    end        
    
    def index
        @station = Station.all
        render :json => {
                status: "success",
                error: false,
                message: "succeed to get station list",
                data: @station
            }.to_json, :status => 200
    end

    def show
        @station = Station.find(params[:id])
        @stationno = StationNo.where(station_id:params[:id])
        s=[]
        @stationno.each do |t|
            line=Line.find_by(linecolor:t.linecolor)
            s<<{stationno:t,linename:line.name}
        end
        render :json => {
            status: "success",
            error: false,
            message: "succeed to get station",
            data: {
                station:@station,
                stationno:s
            }
        }.to_json, :status => 200
    end

    def show_by_line
        line=line_params[:linecolor]
        @no=StationNo.where(linecolor:line)
        @station=[]
        @no.each do |t|
            s=Station.find(t.station_id)
            @station<<{station:s,linecolor:t.linecolor,number:t.number}
        end
        @station =@station.sort_by{ |s| s[:number] }
        render :json => {
            status: "success",
            error: false,
            message: "succeed to get #{line} line station",
            data: @station
        }.to_json, :status => 200
    end

    def show_line
        @station=Station.find(params[:station_id])
        stationno=StationNo.where(station_id:@station.id)
        @line=[]
        stationno.each do |sn|
            line=Line.find_by(linecolor:sn.linecolor)
            @line<<line
        end
        render :json => {
                status: "success",
                error: false,
                message: "succeed to get line with #{@station.name}",
                data: @line
            }.to_json, :status => 200
    end

    def update
        check,@member=check_mrt_admin
        if check
            @station = Station.find(params[:id])
            if !@station.update(station_params)
                render :json => {
                    status: "error",
                    error: true,
                    message: "failed to update station",
                    data: @station.errors
                }.to_json, :status => 400
            else
                l1=no_params[:linecolor_1]
                n1=no_params[:number_1]
                l2=no_params[:linecolor_2]
                n2=no_params[:number_2]
                if check_is_dupliction(l1,n1) && check_is_dupliction(l2,n2)
                    render json: {
                        status: "success",
                        error: false,
                        message: "succeed to update station information",
                        data: @station
                    }.to_json, status: 200
                else
                    temp=StationNo.where(station_id:@station.id)
                    temp.each do |t|
                        t.destroy
                    end
                    @stationno=[]
                    if !check_is_dupliction(l1,n1)
                        @no1=StationNo.new(linecolor:l1,number:n1,station_id:@station.id)
                        @no1.save
                        @stationno<<@no1
                    end
                    if !check_is_dupliction(l2,n2)
                        @no2=StationNo.new(linecolor:l2,number:n2,station_id:@station.id)
                        @no2.save
                        @stationno<<@no2
                    end

                    render :json => {
                        status: "success",
                        error: false,
                        message: "succeed to update station information and No",
                        data: {
                            station:@station,
                            stationno:@stationno
                        }
                    }.to_json, :status => 200

                end
            end
        end    
    end     

    def destroy 
        check,@member=check_mrt_admin
        if check
            @station = Station.find(params[:id])
            station_no=StationNo.where(station_id:@station.id)
            station_no.each do |no|
                time_table=TimeTable.where(line:no.linecolor,end:no.number)
                time_table.destroy_all
            end
            @station.destroy
            render json: {
                status: "success",
                error: false,
                message: "succeed to delete station",
                data: {}
            }.to_json, status: 200
        end
    end        
    

    private

    def station_params
        params.permit(:name, :x_Pos, :y_Pos, :exit_Num)
    end

    def no_params
        params.permit(:linecolor_1,:number_1,:linecolor_2,:number_2)
    end

    def line_params
        params.permit(:linecolor)
    end

    def check_is_dupliction(l,n)
        if l.blank? || n.blank?
            return true
        end
        temp=StationNo.find_by(linecolor:l,number:n)
        if temp.nil?
            return false
        else
            return true
        end
    end
end
