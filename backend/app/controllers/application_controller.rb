class ApplicationController < ActionController::Base
    def check_login
        @login=Login.last
        @session=Session.last
        if @login.nil?|| !@login.isLogin || @session.nil?
            render :json => {
                status: "error",
                error: true,
                message: "Unauthorized",
                data: "The user is not login."
            }.to_json, :status => 401
            return false,nil
        else
            @member=Member.find(@session.member_id)
            return true,@member
        end
    end

    def check_admin
        check,@member=check_login
        if check
            if @member.role=="admin"
                return true
            else
                render :json => {
                    status: "error",
                    error: true,
                    message: "Unauthorized",
                    data: "User not permitted for this action."
                }.to_json, :status => 403
                return false
            end
        end
        return false
    end

    def check_mrt_admin
        check,@member=check_login
        if check
            if @member.role=="admin"||@member.role=="mrt_admin"
                return true
            else
                render :json => {
                    status: "error",
                    error: true,
                    message: "Unauthorized",
                    data: "User not permitted for this action."
                }.to_json, :status => 403
                return false
            end
        end
        return false
    end
end
