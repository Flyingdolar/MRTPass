class Api::Member::CommentController < ApplicationController

    def create
        check,@member=check_login
        if check
            if Comment.find_by(member_id:@member.id,info_id:params[:info_id])
                render :json => {
                    status: "error",
                    error: true,
                    message: "failed to create comment",
                    data: "Each account can only leave one comment on a single attraction."
                }.to_json, :status => 400
            else    
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
    end

    def index
        @comments = Comment.where(info_id:params[:info_id])
        revalue=[]
        @comments.each do |c|
            m=Member.find(c.member_id)
            revalue<<{name:m.nickname,comment:c}
        end
        render :json => {
            status: "success",
            error: false,
            message: "succeed to get info_#{params[:info_id]} comment list",
            data: revalue
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
            @comment = Comment.find(params[:id])
            if @member.id == @comment.member_id
                if @comment.update(comments_params)
                    render json: {
                        status: "success",
                        error: false,
                        message: "succeed to update comment",
                        data: @comment
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
            @comment = Comment.find(params[:id])
            if @member.id != @comment.member_id && @member.role != "admin"
            render :json => {
                status: "error",
                error: true,
                message: "Unauthorized",
                data: "User not permitted for this action."
            }.to_json, :status => 403
            else @comment.destroy
                render json: {
                    status: "success",
                    error: false,
                    message: "succeed to delete comment",
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
