class Api::MrtAdmin::TimeTableController < ApplicationController
    def create
        check,@member=check_mrt_admin
        if check
            @timetable = TimeTable.new(timetable_params)
            @timetable.station_id=params[:station_id]
            if StationNo.find_by(linecolor:@timetable.line,number:@timetable.end) 
                if StationNo.find_by(station_id:@timetable.station_id,linecolor:@timetable.line)
                    if @timetable.save
                        render :json => {
                            status: "success",
                            error: false,
                            message: "succeed to create timetable",
                            data: @timetable
                        }.to_json, :status => 200
                    else
                        render json: {
                            status: "error",
                            error: true,
                            message: "failed to create timetable",
                            data: @timetable.errors
                        }.to_json, status: 400
                    end
                else
                    render json: {
                        status: "error",
                        error: true,
                        message: "failed to create timetable",
                        data: "This station and terminal station not at same line."
                    }.to_json, status: 400
                end
            else
                render json: {
                    status: "error",
                    error: true,
                    message: "failed to create timetable",
                    data: "Terminal station doesn't exist."
                }.to_json, status: 400
            end
        end
    end        
    

    def index
        @timetables = TimeTable.where(station_id:params[:station_id])
        revalue=[]
        @timetables.each do |t|
            s_no=StationNo.find_by(linecolor:t.line,number:t.end)
            s=Station.find(s_no.station_id)
            l=Line.find_by(linecolor:t.line)
            revalue<<{timetable:t,to:s.name,line:l.name}
        end
        revalue =revalue.sort_by{ |q| [q[:timetable].time,q[:timetable].id] }
        render :json => {
                status: "success",
                error: false,
                message: "succeed to get timetable list",
                data: revalue
            }.to_json, :status => 200
    end

    def show
        @timetable = TimeTable.find(params[:id])
        render :json => {
            status: "success",
            error: false,
            message: "succeed to get timetable",
            data: @timetable
        }.to_json, :status => 200
    end

    def update
        check,@member=check_mrt_admin
        if check
            @timetable = TimeTable.new(timetable_params)
            @timetable.station_id=params[:station_id]
            if StationNo.find_by(linecolor:@timetable.line,number:@timetable.end) 
                if StationNo.find_by(station_id:@timetable.station_id,linecolor:@timetable.line)
                    @timetable = TimeTable.find(params[:id])
                    if @timetable.update(timetable_params)
                        render json: {
                            status: "success",
                            error: false,
                            message: "succeed to update timetable",
                            data: @timetable
                        }.to_json, status: 200
                    else
                        render json: {
                            status: "error",
                            error: true,
                            message: "failed to update timetable",
                            data: @timetable.errors
                        }.to_json, status: 400
                    end
                else
                    render json: {
                        status: "error",
                        error: true,
                        message: "failed to update timetable",
                        data: "This station and terminal station not at same line."
                    }.to_json, status: 400
                end
            else
                render json: {
                    status: "error",
                    error: true,
                    message: "failed to update timetable",
                    data: "Terminal station doesn't exist."
                }.to_json, status: 400
            end
        end
    end     

    def destroy 
        check,@member=check_mrt_admin
        if check
            @timetable = TimeTable.find(params[:id])
            @timetable.destroy
            render json: {
                status: "success",
                error: false,
                message: "succeed to delete timetable",
                data: {}
            }.to_json, status: 200
        end        
    end
    
    def time_table_search
        current_time = Time.now 
        start_time = current_time 
        end_time = current_time + 20.minutes
        a = TimeTable.where(station_id: params[:station_id]).where("time >= ? AND time <= ?", start_time.strftime("%H:%M:%S"), end_time.strftime("%H:%M:%S"))
        @temp = []
        a.each do |c|
            if @temp.blank?
                @temp << { line: c.line, end: c.end, name: nil, time: c.time, spend_time: nil, No: c.No }
            else
                check = true
                @temp.each do |d|
                    if c.line == d[:line] && c.end == d[:end]
                        check = false
                        break
                    end
                end
                if check
                    @temp << { line: c.line, end: c.end, name: nil, time: c.time, spend_time: nil, No: c.No }
                end
            end
        end
        terminal = nil
        @temp.each do |item|
            station_no = StationNo.find_by(linecolor: item[:line], number: item[:end])
            name = Station.find(station_no.station_id).name
            item[:name] = "往" + name if name
            item[:spend_time] = calculate_spend_time(item[:time], current_time)
        end
        render json: {
            status: "success",
            error: false,
            message: "succeed to get timetable_search_result",
            data: @temp
        }.to_json, status: 200 
    end

    def calculate_spend_time(time, current_time)
        parts = time.split(':').map(&:to_i)
        s_time = parts[0] * 3600 + parts[1]*60
        current_time = current_time.strftime("%H:%M:%S")
        parts = current_time.split(':').map(&:to_i)
        s_current_time = parts[0] * 3600 + parts[1]*60 + parts[2]
        diff_in_seconds = s_time - s_current_time
        minutes = diff_in_seconds / 60
        seconds = diff_in_seconds % 60
        if seconds <= 30
            seconds = 30
        else 
            seconds = 0
            minutes += 1
        end
        "#{minutes}分#{seconds}秒"
    end



    private 

    def timetable_params
        params.permit(:time, :line, :end, :No)
    end
end
