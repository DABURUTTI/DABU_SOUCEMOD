require 'discordrb'
require 'steam-condenser'
require 'rmagick'
require 'json'
require 'open-uri'
require 'rest-client'
require 'net/http'
require 'uri'
require 'rmagick'
require 'mini_magick'

bot = Discordrb::Commands::CommandBot.new token: 'MzkwNDIyNTgyMzIwNjkzMjQ5.DRJ49g.sr9_Ag7XBp2ea2cgLTgotTkyGC8', client_id: 390422582320693249, prefix: '!'

@tw = ""

bot.ready(){|event,game|
	bot.game = "Japari Games"
	nil
	}

@num = 0
def Get_Server_Status(ip,port)
    begin
    	server = GoldSrcServer.new(ip, port.to_i)
    server.init
    serverdata = "#{server}"
    
    servername = serverdata.match(/server_name: "(.+)"/)
    maxplayer = serverdata.match(/max_players:\s(.+)/)
    players = serverdata.match(/number_of_players:\s(.+)/)
    bot = serverdata.match(/number_of_bots:\s(.+)/)
    
    servernamemeta = servername[1]

   

	trueplayer = players[1].to_i - bot[1].to_i
	
    	if trueplayer.to_i > 1 then
		
			@tw = "#{@tw}\n#{servernamemeta}:#{trueplayer}/#{maxplayer[1]}"
			@num = @num + 1
    	    return
        end
    end
    rescue => exception
        #puts exception
    end
    


def work()
	@tw = ""
	@num = 0
	serverip = ""
	File.open('/home/daburutti/serverlist.txt', 'r:utf-8') do |f|
	    f.each_line do |line|
	        serverip = line.match(/(.+):/)
	        serverport = line.match(/:(.+)/)
	    Get_Server_Status(serverip[1],serverport[1])
	    end
	end

	if @num == 0 then
		@tw = "\n\n現在温め中の鯖はありません..."
	end
end


bot.command :osiete do |event|

	begin
		# 例外が起こるかも知れないコード
		work()
		event.send_message("和鯖のJoin状況です！！#{@tw}")
	
		puts ("#{DateTime.now} => User:#{event.user.name} ID:#{event.user.id} メッセージを送信しました[osiete]")

	rescue => error # 変数(例外オブジェクトの代入)
	
		event.send_message("#{error}")

	end

end

bot.command :help do |event|

	puts ("#{DateTime.now} => User:#{event.user.name} ID:#{event.user.id} メッセージを送信しました[help]")
	event.send_message("じゃあ、簡単に説明しますね...\n------------------------------------------\nコマンド   内容\n!help   この説明を表示します\n!osiete   フレンズサーバーのログイン情報を返します\n!debug   デバッグ用 生の情報を返します\nなおこのBOTはフレンズサーバーグルだけでなく、個人チャットにも反応します")

end
	
bot.command :debug do |event|

	puts ("#{DateTime.now} => User:#{event.user.name} ID:#{event.user.id} メッセージを送信しました[debug]")

	server =  SourceServer.new('122.210.136.164', 27015)
	server.init
	
	event.send_message("サーバー応答[OK] => 取得時間:#{DateTime.now}\nサーバーリスト[0]\n---------------サーバー基本情報---------------\n#{server}\n---------------プレイヤー情報---------------\n#{server.players}\n------------------------------")
	
	server =  SourceServer.new('122.210.136.164', 27010)
	server.init
	
	event.send_message("サーバー応答[OK] => 取得時間:#{DateTime.now}\nサーバーリスト[1]\n---------------サーバー基本情報---------------\n#{server}\n---------------プレイヤー情報---------------\n#{server.players}\n------------------------------")

end

def start_typing(token, channel_id)
    Discordrb::API.request(
      :channels_cid_typing,
      channel_id,
      :post,
      "#{Discordrb::API.api_base}/channels/#{channel_id}/typing",
      nil,
      Authorization: token
    )
end

bot.command :dareiru do |event|
	start_typing('MzkwNDIyNTgyMzIwNjkzMjQ5.DRJ49g.sr9_Ag7XBp2ea2cgLTgotTkyGC8', event.channel.id)
	puts ("#{DateTime.now} => User:#{event.user.name} ID:#{event.user.id} メッセージを送信しました[dareiru]")

	begin
		# 例外が起こるかも知れないコード
		server =  SourceServer.new('122.210.136.164', 27015)
		server.init

		str2 = ""
		str5 = ""
		str = "#{server.players} "

		num = 0
		# 例外が起こるかも知れないコード
		server2 =  SourceServer.new('122.210.136.164', 27010)
		server2.init

		str4 = "#{server2.players} "
		num2 = 0

		while str.index("@id=") do

			str = str.slice(str.index("@id=")+4, str.length - str.index("@id=") - 4)
			num = num + 1
			
		end

		while str4.index("@id=") do

			str4 = str4.slice(str4.index("@id=")+4, str4.length - str4.index("@id=") - 4)
			num2 = num2 + 1
			
		end
		
		work()

		if num == 0 and num2== 0 then

			event.send_message("フレンズサーバーに接続しているユーザーはいません...\n------------------------------------------\nその他、TF2日本サーバーのようす！#{@tw}\n------------------------------------------\nフレンズサーバーに接続! steam://connect/122.210.136.164:27015\nフレンズサーバーMGEに接続! steam://connect/122.210.136.164:27010")
			break

		else

			
			if num == 0

				str2 = "フレンズサーバーで遊んでいる人はいません...\n"
			else
				str = "#{server.players} "
				m = str.scan(/@name="(.*?)"/)

				str2 = "フレンズサーバーで**#{num}人**が遊んでますよ～！遊んでるフレンズさんは...\n\n"
				for i in 1..num do
	
					if m[i-1][0] == "" then
					
						str2 = "#{str2}**[参加中のユーザー]**ちゃん、"
		
					else
	
						str2 = "#{str2}**#{m[i-1][0]}**ちゃん、"
	
					end	
				end
				str2 = "#{str2}です！\n"
			end

			if num2 == 0
				
				str5 = "フレンズサーバーMGEで遊んでいる人はいません..."

			else
				str5 = "フレンズサーバーMGEで**#{num2}人**が遊んでますよ～！遊んでるフレンズさんは...\n\n"
				str4 = "#{server2.players} "
				m = str4.scan(/@name="(.*?)"/)
				for x in 1..num2 do
	
					if m[x-1][0] == "" then
						
						str5 = "#{str5}**[参加中のユーザー]**ちゃん、"
			
					else
		
						str5 = "#{str5}**#{m[x-1][0]}**ちゃん、"
		
					end

					
				end
				str5 =  "#{str5}です！\n"
			end
			
		end
		event.send_message("#{str2}\n------------------------------------------\n#{str5}\n------------------------------------------\nその他、TF2日本サーバーのようす！#{@tw}\n------------------------------------------\nフレンズサーバーに接続! steam://connect/122.210.136.164:27015\nフレンズサーバーMGEに接続! steam://connect/122.210.136.164:27010")
	rescue => error # 変数(例外オブジェクトの代入)

		#event.send_message("あれれ...ちょっと見失っちゃいました...\n---------------[エラー]----------------\nサーバーの情報を取得できませんでした、サーバーが起動していないかアドレスが間違っている可能性があります")

	end

end

bot.command :log do |event|
	start_typing('MzkwNDIyNTgyMzIwNjkzMjQ5.DRJ49g.sr9_Ag7XBp2ea2cgLTgotTkyGC8', event.channel.id)

puts "名前からサーバーを検索して、最新のマッチリザルトを表示します"
#input = gets
APIKEY = "50A39519488BF3EC64B3463BEC71BCC0"
#MatchServerName = input.chomp!
MatchServerName = "hatena"

STEMAIDOFFSET = 76561197960265728

Jsondata_serch_Matches = "http://logs.tf/api/v1/log?title=#{MatchServerName}"

uri = URI.parse(Jsondata_serch_Matches)
puts "ログサーバーに問い合わせています・・・"
json =  Net::HTTP.get(uri)

json_pars = JSON.parse(json)

number = "0"

if json_pars["logs"].length >= 1000 then
    number = "1000件以上"
else
    number = "#{json_pars["logs"].length}件"
end
matchID = 0
begin
    matchID = json_pars["logs"][0]["id"]
rescue => exception
    puts "マッチが見つかりませんでした"
    exit
end
#puts json_pars["logs"]


puts "「hatena」を含むマッチの検索結果：#{number}件"
puts "最新のマッチデータを取得 ID:#{matchID}\n=============="
matchdata = "http://logs.tf/json/#{matchID}"

#TESTURL = "http://logs.tf/json/2127732"

uri = URI.parse(matchdata)

json =  Net::HTTP.get(uri)
json_pars = JSON.parse(json)
title = json_pars["info"]["title"]
map = json_pars["info"]["map"]
date = Time.at(json_pars["info"]["date"])

score_red = json_pars["teams"]["Red"]["score"]
score_blu = json_pars["teams"]["Blue"]["score"]

puts "title:#{title}"
puts "map:#{map}"
puts "date:#{date}"

puts "match result RED:#{score_red} BLU:#{score_blu}"

#三次元配列の初期化
data = Hash.new { |hash,key| hash[key] = Hash.new { |hash,key| hash[key] = {} } }

data["TOPKILL"][0]["name"] = json_pars["players"].sort_by {| a,b | b["kills"].to_i}.reverse[0][0]
data["TOPKILL"][0]["point"] = json_pars["players"].sort_by {| a,b | b["kills"].to_i}.reverse[0][1]["kills"]

data["TOPKILL"][1]["name"] = json_pars["players"].sort_by {| a,b | b["kills"].to_i}.reverse[1][0]
data["TOPKILL"][1]["point"] = json_pars["players"].sort_by {| a,b | b["kills"].to_i}.reverse[1][1]["kills"]

data["TOPKILL"][2]["name"] = json_pars["players"].sort_by {| a,b | b["kills"].to_i}.reverse[2][0]
data["TOPKILL"][2]["point"] = json_pars["players"].sort_by {| a,b | b["kills"].to_i}.reverse[2][1]["kills"]



data["TOPASSIST"][0]["name"] = json_pars["players"].sort_by {| a,b | b["assists"].to_i}.reverse[0][0]
data["TOPASSIST"][0]["point"] = json_pars["players"].sort_by {| a,b | b["assists"].to_i}.reverse[0][1]["assists"]

data["TOPASSIST"][1]["name"] = json_pars["players"].sort_by {| a,b | b["assists"].to_i}.reverse[1][0]
data["TOPASSIST"][1]["point"] = json_pars["players"].sort_by {| a,b | b["assists"].to_i}.reverse[1][1]["assists"]

data["TOPASSIST"][2]["name"] = json_pars["players"].sort_by {| a,b | b["assists"].to_i}.reverse[2][0]
data["TOPASSIST"][2]["point"] = json_pars["players"].sort_by {| a,b | b["assists"].to_i}.reverse[2][1]["assists"]

#Deatshs


data["TOPDEATHS"][0]["name"] = json_pars["players"].sort_by {| a,b | b["deaths"].to_i}.reverse[0][0]
data["TOPDEATHS"][0]["point"] = json_pars["players"].sort_by {| a,b | b["deaths"].to_i}.reverse[0][1]["deaths"]

data["TOPDEATHS"][1]["name"] = json_pars["players"].sort_by {| a,b | b["deaths"].to_i}.reverse[1][0]
data["TOPDEATHS"][1]["point"] = json_pars["players"].sort_by {| a,b | b["deaths"].to_i}.reverse[1][1]["deaths"]

data["TOPDEATHS"][2]["name"] = json_pars["players"].sort_by {| a,b | b["deaths"].to_i}.reverse[2][0]
data["TOPDEATHS"][2]["point"] = json_pars["players"].sort_by {| a,b | b["deaths"].to_i}.reverse[2][1]["deaths"]

#data["MEDICS"][0]["name"] = json_pars["players"].sort_by {| a,b | b["medicstats"]}.reverse[0][0]

num = 0

steamid = ""

json_pars["players"].each_key{|key|
    if json_pars["players"][key]["medicstats"] != nil then

        data["MEDICS"][num.to_i]["name"] = key
        data["MEDICS"][num.to_i]["team"] = json_pars["players"][key]["team"]
        data["MEDICS"][num.to_i]["heal"] = json_pars["players"][key]["heal"]
        data["MEDICS"][num.to_i]["drops"] = json_pars["players"][key]["drops"]
        data["MEDICS"][num.to_i]["ubers"] = json_pars["players"][key]["ubers"]
        num = num.to_i + 1
    end
    steamid = key.match(/U:1:(.+)\]/)

    steamid64 = steamid[1].to_i + STEMAIDOFFSET
    

    url = "http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=#{APIKEY}&steamids=#{steamid64}"
    uri = URI.parse(url)

    json =  Net::HTTP.get(uri)
    json_id_pars = JSON.parse(json)

    imagedata =  json_id_pars["response"]["players"][0]["avatarfull"]
    puts "GET:#{imagedata}"
    open(imagedata, http_basic_authentication: ["", ""]) { |image|
        File.open("/home/daburutti/Test/#{key}.jpg","wb") do |file|
            file.puts image.read
        end
    }
    #-size 200x200 xc:none -fill walter.jpg -draw "circle 100,100 100,1" circle_thumb.png

    value = `convert -size 184x184 xc:none -fill \"/home/daburutti/Test/\[U\:1\:#{steamid[1]}\].jpg\" -draw \"circle 92,92 100,1\" \"/home/daburutti/Test/\[U\:1\:#{steamid[1]}\]_maru.png\"`
    puts "IMAGE CONVERTED"
}

puts data

puts "START IMAGE FAZE"

img = Magick::Image.new(1920,1080)
img = Magick::ImageList.new("/home/daburutti/Test/koredesuwa.png")
draw = Magick::Draw.new


draw.annotate(img, 0, 0, 100, -1897, score_red.to_s) do
    self.font      = '/home/daburutti/Test/ERASBD.TTF'
    self.fill      = 'Black'
    self.stroke    = 'transparent'
    self.pointsize = 270
    self.gravity   = Magick::CenterGravity
end

draw.annotate(img, 0, 0,-100, -1897, score_blu.to_s) do
    self.font      = '/home/daburutti/Test/ERASBD.TTF'
    self.fill      = 'Black'
    self.stroke    = 'transparent'
    self.pointsize = 270
    self.gravity   = Magick::CenterGravity
end


draw.annotate(img, 0, 0,810, 43, title.to_s) do
    self.font      = '/home/daburutti/Test/ERASBD.TTF'
    self.fill      = '#fcf9db'
    self.stroke    = 'transparent'
    self.pointsize = 65
    self.gravity   = Magick::NorthWestGravity
end

draw.annotate(img, 0, 0,125, 190, map.to_s) do
    self.font      = '/home/daburutti/Test/ERASDEMI.TTF'
    self.fill      = '#fcf9db'
    self.stroke    = 'transparent'
    self.pointsize = 70
    self.gravity   = Magick::NorthWestGravity
end

draw.annotate(img, 0, 0,970, 200, date.to_s) do
    self.font      = '/home/daburutti/Test/ERASDEMI.TTF'
    self.fill      = '#fcf9db'
    self.stroke    = 'transparent'
    self.pointsize = 60
    self.gravity   = Magick::NorthWestGravity
end


string =  json_pars["names"][data["TOPKILL"][0]["name"].to_s] + "\n-" + data["TOPKILL"][0]["point"].to_s + "-"

draw.annotate(img, 0, 0, 0, -900, string) do
    self.font      = '/home/daburutti/Test/rounded-mplus-2c-heavy.ttf'
    self.fill      = 'Black'
    self.stroke    = 'transparent'
    self.pointsize = 80
    self.gravity   = Magick::CenterGravity
end

string =  json_pars["names"][data["TOPKILL"][1]["name"].to_s] + "\n-" + data["TOPKILL"][1]["point"].to_s + "-"

draw.annotate(img, 0, 0, 610, -980, string) do
    self.font      = '/home/daburutti/Test/rounded-mplus-2c-heavy.ttf'
    self.fill      = 'Black'
    self.stroke    = 'transparent'
    self.pointsize = 60
    self.gravity   = Magick::CenterGravity
end
string =  json_pars["names"][data["TOPKILL"][2]["name"].to_s] + "\n-" + data["TOPKILL"][2]["point"].to_s + "-"

draw.annotate(img, 0, 0, -610, -980, string) do
    self.font      = '/home/daburutti/Test/rounded-mplus-2c-heavy.ttf'
    self.fill      = 'Black'
    self.stroke    = 'transparent'
    self.pointsize = 60
    self.gravity   = Magick::CenterGravity
end


string =  json_pars["names"][data["TOPASSIST"][0]["name"].to_s] + "\n-" + data["TOPASSIST"][0]["point"].to_s + "-"

draw.annotate(img, 0, 0, 0, 50, string) do
    self.font      = '/home/daburutti/Test/rounded-mplus-2c-heavy.ttf'
    self.fill      = 'Black'
    self.stroke    = 'transparent'
    self.pointsize = 80
    self.gravity   = Magick::CenterGravity
end

string =  json_pars["names"][data["TOPASSIST"][1]["name"].to_s] + "\n-" + data["TOPASSIST"][1]["point"].to_s + "-"

draw.annotate(img, 0, 0, 610, -30, string) do
    self.font      = '/home/daburutti/Test/rounded-mplus-2c-heavy.ttf'
    self.fill      = 'Black'
    self.stroke    = 'transparent'
    self.pointsize = 60
    self.gravity   = Magick::CenterGravity
end
string =  json_pars["names"][data["TOPASSIST"][2]["name"].to_s] + "\n-" + data["TOPASSIST"][2]["point"].to_s + "-"

draw.annotate(img, 0, 0, -610, -30, string) do
    self.font      = '/home/daburutti/Test/rounded-mplus-2c-heavy.ttf'
    self.fill      = 'Black'
    self.stroke    = 'transparent'
    self.pointsize = 60
    self.gravity   = Magick::CenterGravity
end



string =  json_pars["names"][data["TOPDEATHS"][0]["name"].to_s] + "\n-" + data["TOPDEATHS"][0]["point"].to_s + "-"

draw.annotate(img, 0, 0, 0, 1010, string) do
    self.font      = '/home/daburutti/Test/rounded-mplus-2c-heavy.ttf'
    self.fill      = 'Black'
    self.stroke    = 'transparent'
    self.pointsize = 80
    self.gravity   = Magick::CenterGravity
end

string =  json_pars["names"][data["TOPDEATHS"][1]["name"].to_s] + "\n-" + data["TOPDEATHS"][1]["point"].to_s + "-"

draw.annotate(img, 0, 0, 610, 930, string) do
    self.font      = '/home/daburutti/Test/rounded-mplus-2c-heavy.ttf'
    self.fill      = 'Black'
    self.stroke    = 'transparent'
    self.pointsize = 60
    self.gravity   = Magick::CenterGravity
end
string =  json_pars["names"][data["TOPDEATHS"][2]["name"].to_s] + "\n-" + data["TOPDEATHS"][2]["point"].to_s + "-"

draw.annotate(img, 0, 0, -610, 930, string) do
    self.font      = '/home/daburutti/Test/rounded-mplus-2c-heavy.ttf'
    self.fill      = 'Black'
    self.stroke    = 'transparent'
    self.pointsize = 60
    self.gravity   = Magick::CenterGravity
end
puts data["MEDICS"][0]["team"].to_s
if  data["MEDICS"][0]["team"].to_s == "Blue" then
    puts "pt1"
    puts json_pars["names"][data["MEDICS"][1]["name"]].to_s
    puts json_pars["names"][data["MEDICS"][0]["name"]].to_s
    draw.annotate(img, 0, 0, -455, 1425, json_pars["names"][data["MEDICS"][0]["name"]].to_s) do
        self.font      = '/home/daburutti/Test/rounded-mplus-2c-heavy.ttf'
        self.fill      = 'White'
        self.stroke    = 'transparent'
        self.pointsize = 90
        self.gravity   = Magick::CenterGravity
    end

    draw.annotate(img, 0, 0, 455, 1425, json_pars["names"][data["MEDICS"][1]["name"]].to_s) do
        self.font      = '/home/daburutti/Test/rounded-mplus-2c-heavy.ttf'
        self.fill      = 'White'
        self.stroke    = 'transparent'
        self.pointsize = 90
        self.gravity   = Magick::CenterGravity
    end

    draw.annotate(img, 0, 0, -475,1600, data["MEDICS"][0]["heal"].to_s) do
        self.font      = '/home/daburutti/Test/rounded-mplus-2c-heavy.ttf'
        self.fill      = 'Black'
        self.stroke    = 'transparent'
        self.pointsize = 100
        self.gravity   = Magick::CenterGravity
    end
    draw.annotate(img, 0, 0, 475,1600, data["MEDICS"][1]["heal"].to_s) do
        self.font      = '/home/daburutti/Test/rounded-mplus-2c-heavy.ttf'
        self.fill      = 'Black'
        self.stroke    = 'transparent'
        self.pointsize = 100
        self.gravity   = Magick::CenterGravity
    end

    draw.annotate(img, 0, 0, -475,1830, data["MEDICS"][0]["ubers"].to_s) do
        self.font      = '/home/daburutti/Test/rounded-mplus-2c-heavy.ttf'
        self.fill      = 'Black'
        self.stroke    = 'transparent'
        self.pointsize = 100
        self.gravity   = Magick::CenterGravity
    end
    draw.annotate(img, 0, 0, 475,1830, data["MEDICS"][1]["ubers"].to_s) do
        self.font      = '/home/daburutti/Test/rounded-mplus-2c-heavy.ttf'
        self.fill      = 'Black'
        self.stroke    = 'transparent'
        self.pointsize = 100
        self.gravity   = Magick::CenterGravity
    end

    draw.annotate(img, 0, 0, -475,2065, data["MEDICS"][0]["drops"].to_s) do
        self.font      = '/home/daburutti/Test/rounded-mplus-2c-heavy.ttf'
        self.fill      = 'Black'
        self.stroke    = 'transparent'
        self.pointsize = 100
        self.gravity   = Magick::CenterGravity
    end
    draw.annotate(img, 0, 0, 475,2065, data["MEDICS"][1]["drops"].to_s) do
        self.font      = '/home/daburutti/Test/rounded-mplus-2c-heavy.ttf'
        self.fill      = 'Black'
        self.stroke    = 'transparent'
        self.pointsize = 100
        self.gravity   = Magick::CenterGravity
    end

else
    puts "pt2"
    draw.annotate(img, 0, 0, -455, 1425, json_pars["names"][data["MEDICS"][1]["name"]].to_s) do
        self.font      = '/home/daburutti/Test/rounded-mplus-2c-heavy.ttf'
        self.fill      = 'White'
        self.stroke    = 'transparent'
        self.pointsize = 90
        self.gravity   = Magick::CenterGravity
    end

    draw.annotate(img, 0, 0, 455, 1425, json_pars["names"][data["MEDICS"][0]["name"]].to_s) do
        self.font      = '/home/daburutti/Test/rounded-mplus-2c-heavy.ttf'
        self.fill      = 'White'
        self.stroke    = 'transparent'
        self.pointsize = 90
        self.gravity   = Magick::CenterGravity
    end

    draw.annotate(img, 0, 0, -475,1600, data["MEDICS"][1]["heal"].to_s) do
        self.font      = '/home/daburutti/Test/rounded-mplus-2c-heavy.ttf'
        self.fill      = 'Black'
        self.stroke    = 'transparent'
        self.pointsize = 100
        self.gravity   = Magick::CenterGravity
    end
    draw.annotate(img, 0, 0, 475,1600, data["MEDICS"][0]["heal"].to_s) do
        self.font      = '/home/daburutti/Test/rounded-mplus-2c-heavy.ttf'
        self.fill      = 'Black'
        self.stroke    = 'transparent'
        self.pointsize = 100
        self.gravity   = Magick::CenterGravity
    end

    draw.annotate(img, 0, 0, -475,1830, data["MEDICS"][1]["ubers"].to_s) do
        self.font      = '/home/daburutti/Test/rounded-mplus-2c-heavy.ttf'
        self.fill      = 'Black'
        self.stroke    = 'transparent'
        self.pointsize = 100
        self.gravity   = Magick::CenterGravity
    end
    draw.annotate(img, 0, 0, 475,1830, data["MEDICS"][0]["ubers"].to_s) do
        self.font      = '/home/daburutti/Test/rounded-mplus-2c-heavy.ttf'
        self.fill      = 'Black'
        self.stroke    = 'transparent'
        self.pointsize = 100
        self.gravity   = Magick::CenterGravity
    end

    draw.annotate(img, 0, 0, -475,2065, data["MEDICS"][1]["drops"].to_s) do
        self.font      = '/home/daburutti/Test/rounded-mplus-2c-heavy.ttf'
        self.fill      = 'Black'
        self.stroke    = 'transparent'
        self.pointsize = 100
        self.gravity   = Magick::CenterGravity
    end
    draw.annotate(img, 0, 0, 475,2065, data["MEDICS"][0]["drops"].to_s) do
        self.font      = '/home/daburutti/Test/rounded-mplus-2c-heavy.ttf'
        self.fill      = 'Black'
        self.stroke    = 'transparent'
        self.pointsize = 100
        self.gravity   = Magick::CenterGravity
    end


end

overlay = Magick::Image.read("/home/daburutti/Test/#{data["TOPKILL"][0]["name"]}_maru.png").first.resize(455, 455)

img.composite!(overlay, 745, 838, Magick::OverCompositeOp)
overlay = Magick::Image.read("/home/daburutti/Test/#{data["TOPKILL"][1]["name"]}_maru.png").first.resize(330, 330)

img.composite!(overlay, 1405, 899, Magick::OverCompositeOp)

overlay = Magick::Image.read("/home/daburutti/Test/#{data["TOPKILL"][2]["name"]}_maru.png").first.resize(330, 330)

img.composite!(overlay, 185, 899, Magick::OverCompositeOp)


overlay = Magick::Image.read("/home/daburutti/Test/#{data["TOPASSIST"][0]["name"]}_maru.png").first.resize(455, 455)

img.composite!(overlay, 745, 1790, Magick::OverCompositeOp)
overlay = Magick::Image.read("/home/daburutti/Test/#{data["TOPASSIST"][1]["name"]}_maru.png").first.resize(330, 330)

img.composite!(overlay, 1405, 1851, Magick::OverCompositeOp)

overlay = Magick::Image.read("/home/daburutti/Test/#{data["TOPASSIST"][2]["name"]}_maru.png").first.resize(330, 330)

img.composite!(overlay, 185,1851, Magick::OverCompositeOp)

overlay = Magick::Image.read("/home/daburutti/Test/#{data["TOPDEATHS"][0]["name"]}_maru.png").first.resize(455, 455)

img.composite!(overlay, 745, 2750, Magick::OverCompositeOp)

overlay = Magick::Image.read("/home/daburutti/Test/#{data["TOPDEATHS"][1]["name"]}_maru.png").first.resize(330, 330)

img.composite!(overlay, 1405, 2813, Magick::OverCompositeOp)

overlay = Magick::Image.read("/home/daburutti/Test/#{data["TOPDEATHS"][2]["name"]}_maru.png").first.resize(330, 330)

img.composite!(overlay, 185, 2813, Magick::OverCompositeOp)
#img.display
#img.display
ins = Time.new.sec
img.write("/var/www/html/tf2/discordbot_img/#{matchID}-#{ins}.png")
event.send_message("http://www.dabudabu.net:8080/tf2/discordbot_img/#{matchID}-#{ins}.png\nLOG:https://logs.tf/#{matchID}")


end
bot.run
