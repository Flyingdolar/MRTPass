class Api::MrtAdmin::InfoController < ApplicationController
    
    def create_common 
        check,@member=check_login
        if check
            @info=Info.new(info_params)
            @info.type_ = "Common"
            if @info.save
                s1 = stationinfo_params[:station_id_1]
                s2 = stationinfo_params[:station_id_2]
                s3 = stationinfo_params[:station_id_3]
                responses = []
                if !s1.nil?
                    @stationinfo=StationInfo.new(info_id:@info.id,station_id:s1)
                    @stationinfo.save
                    responses<<{info:@info,stationinfo:@stationinfo}
                else
                    @info.destroy
                    render :json => {
                        status: "error",
                        error: true,
                        message: "failed to create common_info",
                        data: "Field not completely filled."
                    }.to_json, :status => 400
                    reutrn
                end
                if !s2.nil?
                    @stationinfo=StationInfo.new(info_id:@info.id,station_id:s2)
                    @stationinfo.save
                    responses<<{info:@info,stationinfo:@stationinfo}
                end
                if !s3.nil?
                    @stationinfo=StationInfo.new(info_id:@info.id,station_id:s2)
                    @stationinfo.save
                    responses<<{info:@info,stationinfo:@stationinfo}
                end
                render :json => {
                    status: "success",
                    error: false,
                    message: "succeed to create common_info",
                    data: responses
                }.to_json, :status => 200
            else
                render :json => {
                    status: "error",
                    error: true,
                    message: "failed to create common_info",
                    data: "Field not completely filled."
                }.to_json, :status => 400
            end
        end        
    end

    def create_trans #l,n必須要照順序
        check=check_admin
        if check
            @info=Info.new(info_params)
            @info.type_ = "Trans"
            if @info.save
                s1 = stationinfo_params[:station_id_1]
                s2 = stationinfo_params[:station_id_2]
                s3 = stationinfo_params[:station_id_3]
                responses = []
                if !s1.nil?
                    @stationinfo=StationInfo.new(info_id:@info.id,station_id:s1)
                    @stationinfo.save
                    responses<<{info:@info,stationinfo:@stationinfo}
                else
                    @info.destroy
                    render :json => {
                        status: "error",
                        error: true,
                        message: "failed to create common_info",
                        data: "Field not completely filled."
                    }.to_json, :status => 400
                    reutrn
                end
                if !s2.nil?
                    @stationinfo=StationInfo.new(info_id:@info.id,station_id:s2)
                    @stationinfo.save
                    responses<<{info:@info,stationinfo:@stationinfo}
                end
                if !s3.nil?
                    @stationinfo=StationInfo.new(info_id:@info.id,station_id:s2)
                    @stationinfo.save
                    responses<<{info:@info,stationinfo:@stationinfo}
                end
                render :json => {
                    status: "success",
                    error: false,
                    message: "succeed to create common_info",
                    data: responses
                }.to_json, :status => 200
            else
                render :json => {
                    status: "error",
                    error: true,
                    message: "failed to create common_info",
                    data: "Field not completely filled."
                }.to_json, :status => 400
            end
        end        
    end


    def index_trans
        @info = Info.where(type_: "Trans")
        render :json => {
                status: "success",
                error: false,
                message: "succeed to get trans_info list",
                data: @info
            }.to_json, :status => 200
    end

    def index_common
        @info = Info.where(type_: "Common")
        info_with_average_score = @info.map do |info|
            average_score = info.comments.average(:score)
            {
                info: info,
                average_score: average_score
            }
        end
        render :json => {
                status: "success",
                error: false,
                message: "succeed to get common_info list",
                data: info_with_average_score
            }.to_json, :status => 200
    end

    def show_trans
        @info = Info.find(params[:id])
        render :json => {
            status: "success",
            error: false,
            message: "succeed to get trans_info",
            data: @info
        }.to_json, :status => 200

    end

    def show_common
        @info = Info.find(params[:id])
        average_score = @info.comments.average(:score)
        render :json => {
            status: "success",
            error: false,
            message: "succeed to get common_info",
            data: {
                info: @info,
                average_score: average_score
            }
        }.to_json, :status => 200
    end
    
    def update_common
        check,@member=check_login
        if check
            @info = Info.find(params[:id])
            if @info.update(info_params)
                render json: {
                    status: "success",
                    error: false,
                    message: "succeed to update common_info",
                    data: @info
                }.to_json, status: 200
            else
                render :json => {
                    status: "error",
                    error: true,
                    message: "failed to update common_info",
                    data: "Field not completely filled."
                }.to_json, :status => 400
            end
        end
    end         

    def update_trans
        check=check_admin
        if check
            @info = Info.find(params[:id])
            if @info.update(info_params)
                render json: {
                    status: "success",
                    error: false,
                    message: "succeed to update trans_info",
                    data: @info
                }.to_json, status: 200
            else
                render :json => {
                    status: "error",
                    error: true,
                    message: "failed to update trans_info",
                    data: "Field not completely filled."
                }.to_json, :status => 400
            end
        end
    end         

    def destroy 
        check=check_admin
        if check
            @info = Info.find(params[:id])
            @info.destroy
                render json: {
                    status: "success",
                    error: false,
                    message: "succeed to delete info",
                    data: {}
                }.to_json, status: 200
        end        
    end

    private

    def info_params
        params.permit(:name, :photo, :address ,:Des)
    end
    
    def stationinfo_params
        params.permit(:station_id_1,:station_id_2,:station_id_3)
    end
end
