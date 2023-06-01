class Api::MrtAdmin::CommentController < ApplicationController

    def create
        check,@member=check_login
        if check
            @comment = Comment.new(comments_params.merge(member_id: @member.id,info_id:params[:info_id]))
            if @comment.save
                render :json => {
                    status: "success",
                    error: false,
                    message: "succeed to create comment",
                    data: @comment
                }.to_json, :status => 200
            else
                render :json => {
                    status: "error",
                    error: true,
                    message: "failed to create comment",
                    data: @comment.errors
                }.to_json, :status => 400
            end
        end        
    end

    def index
        @comments = Comment.where(info_id:params[:info_id])
        render :json => {
            status: "success",
            error: false,
            message: "succeed to get comment list",
            data: @comments
        }.to_json, :status => 200
    end

    def show
        @comments = Comment.find(params[:id])
        render :json => {
            status: "success",
            error: false,
            message: "succeed to get comment",
            data: @comments
        }.to_json, :status => 200
    end
    
    def update
        check,@member=check_login
        if check
            @comments = Comment.find(params[:id])
            if @member.id == @comment.member_id
                if @comments.update(comments_params)
                    render json: {
                        status: "success",
                        error: false,
                        message: "succeed to update comment",
                        data: @comments
                    }.to_json, status: 200
                else
                    render :json => {
                        status: "error",
                        error: true,
                        message: "failed to update comment",
                        data: @comment.errors
                    }.to_json, :status => 400
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
            if @member.id != @comment.member_id && @member.role != "admin"
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
                    message: "success to delete comment",
                    data: {}
                }.to_json, status: 200
            end
        end        
    end


    private

    def comments_params
        params.permit(:photo, :comment, :score)
    end

end