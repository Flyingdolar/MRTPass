class Api::MrtAdmin::StationController < ApplicationController
    
    def index
        @stations=Station.all
        render :json => {
            status: "success",
            error: false,
            message: "successfully get stations",
            data: @stations
        }.to_json, :status => 200
    end

    def create
        @station=Station.new(station_params)
        p "1"
        if @station.save
            render :json => {
                status: "success",
                error: false,
                message: "successfully created station",
                data: @station
            }.to_json, :status => 200
        else
            render :json => {
                status: "error",
                error: true,
                message: "failed to create station",
                data: {
                    error:@sprogram.errors
                }
            }.to_json, :status => 400
        end
    end


    private

    def station_params
        params.permit(:linecolor, :number, :x_Pos, :y_Pos, :Trans_Num, :exit_Num)
    end

end
