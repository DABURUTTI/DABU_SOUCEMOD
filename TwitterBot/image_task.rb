require 'rmagick'

class ImageTask
    def wow_such_a_hot_server(hotdata,data)
          img = Magick::ImageList.new("./cs_go_bg.png")
          draw = Magick::Draw.new
          int = 0
          #puts @server.players


      
          puts data.to_json
          #puts data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[][1]["name"]
          
      
          draw.annotate(img, 0, 0, 175, 365, data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[0][1]["name"]) do
              self.font      = './NotoSansCJKjp-Medium.otf'
              self.fill      = 'Black'
              self.stroke    = 'transparent'
              self.pointsize = 48
              self.gravity   = Magick::NorthWestGravity
          end
      
          draw.annotate(img, 0, 0, 175, 428, "Score:#{data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[0][1]["score"]}   Time:#{data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[0][1]["time"]}min") do
              self.font      = './NotoSansCJKjp-Medium.otf'
              self.fill      = '#424242'
              self.stroke    = 'transparent'
              self.pointsize = 20
              self.gravity   = Magick::NorthWestGravity
          end
      
          draw.annotate(img, 0, 0, 175, 475,  data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[1][1]["name"]) do
              self.font      = './NotoSansCJKjp-Medium.otf'
              self.fill      = 'Black'
              self.stroke    = 'transparent'
              self.pointsize = 48
              self.gravity   = Magick::NorthWestGravity
          end
      
          draw.annotate(img, 0, 0, 175, 538, "Score:#{data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[1][1]["score"]}   Time:#{data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[1][1]["time"]}min") do
              self.font      = './NotoSansCJKjp-Medium.otf'
              self.fill      = '#424242'
              self.stroke    = 'transparent'
              self.pointsize = 20
              self.gravity   = Magick::NorthWestGravity
          end
          draw.annotate(img, 0, 0, 175, 585,  data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[2][1]["name"]) do
              self.font      = './NotoSansCJKjp-Medium.otf'
              self.fill      = 'Black'
              self.stroke    = 'transparent'
              self.pointsize = 48
              self.gravity   = Magick::NorthWestGravity
          end
      
          draw.annotate(img, 0, 0, 175, 648, "Score:#{data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[2][1]["score"]}   Time:#{data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[2][1]["time"]}min") do
              self.font      = './NotoSansCJKjp-Medium.otf'
              self.fill      = '#424242'
              self.stroke    = 'transparent'
              self.pointsize = 20
              self.gravity   = Magick::NorthWestGravity
          end
          draw.annotate(img, 0, 0, 175, 695,  data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[3][1]["name"]) do
              self.font      = './NotoSansCJKjp-Medium.otf'
              self.fill      = 'Black'
              self.stroke    = 'transparent'
              self.pointsize = 48
              self.gravity   = Magick::NorthWestGravity
          end
      
          draw.annotate(img, 0, 0, 175, 758, "Score:#{data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[3][1]["score"]}   Time:#{data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[3][1]["time"]}min") do
              self.font      = './NotoSansCJKjp-Medium.otf'
              self.fill      = '#424242'
              self.stroke    = 'transparent'
              self.pointsize = 20
              self.gravity   = Magick::NorthWestGravity
          end
          draw.annotate(img, 0, 0, 175, 805,  data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[4][1]["name"]) do
              self.font      = './NotoSansCJKjp-Medium.otf'
              self.fill      = 'Black'
              self.stroke    = 'transparent'
              self.pointsize = 48
              self.gravity   = Magick::NorthWestGravity
          end
      
          draw.annotate(img, 0, 0, 175, 868, "Score:#{data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[4][1]["score"]}   Time:#{data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[4][1]["time"]}min") do
              self.font      = './NotoSansCJKjp-Medium.otf'
              self.fill      = '#424242'
              self.stroke    = 'transparent'
              self.pointsize = 20
              self.gravity   = Magick::NorthWestGravity
          end
          draw.annotate(img, 0, 0, 175, 915, data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[5][1]["name"]) do
              self.font      = './NotoSansCJKjp-Medium.otf'
              self.fill      = 'Black'
              self.stroke    = 'transparent'
              self.pointsize = 48
              self.gravity   = Magick::NorthWestGravity
          end
      
          draw.annotate(img, 0, 0, 175, 978, "Score:#{data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[5][1]["score"]}   Time:#{data["Player"].sort_by {| a,b | b["score"].to_i}.reverse[5][1]["time"]}min") do
              self.font      = './NotoSansCJKjp-Medium.otf'
              self.fill      = '#424242'
              self.stroke    = 'transparent'
              self.pointsize = 20
              self.gravity   = Magick::NorthWestGravity
          end
          map_name = hotdata[0]["mapname"]
          if hotdata[0]["mapname"].length > 21 then
              map_name = hotdata[0]["mapname"].slice(0, 21)
              map_name = "#{map_name}..."
          end


          draw.annotate(img, 0, 0, 470, -125, map_name) do
              self.font      = './NotoSansCJKjp-Bold.otf'
              self.fill      = '#000000'
              self.stroke    = 'transparent'
              self.pointsize = 50
              self.gravity   = Magick::CenterGravity
          end
      
          draw.annotate(img, 0, 0, 470, -15, "#{hotdata[0]["player"]}/#{hotdata[0]["maxplayer"]}") do
              self.font      = './NotoSansCJKjp-Bold.otf'
              self.fill      = '#000000'
              self.stroke    = 'transparent'
              self.pointsize = 50
              self.gravity   = Magick::CenterGravity
          end
      
          draw.annotate(img, 0, 0, 470, 95, "#{hotdata[0]["ip"]}:#{hotdata[0]["port"]}") do
              self.font      = './NotoSansCJKjp-Bold.otf'
              self.fill      = '#000000'
              self.stroke    = 'transparent'
              self.pointsize = 50
              self.gravity   = Magick::CenterGravity
          end
        tag = hotdata[0]["tag"]
          if hotdata[0]["tag"].length > 35 then
              tag = hotdata[0]["tag"].slice(0, 35)
              tag = "#{tag}..."
          end
          draw.annotate(img, 0, 0, 470, 205, tag) do
              self.font      = './NotoSansCJKjp-Bold.otf'
              self.fill      = '#000000'
              self.stroke    = 'transparent'
              self.pointsize = 30
              self.gravity   = Magick::CenterGravity
          end
      
          draw.annotate(img, 0, 0, 470, 315, hotdata[0]["ver"]) do
              self.font      = './NotoSansCJKjp-Bold.otf'
              self.fill      = '#000000'
              self.stroke    = 'transparent'
              self.pointsize = 50
              self.gravity   = Magick::CenterGravity
          end
          if hotdata[0]["os"] == "l" then
              os = "Linux"
          else
              os = "Windows"
          end
          draw.annotate(img, 0, 0, 470, 425, os) do
              self.font      = './NotoSansCJKjp-Bold.otf'
              self.fill      = '#000000'
              self.stroke    = 'transparent'
              self.pointsize = 50
              self.gravity   = Magick::CenterGravity
          end

          draw.annotate(img, 0, 0, 120, 145, hotdata[0]["servername"]) do
              self.font      = './NotoSansCJKjp-Bold.otf'
              self.fill      = '#1f69e0'
              self.stroke    = 'transparent'
              self.pointsize = 50
              self.gravity   = Magick::NorthWestGravity
          end

          img.write("./tweet.png")
      end

      def omg_a_lot_of_hot_server(data)
        img = Magick::ImageList.new("./cs_go_bg_2.png")
        draw = Magick::Draw.new

        overlay = Magick::ImageList.new("./panel.png")

        img.composite!(overlay, 15, 150, Magick::OverCompositeOp)

        draw.annotate(img, 0, 0, 145, 179, data[0]["servername"]) do
            self.font      = './NotoSansCJKjp-Bold.otf'
            self.fill      = '#000000'
            self.stroke    = 'transparent'
            self.pointsize = 50
            self.gravity   = Magick::NorthWestGravity
        end

        draw.annotate(img, 0, 0, 165, 272, "#{data[0]["player"]}/#{data[0]["maxplayer"]}") do
            self.font      = './NotoSansCJKjp-Medium.otf'
            self.fill      = '#000000'
            self.stroke    = 'transparent'
            self.pointsize = 50
            self.gravity   = Magick::NorthWestGravity
        end

        draw.annotate(img, 0, 0, 475, 272, data[0]["mapname"]) do
            self.font      = './NotoSansCJKjp-Medium.otf'
            self.fill      = '#000000'
            self.stroke    = 'transparent'
            self.pointsize = 50
            self.gravity   = Magick::NorthWestGravity
        end

        img.composite!(overlay, 15, 380, Magick::OverCompositeOp)

        draw.annotate(img, 0, 0, 145, 409, data[1]["servername"]) do
            self.font      = './NotoSansCJKjp-Bold.otf'
            self.fill      = '#000000'
            self.stroke    = 'transparent'
            self.pointsize = 50
            self.gravity   = Magick::NorthWestGravity
        end

        draw.annotate(img, 0, 0, 165, 502, "#{data[1]["player"]}/#{data[1]["maxplayer"]}") do
            self.font      = './NotoSansCJKjp-Medium.otf'
            self.fill      = '#000000'
            self.stroke    = 'transparent'
            self.pointsize = 50
            self.gravity   = Magick::NorthWestGravity
        end

        draw.annotate(img, 0, 0, 475, 502, data[1]["mapname"]) do
            self.font      = './NotoSansCJKjp-Medium.otf'
            self.fill      = '#000000'
            self.stroke    = 'transparent'
            self.pointsize = 50
            self.gravity   = Magick::NorthWestGravity
        end

        if data.length > 2 then
        img.composite!(overlay, 15, 610, Magick::OverCompositeOp)

        draw.annotate(img, 0, 0, 145, 639, data[2]["servername"]) do
            self.font      = './NotoSansCJKjp-Bold.otf'
            self.fill      = '#000000'
            self.stroke    = 'transparent'
            self.pointsize = 50
            self.gravity   = Magick::NorthWestGravity
        end

        draw.annotate(img, 0, 0, 165, 732, "#{data[2]["player"]}/#{data[2]["maxplayer"]}") do
            self.font      = './NotoSansCJKjp-Medium.otf'
            self.fill      = '#000000'
            self.stroke    = 'transparent'
            self.pointsize = 50
            self.gravity   = Magick::NorthWestGravity
        end

        draw.annotate(img, 0, 0, 475, 732, data[2]["mapname"]) do
            self.font      = './NotoSansCJKjp-Medium.otf'
            self.fill      = '#000000'
            self.stroke    = 'transparent'
            self.pointsize = 50
            self.gravity   = Magick::NorthWestGravity
        end

        end

        if data.length > 3 then
        img.composite!(overlay, 15, 840, Magick::OverCompositeOp)

        draw.annotate(img, 0, 0, 145, 869, data[3]["servername"]) do
            self.font      = './NotoSansCJKjp-Bold.otf'
            self.fill      = '#000000'
            self.stroke    = 'transparent'
            self.pointsize = 50
            self.gravity   = Magick::NorthWestGravity
        end

        draw.annotate(img, 0, 0, 165, 962, "#{data[3]["player"]}/#{data[3]["maxplayer"]}") do
            self.font      = './NotoSansCJKjp-Medium.otf'
            self.fill      = '#000000'
            self.stroke    = 'transparent'
            self.pointsize = 50
            self.gravity   = Magick::NorthWestGravity
        end

        draw.annotate(img, 0, 0, 475, 962, data[3]["mapname"]) do
            self.font      = './NotoSansCJKjp-Medium.otf'
            self.fill      = '#000000'
            self.stroke    = 'transparent'
            self.pointsize = 50
            self.gravity   = Magick::NorthWestGravity
        end

        end
        img.write("./tweet.png")

        puts "OK2"
      end
end
