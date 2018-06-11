//使用数機能などの宣言
#include <sourcemod>
#include <tf2_stocks>
#include <tf2_morestocks>
#include <tf2>
#include <morecolors>

new votes[10][2];
//new votes[][] = {5,3,9,2,4,6,7,1,8,10};

//Cvar宣言
new ConVar:cw_class;

//グローバル変数とかの宣言
//new bool:doflag = true;
new bool:firstflag = false;
new bool:isEnable = false;
new bool:isFirst = true;
//new char classname[] = "";
new String:s_classname[32];

//文字の先頭につくやつ
new String:cw[32] = "{white}[{gold}CW{white}]";

//メニュー
new Menu:votemenu;
new class_i = 1;
new votestate = 0;


//プラグイン情報を記述
public Plugin:myinfo = 
{
	name = "[TF2] Class war!",
	author = "DABURUTTI",
	description = "クラスウォーをきっちり行うためのプラグイン",
	version = "1.0.0",
	url = "https://twitter.com/kaban_chan_tf2",
}

//プラグインが最初に読み込まれた
public OnPluginStart()
{
    //Cvar登録
    cw_class = CreateConVar("sm_cw_class", "0", "0:stop any:Setclass");
    //Cvarの変更を監視
    cw_class.AddChangeHook(OnCwModeChanged);
	
    //RegAdminCmd("cw_start", cw_start, ADMFLAG_KICK, "クラスウォー勃発時に実行される");
    //コマンドを登録
    RegAdminCmd("cw_class_select", cw_class_select, ADMFLAG_KICK, "クラスウォー開始処理");
    
    //イベントを監視
    HookEvent("teamplay_round_win", Evemt_round_win);
    
    //コールバック追加
    AddCommandListener (OnPlayerChangeclass, "joinclass");
    votemenu = CreateMenu(MenuHandler1,MENU_ACTIONS_ALL);
    createmenu();

    // for(int i=0; i <= 9; i ++)
    // {
    //     votes[i] = 0;
    // }
}

//ラウンドが終了したので終了処理
public Action:Evemt_round_win(Handle:event, const String:name[], bool:dont_broadcast)
{
    //無効なら処理しない
    if(GetConVarInt(cw_class) == 0)
    {
        return;
    }
    CPrintToChatAll("%s{hure1}ラウンド終了に伴い、クラス制限を解除しました！",cw,s_classname);
    cw_stop_task();
}
//共通の終了処理
public Action cw_stop_task()
{
    //フラグをもとに戻す
    isFirst = true;
    isEnable = false;
    class_i = 1;
    votestate = 0;
    firstflag = false;

    //二次配列を初期化
    for(int i=0; i <= 9; i ++)
    {
        votes[i][0] = 0;
    }
    votes[0][0] = 33;
    votes[0][1] = 0;
    votes[1][1] = 1;
    votes[2][1] = 3;
    votes[3][1] = 7;
    votes[4][1] = 4;
    votes[5][1] = 6;
    votes[6][1] = 9;
    votes[7][1] = 5;
    votes[8][1] = 2;
    votes[9][1] = 8;
}

//メニュー項目を追加
public Action createmenu()
{
	//項目追加
    votemenu.SetTitle("遊びたいクラスに投票してください！");
    votemenu.AddItem("1","スカウト");
    votemenu.AddItem("2","ソルジャー");
    votemenu.AddItem("3","パイロ");
    votemenu.AddItem("4","デモマン");
    votemenu.AddItem("5","ヘビー");
    votemenu.AddItem("6","エンジニア");
    votemenu.AddItem("7","メディック");
    votemenu.AddItem("8","スナイパー");
    votemenu.AddItem("9","スパイ");
    //終了ﾎﾞﾀﾝは表示しない
    votemenu.ExitButton = false;
}


//マップがロードされた
public OnMapStart()
{
    //終了処理で初期化
    cw_stop_task();
}

//コマンドが実行された
public Action cw_class_select(int client, int args)
{
    //すでに実行されているか確認
    if(!isFirst)
    {
        CPrintToChatAll("%s{hure2}すでにクラスウォーモードが有効です！\nクラス変更をする場合は一度終了してください",cw);
        return Plugin_Handled;
    }

    //すべてのクライアントに対して送信
    for(int i = 1; i <= MaxClients; i++)
	{
        //ゲームに参加しているか
        if(!IsClientInGame(i))
        {
            continue;
        }
        //メニュー表示
        votemenu.Display(i,10)
    }
    //タイムアウトを設定する
    CreateTimer(10.0,vote_timeout);

    return Plugin_Handled;
}

//メニューコールバック
public int MenuHandler1(Menu votemenu, MenuAction action, int param1, int param2)
{
    //メニューのActionによって分岐
	switch(action)
	{
        //メニューが表示されたとき
		case MenuAction_Start:
		{
			//PrintToServer("クラス投票を開始しました！");
		}
        //メニューのあいてむが選択された
		case MenuAction_Select:
		{
            //メニューの項目を取得して処理する
            char info[32];
            votemenu.GetItem(param2, info, sizeof(info));
            int x = StringToInt(info);
            
            votes[x][0] = votes[x][0] + 1;
            votestate = votestate + 1;
            setClassname(votes[x][1]);
            CPrintToChat(param1,"%s{hure2}あなたは{hure4}%s{hure2}に投票しました",cw,s_classname)
            //全員の投票が終わっているかチェック
            if(votestate == Get_number_of_players())
            {
           
                voteend();
                return 0;
            }
            //終わっていなかった
            CPrintToChat(param1,"%s{hure2}投票が完了するまでお待ちください",cw);
		}
        
	}return 0;
}

//投票がタイムアウトする処理
public Action:vote_timeout(Handle:timer)
{
    //メニューを消す
    CancelMenu(votemenu);
    voteend();
    return Plugin_Continue;
}

//プレイヤーの人数を返すメソッド
public int Get_number_of_players()
{
    int i = 0;
    for(int x = 1;x < MaxClients;x++)
    {
        if(!IsClientInGame(x))
        {
            continue;
        }
        i ++;
    }

    return i;
}

//投票が終了
public Action voteend()
{
    //ダブり回避
    if(!isFirst)
    {
        return Plugin_Handled;
    }
    isFirst = false;
    //int class = 1;

    //バブルソートで配列を得票順に並び変える
    //少ないのでこれで問題なし
    for(int i=0; i < 10; i++)
    {
        for(int j=0; j < 10-i-1; j++)
        {
            if(votes[j][0] < votes[j+1][0]) 
            {
            	int asc = votes[j][0];
                int tmp = votes[j][1];
            	votes[j][0] = votes[j+1][0];
                votes[j][1] = votes[j+1][1];

            	votes[j+1][0] = asc;
                votes[j+1][1] = tmp;

            }
        }
    }
    
    //上位３つを表示させる
    CPrintToChatAll("{hure3}===投票結果（トップ３）===");
    for(int i=1; i <= 3; i ++)
    {
        //得票がゼロだったら表示しない
        if(votes[i][0] == 0)
        {
            continue;
        }
        setClassname(votes[i][1]);
        CPrintToChatAll("{sienna}%s{default}:%i票",s_classname,votes[i][0]);
    }
    CPrintToChatAll("{hure3}================");
    //一位が二つ以上あった場合の処理
    int iqustatus = 1;
    for(int i= 1; i < 9;i++)
    {
        //配列の値が同一か？
        if(votes[i][0] == votes[i+1][0])
        {
            iqustatus ++;
        }
        else
        {
            break;
        }
    }

    //ダブった中からランダムに一つ選ぶ
    //ダブってなくても結局1が返るのでOK
    int classnum = GetRandomInt(1, iqustatus);
    setClassname(votes[classnum][1]);
    
    //ダブりがあった時の表示
    if(iqustatus != 1){
        CPrintToChatAll("%s{hure3}TOP%iの中から、{hure4}%s{hure3}が選ばれました！\n5秒後にクラス変更を行います...",cw,iqustatus,s_classname);
    }
    //なかった時
    else{
        CPrintToChatAll("%s{hure3}選ばれたクラスは{hure4}%s{hure3}です！\n5秒後にクラス変更を行います...",cw,s_classname);
    }

    //遅延して実行
    CreateTimer(5.0,Fire_cw,votes[classnum][1]);
    return Plugin_Handled;
}

//Cvarを設定して、クラスウォー開始処理に移る
public Action:Fire_cw(Handle:timer,any iclass)
{
    SetConVarInt(cw_class,iclass);
}

//Cvarの値が変更された
public void OnCwModeChanged(ConVar convar, char[] oldValue, char[] newValue)
{
    //クラスウォー勃発　フラグを立てる
    isEnable = true;

    //Cvarの値を代入
    class_i = GetConVarInt(cw_class);

    //Cvarが０に設定されたらクラスウォーを終了
    if(class_i == 0)
    {
        CPrintToChatAll("%s{hure1}クラスウォーモードを終了しました",cw,s_classname);
        cw_stop_task();

        return;
    }
    //全プレイヤーに対してチャットを送信
    CPrintToChatAll("%s{hure5}クラスウォーモードスタート！",cw);
    
    //すべてのクライアントに対して実行
    for (int i=1; i<=MaxClients; i++)
	{
        //指定したクライアントはゲーム内にいるか
		if (!IsClientInGame(i))
		{
            //いなかった
			continue;
		}
        //存在するプレイヤーのクラスは設定されたクラスか？
        if(TF2_GetPlayerClass(i) != GetClassType(class_i))
        {
            //違ったのでクラスを変更
            TF2_SetPlayerClass(i,GetClassType(class_i));
            //リスポーンさせる
            TF2_RespawnPlayer(i);
            CPrintToChat(i,"%s{hure6}あなたのクラスは強制的に変更されました",cw);
        }
	}

    //処理が終わったのでラウンドをリスタート(没機能)
    //ServerCommand("mp_restartgame 5");

    //同じ処理を二度しないようにするための処理
    firstflag = true;

}

//プレイヤーがクラスを変更したとき
public Action:OnPlayerChangeclass(client, const String:command[], argc)
{
    //↓クラスウォーモード中に途中参加してきた人用の処理↓
    //プラグインは有効か？これは二度目以降の実行か？プレイヤーのクラスは指定されたものと違うのか？
    if(isEnable && firstflag && TF2_GetPlayerClass(client) != GetClassType(class_i))
    {
       //違ったのでクラスを変更
        TF2_SetPlayerClass(client,GetClassType(class_i));
        //リスポーンさせる
        TF2_RespawnPlayer(client);
        //クラス変更をしたプレイヤーに対してチャットを送信
        CPrintToChat(client,"%s{hure6}現在クラスウォーモードが有効なため\nあなたのクラスは強制的に変更されました",cw);
        //もともとのイベント（クラス変更）をキャンセル
        return Plugin_Handled;
    }

    //↓クラスウォーモード中にクラスを変更しようとした↓
    if(isEnable && firstflag)
    {
        //それは無理ですね、と送信
        CPrintToChat(client,"%s{hure6}現在クラスウォーモードが有効なため\nクラス変更ができません",cw);
        //イベント(クラス変更)をキャンセル
        return Plugin_Handled;
	}

    //エラー回避
    return Plugin_Continue;
}

//クラスの名前をグローバル変数に代入する
//SoucemodってString返せない...?
public Action setClassname(int i_class)
{
    //i_classの内容によって分岐する
    switch(i_class)
    {
        //i_classが１だったら...
        case 1:
        {
            //"スカウト"にする
            s_classname = "スカウト";
        }
        case 2:
        {
            //以後同じ処理....
            s_classname = "スナイパー";
        }
        case 3:
        {
            s_classname = "ソルジャー";
        }
        case 4:
        {
            s_classname = "デモマン";
        }
        case 5:
        {
            s_classname = "メディック";
        }
        case 6:
        {
            s_classname = "ヘビー";
        }
        case 7:
        {
            s_classname = "パイロ";
        }
        case 8:
        {
            s_classname = "スパイ";
        }
        case 9:
        {
            s_classname = "エンジニア";
        }
        
    }
    return Plugin_Handled;
}
//数字から、クラスタイプを取得するメソッド
//戻り値は "TFClassType" メソッド名は "GetClassType" 整数を"i_class"として受け取る
public TFClassType GetClassType(int i_class)
{
    //i_classの内容によって分岐する
    switch(i_class)
    {
        //i_classが１だったら...
        case 1:
        {
            //"TFClass_Scout"　を返す
            return TFClass_Scout;
        }

        //以後同じ処理....
        case 2:
        {
            return TFClass_Sniper;
        }

        case 3:
        {
            return TFClass_Soldier;
        }

        case 4:
        {
            return TFClass_DemoMan;
        }

        case 5:
        {
            return TFClass_Medic;
        }

        case 6:
        {
            return TFClass_Heavy;
        }

        case 7:
        {
            return TFClass_Pyro;
        }

        case 8:
        {
            return TFClass_Spy;
        }

        case 9:
        {
            return TFClass_Engineer;
        }
    }

    //それらに合致しなかった
    //"TFClass_Unknown" を返す（エラー回避）
    return TFClass_Unknown;
}