class Api::Admin::AuthorizationController < ApplicationController
    def index
        check=check_admin
        if check
            @members=Member.where.not(role: "admin")
            render :json => {
                status: "success",
                error: false,
                message: "succeed to get member list",
                data: @members
            }.to_json, :status => 200
        end
    end

    def show
        check=check_admin
        if check
            @member=Member.find(params[:id])
            if @member.role == "admin"
                render :json => {
                    status: "error",
                    error: true,
                    message: "failed to get member",
                    data: "Member #{@member.id} is admin."
                }.to_json, :status => 400
            else
                render :json => {
                    status: "success",
                    error: false,
                    message: "succeed to get member",
                    data: @member
                }.to_json, :status => 200
            end
        end
    end

    def update
        check=check_admin
        if check
            @member=Member.find(params[:id])
            if @member.role == "admin"
                render :json => {
                    status: "error",
                    error: true,
                    message: "failed to update member information",
                    data: "Member #{@member.id} is admin."
                }.to_json, :status => 400
            else
                if @member.update(update_params)
                    render :json => {
                        status: "success",
                        error: false,
                        message: "succeed to update member information",
                        data: @member
                    }.to_json, :status => 200
                else
                    render :json => {
                        status: "error",
                        error: true,
                        message: "failed to update member information",
                        data: @member.errors
                    }.to_json, :status => 400
                end
            end
        end
    end

    def destroy
        check=check_admin
        if check
            @member=Member.find(params[:id])
            if @member.role == "admin"
                render :json => {
                    status: "error",
                    error: true,
                    message: "failed to delete member",
                    data: "Member #{@member.id} is admin."
                }.to_json, :status => 400
            else
                @member.destroy
                render :json => {
                    status: "success",
                    error: false,
                    message: "succeed to delete member",
                    data: {}
                }.to_json, :status => 200
            end
        end
    end


    private

    def update_params
        params.permit(:nickname,:password,:role)
    end
    
end
