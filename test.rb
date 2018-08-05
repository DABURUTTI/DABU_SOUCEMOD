require 'discordrb'
require 'steam-condenser'

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
        puts exception
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
	
		puts ("#{DateTime.now} => メッセージを送信しました[osiete]")

	rescue => error # 変数(例外オブジェクトの代入)
	
		event.send_message("#{error}")

	end

end

bot.command :help do |event|

	puts ("#{DateTime.now} => メッセージを送信しました[help]")
	event.send_message("じゃあ、簡単に説明しますね...\n------------------------------------------\nコマンド   内容\n!help   この説明を表示します\n!osiete   フレンズサーバーのログイン情報を返します\n!debug   デバッグ用 生の情報を返します\nなおこのBOTはフレンズサーバーグルだけでなく、個人チャットにも反応します")

end
	
bot.command :debug do |event|

	puts ("#{DateTime.now} => メッセージを送信しました[debug]")

	server =  SourceServer.new('122.210.136.164', 27015)
	server.init
	
	event.send_message("サーバー応答[OK] => 取得時間:#{DateTime.now}\nサーバーリスト[0]\n---------------サーバー基本情報---------------\n#{server}\n---------------プレイヤー情報---------------\n#{server.players}\n------------------------------")
	
	server =  SourceServer.new('122.210.136.164', 27016)
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
				puts "通貨１"
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
				puts "通貨２"
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

bot.run
