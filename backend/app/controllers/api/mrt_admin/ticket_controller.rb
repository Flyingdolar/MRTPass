class Api::MrtAdmin::TicketController < ApplicationController
    def create
        check,@member=check_mrt_admin
        if check
            @ticket = Ticket.new(ticket_params)
            if @ticket.save
                render :json => {
                    status: "success",
                    error: false,
                    message: "succeed to create ticket",
                    data: @ticket
                }.to_json, :status => 200
            else
                render json: {
                    status: "error",
                    error: true,
                    message: "failed to create ticket",
                    data: @ticket.errors
                }.to_json, status: 400
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

    def update
        check,@member=check_mrt_admin
        if check
            @ticket = Ticket.find(params[:id])
            if @ticket.update(ticket_params)
                render json: {
                    status: "success",
                    error: false,
                    message: "succeed to update ticket",
                    data: @ticket
                }.to_json, status: 200
            else
                render json: {
                    status: "error",
                    error: true,
                    message: "failed to update ticket",
                    data: @ticket.errors
                }.to_json, status: 400
            end
        end
    end     

    def destroy 
        check,@member=check_mrt_admin
        if check
            @ticket = Ticket.find(params[:id])
            @ticket.destroy
            render json: {
                status: "success",
                error: false,
                message: "succeed to delete ticket",
                data: {}
            }.to_json, status: 200
        end        
    end

    def price_search
        station1 = Station.find_by(id: params[:station1])
        station2 = Station.find_by(id: params[:station2])
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
        params.permit(:price, :upper_bound, :lower_bound)
    end
end
