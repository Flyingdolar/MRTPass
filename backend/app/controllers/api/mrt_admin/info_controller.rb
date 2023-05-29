class Api::MrtAdmin::InfoController < ApplicationController
    
    def create_common # l,n必須要照順序
        check,@member=check_login
        if check
            @info=Info.new(info_params)
            @info.type_ = "Common"
            if @info.save
                l1 = stationinfo_params[:linecolor1]
                l2 = stationinfo_params[:linecolor2]
                l3 = stationinfo_params[:linecolor3]
                n1 = stationinfo_params[:number1]
                n2 = stationinfo_params[:number2]
                n3 = stationinfo_params[:number3]
                responses = []
                if !l1.nil? && !n1.nil?
                    @stationinfo=StationInfo.new(linecolor:l1,number:n1,info_id:@info.id)
                    @stationinfo.save
                    responses << {
                        status: "success",
                        error: false,
                        message: "successfully created common_info",
                        data:{
                            info:@info,
                            stationinfo:@stationinfo
                        } 
                    }
                else
                    render :json => {
                        status: "error",
                        error: true,
                        message: "failed to create common_info",
                        data: {
                            error:@info.errors
                        }
                    }.to_json, :status => 400
                    reutrn
                end
                if !l2.nil? && !n2.nil?
                    @stationinfo=StationInfo.new(linecolor:l2,number:n2,info_id:@info.id)
                    @stationinfo.save
                    responses << {
                        status: "success",
                        error: false,
                        message: "successfully created common_info",
                        data:{
                            stationinfo:@stationinfo
                        } 
                    }
                end
                if !l3.nil? && !n3.nil?
                    @stationinfo=StationInfo.new(linecolor:l3,number:n3,info_id:@info.id)
                    @stationinfo.save
                    responses << {
                        status: "success",
                        error: false,
                        message: "successfully created common_info",
                        data:{
                            stationinfo:@stationinfo
                        } 
                    }
                end
                render json: responses.to_json, status: 200
            else
                render :json => {
                    status: "error",
                    error: true,
                    message: "failed to create common_info",
                    data: {
                        error:@info.errors
                    }
                }.to_json, :status => 400
            end
        end        
    end

    def create_trans #l,n必須要照順序
        check,@member=check_admin
        if check
            @info=Info.new(info_params)
            @info.type_ = "Trans"
            if @info.save
                l1 = stationinfo_params[:linecolor1]
                l2 = stationinfo_params[:linecolor2]
                l3 = stationinfo_params[:linecolor3]
                n1 = stationinfo_params[:number1]
                n2 = stationinfo_params[:number2]
                n3 = stationinfo_params[:number3]
                responses = []
                if !l1.nil? && !n1.nil?
                    @stationinfo=StationInfo.new(linecolor:l1,number:n1,info_id:@info.id)
                    @stationinfo.save
                    responses << {
                        status: "success",
                        error: false,
                        message: "successfully created trans_info",
                        data:{
                            info:@info,
                            stationinfo:@stationinfo
                        } 
                    }
                else
                    render :json => {
                        status: "error",
                        error: true,
                        message: "failed to create trans_info",
                        data: {
                            error:@info.errors
                        }
                    }.to_json, :status => 400
                    reutrn
                end
                if !l2.nil? && !n2.nil?
                    @stationinfo=StationInfo.new(linecolor:l2,number:n2,info_id:@info.id)
                    @stationinfo.save
                    responses << {
                        status: "success",
                        error: false,
                        message: "successfully created trans_info",
                        data:{
                            stationinfo:@stationinfo
                        } 
                    }
                end
                if !l3.nil? && !n3.nil?
                    @stationinfo=StationInfo.new(linecolor:l3,number:n3,info_id:@info.id)
                    @stationinfo.save
                    responses << {
                        status: "success",
                        error: false,
                        message: "successfully created trans_info",
                        data:{
                            stationinfo:@stationinfo
                        } 
                    }
                end
                render json: responses.to_json, status: 200
            else
                render :json => {
                    status: "error",
                    error: true,
                    message: "failed to create trans_info",
                    data: {
                        error:@info.errors
                    }
                }.to_json, :status => 400
            end
        end        
    end

    def index_trans
        @info = Info.where(type_: "Trans")
        render :json => {
                status: "success",
                error: false,
                message: "Sucess to see all trans_infos.",
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
                message: "Sucess to see all common_infos.",
                data: info_with_average_score
            }.to_json, :status => 200
    end

    def show_trans
        @info = Info.find(params[:id])
        if @info.nil?
            render :json => {
                status: "error",
                error: true,
                message: "failed to get the specific trans_info",
                data: "can't find the info"
            }.to_json, :status => 400
        else
            render :json => {
                status: "success",
                error: false,
                message: "Sucess to see the specific trans_info.",
                data: @info
            }.to_json, :status => 200
        end
    end

    def show_common
        @info = Info.find(params[:id])
        if @info.nil?
            render :json => {
                status: "error",
                error: true,
                message: "failed to get the specific common_info",
                data: "can't find the info"
            }.to_json, :status => 400
        else
            average_score = @info.comments.average(:score)
            render :json => {
                status: "success",
                error: false,
                message: "Sucess to see the specific common_info.",
                data: {
                    info: @info,
                    average_score: average_score
                  }
            }.to_json, :status => 200
        end
    end
    
    def update_common
        check,@member=check_login
        if check
            @info = Info.find(params[:id])
            if @info.nil?
            render json: {
                status: "error",
                error: true,
                message: "Failed to edit common_info.",
                data: "Info not found."
            }.to_json, status: 404
            else @info.update(info_params)
            render json: {
                status: "success",
                error: false,
                message: "Successfully edited the common_info.",
                data: @info
            }.to_json, status: 200
            end
        end
    end         

    def update_trans
        check,@member=check_admin
        if check
            @info = Info.find(params[:id])
            if @info.nil?
            render json: {
                status: "error",
                error: true,
                message: "Failed to edit trans_info.",
                data: "Info not found."
            }.to_json, status: 404
            else @info.update(info_params)
            render json: {
                status: "success",
                error: false,
                message: "Successfully edited the trans_info.",
                data: @info
            }.to_json, status: 200
            end
        end
    end         

    def destroy 
        check,@member=check_admin
        if check
            @info = Info.find(params[:id])
            @comments = Comment.where(info_id: @info.id)
            if @info.nil?
            render json: {
                status: "error",
                error: true,
                message: "Failed to delete info.",
                data: "Info not found."
            }.to_json, status: 404
            elsif @comments.nil?
                @info.destroy
                render json: {
                    status: "success",
                    error: false,
                    message: "Success for delete an info.",
                    data: {}
                }.to_json, status: 200
            else @comments.destroy_all
                @info.destroy
                render json: {
                    status: "success",
                    error: false,
                    message: "Success for delete an info.",
                    data: {}
                }.to_json, status: 200
            end
        end        
    end

    private

    def info_params
        params.permit(:name, :photo, :address ,:Des)
    end
    
    def stationinfo_params
        params.permit(:linecolor1, :number1, :linecolor2, :number2 ,:linecolor3, :number3)
    end
end
