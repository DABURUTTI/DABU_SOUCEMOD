require 'rmagick'
require 'json'
require 'open-uri'
require 'twitter'
require 'rest-client'
require 'net/http'
require 'uri'
require 'rmagick'
require 'mini_magick'
require 'steam-condenser'
require 'twitter'
@page = 0
@tw = []

@tw[0] = "鯖温め中!"
@num = 0
@num2 = 0
@server

@client = Twitter::REST::Client.new do |config|
    config.consumer_key        = ""
    config.consumer_secret     = ""
    config.access_token        = ""
    config.access_token_secret = ""
end

def wow_such_a_hot_server(server_name,number_of_trueplayers,max_players,ip,port,map_name,tag,var,os)

  img = Magick::Image.new(1920,1080)
    img = Magick::ImageList.new("/home/daburutti/Testgo/tf2_2.png")
    draw = Magick::Draw.new
    data = Hash.new { |hash,key| hash[key] = Hash.new { |hash,key| hash[key] = {} } }
    int = 0
    #puts @server.players

    for x in 0...6 do
        data["Player"][x]["name"] = "-"
        data["Player"][x]["score"] = 0
        data["Player"][x]["time"] = 0
    end

    @server.players.each do |value , key|
        # key.to_s
        
        begin
            name = key.to_s.match(/#0 "(.+)\"/)[1]
        rescue
            name = "-Joining-"
        end
        begin
        score = key.to_s.match(/Score:\s(.+),/)[1]
    rescue
        score = "-"
    end
        begin
        time = key.to_s.match(/Time:\s(.+)/)[1].to_i/60.round
    rescue
        time = "-"
    end

    if name.length > 17 then
        name = name.slice(0, 17)
        name = "#{name}..."
    end
        data["Player"][int]["name"] = name
        data["Player"][int]["score"] = score.to_i
        data["Player"][int]["time"] = time
        int = int + 1
        #puts key
    end
    twstr = "#{server_name.gsub(/#/, "")} がアツい！(#{number_of_trueplayers}/#{max_players})今すぐ参加だ！\n現在のTOP「#{data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[0][1]["name"]}」スコア:#{data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[0][1]["score"]}\nプレイ中のマップ「#{map_name}」\n#{ip}:#{port}"
    puts data.to_json
    #puts data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[][1]["name"]
    

    draw.annotate(img, 0, 0, 175, 370, data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[0][1]["name"]) do
        self.font      = '/home/daburutti/Test/rounded-mplus-2c-heavy.ttf'
        self.fill      = 'Black'
        self.stroke    = 'transparent'
        self.pointsize = 48
        self.gravity   = Magick::NorthWestGravity
    end

    draw.annotate(img, 0, 0, 175, 428, "Score:#{data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[0][1]["score"]}   Time:#{data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[0][1]["time"]}min") do
        self.font      = '/home/daburutti/Test/rounded-mplus-2c-heavy.ttf'
        self.fill      = '#424242'
        self.stroke    = 'transparent'
        self.pointsize = 20
        self.gravity   = Magick::NorthWestGravity
    end

    draw.annotate(img, 0, 0, 175, 480,  data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[1][1]["name"]) do
        self.font      = '/home/daburutti/Test/rounded-mplus-2c-heavy.ttf'
        self.fill      = 'Black'
        self.stroke    = 'transparent'
        self.pointsize = 48
        self.gravity   = Magick::NorthWestGravity
    end

    draw.annotate(img, 0, 0, 175, 538, "Score:#{data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[1][1]["score"]}   Time:#{data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[1][1]["time"]}min") do
        self.font      = '/home/daburutti/Test/rounded-mplus-2c-heavy.ttf'
        self.fill      = '#424242'
        self.stroke    = 'transparent'
        self.pointsize = 20
        self.gravity   = Magick::NorthWestGravity
    end
    draw.annotate(img, 0, 0, 175, 590,  data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[2][1]["name"]) do
        self.font      = '/home/daburutti/Test/rounded-mplus-2c-heavy.ttf'
        self.fill      = 'Black'
        self.stroke    = 'transparent'
        self.pointsize = 48
        self.gravity   = Magick::NorthWestGravity
    end

    draw.annotate(img, 0, 0, 175, 648, "Score:#{data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[2][1]["score"]}   Time:#{data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[2][1]["time"]}min") do
        self.font      = '/home/daburutti/Test/rounded-mplus-2c-heavy.ttf'
        self.fill      = '#424242'
        self.stroke    = 'transparent'
        self.pointsize = 20
        self.gravity   = Magick::NorthWestGravity
    end
    draw.annotate(img, 0, 0, 175, 700,  data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[3][1]["name"]) do
        self.font      = '/home/daburutti/Test/rounded-mplus-2c-heavy.ttf'
        self.fill      = 'Black'
        self.stroke    = 'transparent'
        self.pointsize = 48
        self.gravity   = Magick::NorthWestGravity
    end

    draw.annotate(img, 0, 0, 175, 758, "Score:#{data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[3][1]["score"]}   Time:#{data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[3][1]["time"]}min") do
        self.font      = '/home/daburutti/Test/rounded-mplus-2c-heavy.ttf'
        self.fill      = '#424242'
        self.stroke    = 'transparent'
        self.pointsize = 20
        self.gravity   = Magick::NorthWestGravity
    end
    draw.annotate(img, 0, 0, 175, 810,  data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[4][1]["name"]) do
        self.font      = '/home/daburutti/Test/rounded-mplus-2c-heavy.ttf'
        self.fill      = 'Black'
        self.stroke    = 'transparent'
        self.pointsize = 48
        self.gravity   = Magick::NorthWestGravity
    end

    draw.annotate(img, 0, 0, 175, 868, "Score:#{data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[4][1]["score"]}   Time:#{data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[4][1]["time"]}min") do
        self.font      = '/home/daburutti/Test/rounded-mplus-2c-heavy.ttf'
        self.fill      = '#424242'
        self.stroke    = 'transparent'
        self.pointsize = 20
        self.gravity   = Magick::NorthWestGravity
    end
    draw.annotate(img, 0, 0, 175, 920, data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[5][1]["name"]) do
        self.font      = '/home/daburutti/Test/rounded-mplus-2c-heavy.ttf'
        self.fill      = 'Black'
        self.stroke    = 'transparent'
        self.pointsize = 48
        self.gravity   = Magick::NorthWestGravity
    end

    draw.annotate(img, 0, 0, 175, 978, "Score:#{data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[5][1]["score"]}   Time:#{data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[5][1]["time"]}min") do
        self.font      = '/home/daburutti/Test/rounded-mplus-2c-heavy.ttf'
        self.fill      = '#424242'
        self.stroke    = 'transparent'
        self.pointsize = 20
        self.gravity   = Magick::NorthWestGravity
    end
    if map_name.length > 21 then
        map_name = map_name.slice(0, 21)
        map_name = "#{map_name}..."
    end
    draw.annotate(img, 0, 0, 470, -120, map_name) do
        self.font      = '/home/daburutti/Test/GenEiNuGothic-EB.ttf'
        self.fill      = '#000000'
        self.stroke    = 'transparent'
        self.pointsize = 50
        self.gravity   = Magick::CenterGravity
    end

    draw.annotate(img, 0, 0, 470, -10, "#{number_of_trueplayers}/#{max_players}") do
        self.font      = '/home/daburutti/Test/GenEiNuGothic-EB.ttf'
        self.fill      = '#000000'
        self.stroke    = 'transparent'
        self.pointsize = 50
        self.gravity   = Magick::CenterGravity
    end

    draw.annotate(img, 0, 0, 470, 100, "#{ip}:#{port}") do
        self.font      = '/home/daburutti/Test/GenEiNuGothic-EB.ttf'
        self.fill      = '#000000'
        self.stroke    = 'transparent'
        self.pointsize = 50
        self.gravity   = Magick::CenterGravity
    end

    if tag.length > 35 then
        tag = tag.slice(0, 35)
        tag = "#{tag}..."
    end
    draw.annotate(img, 0, 0, 470, 210, tag) do
        self.font      = '/home/daburutti/Test/GenEiNuGothic-EB.ttf'
        self.fill      = '#000000'
        self.stroke    = 'transparent'
        self.pointsize = 30
        self.gravity   = Magick::CenterGravity
    end

    draw.annotate(img, 0, 0, 470, 320, var) do
        self.font      = '/home/daburutti/Test/GenEiNuGothic-EB.ttf'
        self.fill      = '#000000'
        self.stroke    = 'transparent'
        self.pointsize = 50
        self.gravity   = Magick::CenterGravity
    end
    if os == "l" then
        os = "Linux"
    else
        os = "Windows"
    end
    draw.annotate(img, 0, 0, 470, 430, os) do
        self.font      = '/home/daburutti/Test/GenEiNuGothic-EB.ttf'
        self.fill      = '#000000'
        self.stroke    = 'transparent'
        self.pointsize = 50
        self.gravity   = Magick::CenterGravity
    end

    draw.annotate(img, 0, 0, 120, 160, server_name) do
        self.font      = '/home/daburutti/Test/GenEiNuGothic-EB.ttf'
        self.fill      = '#1f69e0'
        self.stroke    = 'transparent'
        self.pointsize = 50
        self.gravity   = Magick::NorthWestGravity
    end

    img.write("/home/daburutti/Testgo/tw.png")
    images = []
    images << File.new('/home/daburutti/Testgo/tw.png')
puts twstr
    res = @client.update_with_media(twstr, images)
    #puts res
    #@client.update("#{twstr}")
end

def wow_such_a_super_hot_server(server_name,number_of_trueplayers,max_players,ip,port,map_name,tag,var,os)
    
    img = Magick::Image.new(1920,1080)
    img = Magick::ImageList.new("/home/daburutti/Testgo/tf2_2.png")
    draw = Magick::Draw.new
    data = Hash.new { |hash,key| hash[key] = Hash.new { |hash,key| hash[key] = {} } }
    int = 0
    for x in 0...6 do
        data["Player"][x]["name"] = "-"
        data["Player"][x]["score"] = 0
        data["Player"][x]["time"] = 0
    end
    #puts @server.players
    @server.players.each do |value , key|
        # key.to_s
        begin
            name = key.to_s.match(/#0 "(.+)\"/)[1]
        rescue
            name = "-Joining-"
        end
        begin
        score = key.to_s.match(/Score:\s(.+),/)[1]
    rescue
        score = "-"
    end
        begin
        time = key.to_s.match(/Time:\s(.+)/)[1].to_i/60.round
    rescue
        time = "-"
    end
    if name.length > 17 then
        name = name.slice(0, 17)
        name = "#{name}..."
    end
        data["Player"][int]["name"] = name
        data["Player"][int]["score"] = score.to_i
        data["Player"][int]["time"] = time
        int = int + 1
        #puts key
    end


    
    #puts data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[][1]["name"]
    twstr = "#{server_name.gsub(/#/, "")} が満員で激アツ！Join戦争だ！\n現在のTOP「#{data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[0][1]["name"]}」スコア:#{data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[0][1]["score"]}\nプレイ中のマップ「#{map_name}」\n#{ip}:#{port}"


    draw.annotate(img, 0, 0, 175, 370, data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[0][1]["name"]) do
        self.font      = '/home/daburutti/Test/rounded-mplus-2c-heavy.ttf'
        self.fill      = 'Black'
        self.stroke    = 'transparent'
        self.pointsize = 48
        self.gravity   = Magick::NorthWestGravity
    end

    draw.annotate(img, 0, 0, 175, 428, "Score:#{data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[0][1]["score"]}   Time:#{data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[0][1]["time"]}min") do
        self.font      = '/home/daburutti/Test/rounded-mplus-2c-heavy.ttf'
        self.fill      = '#424242'
        self.stroke    = 'transparent'
        self.pointsize = 20
        self.gravity   = Magick::NorthWestGravity
    end

    draw.annotate(img, 0, 0, 175, 480,  data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[1][1]["name"]) do
        self.font      = '/home/daburutti/Test/rounded-mplus-2c-heavy.ttf'
        self.fill      = 'Black'
        self.stroke    = 'transparent'
        self.pointsize = 48
        self.gravity   = Magick::NorthWestGravity
    end

    draw.annotate(img, 0, 0, 175, 538, "Score:#{data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[1][1]["score"]}   Time:#{data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[1][1]["time"]}min") do
        self.font      = '/home/daburutti/Test/rounded-mplus-2c-heavy.ttf'
        self.fill      = '#424242'
        self.stroke    = 'transparent'
        self.pointsize = 20
        self.gravity   = Magick::NorthWestGravity
    end
    draw.annotate(img, 0, 0, 175, 590,  data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[2][1]["name"]) do
        self.font      = '/home/daburutti/Test/rounded-mplus-2c-heavy.ttf'
        self.fill      = 'Black'
        self.stroke    = 'transparent'
        self.pointsize = 48
        self.gravity   = Magick::NorthWestGravity
    end

    draw.annotate(img, 0, 0, 175, 648, "Score:#{data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[2][1]["score"]}   Time:#{data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[2][1]["time"]}min") do
        self.font      = '/home/daburutti/Test/rounded-mplus-2c-heavy.ttf'
        self.fill      = '#424242'
        self.stroke    = 'transparent'
        self.pointsize = 20
        self.gravity   = Magick::NorthWestGravity
    end
    draw.annotate(img, 0, 0, 175, 700,  data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[3][1]["name"]) do
        self.font      = '/home/daburutti/Test/rounded-mplus-2c-heavy.ttf'
        self.fill      = 'Black'
        self.stroke    = 'transparent'
        self.pointsize = 48
        self.gravity   = Magick::NorthWestGravity
    end

    draw.annotate(img, 0, 0, 175, 758, "Score:#{data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[3][1]["score"]}   Time:#{data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[3][1]["time"]}min") do
        self.font      = '/home/daburutti/Test/rounded-mplus-2c-heavy.ttf'
        self.fill      = '#424242'
        self.stroke    = 'transparent'
        self.pointsize = 20
        self.gravity   = Magick::NorthWestGravity
    end
    draw.annotate(img, 0, 0, 175, 810,  data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[4][1]["name"]) do
        self.font      = '/home/daburutti/Test/rounded-mplus-2c-heavy.ttf'
        self.fill      = 'Black'
        self.stroke    = 'transparent'
        self.pointsize = 48
        self.gravity   = Magick::NorthWestGravity
    end

    draw.annotate(img, 0, 0, 175, 868, "Score:#{data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[4][1]["score"]}   Time:#{data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[4][1]["time"]}min") do
        self.font      = '/home/daburutti/Test/rounded-mplus-2c-heavy.ttf'
        self.fill      = '#424242'
        self.stroke    = 'transparent'
        self.pointsize = 20
        self.gravity   = Magick::NorthWestGravity
    end
    draw.annotate(img, 0, 0, 175, 920, data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[5][1]["name"]) do
        self.font      = '/home/daburutti/Test/rounded-mplus-2c-heavy.ttf'
        self.fill      = 'Black'
        self.stroke    = 'transparent'
        self.pointsize = 48
        self.gravity   = Magick::NorthWestGravity
    end

    draw.annotate(img, 0, 0, 175, 978, "Score:#{data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[5][1]["score"]}   Time:#{data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[5][1]["time"]}min") do
        self.font      = '/home/daburutti/Test/rounded-mplus-2c-heavy.ttf'
        self.fill      = '#424242'
        self.stroke    = 'transparent'
        self.pointsize = 20
        self.gravity   = Magick::NorthWestGravity
    end
    if map_name.length > 21 then
        map_name = map_name.slice(0, 21)
        map_name = "#{map_name}..."
    end
    draw.annotate(img, 0, 0, 470, -120, map_name) do
        self.font      = '/home/daburutti/Test/GenEiNuGothic-EB.ttf'
        self.fill      = '#000000'
        self.stroke    = 'transparent'
        self.pointsize = 50
        self.gravity   = Magick::CenterGravity
    end

    draw.annotate(img, 0, 0, 470, -10, "#{number_of_trueplayers}/#{max_players}") do
        self.font      = '/home/daburutti/Test/GenEiNuGothic-EB.ttf'
        self.fill      = '#000000'
        self.stroke    = 'transparent'
        self.pointsize = 50
        self.gravity   = Magick::CenterGravity
    end

    draw.annotate(img, 0, 0, 470, 100, "#{ip}:#{port}") do
        self.font      = '/home/daburutti/Test/GenEiNuGothic-EB.ttf'
        self.fill      = '#000000'
        self.stroke    = 'transparent'
        self.pointsize = 50
        self.gravity   = Magick::CenterGravity
    end

    if tag.length > 35 then
        tag = tag.slice(0, 35)
        tag = "#{tag}..."
    end
    draw.annotate(img, 0, 0, 470, 210, tag) do
        self.font      = '/home/daburutti/Test/GenEiNuGothic-EB.ttf'
        self.fill      = '#000000'
        self.stroke    = 'transparent'
        self.pointsize = 30
        self.gravity   = Magick::CenterGravity
    end

    draw.annotate(img, 0, 0, 470, 320, var) do
        self.font      = '/home/daburutti/Test/GenEiNuGothic-EB.ttf'
        self.fill      = '#000000'
        self.stroke    = 'transparent'
        self.pointsize = 50
        self.gravity   = Magick::CenterGravity
    end
    if os == "l" then
        os = "Linux"
    else
        os = "Windows"
    end
    draw.annotate(img, 0, 0, 470, 430, os) do
        self.font      = '/home/daburutti/Test/GenEiNuGothic-EB.ttf'
        self.fill      = '#000000'
        self.stroke    = 'transparent'
        self.pointsize = 50
        self.gravity   = Magick::CenterGravity
    end

    draw.annotate(img, 0, 0, 120, 160, server_name) do
        self.font      = '/home/daburutti/Test/GenEiNuGothic-EB.ttf'
        self.fill      = '#1f69e0'
        self.stroke    = 'transparent'
        self.pointsize = 50
        self.gravity   = Magick::NorthWestGravity
    end

    img.write("/home/daburutti/Testgo/tw.png")
    images = []
    images << File.new('/home/daburutti/Testgo/tw.png')
    puts twstr
    res = @client.update_with_media(twstr, images)
    #puts res
    #@client.update("#{twstr}")
end

def Get_Server_Status(ip,port)
    begin
    @server = SourceServer.new(ip, port.to_i)
    @server.init
    serverdata = "#{@server}"
    
    player =  @server.players
    mapname = serverdata.match(/map_name: "(.+)"/)
    servername = serverdata.match(/server_name: "(.+)"/)
    maxplayer = serverdata.match(/max_players:\s(.+)/)
    players = serverdata.match(/number_of_players:\s(.+)/)
    bot = serverdata.match(/number_of_bots:\s(.+)/)
    tag = serverdata.match(/server_tags: "(.+)"/)
    ver = serverdata.match(/game_version: "(.+)"/)
    os = serverdata.match(/operating_system: "(.+)"/)

    servernamemeta = servername[1]

    mapname = mapname[1]
    
    if servernamemeta.length > 26 then
        servernamemeta = servernamemeta.slice(0, 26)
    end

    #trueplayer = players[1].to_i - bot[1].to_i
    trueplayer = players[1].to_i

#puts server.players("0000")
#puts server.players.to_json
#puts server
    servername = servername[1]

     puts "#{servernamemeta}:#{trueplayer}/#{maxplayer[1]} at #{ip}:#{port}"
    if trueplayer.to_i == maxplayer[1].to_i then
        wow_such_a_super_hot_server(servername,trueplayer,maxplayer[1],ip,port,mapname,tag[1],ver[1],os[1])
        return
    end

    if trueplayer.to_i / maxplayer[1].to_i.to_f > 0.85 then
        wow_such_a_hot_server(servername,trueplayer,maxplayer[1],ip,port,mapname,tag[1],ver[1],os[1])
        #wow_such_a_super_hot_server(servername,trueplayer,maxplayer[1],ip,port,mapname,tag[1],ver[1],os[1])
        return
    end

    if trueplayer.to_i  > 23 then
        wow_such_a_hot_server(servername,trueplayer,maxplayer[1],ip,port,mapname,tag[1],ver[1],os[1])
        #wow_such_a_super_hot_server(servername,trueplayer,maxplayer[1],ip,port,mapname,tag[1],ver[1],os[1])
        return
    end

    #puts "経過"
    if trueplayer.to_i > 0 then
        #puts "#{servername[1]}:#{trueplayer}/#{maxplayer[1]}"
        if mapname.length > 29 then
            mapname = mapname.slice(0, 28)
            mapname = "#{mapname}..."
        end
        ary = @tw.length - 1
        arynext = @tw.length
        if @tw[ary].encode("EUC-JP").bytesize + "#{servernamemeta}:#{trueplayer}/#{maxplayer[1]}\n#{mapname}".encode("EUC-JP").bytesize > 280 then
            #puts "経過1"
            @tw[arynext] = "鯖温め中!(その#{arynext + 1})\n#{servernamemeta}:#{trueplayer}/#{maxplayer[1]}\n#{mapname}"
        else
            #puts "経過2"
        @tw[ary] = "#{@tw[ary]}\n#{servernamemeta}:#{trueplayer}/#{maxplayer[1]}\n#{mapname}"
        return
        end
    end

    rescue => exception
        puts exception
    end

  end

serverip = ""
File.open('/home/daburutti/Testgo/sdgolist.txt', 'r:utf-8') do |f|
    f.each_line do |line|
        serverip = line.match(/(.+):/)
        serverport = line.match(/:(.+)/)
    Get_Server_Status(serverip[1],serverport[1])
    end
end

@page = 0

while @tw[@page] != nil do
    puts @tw[@page]
    if @tw[@page].length < 8 then
        break
    end
    @client.update("#{@tw[@page]}")
    @page = @page + 1
  end
