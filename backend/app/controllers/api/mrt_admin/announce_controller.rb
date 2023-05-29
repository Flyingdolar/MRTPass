class Api::MrtAdmin::AnnounceController < ApplicationController
    def create
        check,@member=check_mrt_admin
        if check
            @announce = Announcement.new(announce_params.merge(member_id: @member.id))
            @announce.save
            render :json => {
            status: "success",
            error: false,
            message: "Success for create an announcement.",
            data: @announce
        }.to_json, :status => 200
        end
    end        
    

    def index
        @announce = Announcement.all
        render :json => {
                status: "success",
                error: false,
                message: "Sucess to see all announcements.",
                data: @announce
            }.to_json, :status => 200
    end

    def show
        @announce = Announcement.find(params[:id])
        if @announce.nil?
            render :json => {
                status: "error",
                error: true,
                message: "failed to get the specific announcement",
                data: "can't find the announcement"
            }.to_json, :status => 400
        else
            render :json => {
                status: "success",
                error: false,
                message: "Sucess to see the specific announcements.",
                data: @announce
            }.to_json, :status => 200
        end
    end

    def update
        check,@member=check_mrt_admin
        if check
            @announce = Announcement.find(params[:id])
            if @announce.nil?
            render json: {
                status: "error",
                error: true,
                message: "Failed to edit announcement.",
                data: "Announcement not found."
            }.to_json, status: 404
            else @announce.update(announce_params)
            render json: {
                status: "success",
                error: false,
                message: "Successfully edited the announcement.",
                data: @announce
            }.to_json, status: 200
            end
        end
    end     

    def destroy 
        check,@member=check_mrt_admin
        if check
            @announce = Announcement.find(params[:id])
            if @announce.nil?
            render json: {
                status: "error",
                error: true,
                message: "Failed to delete announcement.",
                data: "Announcement not found."
            }.to_json, status: 404
            else @announce.destroy
            render json: {
                status: "success",
                error: false,
                message: "Success for delete an announcement.",
                data: {}
            }.to_json, status: 200
            end
        end        
    end

    
    private 

    def announce_params
        params.permit(:topic, :context, :member_id)
    end
      
end
