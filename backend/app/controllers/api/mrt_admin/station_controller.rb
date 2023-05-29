class Api::MrtAdmin::StationController < ApplicationController
    
    def create
        check,@member=check_mrt_admin
        if check
            @station=Station.new(station_params)
            @station.save
            render :json => {
            status: "success",
            error: false,
            message: "Success for create a station.",
            data: @station
        }.to_json, :status => 200
        end
    end        
    

    def index
        @station = Station.all
        render :json => {
                status: "success",
                error: false,
                message: "Sucess to see all stations.",
                data: @station
            }.to_json, :status => 200
    end

    def show
        @station = Station.find(params[:id])
        if @station.nil?
            render :json => {
                status: "error",
                error: true,
                message: "failed to get the specific station",
                data: "can't find the station"
            }.to_json, :status => 400
        else
            render :json => {
                status: "success",
                error: false,
                message: "Sucess to see the specific station.",
                data: @station
            }.to_json, :status => 200
        end
    end

    def update
        check,@member=check_mrt_admin
        if check
            @station = Station.find(params[:id])
            if @station.nil?
            render json: {
                status: "error",
                error: true,
                message: "Failed to edit station.",
                data: "station not found."
            }.to_json, status: 404
            else @station.update(station_params)
            render json: {
                status: "success",
                error: false,
                message: "Successfully edited the station.",
                data: @station
            }.to_json, status: 200
            end
        end
    end     

    def destroy 
        check,@member=check_mrt_admin
        if check
            @station = Station.find(params[:id])
            if @station.nil?
            render json: {
                status: "error",
                error: true,
                message: "Failed to delete station.",
                data: "station not found."
            }.to_json, status: 404
            else @station.destroy
            render json: {
                status: "success",
                error: false,
                message: "Success for delete an station.",
                data: {}
            }.to_json, status: 200
            end
        end
    end        
    

    private

    def station_params
        params.permit(:linecolor, :number, :x_Pos, :y_Pos, :isCross, :exit_Num, :name)
    end

end
