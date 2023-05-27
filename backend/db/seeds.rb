# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#

def set_time_table(start_count,end_count,line,no)
    a=Station.where(linecolor:line)
    time_="06:00"
    while(time_<="23:00")
        i=start_count
        each_time_=time_
        a.each do |temp|
            each_time_=time_add(each_time_,3)
            if i>=end_count
                break
            elsif temp.number!=i
                s=CrossStation.find_by(linecolor_2:temp.linecolor,number_2:i)
                TimeTable.create(time:each_time_,line:line,end:end_count,linecolor:s.linecolor_1,number:s.number_1,No:no)
                i=i+1
                redo
            else
                TimeTable.create(time:each_time_,line:line,end:end_count,linecolor:line,number:temp.number,No:no)
                i=i+1
            end
        end
        time_=time_add(time_,5)
        no=no+7
    end
end


def set_time_table_inverse(start_count,end_count,line,no)
    a=Station.where(linecolor:line).order(number: :desc)
    time_="06:00"
    while(time_<="23:00")
        i=start_count
        each_time_=time_
        a.each do |temp|
            each_time_=time_add(each_time_,3)
            if i<=end_count
                break
            elsif temp.number>start_count
                next
            elsif temp.number!=i
                s=CrossStation.find_by(linecolor_2:temp.linecolor,number_2:i)
                TimeTable.create(time:each_time_,line:line,end:end_count,linecolor:s.linecolor_1,number:s.number_1,No:no)
                i=i-1
                redo
            else
                TimeTable.create(time:each_time_,line:line,end:end_count,linecolor:line,number:temp.number,No:no)
                i=i-1
            end
        end
        time_=time_add(time_,5)
        no=no+7
    end
end

def time_add(start,diff)
    time=start
    hour, minute = time.split(':').map(&:to_i)
    minute += diff
    if minute >= 60
        hour += 1
        minute -= 60
    end
    if hour==24
        hour=0
    end
    new_time = format('%02d:%02d', hour, minute)
    return new_time
end


p "DB seeding start"
p "Clear DB"
Announcement.destroy_all
Comment.destroy_all
Login.destroy_all
Session.destroy_all
Lost.destroy_all
StationInfo.destroy_all
Info.destroy_all
Ticket.destroy_all
TimeTable.destroy_all
CrossStation.destroy_all
Station.destroy_all
Line.destroy_all
Member.destroy_all

p "Create member"
Member.create(account:"admin",password:"123456",nickname:"admin",role:"admin")
Member.create(account:"mrt_admin",password:"123456",nickname:"北捷管理員",role:"mrt_admin")
Member.create(account:"user1",password:"123456",nickname:"user#344003",role:"user")
Member.create(account:"user2",password:"123456",nickname:"user#344004",role:"user")

p "Create line"
Line.create(linecolor:"BR",name:"文湖線",colorcode:"#c48c31")
Line.create(linecolor: "R",name:"淡水信義線",colorcode:"#e3002c")
Line.create(linecolor: "G",name:"松山新店線",colorcode:"#008659")
Line.create(linecolor: "O",name:"中和新蘆線",colorcode:"#f8b61c")
Line.create(linecolor:"BL",name:"板南線",colorcode:"#0070bd")
Line.create(linecolor:"Y",name:"環狀線",colorcode:"#ffdb00")
Line.create(linecolor:"LG",name:"小碧潭支線",colorcode:"#cfdb00")
Line.create(linecolor:"LR",name:"新北投支線",colorcode:"#fd92a3")

p "Create station"
p "BR line"
Station.create(linecolor:"BR",number: 1,x_Pos:24.9982,y_Pos:121.5793,isCross:false,exit_Num:2,name:"動物園")
Station.create(linecolor:"BR",number: 2,x_Pos:24.9982,y_Pos:121.5731,isCross:false,exit_Num:1,name:"木柵")
Station.create(linecolor:"BR",number: 3,x_Pos:24.9986,y_Pos:121.5681,isCross:false,exit_Num:1,name:"萬芳社區")
Station.create(linecolor:"BR",number: 4,x_Pos:24.9994,y_Pos:121.5582,isCross:false,exit_Num:1,name:"萬芳醫院")
Station.create(linecolor:"BR",number: 5,x_Pos:25.0055,y_Pos:121.5571,isCross:false,exit_Num:1,name:"辛亥")
Station.create(linecolor:"BR",number: 6,x_Pos:25.0185,y_Pos:121.5588,isCross:false,exit_Num:1,name:"麟光")
Station.create(linecolor:"BR",number: 7,x_Pos:25.0238,y_Pos:121.5531,isCross:false,exit_Num:1,name:"六張犁")
Station.create(linecolor:"BR",number: 8,x_Pos:25.0261,y_Pos:121.5434,isCross:false,exit_Num:1,name:"科技大樓")
Station.create(linecolor:"BR",number: 9,x_Pos:25.0329,y_Pos:121.5436,isCross:true ,exit_Num:6,name:"大安")
Station.create(linecolor:"BR",number:10,x_Pos:25.0416,y_Pos:121.5438,isCross:true ,exit_Num:5,name:"忠孝復興")
Station.create(linecolor:"BR",number:11,x_Pos:25.0523,y_Pos:121.5440,isCross:true ,exit_Num:8,name:"南京復興")
Station.create(linecolor:"BR",number:12,x_Pos:25.0608,y_Pos:121.5442,isCross:false,exit_Num:1,name:"中山國中")
Station.create(linecolor:"BR",number:13,x_Pos:25.0630,y_Pos:121.5520,isCross:false,exit_Num:3,name:"松山機場")
Station.create(linecolor:"BR",number:14,x_Pos:25.0795,y_Pos:121.5469,isCross:false,exit_Num:3,name:"大直")
Station.create(linecolor:"BR",number:15,x_Pos:25.0849,y_Pos:121.5556,isCross:false,exit_Num:3,name:"劍南路")
Station.create(linecolor:"BR",number:16,x_Pos:25.0821,y_Pos:121.5672,isCross:false,exit_Num:2,name:"西湖")
Station.create(linecolor:"BR",number:17,x_Pos:25.0800,y_Pos:121.5751,isCross:false,exit_Num:2,name:"港墘")
Station.create(linecolor:"BR",number:18,x_Pos:25.0785,y_Pos:121.5848,isCross:false,exit_Num:2,name:"文德")
Station.create(linecolor:"BR",number:19,x_Pos:25.0837,y_Pos:121.5944,isCross:false,exit_Num:2,name:"內湖")
Station.create(linecolor:"BR",number:20,x_Pos:25.0838,y_Pos:121.6021,isCross:false,exit_Num:2,name:"大湖公園")
Station.create(linecolor:"BR",number:21,x_Pos:25.0727,y_Pos:121.6072,isCross:false,exit_Num:2,name:"葫洲")
Station.create(linecolor:"BR",number:22,x_Pos:25.0671,y_Pos:121.6114,isCross:false,exit_Num:3,name:"東湖")
Station.create(linecolor:"BR",number:23,x_Pos:25.0599,y_Pos:121.6160,isCross:false,exit_Num:2,name:"南港軟體園區")
Station.create(linecolor:"BR",number:24,x_Pos:25.0553,y_Pos:121.6175,isCross:true ,exit_Num:7,name:"南港展覽館")

p "R line"
Station.create(linecolor: "R",number: 2,x_Pos:25.0328,y_Pos:121.5696,isCross:false,exit_Num:3,name:"象山")
Station.create(linecolor: "R",number: 3,x_Pos:25.0331,y_Pos:121.5633,isCross:false,exit_Num:5,name:"台北101/世貿")
Station.create(linecolor: "R",number: 4,x_Pos:25.0333,y_Pos:121.5535,isCross:false,exit_Num:5,name:"信義安和")
Station.create(linecolor: "R",number: 6,x_Pos:25.0334,y_Pos:121.5349,isCross:false,exit_Num:6,name:"大安森林公園")
Station.create(linecolor: "R",number: 7,x_Pos:25.0338,y_Pos:121.5287,isCross:true ,exit_Num:8,name:"東門")
Station.create(linecolor: "R",number: 8,x_Pos:25.0327,y_Pos:121.5183,isCross:true ,exit_Num:7,name:"中正紀念堂")
Station.create(linecolor: "R",number: 9,x_Pos:25.0413,y_Pos:121.5160,isCross:false,exit_Num:4,name:"台大醫院")
Station.create(linecolor: "R",number:10,x_Pos:25.0463,y_Pos:121.5175,isCross:true ,exit_Num:8,name:"台北車站")
Station.create(linecolor: "R",number:11,x_Pos:25.0527,y_Pos:121.5204,isCross:true ,exit_Num:6,name:"中山")
Station.create(linecolor: "R",number:12,x_Pos:25.0578,y_Pos:121.5206,isCross:false,exit_Num:2,name:"雙連")
Station.create(linecolor: "R",number:13,x_Pos:25.0629,y_Pos:121.5193,isCross:true ,exit_Num:10,name:"民權西路")
Station.create(linecolor: "R",number:14,x_Pos:25.0714,y_Pos:121.5201,isCross:false,exit_Num:2,name:"圓山")
Station.create(linecolor: "R",number:15,x_Pos:25.0849,y_Pos:121.5251,isCross:false,exit_Num:3,name:"劍潭")
Station.create(linecolor: "R",number:16,x_Pos:25.0935,y_Pos:121.5262,isCross:false,exit_Num:2,name:"士林")
Station.create(linecolor: "R",number:17,x_Pos:25.1031,y_Pos:121.5225,isCross:false,exit_Num:2,name:"芝山")
Station.create(linecolor: "R",number:18,x_Pos:25.1097,y_Pos:121.5188,isCross:false,exit_Num:3,name:"明德")
Station.create(linecolor: "R",number:19,x_Pos:25.1145,y_Pos:121.5156,isCross:false,exit_Num:2,name:"石牌")
Station.create(linecolor: "R",number:20,x_Pos:25.1209,y_Pos:121.5063,isCross:false,exit_Num:2,name:"唭哩岸")
Station.create(linecolor: "R",number:21,x_Pos:25.1255,y_Pos:121.5011,isCross:false,exit_Num:3,name:"奇岩")
Station.create(linecolor: "R",number:22,x_Pos:25.1318,y_Pos:121.4986,isCross:true ,exit_Num:2,name:"北投")
Station.create(linecolor: "R",number:23,x_Pos:25.1375,y_Pos:121.4854,isCross:false,exit_Num:2,name:"復興崗")
Station.create(linecolor: "R",number:24,x_Pos:25.1310,y_Pos:121.4734,isCross:false,exit_Num:2,name:"忠義")
Station.create(linecolor: "R",number:25,x_Pos:25.1256,y_Pos:121.4671,isCross:false,exit_Num:2,name:"關渡")
Station.create(linecolor: "R",number:26,x_Pos:25.1369,y_Pos:121.4595,isCross:false,exit_Num:2,name:"竹圍")
Station.create(linecolor: "R",number:27,x_Pos:25.1540,y_Pos:121.4589,isCross:false,exit_Num:2,name:"紅樹林")
Station.create(linecolor: "R",number:28,x_Pos:25.1678,y_Pos:121.4456,isCross:false,exit_Num:3,name:"淡水")

p "G line"
Station.create(linecolor: "G",number: 1,x_Pos:24.9579,y_Pos:121.5376,isCross:false,exit_Num:1,name:"新店")
Station.create(linecolor: "G",number: 2,x_Pos:24.9674,y_Pos:121.5413,isCross:false,exit_Num:2,name:"新店區公所")
Station.create(linecolor: "G",number: 3,x_Pos:24.9752,y_Pos:121.5429,isCross:true ,exit_Num:2,name:"七張")
Station.create(linecolor: "G",number: 4,x_Pos:24.9829,y_Pos:121.5414,isCross:true ,exit_Num:5,name:"大坪林")
Station.create(linecolor: "G",number: 5,x_Pos:24.9921,y_Pos:121.5406,isCross:false,exit_Num:3,name:"景美")
Station.create(linecolor: "G",number: 6,x_Pos:25.0019,y_Pos:121.5391,isCross:false,exit_Num:4,name:"萬隆")
Station.create(linecolor: "G",number: 7,x_Pos:25.0149,y_Pos:121.5342,isCross:false,exit_Num:4,name:"公館")
Station.create(linecolor: "G",number: 8,x_Pos:25.0207,y_Pos:121.5282,isCross:false,exit_Num:5,name:"台電大樓")
Station.create(linecolor: "G",number: 9,x_Pos:25.0264,y_Pos:121.5229,isCross:true ,exit_Num:9,name:"古亭")
Station.create(linecolor: "G",number:11,x_Pos:25.0355,y_Pos:121.5109,isCross:false,exit_Num:4,name:"小南門")
Station.create(linecolor: "G",number:12,x_Pos:25.0421,y_Pos:121.5083,isCross:true ,exit_Num:6,name:"西門")
Station.create(linecolor: "G",number:13,x_Pos:25.0496,y_Pos:121.5102,isCross:false,exit_Num:3,name:"北門")
Station.create(linecolor: "G",number:15,x_Pos:25.0520,y_Pos:121.5331,isCross:true ,exit_Num:8,name:"松江南京")
Station.create(linecolor: "G",number:17,x_Pos:25.0518,y_Pos:121.5515,isCross:false,exit_Num:5,name:"台北小巨蛋")
Station.create(linecolor: "G",number:18,x_Pos:25.0517,y_Pos:121.5647,isCross:false,exit_Num:4,name:"南京三民")
Station.create(linecolor: "G",number:19,x_Pos:25.0501,y_Pos:121.5777,isCross:false,exit_Num:5,name:"松山")

p "O line"
Station.create(linecolor: "O",number: 1,x_Pos:24.9900,y_Pos:121.5092,isCross:false,exit_Num:4,name:"南勢角")
Station.create(linecolor: "O",number: 2,x_Pos:24.9939,y_Pos:121.5051,isCross:true ,exit_Num:1,name:"景安")
Station.create(linecolor: "O",number: 3,x_Pos:25.0029,y_Pos:121.5112,isCross:false,exit_Num:1,name:"永安市場")
Station.create(linecolor: "O",number: 4,x_Pos:25.0138,y_Pos:121.5155,isCross:false,exit_Num:2,name:"頂溪")
Station.create(linecolor: "O",number: 7,x_Pos:25.0424,y_Pos:121.5329,isCross:true ,exit_Num:7,name:"忠孝新生") 
Station.create(linecolor: "O",number: 9,x_Pos:25.0597,y_Pos:121.5332,isCross:false,exit_Num:4,name:"行天宮")
Station.create(linecolor: "O",number:10,x_Pos:25.0627,y_Pos:121.5264,isCross:false,exit_Num:4,name:"中山國小")
Station.create(linecolor: "O",number:12,x_Pos:25.0633,y_Pos:121.5127,isCross:false,exit_Num:3,name:"大橋頭")
Station.create(linecolor: "O",number:13,x_Pos:25.0633,y_Pos:121.5008,isCross:false,exit_Num:1,name:"台北橋")
Station.create(linecolor: "O",number:14,x_Pos:25.0603,y_Pos:121.4922,isCross:false,exit_Num:3,name:"菜寮")
Station.create(linecolor: "O",number:15,x_Pos:25.0558,y_Pos:121.4847,isCross:false,exit_Num:3,name:"三重")
Station.create(linecolor: "O",number:16,x_Pos:25.0465,y_Pos:121.4719,isCross:false,exit_Num:3,name:"先嗇宮")
Station.create(linecolor: "O",number:17,x_Pos:25.0397,y_Pos:121.4617,isCross:true ,exit_Num:4,name:"頭前庄")
Station.create(linecolor: "O",number:18,x_Pos:25.0361,y_Pos:121.4525,isCross:false,exit_Num:2,name:"新莊")
Station.create(linecolor: "O",number:19,x_Pos:25.0327,y_Pos:121.4355,isCross:false,exit_Num:4,name:"輔大")
Station.create(linecolor: "O",number:20,x_Pos:25.0289,y_Pos:121.4227,isCross:false,exit_Num:2,name:"丹鳳")
Station.create(linecolor: "O",number:21,x_Pos:25.0219,y_Pos:121.4113,isCross:false,exit_Num:3,name:"迴龍")
Station.create(linecolor: "O",number:50,x_Pos:25.0703,y_Pos:121.4969,isCross:false,exit_Num:1,name:"三重國小")
Station.create(linecolor: "O",number:51,x_Pos:25.0769,y_Pos:121.4863,isCross:false,exit_Num:2,name:"三和國中")
Station.create(linecolor: "O",number:52,x_Pos:25.0807,y_Pos:121.4797,isCross:false,exit_Num:2,name:"徐匯中學")
Station.create(linecolor: "O",number:53,x_Pos:25.0855,y_Pos:121.4734,isCross:false,exit_Num:2,name:"三民高中")
Station.create(linecolor: "O",number:54,x_Pos:25.0916,y_Pos:121.4645,isCross:false,exit_Num:3,name:"蘆洲")

p "BL line"
Station.create(linecolor:"BL",number: 1,x_Pos:24.9601,y_Pos:121.4205,isCross:false,exit_Num:4,name:"頂埔")
Station.create(linecolor:"BL",number: 2,x_Pos:24.9667,y_Pos:121.4361,isCross:false,exit_Num:4,name:"永寧")
Station.create(linecolor:"BL",number: 3,x_Pos:24.9731,y_Pos:121.4444,isCross:false,exit_Num:3,name:"土城")
Station.create(linecolor:"BL",number: 4,x_Pos:24.9853,y_Pos:121.4488,isCross:false,exit_Num:3,name:"海山")
Station.create(linecolor:"BL",number: 5,x_Pos:24.9980,y_Pos:121.4525,isCross:false,exit_Num:3,name:"亞東醫院")
Station.create(linecolor:"BL",number: 6,x_Pos:25.0086,y_Pos:121.4594,isCross:false,exit_Num:3,name:"府中")
Station.create(linecolor:"BL",number: 7,x_Pos:25.0136,y_Pos:121.4623,isCross:true ,exit_Num:5,name:"板橋")
Station.create(linecolor:"BL",number: 8,x_Pos:25.0237,y_Pos:121.4684,isCross:false,exit_Num:5,name:"新埔")
Station.create(linecolor:"BL",number: 9,x_Pos:25.0300,y_Pos:121.4724,isCross:false,exit_Num:6,name:"江子翠")
Station.create(linecolor:"BL",number:10,x_Pos:25.0353,y_Pos:121.4998,isCross:false,exit_Num:3,name:"龍山寺")
Station.create(linecolor:"BL",number:13,x_Pos:25.0448,y_Pos:121.5232,isCross:false,exit_Num:6,name:"善導寺")
Station.create(linecolor:"BL",number:16,x_Pos:25.0415,y_Pos:121.5511,isCross:false,exit_Num:8,name:"忠孝敦化")
Station.create(linecolor:"BL",number:17,x_Pos:25.0413,y_Pos:121.5578,isCross:false,exit_Num:5,name:"國父紀念館")
Station.create(linecolor:"BL",number:18,x_Pos:25.0412,y_Pos:121.5652,isCross:false,exit_Num:4,name:"市政府")
Station.create(linecolor:"BL",number:19,x_Pos:25.0409,y_Pos:121.5763,isCross:false,exit_Num:5,name:"永春")
Station.create(linecolor:"BL",number:20,x_Pos:25.0451,y_Pos:121.5825,isCross:false,exit_Num:4,name:"後山埤")
Station.create(linecolor:"BL",number:21,x_Pos:25.0505,y_Pos:121.5933,isCross:false,exit_Num:4,name:"昆陽")
Station.create(linecolor:"BL",number:22,x_Pos:25.0521,y_Pos:121.6067,isCross:false,exit_Num:2,name:"南港")

p "Y line"
Station.create(linecolor: "Y",number: 8,x_Pos:24.9829,y_Pos:121.5340,isCross:false,exit_Num:1,name:"十四張")
Station.create(linecolor: "Y",number: 9,x_Pos:24.9905,y_Pos:121.5251,isCross:false,exit_Num:2,name:"秀朗橋")
Station.create(linecolor: "Y",number:10,x_Pos:24.9920,y_Pos:121.5166,isCross:false,exit_Num:1,name:"景平")
Station.create(linecolor: "Y",number:12,x_Pos:25.0020,y_Pos:121.4961,isCross:false,exit_Num:1,name:"中和")
Station.create(linecolor: "Y",number:13,x_Pos:25.0044,y_Pos:121.4905,isCross:false,exit_Num:1,name:"橋和")
Station.create(linecolor: "Y",number:14,x_Pos:25.0084,y_Pos:121.4842,isCross:false,exit_Num:1,name:"中原")
Station.create(linecolor: "Y",number:15,x_Pos:25.0145,y_Pos:121.4722,isCross:false,exit_Num:1,name:"板新")
Station.create(linecolor: "Y",number:17,x_Pos:25.0261,y_Pos:121.4668,isCross:false,exit_Num:1,name:"新埔民生")
Station.create(linecolor: "Y",number:19,x_Pos:25.0503,y_Pos:121.4602,isCross:false,exit_Num:2,name:"幸福")
Station.create(linecolor: "Y",number:20,x_Pos:25.0615,y_Pos:121.4599,isCross:false,exit_Num:1,name:"新北產業園區")

p "LR line"
Station.create(linecolor:"LR",number: 2,x_Pos:25.1369,y_Pos:121.5025,isCross:false,exit_Num:2,name:"新北投")

p "LG line"
Station.create(linecolor:"LG",number: 2,x_Pos:24.9719,y_Pos:121.5303,isCross:false,exit_Num:2,name:"小碧潭")


p "Connect cross station"
CrossStation.create(linecolor_1:"BR",number_1: 9,linecolor_2: "R",number_2: 5,name:"大安")
CrossStation.create(linecolor_1:"BR",number_1:10,linecolor_2:"BL",number_2:15,name:"忠孝復興")
CrossStation.create(linecolor_1:"BR",number_1:11,linecolor_2: "G",number_2:16,name:"南京復興")
CrossStation.create(linecolor_1:"BR",number_1:24,linecolor_2:"BL",number_2:23,name:"南港展覽館")

CrossStation.create(linecolor_1:"R",number_1: 7,linecolor_2: "O",number_2: 6,name:"東門")
CrossStation.create(linecolor_1:"R",number_1: 8,linecolor_2: "G",number_2:10,name:"中正紀念堂")
CrossStation.create(linecolor_1:"R",number_1:10,linecolor_2:"BL",number_2:12,name:"台北車站")
CrossStation.create(linecolor_1:"R",number_1:11,linecolor_2: "G",number_2:14,name:"中山")
CrossStation.create(linecolor_1:"R",number_1:13,linecolor_2: "O",number_2:11,name:"民權西路")
CrossStation.create(linecolor_1:"R",number_1:22,linecolor_2:"LR",number_2: 1,name:"北投")

CrossStation.create(linecolor_1:"G",number_1: 3,linecolor_2:"LG",number_2: 1,name:"七張")
CrossStation.create(linecolor_1:"G",number_1: 4,linecolor_2: "Y",number_2: 7,name:"大坪林")
CrossStation.create(linecolor_1:"G",number_1: 9,linecolor_2: "O",number_2: 5,name:"古亭")
CrossStation.create(linecolor_1:"G",number_1:12,linecolor_2:"BL",number_2:11,name:"西門")
CrossStation.create(linecolor_1:"G",number_1:15,linecolor_2: "O",number_2: 8,name:"松江南京")

CrossStation.create(linecolor_1:"O",number_1: 2,linecolor_2: "Y",number_2:11,name:"景安")
CrossStation.create(linecolor_1:"O",number_1: 7,linecolor_2:"BL",number_2:14,name:"忠孝新生")
CrossStation.create(linecolor_1:"O",number_1:17,linecolor_2: "Y",number_2:18,name:"頭前庄")

CrossStation.create(linecolor_1:"BL",number_1:8,linecolor_2: "Y",number_2:16,name:"板橋")


p "Set time table"
p "From BR01 To BR24"
set_time_table(1,24,"BR",1000)
p "From R02 To R28"
set_time_table(2,28,"R",3000)
p "From G01 To G19"
set_time_table(1,19,"G",5000)
p "From O01 To O21"
set_time_table(1,21,"O",7000)
p "From O01 To O54"
a=Station.where(linecolor:"O")
time_="06:02"
no=7002
while(time_<="23:02")
    i=1
    each_time_=time_
    a.each do |temp|
        each_time_=time_add(each_time_,3)
        if i>=54
            break
        elsif i>12&&i<50
        elsif temp.number!=i
            s=CrossStation.find_by(linecolor_2:temp.linecolor,number_2:i)
            TimeTable.create(time:each_time_,line:"O",end:54,linecolor:s.linecolor_1,number:s.number_1,No:no)
            i=i+1
            redo
        else
            TimeTable.create(time:each_time_,line:"O",end:54,linecolor:"O",number:temp.number,No:no)
            i=i+1
        end
    end
    time_=time_add(time_,5)
    no=no+7
end

p "From BL01 To BL23"
set_time_table(1,23,"BL",8500)
p "From Y07 To Y20"
set_time_table(7,20,"Y",8505)
p "From LG01 To LG02"
set_time_table(1,2,"LG",5005)
p "From LR01 To LR02"
set_time_table(1,2,"LR",3005)

p "Set time table"
p "From BR24 To BR01"
set_time_table_inverse(24,1,"BR",1001)
p "From R28 To R02"
set_time_table_inverse(28,2,"R",3001)
p "From G19 To G01"
set_time_table_inverse(19,1,"G",5001)
p "From O21 To O01"
set_time_table_inverse(21,1,"O",7001)
p "From O54 To O01"
a=Station.where(linecolor:"O").order(number: :desc)
time_="06:00"
no=7003
while(time_<="23:00")
    i=54
    each_time_=time_
    a.each do |temp|
        each_time_=time_add(each_time_,3)
        if i<=1
            break
        elsif i>12&&i<50
        elsif temp.number!=i
            s=CrossStation.find_by(linecolor_2:temp.linecolor,number_2:i)
            TimeTable.create(time:each_time_,line:"O",end:1,linecolor:s.linecolor_1,number:s.number_1,No:no)
            i=i-1
            redo
        else
            TimeTable.create(time:each_time_,line:"O",end:1,linecolor:"O",number:temp.number,No:no)
            i=i-1
        end
    end
    time_=time_add(time_,5)
    no=no+7
end

p "From BL23 To BL01"
set_time_table_inverse(23,01,"BL",8501)
p "From Y20 To Y07"
set_time_table_inverse(20,7,"Y",8506)
p "From LG02 To LG01"
set_time_table_inverse(2,1,"LG",5006)
p "From LR02 To LR01"
set_time_table_inverse(2,1,"LR",3006)


p "Set ticket price"
Ticket.create(upper_bound: 5.0,lower_bound: 0.0,price:20)
Ticket.create(upper_bound: 8.0,lower_bound: 5.0,price:25)
Ticket.create(upper_bound:11.0,lower_bound: 8.0,price:30)
Ticket.create(upper_bound:14.0,lower_bound:11.0,price:35)
Ticket.create(upper_bound:17.0,lower_bound:14.0,price:40)
Ticket.create(upper_bound:20.0,lower_bound:17.0,price:45)
Ticket.create(upper_bound:23.0,lower_bound:20.0,price:50)
Ticket.create(upper_bound:27.0,lower_bound:23.0,price:55)
Ticket.create(upper_bound:31.0,lower_bound:27.0,price:60)
Ticket.create(upper_bound:1000.0,lower_bound:31.0,price:65)



p "DB Seeded"

