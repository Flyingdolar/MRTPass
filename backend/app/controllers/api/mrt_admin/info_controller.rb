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
                if !s1.blank?
                    @stationinfo=StationInfo.new(info_id:@info.id,station_id:s1)
                    @stationinfo.save
                    responses<<s1
                else
                    @info.destroy
                    render :json => {
                        status: "error",
                        error: true,
                        message: "failed to create common_info",
                        data: "Field not completely filled."
                    }.to_json, :status => 400
                    return
                end
                if !s2.blank?
                    @stationinfo=StationInfo.new(info_id:@info.id,station_id:s2)
                    @stationinfo.save
                    responses<<s2
                end
                if !s3.blank?
                    @stationinfo=StationInfo.new(info_id:@info.id,station_id:s3)
                    @stationinfo.save
                    responses<<s3
                end
                render :json => {
                    status: "success",
                    error: false,
                    message: "succeed to create common_info",
                    data:{
                        info:@info,
                        station_id:responses
                    } 
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

    def create_trans 
        check=check_admin
        if check
            @info=Info.new(info_params)
            @info.type_ = "Trans"
            if @info.save
                s1 = stationinfo_params[:station_id_1]
                s2 = stationinfo_params[:station_id_2]
                s3 = stationinfo_params[:station_id_3]
                responses = []
                if !s1.blank?
                    @stationinfo=StationInfo.new(info_id:@info.id,station_id:s1)
                    @stationinfo.save
                    responses<<s1
                else
                    @info.destroy
                    render :json => {
                        status: "error",
                        error: true,
                        message: "failed to create trans_info",
                        data: "Field not completely filled."
                    }.to_json, :status => 400
                    return
                end
                if !s2.blank?
                    @stationinfo=StationInfo.new(info_id:@info.id,station_id:s2)
                    @stationinfo.save
                    responses<<s2
                end
                if !s3.blank?
                    @stationinfo=StationInfo.new(info_id:@info.id,station_id:s3)
                    @stationinfo.save
                    responses<<s3
                end
                render :json => {
                    status: "success",
                    error: false,
                    message: "succeed to create trans_info",
                    data: {
                        info:@info,
                        station_id:responses
                    } 
                }.to_json, :status => 200
            else
                render :json => {
                    status: "error",
                    error: true,
                    message: "failed to create trans_info",
                    data: "Field not completely filled."
                }.to_json, :status => 400
            end
        end        
    end


    def index_trans
        s=Station.find(station_params[:station_id])
        s_i=StationInfo.where(station_id:s.id)
        @info=[] 
        s_i.each do |t|
            k=Info.find(t.info_id)
            if k.type_=="Trans"
                @info<<k
            end
        end
        render :json => {
                status: "success",
                error: false,
                message: "succeed to get trans_info list around #{s.name}",
                data: @info
            }.to_json, :status => 200
    end

    def index_common
        s=Station.find(station_params[:station_id])
        s_i=StationInfo.where(station_id:s.id)
        @info=[] 
        s_i.each do |t|
            k=Info.find(t.info_id)
            if k.type_=="Common"
                @info<<k
            end
        end
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
                message: "succeed to get common_info list around #{s.name}",
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
    
    def station_params
        params.permit(:station_id)
    end

    def stationinfo_params
        params.permit(:station_id_1,:station_id_2,:station_id_3)
    end
end
