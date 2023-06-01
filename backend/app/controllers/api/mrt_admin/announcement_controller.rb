class Api::MrtAdmin::AnnouncementController < ApplicationController
    def create
        check,@member=check_mrt_admin
        if check
            @announce = Announcement.new(announce_params.merge(member_id: @member.id))
            if @announce.save
                render :json => {
                    status: "success",
                    error: false,
                    message: "succeed to create announcement",
                    data: @announce
                }.to_json, :status => 200
            else
                render json: {
                    status: "error",
                    error: true,
                    message: "failed to create announcement",
                    data: @announce.errors
                }.to_json, status: 400
            end
        end
    end        
    

    def index
        @announce = Announcement.all
        render :json => {
                status: "success",
                error: false,
                message: "succeed to get announcement list",
                data: @announce
            }.to_json, :status => 200
    end

    def show
        @announce = Announcement.find(params[:id])
        render :json => {
            status: "success",
            error: false,
            message: "succeed to get announcement",
            data: @announce
        }.to_json, :status => 200
    end

    def update
        check,@member=check_mrt_admin
        if check
            @announce = Announcement.find(params[:id])
            if @announce.update(announce_params)
                render json: {
                    status: "success",
                    error: false,
                    message: "succeed to update announcement",
                    data: @announce
                }.to_json, status: 200
            else
                render json: {
                    status: "error",
                    error: true,
                    message: "failed to update announcement",
                    data: @announce.errors
                }.to_json, status: 400
            end
        end
    end     

    def destroy 
        check,@member=check_mrt_admin
        if check
            @announce = Announcement.find(params[:id])
            @announce.destroy
            render json: {
                status: "success",
                error: false,
                message: "succeed to delete announcement",
                data: {}
            }.to_json, status: 200
        end        
    end

    
    private 

    def announce_params
        params.permit(:topic, :context)
    end
end
