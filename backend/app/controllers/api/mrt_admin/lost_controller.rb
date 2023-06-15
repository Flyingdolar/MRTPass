class Api::MrtAdmin::LostController < ApplicationController
    def create
        check,@member=check_mrt_admin
        if check
            @lost = Lost.new(lost_params.merge(member_id: @member.id))
            if @lost.save
                render :json => {
                    status: "success",
                    error: false,
                    message: "succeed to create lost",
                    data: @lost
                }.to_json, :status => 200
            else
                render json: {
                    status: "error",
                    error: true,
                    message: "failed to create lost",
                    data: @lost.errors
                }.to_json, status: 400
            end
        end
    end        
    

    def index
        @lost = Lost.all
        render :json => {
                status: "success",
                error: false,
                message: "succeed to get lost list",
                data: @lost
            }.to_json, :status => 200
    end

    def show
        @lost = Lost.find(params[:id])
        render :json => {
            status: "success",
            error: false,
            message: "succeed to get lost",
            data: @lost
        }.to_json, :status => 200
    end

    def update
        check,@member=check_mrt_admin
        if check
            @lost = Lost.find(params[:id])
            if @lost.update(lost_params)
                render json: {
                    status: "success",
                    error: false,
                    message: "succeed to update lost",
                    data: @lost
                }.to_json, status: 200
            else
                render json: {
                    status: "error",
                    error: true,
                    message: "failed to update lost",
                    data: @lost.errors
                }.to_json, status: 400
            end
        end
    end     

    def destroy 
        check,@member=check_mrt_admin
        if check
            @lost = Lost.find(params[:id])
            @lost.destroy
            render json: {
                status: "success",
                error: false,
                message: "succeed to delete lost",
                data: {}
            }.to_json, status: 200
        end        
    end

    
    private 

    def lost_params
        params.permit(:item, :photo, :time, :location, :lost_Attr)
    end
end
