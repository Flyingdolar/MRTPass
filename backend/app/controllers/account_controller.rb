class AccountController < ApplicationController
    def create
        @member = Member.new(member_params)
        @member.role = "user"
        id=format('%03d',Member.last.id+1)
        @member.nickname ="user#344#{id}"
        if @member.save
            render :json => {
                status: "success",
                error: false,
                message: "succeed to created account",
                data: @member
            }.to_json, :status => 200
        else
            render :json => {
                status: "error",
                error: true,
                message: "failed to create account",
                data: {
                    error:@member.errors
                }
            }.to_json, :status => 400
        end
    end

    def new_session
        @login=Login.last
        @session=Session.last
        if @login.nil? || !@login.isLogin || @session.nil?
            @member = Member.find_by(account: params[:account])
            if @member.nil?
                render :json => {
                    status: "error",
                    error: true,
                    message: "failed to login",
                    data: "This account doesn't exist."
                }.to_json, :status => 400
            elsif @member.password != params[:password]
                render :json => {
                    status: "error",
                    error: true,
                    message: "failed to login",
                    data: "Password error."
                }.to_json, :status => 400
            else
                @session=Session.create(member_id: @member.id)
                @login=Login.create(isLogin:true)
                render :json => {
                    status: "success",
                    error: false,
                    message: "succeed to login",
                    data:  @member
                }.to_json, :status => 200
            end
        else
            @member=Member.find(@session.member_id)
            render :json => {
                status: "error",
                error: true,
                message: "failed to login",
                data: "Already logged in (#{@member.nickname})."
            }.to_json, :status => 403
        end  
    end

    def get_session
        @session=Session.last
        @login  =Login.last
        if @login.nil?||!@login.isLogin
            render :json => {
                status: "success",
                error: false,
                message: "succeed to get session",
                data: {
                    isLogin: false
                }
            }.to_json, :status => 200
        elsif @session.nil?
            render :json => {
                status: "error",
                error: true,
                message: "failed to get session",
                data: "This is no session log."
            }.to_json, :status => 400
        else
            @member=Member.find(@session.member_id)
            render :json => {
                status: "success",
                error: false,
                message: "succeed to get session",
                data: {
                    isLogin: true,
                    member: @member
                }
            }.to_json, :status => 200
        end
    end

    def delete
        @login=Login.last
        if !@login.nil? && @login.isLogin
            @login=Login.create(isLogin:false)
            render :json => {
                status: "success",
                error: false,
                message: "succeed to logout",
                data:  {}
            }.to_json, :status => 200
        else
            render :json => {
                status: "error",
                error: true,
                message: "failed to logout",
                data: "Already logged out."
            }.to_json, :status => 401
        end
    end

    def update
        check,@member=check_login
        if check
            if @member.update(update_params)
                render :json => {
                    status: "success",
                    error: false,
                    message: "succeed to update account information",
                    data: @member
                }.to_json, :status => 200
            else
                render :json => {
                    status: "error",
                    error: true,
                    message: "failed to update account information",
                    data: @member.errors
                }.to_json, :status => 400
            end   
        end
    end

    def update_pswd
        check,@member=check_login
        if check
            if @member.password==password_params[:old_password]
                if password_params[:new_password]==password_params[:confirmation]
                    @member.password=password_params[:new_password]
                    if @member.save
                        render :json => {
                            status: "success",
                            error: false,
                            message: "succeed to update password",
                            data: @member
                        }.to_json, :status => 200
                    else
                        render :json => {
                            status: "error",
                            error: true,
                            message: "failed to update password",
                            data: @member.errors
                        }.to_json, :status => 400
                    end
                else
                    render :json => {
                        status: "error",
                        error: true,
                        message: "failed to update password",
                        data: "The password confirmation does not match the new password."
                    }.to_json, :status => 400
                end
            else
                render :json => {
                    status: "error",
                    error: true,
                    message: "failed to update password",
                    data: "Old password error."
                }.to_json, :status => 400
            end
        end
    end


    private

    def member_params
        params.permit(:account, :password)
    end

    def update_params
        params.permit(:nickname,:picture)
    end

    def password_params
        params.permit(:old_password,:new_password,:confirmation)
    end

end
