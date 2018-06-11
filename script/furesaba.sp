#include <sourcemod>
#include <tf2_stocks>
#include <tf2>
#include <tf2_morestocks>

public Plugin:myinfo = 
{
	name = "[TF2]フレ鯖ユーティリティ",
	author = "DABURUTTI",
	description = "ラウンドの時間、ラウンド数、自動投票開始などを操作します",
	version = "1.0.0",
	url = "http://www.daburutti.site/wp-content/tf2/site",
}


new String:Show_text[255];//HUDのに表示する文字
new String:maptype[255];//マップ名を格納
new bool:flag = true;//一度だけ実行するためのフラグ
new String:s_gametype[255];

public OnPluginStart()
{	
	HookEvent("teamplay_round_start", Event_round_start);
}

public OnMapStart()
{
	CreateTimer(5.0,maintask);
	flag = true;
}

public Action:Cmd_setupend(client, args){
	new ent = -1;
	ent = FindEntityByClassname(ent, "team_round_timer");
	
	if(ent == -1){
		return false;
	}
	
	FireEntityOutput(ent,"OnSetupFinished");
	
}

public Action:Event_round_start(Handle:event, const String:name[], bool:dont_broadcast)
{
	//一度だけ起動する、かつKOTHマップではない、(TF2_GetRoundTimeLeftはKOTHで実行するとエラーがおこるため)
	if(flag&&!TF2_IsGameModeKoth())
	{	
		int timeleft;
		TF2TimerState state = TF2_GetRoundTimeLeft(timeleft);
		if(state == 3 || state == 5)
		{	
			CreateTimer(1.0,showtext_welcome);//Ｗｅｌｃｏｍｅメッセージを表示
			CreateTimer(7.0,showtext);//ラウンドの設定を表示
			flag = false;//フラグを折る
		}
	}
	else if (flag&&TF2_IsGameModeKoth()&&GetMapType() == 1)
	{	
		int redClock;
		int bluClock;
		TF2TimerState state = TF2_GetKothClocks(redClock, bluClock);
		if(state == 4)
		{
			CreateTimer(1.0,showtext_welcome);
			CreateTimer(7.0,showtext);
			CreateTimer(13.0,showtext_armrace);
			flag = false;
		}
	}
	
	else if (flag&&TF2_IsGameModeKoth()&&GetMapType() == 2)
	{	
		int redClock;
		int bluClock;
		TF2TimerState state = TF2_GetKothClocks(redClock, bluClock);
		if(state == 4)
		{
			CreateTimer(6.0,showtext);
			flag = false;
		}
	}
}

public Action:showtext_welcome(Handle:timer)
{
	new String:mapname[255] = "";
	new String:usrname[255] = "";
	GetMapDisplayName(maptype,mapname,255);
	SetHudTextParams(-1.0, 0.25, 5.0, 255, 255, 255, 255,1,1.0,0.5,0.5);
	for(int i = 1; i <= MaxClients; i++)
	{
		//クライアントはゲーム中か？BOTではないか？
		if( IsClientInGame(i) && IsFakeClient(i) == false)
		{
			GetClientName(i,usrname,255);
			ShowHudText(i,-1,"-[JP]フレンズサーバーへようこそ、%s!-\n\nプレイ中のマップは[%s] %s",usrname,s_gametype,mapname);
		}
	}
	
}


public Action:showtext_armrace(Handle:timer)
{
	SetHudTextParams(-1.0, 0.25, 5.0, 255, 255, 255, 255,1,1.0,0.5,0.5);
	for(int i = 1; i <= MaxClients; i++)
	{
		//クライアントはゲーム中か？BOTではないか？
		if( IsClientInGame(i) && IsFakeClient(i) == false)
		{
			ShowHudText(i,-1,"-特殊ルール-\n\nフレンズ鯖のKOTHでは軍拡競争をプレイできます！(投票制)");
		}
	}
	CreateTimer(2.5,AskArmrace);
	
}

public Action:AskArmrace(Handle:timer)
{
	//軍拡競争にするか尋ねる
	PrintToChatAll("この投票は自動で呼び出されました");
	ServerCommand("sm_cvote 3_auto_2");
	return true;
}

public Action:showtext(Handle:timer)
{
	//HUDを設定する
	SetHudTextParams(-1.0, 0.25, 5.0, 255, 255, 255, 255,1,1.0,0.5,0.5);
	//すべてのクライアントに送信
	for(int i = 1; i <= MaxClients; i++)
	{
		//クライアントはゲーム中か？BOTではないか？
		if( IsClientInGame(i) && IsFakeClient(i) == false)
		{
			ShowHudText(i,-1,Show_text);
		}
	}
}

public  Action:maintask(Handle:timer)
{
	switch(GetMapType())
	{
		case 0://PLだった場合
		{
			ServerCommand("mp_timelimit 15");
			ServerCommand("mce_starttime 13.0");			
			ServerCommand("mp_maxrounds 2");
			Show_text = "-このラウンドのルール-\n\n制限時間:15分   ラウンド数最大2回   残り時間5分を切ると攻守交代せずにマップを移動します";
			s_gametype = "ペイロード";
		}
	
		case 1://普通のKOTHの場合
		{
			ServerCommand("mp_timelimit 10");
			ServerCommand("mce_starttime 8.0");	
			ServerCommand("mp_maxrounds 1");
			Show_text = "-このラウンドのルール-\n\n制限時間:10分   ラウンド数:1回";
			s_gametype = "キングオブザヒル";
		}
	
		case 2://イベント系KOTHの場合
		{
			ServerCommand("mp_timelimit 10");
			ServerCommand("mce_starttime 8.0");	
			ServerCommand("mp_maxrounds 1");
			s_gametype = "キングオブザヒル・イベント";
			Show_text = "-このラウンドのルール-\n\n制限時間:10分   ラウンド数:1回";
		}
	
		case 3://CP + PLRだった場合
		{
			ServerCommand("mp_timelimit 10");
			ServerCommand("mce_starttime 8.0");	
			ServerCommand("mp_maxrounds 1");
			s_gametype = "コントロールポイント";
			Show_text = "-このラウンドのルール-\n\n制限時間:10分   ラウンド数:1回   サドンデス:有効";
		}
		
		case 4://攻撃+防衛だった場合
		{
			ServerCommand("mp_timelimit 10");
			ServerCommand("mce_starttime 8.0");	
			ServerCommand("mp_maxrounds 2");
			s_gametype = "攻撃/防衛";
			Show_text = "-このラウンドのルール-\n\n制限時間:10分   ラウンド数最大:2回   残り時間5分を切ると攻守交代せずにマップを移動します";
		}

		case 5://CTFだった場合
		{
			ServerCommand("mp_timelimit 10");
			ServerCommand("mce_starttime 8.0");	
			ServerCommand("mp_maxrounds 1");
			s_gametype = "キャプチャーザフラッグ";
			Show_text = "-このラウンドのルール-\n\n制限時間:10分   ラウンド数:1回";
		}
		
		case 6://PLRだった場合
		{
			ServerCommand("mp_timelimit 10");
			ServerCommand("mce_starttime 8.0");	
			ServerCommand("mp_maxrounds 1");
			s_gametype = "ペイロードレース";
			Show_text = "-このラウンドのルール-\n\n制限時間:10分   ラウンド数:1回";
		}
	}
	
	return true;
}
public int GetMapType()
{
	//マップの名前を取得
	GetCurrentMap(maptype,255);
	//...に「PL」が含まれる
	if(StrContains(maptype,"pl_",false) != -1)
	{
		return 0;
	}
	//...に「KOTH」が含まれる ...に「event」が含まれない
	if(StrContains(maptype,"koth_",false) != -1 && StrContains(maptype,"event",false) == -1 )
	{
		return 1;
	}
	//...に「KOTH」が含まれる
	if(StrContains(maptype,"koth_",false) != -1)
	{
		return 2;
	}
	//...に「CP」が含まれる
	if(StrContains(maptype,"cp_",false) != -1)
	{
		new iTeam;
		new iEnt = -1;
		//CPを検索
		while ((iEnt = FindEntityByClassname(iEnt, "team_control_point")) != -1)
		{
			//見つかったらそれが青チームか検証
			iTeam = GetEntProp(iEnt, Prop_Send, "m_iTeamNum");
			if (iTeam != 2)
			{
				return 3;//青チームのCPが見つかったのでこれは普通のCP
			}
		}
		return 4;//すべて赤チームのCPだったら攻撃/防衛マップである
	}
		//...に「ctf」が含まれる
	if(StrContains(maptype,"ctf_",false) != -1)
	{
		return 5;
	}
	//...に「plr」が含まれる
	if(StrContains(maptype,"plr_",false) != -1)
	{
		return 6;
	}
	
	return 0;
}