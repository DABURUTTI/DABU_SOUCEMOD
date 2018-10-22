#include <sourcemod>
#include <tf2_stocks>


new ConVar:v_intervaltime;
new int:timeleft;
new String:Show_text[255];
new String:mapname[255];
ConVar nextmap;

public Plugin:myinfo =
{
	name = "[TF2]nextmap",
	author = "DABURUTTI",
	description = "次のマップに強制変更します",
	version = "1.0",
	url = ""
}

public OnPluginStart(){

    v_intervaltime = CreateConVar("sm_map_time", "30", "The time of interval to change the map between 2 maps");
    //CreateTimer(1.0,Loop);
    timeleft = GetConVarInt(v_intervaltime);
    HookConVarChange(v_intervaltime, OnConVarChanged_intervaltime);
    nextmap = FindConVar("sm_nextmap");
}


public OnConVarChanged_intervaltime(ConVar convar, const char[] oldValue, const char[] newValue){

    timeleft = GetConVarInt(v_intervaltime);
}

public OnMapStart(){
	timeleft = GetConVarInt(v_intervaltime);
	CreateTimer(1.0,Loop);
}

public Action:Loop(Handle:timer){
	if(timeleft <= 3)
	{
        CreateTimer(1.0,final);
		return Plugin_Handled;
	}
    PrintToChatAll("マップの変更時間まで、あと%i分です！",timeleft);
	timeleft = timeleft - 1;
	CreateTimer(60.0,Loop2)
}

public Action:Loop2(Handle:timer){
	if(timeleft <= 3)
	{
        CreateTimer(1.0,final);
		return Plugin_Handled;
	}
    PrintToChatAll("マップの変更時間まで、あと%i分です！",timeleft);
	timeleft = timeleft - 1;
	CreateTimer(60.0,Loop);
}

public Action:final(Handle:timer)
{
    Show_text = "！警告！\nあと3分でマップを変更します！";
    PrintToChatAll("マップの変更時間まで、あと3分です！");
    CreateTimer(0.1,showtext);
    CreateTimer(60.0,fina2);
}

public Action:fina2(Handle:timer)
{
    Show_text = "！警告！\nあと2分でマップを変更します！";
    PrintToChatAll("マップの変更時間まで、あと2分です！");
    CreateTimer(0.1,showtext);
    CreateTimer(60.0,fina3);
}

public Action:fina3(Handle:timer){

    Show_text = "！警告！\nあと1分でマップを変更します！";
    PrintToChatAll("マップの変更時間まで、あと1分です！");
    CreateTimer(0.1,showtext);
    CreateTimer(60.0,fina4);
}

public Action:fina4(Handle:timer)
{
    Show_text = "マップを変更します！";
    PrintToChatAll("サーバーがマップ変更の作業を開始しています...");
    CreateTimer(0.1,showtext);
    CreateTimer(60.0,fina5);
}

public Action:fina5(Handle:timer)
{
    GetConVarString(nextmap,mapname,255);
    ServerCommand("changelevel %s",mapname);
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