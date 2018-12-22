require 'rmagick'
require 'json'
require 'twitter'
require 'steam-condenser'

require './image_task.rb'

@imagetask = ImageTask.new

@qeue = 0

@tw = []

@tw[0] = "鯖温め中!"

@server

@hotserverdata = Hash.new { |hash,key| hash[key] = Hash.new { |hash,key| hash[key] = {} } }

@client = Twitter::REST::Client.new do |config|
    config.consumer_key        = ""
    config.consumer_secret     = ""
    config.access_token        = ""
    config.access_token_secret = ""
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

    if servernamemeta.length > 28 then
        servernamemeta = servernamemeta.slice(0, 29)
    end

    #trueplayer = players[1].to_i - bot[1].to_i
    trueplayer = players[1].to_i

#puts server.players("0000")
#puts server.players.to_json
#puts server
    servername = servername[1]

     puts "#{servernamemeta}:#{trueplayer}/#{maxplayer[1]} at #{ip}:#{port}"
    # if trueplayer.to_i == maxplayer[1].to_i then
    #     wow_such_a_super_hot_server(servername,trueplayer,maxplayer[1],ip,port,mapname,tag[1],ver[1],os[1])
    #     return
    # end

    if trueplayer.to_i / maxplayer[1].to_i.to_f > 0.85 || trueplayer.to_i  > 23 then

        @hotserverdata[@qeue]["servername"] = servername
        @hotserverdata[@qeue]["player"] = trueplayer
        @hotserverdata[@qeue]["maxplayer"] = maxplayer[1].to_i
        @hotserverdata[@qeue]["ip"] = ip
        @hotserverdata[@qeue]["port"] = port.to_i
        @hotserverdata[@qeue]["mapname"] = mapname
        @hotserverdata[@qeue]["tag"] = tag[1]
        @hotserverdata[@qeue]["ver"] = ver[1]
        @hotserverdata[@qeue]["os"] = os[1]

        @qeue = @qeue + 1

        return
    end

    if trueplayer.to_i > 0 then
        #puts "#{servername[1]}:#{trueplayer}/#{maxplayer[1]}"
        if mapname.length > 29 then
            mapname = mapname.slice(0, 28)
            mapname = "#{mapname}..."
        end
        ary = @tw.length - 1
        arynext = @tw.length
        if @tw[ary].encode("EUC-JP").bytesize + "#{servernamemeta}:#{trueplayer}/#{maxplayer[1]}\n・#{mapname}".encode("EUC-JP").bytesize > 275 then
            #puts "経過1"
            @tw[arynext] = "鯖温め中!(その#{arynext + 1})\n#{servernamemeta}:#{trueplayer}/#{maxplayer[1]}\n・#{mapname}"
        else
            #puts "経過2"
        @tw[ary] = "#{@tw[ary]}\n#{servernamemeta}:#{trueplayer}/#{maxplayer[1]}\n・#{mapname}"
        return
        end
    end

    rescue => exception
         puts exception
     end

  end

serverip = ""
File.open('./serverlist.txt', 'r:utf-8') do |f|
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

if @hotserverdata.length == 1 then
    Get_Server_Status(@hotserverdata[0]["ip"],@hotserverdata[0]["port"])
    data = Hash.new { |hash,key| hash[key] = Hash.new { |hash,key| hash[key] = {} } }
    for x in 0...6 do
        data["Player"][x]["name"] = "-"
        data["Player"][x]["score"] = 0
        data["Player"][x]["time"] = 0
    end
    int = 0
    @server.players.each do |value , key|
        # key.to_s

        begin
            name = key.to_s.match(/#0 "(.+)\"/)[1]
        rescue
            name = "-Joining-"
        end
        begin
        score = key.to_s.match(/Score:\s(.+),/)[1]
    rescue => exception
        puts exception
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
    puts data.to_json
    twstr = ""
    @imagetask.wow_such_a_hot_server(@hotserverdata,data)
    if @hotserverdata[0]["player"] == @hotserverdata[0]["maxplayer"] then
        twstr = "#{@hotserverdata[0]["servername"].gsub(/#/, "")} が満員で激アツだっ！Join戦争だっ！\n現在のTOP「#{data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[0][1]["name"]}」スコア:#{data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[0][1]["score"]}\nプレイ中のマップ「#{@hotserverdata[0]["mapname"]}」\n#{@hotserverdata[0]["ip"]}:#{@hotserverdata[0]["port"]}"
    else
        twstr = "#{@hotserverdata[0]["servername"].gsub(/#/, "")} がアツいっ！(#{@hotserverdata[0]["player"]}/#{@hotserverdata[0]["maxplayer"]})今すぐ参加だっ！\n現在のTOP「#{data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[0][1]["name"]}」スコア:#{data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[0][1]["score"]}\nプレイ中のマップ「#{@hotserverdata[0]["mapname"]}」\n#{@hotserverdata[0]["ip"]}:#{@hotserverdata[0]["port"]}"
    end

    images = []
    images << File.new('./tweet.png')
    res = @client.update_with_media(twstr, images)
    puts res
elsif @hotserverdata.length > 1 then
    @imagetask.omg_a_lot_of_hot_server(@hotserverdata)
    images = []
    images << File.new('./tweet.png')

    twstr2 = ""

    for key, value in @hotserverdata do

    name_out = value["servername"]
    if  value["servername"].length > 28 then
        name_out = value["servername"].slice(0, 29)
    end

    twstr2 = "#{twstr2}#{name_out}:#{value["player"]}/#{value["maxplayer"]}\n"
    #gputs @hotserverdata[i]["servername"]

    end

    res = @client.update_with_media("複数の鯖が熱いぜっ！\n#{twstr2}", images)
    puts res

end


#puts @hotserverdata.to_json

#puts @hotserverdata.length
