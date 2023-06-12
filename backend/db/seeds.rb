# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#

def set_time_table(start_count,end_count,line,no)
    a=StationNo.where(linecolor:line)
    time_="06:00"
    while(time_<="23:00")
        i=start_count
        each_time_=time_
        a.each do |temp|
            each_time_=time_add(each_time_,3)
            if i>=end_count
                break
            else
                TimeTable.create(time:each_time_,line:line,end:end_count,station_id:temp.station_id,No:no)
                i=i+1
            end
        end
        time_=time_add(time_,5)
        no=no+7
    end
end


def set_time_table_inverse(start_count,end_count,line,no)
    a=StationNo.where(linecolor:line).order(number: :desc)
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
            else
                TimeTable.create(time:each_time_,line:line,end:end_count,station_id:temp.station_id,No:no)
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
StationNo.destroy_all
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
Station.create(x_Pos:24.9982,y_Pos:121.5793,exit_Num:2,name:"動物園")
Station.create(x_Pos:24.9982,y_Pos:121.5731,exit_Num:1,name:"木柵")
Station.create(x_Pos:24.9986,y_Pos:121.5681,exit_Num:1,name:"萬芳社區")
Station.create(x_Pos:24.9994,y_Pos:121.5582,exit_Num:1,name:"萬芳醫院")
Station.create(x_Pos:25.0055,y_Pos:121.5571,exit_Num:1,name:"辛亥")
Station.create(x_Pos:25.0185,y_Pos:121.5588,exit_Num:1,name:"麟光")
Station.create(x_Pos:25.0238,y_Pos:121.5531,exit_Num:1,name:"六張犁")
Station.create(x_Pos:25.0261,y_Pos:121.5434,exit_Num:1,name:"科技大樓")
Station.create(x_Pos:25.0329,y_Pos:121.5436,exit_Num:6,name:"大安")
Station.create(x_Pos:25.0416,y_Pos:121.5438,exit_Num:5,name:"忠孝復興")
Station.create(x_Pos:25.0523,y_Pos:121.5440,exit_Num:8,name:"南京復興")
Station.create(x_Pos:25.0608,y_Pos:121.5442,exit_Num:1,name:"中山國中")
Station.create(x_Pos:25.0630,y_Pos:121.5520,exit_Num:3,name:"松山機場")
Station.create(x_Pos:25.0795,y_Pos:121.5469,exit_Num:3,name:"大直")
Station.create(x_Pos:25.0849,y_Pos:121.5556,exit_Num:3,name:"劍南路")
Station.create(x_Pos:25.0821,y_Pos:121.5672,exit_Num:2,name:"西湖")
Station.create(x_Pos:25.0800,y_Pos:121.5751,exit_Num:2,name:"港墘")
Station.create(x_Pos:25.0785,y_Pos:121.5848,exit_Num:2,name:"文德")
Station.create(x_Pos:25.0837,y_Pos:121.5944,exit_Num:2,name:"內湖")
Station.create(x_Pos:25.0838,y_Pos:121.6021,exit_Num:2,name:"大湖公園")
Station.create(x_Pos:25.0727,y_Pos:121.6072,exit_Num:2,name:"葫洲")
Station.create(x_Pos:25.0671,y_Pos:121.6114,exit_Num:3,name:"東湖")
Station.create(x_Pos:25.0599,y_Pos:121.6160,exit_Num:2,name:"南港軟體園區")
Station.create(x_Pos:25.0553,y_Pos:121.6175,exit_Num:7,name:"南港展覽館")

Station.create(x_Pos:25.0328,y_Pos:121.5696,exit_Num:3,name:"象山")
Station.create(x_Pos:25.0331,y_Pos:121.5633,exit_Num:5,name:"台北101/世貿")
Station.create(x_Pos:25.0333,y_Pos:121.5535,exit_Num:5,name:"信義安和")
Station.create(x_Pos:25.0334,y_Pos:121.5349,exit_Num:6,name:"大安森林公園")
Station.create(x_Pos:25.0338,y_Pos:121.5287,exit_Num:8,name:"東門")
Station.create(x_Pos:25.0327,y_Pos:121.5183,exit_Num:7,name:"中正紀念堂")
Station.create(x_Pos:25.0413,y_Pos:121.5160,exit_Num:4,name:"台大醫院")
Station.create(x_Pos:25.0463,y_Pos:121.5175,exit_Num:8,name:"台北車站")
Station.create(x_Pos:25.0527,y_Pos:121.5204,exit_Num:6,name:"中山")
Station.create(x_Pos:25.0578,y_Pos:121.5206,exit_Num:2,name:"雙連")
Station.create(x_Pos:25.0629,y_Pos:121.5193,exit_Num:10,name:"民權西路")
Station.create(x_Pos:25.0714,y_Pos:121.5201,exit_Num:2,name:"圓山")
Station.create(x_Pos:25.0849,y_Pos:121.5251,exit_Num:3,name:"劍潭")
Station.create(x_Pos:25.0935,y_Pos:121.5262,exit_Num:2,name:"士林")
Station.create(x_Pos:25.1031,y_Pos:121.5225,exit_Num:2,name:"芝山")
Station.create(x_Pos:25.1097,y_Pos:121.5188,exit_Num:3,name:"明德")
Station.create(x_Pos:25.1145,y_Pos:121.5156,exit_Num:2,name:"石牌")
Station.create(x_Pos:25.1209,y_Pos:121.5063,exit_Num:2,name:"唭哩岸")
Station.create(x_Pos:25.1255,y_Pos:121.5011,exit_Num:3,name:"奇岩")
Station.create(x_Pos:25.1318,y_Pos:121.4986,exit_Num:2,name:"北投")
Station.create(x_Pos:25.1375,y_Pos:121.4854,exit_Num:2,name:"復興崗")
Station.create(x_Pos:25.1310,y_Pos:121.4734,exit_Num:2,name:"忠義")
Station.create(x_Pos:25.1256,y_Pos:121.4671,exit_Num:2,name:"關渡")
Station.create(x_Pos:25.1369,y_Pos:121.4595,exit_Num:2,name:"竹圍")
Station.create(x_Pos:25.1540,y_Pos:121.4589,exit_Num:2,name:"紅樹林")
Station.create(x_Pos:25.1678,y_Pos:121.4456,exit_Num:3,name:"淡水")

Station.create(x_Pos:24.9579,y_Pos:121.5376,exit_Num:1,name:"新店")
Station.create(x_Pos:24.9674,y_Pos:121.5413,exit_Num:2,name:"新店區公所")
Station.create(x_Pos:24.9752,y_Pos:121.5429,exit_Num:2,name:"七張")
Station.create(x_Pos:24.9829,y_Pos:121.5414,exit_Num:5,name:"大坪林")
Station.create(x_Pos:24.9921,y_Pos:121.5406,exit_Num:3,name:"景美")
Station.create(x_Pos:25.0019,y_Pos:121.5391,exit_Num:4,name:"萬隆")
Station.create(x_Pos:25.0149,y_Pos:121.5342,exit_Num:4,name:"公館")
Station.create(x_Pos:25.0207,y_Pos:121.5282,exit_Num:5,name:"台電大樓")
Station.create(x_Pos:25.0264,y_Pos:121.5229,exit_Num:9,name:"古亭")
Station.create(x_Pos:25.0355,y_Pos:121.5109,exit_Num:4,name:"小南門")
Station.create(x_Pos:25.0421,y_Pos:121.5083,exit_Num:6,name:"西門")
Station.create(x_Pos:25.0496,y_Pos:121.5102,exit_Num:3,name:"北門")
Station.create(x_Pos:25.0520,y_Pos:121.5331,exit_Num:8,name:"松江南京")
Station.create(x_Pos:25.0518,y_Pos:121.5515,exit_Num:5,name:"台北小巨蛋")
Station.create(x_Pos:25.0517,y_Pos:121.5647,exit_Num:4,name:"南京三民")
Station.create(x_Pos:25.0501,y_Pos:121.5777,exit_Num:5,name:"松山")

Station.create(x_Pos:24.9900,y_Pos:121.5092,exit_Num:4,name:"南勢角")
Station.create(x_Pos:24.9939,y_Pos:121.5051,exit_Num:1,name:"景安")
Station.create(x_Pos:25.0029,y_Pos:121.5112,exit_Num:1,name:"永安市場")
Station.create(x_Pos:25.0138,y_Pos:121.5155,exit_Num:2,name:"頂溪")
Station.create(x_Pos:25.0424,y_Pos:121.5329,exit_Num:7,name:"忠孝新生") 
Station.create(x_Pos:25.0597,y_Pos:121.5332,exit_Num:4,name:"行天宮")
Station.create(x_Pos:25.0627,y_Pos:121.5264,exit_Num:4,name:"中山國小")
Station.create(x_Pos:25.0633,y_Pos:121.5127,exit_Num:3,name:"大橋頭")
Station.create(x_Pos:25.0633,y_Pos:121.5008,exit_Num:1,name:"台北橋")
Station.create(x_Pos:25.0603,y_Pos:121.4922,exit_Num:3,name:"菜寮")
Station.create(x_Pos:25.0558,y_Pos:121.4847,exit_Num:3,name:"三重")
Station.create(x_Pos:25.0465,y_Pos:121.4719,exit_Num:3,name:"先嗇宮")
Station.create(x_Pos:25.0397,y_Pos:121.4617,exit_Num:4,name:"頭前庄")
Station.create(x_Pos:25.0361,y_Pos:121.4525,exit_Num:2,name:"新莊")
Station.create(x_Pos:25.0327,y_Pos:121.4355,exit_Num:4,name:"輔大")
Station.create(x_Pos:25.0289,y_Pos:121.4227,exit_Num:2,name:"丹鳳")
Station.create(x_Pos:25.0219,y_Pos:121.4113,exit_Num:3,name:"迴龍")
Station.create(x_Pos:25.0703,y_Pos:121.4969,exit_Num:1,name:"三重國小")
Station.create(x_Pos:25.0769,y_Pos:121.4863,exit_Num:2,name:"三和國中")
Station.create(x_Pos:25.0807,y_Pos:121.4797,exit_Num:2,name:"徐匯中學")
Station.create(x_Pos:25.0855,y_Pos:121.4734,exit_Num:2,name:"三民高中")
Station.create(x_Pos:25.0916,y_Pos:121.4645,exit_Num:3,name:"蘆洲")

Station.create(x_Pos:24.9601,y_Pos:121.4205,exit_Num:4,name:"頂埔")
Station.create(x_Pos:24.9667,y_Pos:121.4361,exit_Num:4,name:"永寧")
Station.create(x_Pos:24.9731,y_Pos:121.4444,exit_Num:3,name:"土城")
Station.create(x_Pos:24.9853,y_Pos:121.4488,exit_Num:3,name:"海山")
Station.create(x_Pos:24.9980,y_Pos:121.4525,exit_Num:3,name:"亞東醫院")
Station.create(x_Pos:25.0086,y_Pos:121.4594,exit_Num:3,name:"府中")
Station.create(x_Pos:25.0136,y_Pos:121.4623,exit_Num:5,name:"板橋")
Station.create(x_Pos:25.0237,y_Pos:121.4684,exit_Num:5,name:"新埔")
Station.create(x_Pos:25.0300,y_Pos:121.4724,exit_Num:6,name:"江子翠")
Station.create(x_Pos:25.0353,y_Pos:121.4998,exit_Num:3,name:"龍山寺")
Station.create(x_Pos:25.0448,y_Pos:121.5232,exit_Num:6,name:"善導寺")
Station.create(x_Pos:25.0415,y_Pos:121.5511,exit_Num:8,name:"忠孝敦化")
Station.create(x_Pos:25.0413,y_Pos:121.5578,exit_Num:5,name:"國父紀念館")
Station.create(x_Pos:25.0412,y_Pos:121.5652,exit_Num:4,name:"市政府")
Station.create(x_Pos:25.0409,y_Pos:121.5763,exit_Num:5,name:"永春")
Station.create(x_Pos:25.0451,y_Pos:121.5825,exit_Num:4,name:"後山埤")
Station.create(x_Pos:25.0505,y_Pos:121.5933,exit_Num:4,name:"昆陽")
Station.create(x_Pos:25.0521,y_Pos:121.6067,exit_Num:2,name:"南港")

Station.create(x_Pos:24.9829,y_Pos:121.5340,exit_Num:1,name:"十四張")
Station.create(x_Pos:24.9905,y_Pos:121.5251,exit_Num:2,name:"秀朗橋")
Station.create(x_Pos:24.9920,y_Pos:121.5166,exit_Num:1,name:"景平")
Station.create(x_Pos:25.0020,y_Pos:121.4961,exit_Num:1,name:"中和")
Station.create(x_Pos:25.0044,y_Pos:121.4905,exit_Num:1,name:"橋和")
Station.create(x_Pos:25.0084,y_Pos:121.4842,exit_Num:1,name:"中原")
Station.create(x_Pos:25.0145,y_Pos:121.4722,exit_Num:1,name:"板新")
Station.create(x_Pos:25.0261,y_Pos:121.4668,exit_Num:1,name:"新埔民生")
Station.create(x_Pos:25.0503,y_Pos:121.4602,exit_Num:2,name:"幸福")
Station.create(x_Pos:25.0615,y_Pos:121.4599,exit_Num:1,name:"新北產業園區")

Station.create(x_Pos:25.1369,y_Pos:121.5025,exit_Num:2,name:"新北投")

Station.create(x_Pos:24.9719,y_Pos:121.5303,exit_Num:2,name:"小碧潭")


p "Set Station No."
p "BR line"
StationNo.create(linecolor:"BR",number:1 ,station_id:1)
StationNo.create(linecolor:"BR",number:2 ,station_id:2)
StationNo.create(linecolor:"BR",number:3 ,station_id:3)
StationNo.create(linecolor:"BR",number:4 ,station_id:4)
StationNo.create(linecolor:"BR",number:5 ,station_id:5)
StationNo.create(linecolor:"BR",number:6 ,station_id:6)
StationNo.create(linecolor:"BR",number:7 ,station_id:7)
StationNo.create(linecolor:"BR",number:8 ,station_id:8)
StationNo.create(linecolor:"BR",number:9 ,station_id:9)
StationNo.create(linecolor:"BR",number:10,station_id:10)
StationNo.create(linecolor:"BR",number:11,station_id:11)
StationNo.create(linecolor:"BR",number:12,station_id:12)
StationNo.create(linecolor:"BR",number:13,station_id:13)
StationNo.create(linecolor:"BR",number:14,station_id:14)
StationNo.create(linecolor:"BR",number:15,station_id:15)
StationNo.create(linecolor:"BR",number:16,station_id:16)
StationNo.create(linecolor:"BR",number:17,station_id:17)
StationNo.create(linecolor:"BR",number:18,station_id:18)
StationNo.create(linecolor:"BR",number:19,station_id:19)
StationNo.create(linecolor:"BR",number:20,station_id:20)
StationNo.create(linecolor:"BR",number:21,station_id:21)
StationNo.create(linecolor:"BR",number:22,station_id:22)
StationNo.create(linecolor:"BR",number:23,station_id:23)
StationNo.create(linecolor:"BR",number:24,station_id:24)

p "R line"
StationNo.create(linecolor:"R",number:2	,station_id:25)
StationNo.create(linecolor:"R",number:3	,station_id:26)
StationNo.create(linecolor:"R",number:4	,station_id:27)
StationNo.create(linecolor:"R",number:5	,station_id:9)
StationNo.create(linecolor:"R",number:6	,station_id:28)
StationNo.create(linecolor:"R",number:7	,station_id:29)
StationNo.create(linecolor:"R",number:8	,station_id:30)
StationNo.create(linecolor:"R",number:9	,station_id:31)
StationNo.create(linecolor:"R",number:10,station_id:32)
StationNo.create(linecolor:"R",number:11,station_id:33)
StationNo.create(linecolor:"R",number:12,station_id:34)
StationNo.create(linecolor:"R",number:13,station_id:35)
StationNo.create(linecolor:"R",number:14,station_id:36)
StationNo.create(linecolor:"R",number:15,station_id:37)
StationNo.create(linecolor:"R",number:16,station_id:38)
StationNo.create(linecolor:"R",number:17,station_id:39)
StationNo.create(linecolor:"R",number:18,station_id:40)
StationNo.create(linecolor:"R",number:19,station_id:41)
StationNo.create(linecolor:"R",number:20,station_id:42)
StationNo.create(linecolor:"R",number:21,station_id:43)
StationNo.create(linecolor:"R",number:22,station_id:44)
StationNo.create(linecolor:"R",number:23,station_id:45)
StationNo.create(linecolor:"R",number:24,station_id:46)
StationNo.create(linecolor:"R",number:25,station_id:47)
StationNo.create(linecolor:"R",number:26,station_id:48)
StationNo.create(linecolor:"R",number:27,station_id:49)
StationNo.create(linecolor:"R",number:28,station_id:50)

p "G line"
StationNo.create(linecolor:"G",number:1	,station_id:51)
StationNo.create(linecolor:"G",number:2	,station_id:52)
StationNo.create(linecolor:"G",number:3	,station_id:53)
StationNo.create(linecolor:"G",number:4	,station_id:54)
StationNo.create(linecolor:"G",number:5	,station_id:55)
StationNo.create(linecolor:"G",number:6	,station_id:56)
StationNo.create(linecolor:"G",number:7	,station_id:57)
StationNo.create(linecolor:"G",number:8	,station_id:58)
StationNo.create(linecolor:"G",number:9	,station_id:59)
StationNo.create(linecolor:"G",number:10,station_id:30)
StationNo.create(linecolor:"G",number:11,station_id:60)
StationNo.create(linecolor:"G",number:12,station_id:61)
StationNo.create(linecolor:"G",number:13,station_id:62)
StationNo.create(linecolor:"G",number:14,station_id:33)
StationNo.create(linecolor:"G",number:15,station_id:63)
StationNo.create(linecolor:"G",number:16,station_id:11)
StationNo.create(linecolor:"G",number:17,station_id:64)
StationNo.create(linecolor:"G",number:18,station_id:65)
StationNo.create(linecolor:"G",number:19,station_id:66)

p "O line"
StationNo.create(linecolor:"O",number:1	,station_id:67)
StationNo.create(linecolor:"O",number:2	,station_id:68)
StationNo.create(linecolor:"O",number:3	,station_id:69)
StationNo.create(linecolor:"O",number:4	,station_id:70)
StationNo.create(linecolor:"O",number:5	,station_id:59)
StationNo.create(linecolor:"O",number:6	,station_id:29)
StationNo.create(linecolor:"O",number:7	,station_id:71)
StationNo.create(linecolor:"O",number:8	,station_id:63)
StationNo.create(linecolor:"O",number:9	,station_id:72)
StationNo.create(linecolor:"O",number:10,station_id:73)
StationNo.create(linecolor:"O",number:11,station_id:35)
StationNo.create(linecolor:"O",number:12,station_id:74)
StationNo.create(linecolor:"O",number:13,station_id:75)
StationNo.create(linecolor:"O",number:14,station_id:76)
StationNo.create(linecolor:"O",number:15,station_id:77)
StationNo.create(linecolor:"O",number:16,station_id:78)
StationNo.create(linecolor:"O",number:17,station_id:79)
StationNo.create(linecolor:"O",number:18,station_id:80)
StationNo.create(linecolor:"O",number:19,station_id:81)
StationNo.create(linecolor:"O",number:20,station_id:82)
StationNo.create(linecolor:"O",number:21,station_id:83)
StationNo.create(linecolor:"O",number:50,station_id:84)
StationNo.create(linecolor:"O",number:51,station_id:85)
StationNo.create(linecolor:"O",number:52,station_id:86)
StationNo.create(linecolor:"O",number:53,station_id:87)
StationNo.create(linecolor:"O",number:54,station_id:88)

p "BL line"
StationNo.create(linecolor:"BL",number:1 ,station_id:89)
StationNo.create(linecolor:"BL",number:2 ,station_id:90)
StationNo.create(linecolor:"BL",number:3 ,station_id:91)
StationNo.create(linecolor:"BL",number:4 ,station_id:92)
StationNo.create(linecolor:"BL",number:5 ,station_id:93)
StationNo.create(linecolor:"BL",number:6 ,station_id:94)
StationNo.create(linecolor:"BL",number:7 ,station_id:95)
StationNo.create(linecolor:"BL",number:8 ,station_id:96)
StationNo.create(linecolor:"BL",number:9 ,station_id:97)
StationNo.create(linecolor:"BL",number:10,station_id:98)
StationNo.create(linecolor:"BL",number:11,station_id:61)
StationNo.create(linecolor:"BL",number:12,station_id:32)
StationNo.create(linecolor:"BL",number:13,station_id:99)
StationNo.create(linecolor:"BL",number:14,station_id:71)
StationNo.create(linecolor:"BL",number:15,station_id:10)
StationNo.create(linecolor:"BL",number:16,station_id:100)
StationNo.create(linecolor:"BL",number:17,station_id:101)
StationNo.create(linecolor:"BL",number:18,station_id:102)
StationNo.create(linecolor:"BL",number:19,station_id:103)
StationNo.create(linecolor:"BL",number:20,station_id:104)
StationNo.create(linecolor:"BL",number:21,station_id:105)
StationNo.create(linecolor:"BL",number:22,station_id:106)
StationNo.create(linecolor:"BL",number:23,station_id:24)

p "Y line"
StationNo.create(linecolor:"Y",number:7	,station_id:54)
StationNo.create(linecolor:"Y",number:8	,station_id:107)
StationNo.create(linecolor:"Y",number:9	,station_id:108)
StationNo.create(linecolor:"Y",number:10,station_id:109)
StationNo.create(linecolor:"Y",number:11,station_id:68)
StationNo.create(linecolor:"Y",number:12,station_id:110)
StationNo.create(linecolor:"Y",number:13,station_id:111)
StationNo.create(linecolor:"Y",number:14,station_id:112)
StationNo.create(linecolor:"Y",number:15,station_id:113)
StationNo.create(linecolor:"Y",number:16,station_id:95)
StationNo.create(linecolor:"Y",number:17,station_id:114)
StationNo.create(linecolor:"Y",number:18,station_id:115)
StationNo.create(linecolor:"Y",number:19,station_id:79)
StationNo.create(linecolor:"Y",number:20,station_id:116)

p "LR line"
StationNo.create(linecolor:"LR",number:1,station_id:44)
StationNo.create(linecolor:"LR",number:2,station_id:117)

p "LG line"
StationNo.create(linecolor:"LG",number:1,station_id:53)
StationNo.create(linecolor:"LG",number:2,station_id:118)

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
a=StationNo.where(linecolor:"O")
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
        else
            TimeTable.create(time:each_time_,line:"O",end:54,station_id:temp.station_id,No:no)
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
a=StationNo.where(linecolor:"O").order(number: :desc)
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
        else
            TimeTable.create(time:each_time_,line:"O",end:1,station_id:temp.station_id,No:no)
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

