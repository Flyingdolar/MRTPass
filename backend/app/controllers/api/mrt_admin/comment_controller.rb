class Api::MrtAdmin::CommentController < ApplicationController

    def create
        check,@member=check_login
        if check
            @info = Info.find(params[:info_id])
            @comments = Comment.new(comments_params.merge(member_id: @member.id,info_id: @info.id))
            if @comments.save
                render :json => {
                    status: "success",
                    error: false,
                    message: "successfully created comment",
                    data: @comments
                }.to_json, :status => 200
            else
                render :json => {
                    status: "error",
                    error: true,
                    message: "failed to create comment",
                    data: {
                        error:@comments.errors
                    }
                }.to_json, :status => 400
            end
            
        end        
    end

    def index
        @info = Info.find(params[:info_id])
        @comments = Comment.where(info_id: @info.id)
        #@comments = Comment.joins(:info).where(info_id: params[:info_id]).order(:number)
        render :json => {
                status: "success",
                error: false,
                message: "Sucess to see all comments.",
                data: {
                    info: @info,
                    comments: @comments
                }
            }.to_json, :status => 200
    end

    def show
        @comments = Comment.find(params[:id])
        if @comments.nil?
            render :json => {
                status: "error",
                error: true,
                message: "failed to get the specific comment",
                data: "can't find the comment"
            }.to_json, :status => 400
        else
            render :json => {
                status: "success",
                error: false,
                message: "Sucess to see the specific comment.",
                data: @comments
            }.to_json, :status => 200
        end
    end


    
    def update
        check,@member=check_login
        if check
            @comments = Comment.find(params[:id])
            if @member.id == @comment.member_id
                if @comments.nil?
                render json: {
                    status: "error",
                    error: true,
                    message: "Failed to edit comment.",
                    data: "Info not found."
                }.to_json, status: 404
                else @comments.update(comments_params)
                render json: {
                    status: "success",
                    error: false,
                    message: "Successfully edited the comment.",
                    data: @comments
                }.to_json, status: 200
                end
            else 
            render :json => {
                status: "error",
                error: true,
                message: "Unauthorized",
                data: "User not permitted for this action."
            }.to_json, :status => 403
            end
        end
    end         


    def destroy 
        check,@member=check_login
        if check
            @comments = Comment.find(params[:id])
            if @comments.nil?
            render json: {
                status: "error",
                error: true,
                message: "Failed to delete comment.",
                data: "Info not found."
            }.to_json, status: 404
            elsif @member.id != @comment.member_id && @member.role != "admin"
            render :json => {
                status: "error",
                error: true,
                message: "Unauthorized",
                data: "User not permitted for this action."
            }.to_json, :status => 403
            else @comments.destroy
            render json: {
                status: "success",
                error: false,
                message: "Success for delete an comment.",
                data: {}
            }.to_json, status: 200
            end
        end        
    end


    private

    def comments_params
        params.permit(:photo, :comment, :score, :member_id, :info_id)
    end

end
