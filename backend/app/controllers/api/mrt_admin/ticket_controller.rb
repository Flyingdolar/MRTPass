class Api::MrtAdmin::TicketController < ApplicationController
    def create
        check,@member=check_mrt_admin
        if check
            @ticket = Ticket.new
            t=Ticket.last
            @ticket.lower_bound=ticket_params[:distance]
            @ticket.price=ticket_params[:price]
            if t
                @ticket.price+=t.price
            end
            @ticket.upper_bound=1000.0
            if !@ticket.save
                Ticket.destroy_all
                render :json => {
                    status: "error",
                    error: true,
                    message: "failed to create ticket",
                    data: @ticket.errors
                }.to_json, :status => 400
            else
                if t
                    t.upper_bound=@ticket.lower_bound
                    if t.lower_bound>=t.upper_bound
                        Ticket.destroy_all
                        render :json => {
                            status: "error",
                            error: true,
                            message: "failed to create ticket",
                            data: "Distance is lower than last one."
                        }.to_json, :status => 400
                    else
                        t.save
                        render :json => {
                            status: "success",
                            error: false,
                            message: "succeed to create ticket",
                            data: Ticket.all
                        }.to_json, :status => 200
                    end
                else
                    render :json => {
                        status: "success",
                        error: false,
                        message: "succeed to create ticket",
                        data: Ticket.all
                    }.to_json, :status => 200
                end
            end
        end
    end        
    

    def index
        @ticket = Ticket.all
        render :json => {
                status: "success",
                error: false,
                message: "succeed to get ticket list",
                data: @ticket
            }.to_json, :status => 200
    end

    def show
        @ticket = Ticket.find(params[:id])
        render :json => {
            status: "success",
            error: false,
            message: "succeed to get ticket",
            data: @ticket
        }.to_json, :status => 200
    end

    def destroy 
        check,@member=check_mrt_admin
        if check
            Ticket.destroy_all
            render json: {
                status: "success",
                error: false,
                message: "succeed to delete all ticket",
                data: {}
            }.to_json, status: 200
        end        
    end

    def price_search
        station1 = Station.find(price_params[:station1])
        station2 = Station.find(price_params[:station2])
        lat1 = station1.x_Pos
        lon1 = station1.y_Pos
        lat2 = station2.x_Pos
        lon2 = station2.y_Pos
    
        # 將經緯度轉換為弧度
        lat1_rad = lat1* Math::PI / 180
        lon1_rad = lon1* Math::PI / 180
        lat2_rad = lat2* Math::PI / 180
        lon2_rad = lon2* Math::PI / 180
    
        # 計算差異的緯度和經度
        dlat = lat2_rad - lat1_rad
        dlon = lon2_rad - lon1_rad
    
        # 使用 Haversine 公式計算球面距離
        a = Math.sin(dlat / 2) ** 2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon / 2) ** 2
        c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
        radius = 6371 # 地球半徑，單位為公里
        distance = radius * c
        ticketss = Ticket.all
        @matching_ticket = ticketss.find do |ticket|
            ticket.lower_bound <= distance && distance < ticket.upper_bound
        end
        render json: {
            status: "success",
            error: false,
            message: "succeed to return ticket price",
            data: @matching_ticket.price,
        }.to_json, status: 200
    end
    
    
    
    private 

    def ticket_params
        params.permit(:price, :distance)
    end

    def price_params
        params.permit(:station1,:station2)
    end
end
