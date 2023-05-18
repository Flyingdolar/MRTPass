class Api::MrtAdmin::AnnounceController < ApplicationController
    def create
        @session=Session.last
        @login  =Login.last
        if @login.nil?||!@login.isLogin||@session.nil?
            render :json => {
                status: "error",
                error: true,
                message: "Failed to create announcement.",
                data: "The user is not login."
            }.to_json, :status => 400
        else
            @member=Member.find(@session.member_id)
            if @member.role == "mrt_admin"
                @announce = Announcement.new(announce_params.merge(member_id: @member.id))
                @announce.save
                render :json => {
                status: "success",
                error: false,
                message: "Success for create an announcement.",
                data: @announce
            }.to_json, :status => 200
            else 
                render :json => {
                status: "error",
                error: true,
                message: "Failed to create announcement.",
                data: "Wrong authority."
            }.to_json, :status => 403
            end
        end        
    end

    def show_all
        @announce = Announcement.all
        render :json => {
                status: "success",
                error: false,
                message: "Sucess to see all announcements.",
                data: @announce
            }.to_json, :status => 200
    end

    def show_one
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

    def edit
        @session = Session.last
        @login = Login.last
      
        if @login.nil? || !@login.isLogin || @session.nil?
            render json: {
                status: "error",
                error: true,
                message: "Failed to edit announcement.",
                data: "The user is not logged in."
            }.to_json, status: 400
        else
            @member = Member.find(@session.member_id)
            if @member.role == "mrt_admin"
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
            else
                render json: {
                status: "error",
                error: true,
                message: "Failed to edit announcement.",
                data: "Insufficient authority."
                }.to_json, status: 403
            end
        end
    end      

    def delete 
        @session=Session.last
        @login  =Login.last
        if @login.nil?||!@login.isLogin||@session.nil?
            render :json => {
                status: "error",
                error: true,
                message: "Failed to delete announcement.",
                data: "The user is not login."
            }.to_json, :status => 400
        else
            @member = Member.find(@session.member_id)
            if @member.role == "mrt_admin"
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
            else
                render json: {
                status: "error",
                error: true,
                message: "Failed to delete announcement.",
                data: "Wrong authority."
                }.to_json, status: 403
            end
        end        
    end

    
    private 

    def announce_params
        params.permit(:topic, :context, :member_id)
    end
      
end
