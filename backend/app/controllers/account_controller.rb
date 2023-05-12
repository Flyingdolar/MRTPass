class AccountController < ApplicationController
    def create
        @member = Member.new(member_params)
        if @member.save
            @member.role = "user"
            id=format('%03d',@member.id)
            @member.nickname ="user#344#{id}"
            @member.save
            render :json => {
                status: "success",
                error: false,
                message: "successfully created account",
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
                    data: "This account doesn't exist"
                }.to_json, :status => 400
            elsif @member.password != params[:password]
                render :json => {
                    status: "error",
                    error: true,
                    message: "failed to login",
                    data: "Password error"
                }.to_json, :status => 400
            else
                @session=Session.create(member_id: @member.id)
                @login=Login.create(isLogin:true)
                render :json => {
                    status: "success",
                    error: false,
                    message: "successfully login",
                    data:  @member
                }.to_json, :status => 200
            end
        else
            @member=Member.find(@session.member_id)
            render :json => {
                status: "error",
                error: true,
                message: "failed to login",
                data: "Already logged in (#{@member.nickname})"
            }.to_json, :status => 403
        end  
    end

    def get_session
        @session=Session.last
        @login  =Login.last
        if @login.nil?||@login.isLogin==false
            render :json => {
                status: "success",
                error: false,
                message: "No user online",
                data: {
                    isLogin: false
                }
            }.to_json, :status => 200
        elsif @session.nil?
            render :json => {
                status: "error",
                error: true,
                message: "failed to get session log",
                data: "This is no session log"
            }.to_json, :status => 400
        else
            @member=Member.find(@session.member_id)
            render :json => {
                status: "success",
                error: false,
                message: "User online",
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
                message: "successfully logout",
                data:  {}
            }.to_json, :status => 200
        else
            render :json => {
                status: "error",
                error: true,
                message: "failed to logout",
                data: "Already logged out"
            }.to_json, :status => 401
        end
    end

    private

    def member_params
        params.permit(:account, :password)
    end
end
