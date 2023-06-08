class Api::MrtAdmin::LineController < ApplicationController
    def create
        check,@member=check_mrt_admin
        if check
            @line = Line.new(line_params)
            if @line.save
                render :json => {
                    status: "success",
                    error: false,
                    message: "succeed to create line",
                    data: @line
                }.to_json, :status => 200
            else
                render json: {
                    status: "error",
                    error: true,
                    message: "failed to create line",
                    data: @line.errors
                }.to_json, status: 400
            end
        end
    end        
    

    def index
        @line = Line.all
        render :json => {
                status: "success",
                error: false,
                message: "succeed to get line list",
                data: @line
            }.to_json, :status => 200
    end

    def show
        @line = Line.find(params[:id])
        render :json => {
            status: "success",
            error: false,
            message: "succeed to get line",
            data: @line
        }.to_json, :status => 200
    end

    def update
        check,@member=check_mrt_admin
        if check
            @line = Line.find(params[:id])
            if @line.update(line_params)
                render json: {
                    status: "success",
                    error: false,
                    message: "succeed to update line",
                    data: @line
                }.to_json, status: 200
            else
                render json: {
                    status: "error",
                    error: true,
                    message: "failed to update line",
                    data: @line.errors
                }.to_json, status: 400
            end
        end
    end     

    def destroy 
        check,@member=check_mrt_admin
        if check
            @line = Line.find(params[:id])
            stationno=StationNo.where(linecolor:@line.linecolor)
            stationno.each do |t|
                q=t.station_id
                t.destroy
                temp=StationNo.where(station_id:q)
                if temp.blank?
                    Station.find(q).destroy
                end
            end
            @line.destroy
            render json: {
                status: "success",
                error: false,
                message: "succeed to delete line",
                data: {}
            }.to_json, status: 200
        end        
    end

    
    private 

    def line_params
        params.permit(:linecolor, :name, :colorcode)
    end
end
