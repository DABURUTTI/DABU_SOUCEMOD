#include <sourcemod>
#include <tf2_stocks>
#include <tf2>

#define YES "#yes"
#define NO "#no"

new Handle:ninzuu;	//Cvar:sm_teamswitch_trigger
/*
変数の用途をメモしておこう
あと命名規則を付けることを勧めます。
この場合Cvarで使ってるよというのを分かりやすくした方が良いと思います。
例：v_ninzuu CvarNinzuu cNinzuu
*/


new int:BLUs;	//Bluの人数
new int:REDs;	//Bluの人数
new int:FLAG1;
/*
同様にこちらも。
intBLUsやiBLUs等変数の型が見て分かるとなおベター。
強いていうとグローバル変数であるのが分かると関数内で宣言してるところがないか必至で探さなくていいので
g_iBLUsとかグローバルと分かるようにしてやった方がいいと思います。
*/

public Plugin:myinfo =
{
	name = "[TF2]Team switch for unbalance",
	author = "DABURUTTI",
	description = "カジュアルのチーム人数差改善機能を再現します。",
	version = "",
	url = ""
}

public OnPluginStart()
{
	//このプラグインを使用する場合はオートバランスを無効にする。
	
	/*
	プラグインの運用方針によるので一概には言えないと思いますが、
	cvarの変更はプラグインを終了しても戻るので
	元の値を控えておくか、変更時に確認を取るかした方がいいかもしれません。
	
	また、プラグインを入れたら常に動作するのか、Cvarで有効無効を切り替えるのかも考えてみてください。
	僕は勝手に値を変えたり勝手に動いたり終了しても変更点を残してしまうプラグインは行儀が悪いと思っています。
	（自分のプラグインが行儀が良いとは言っていない）
	*/
	ServerCommand("mp_autoteambalance 0");
	
	/*
	せっかくだから同じ関数呼んでるのは揃えましょう（並べ替えました）
	後関数名にも命名規則を付けましょう。OnEvent～かEvent_～のどちらかへ統一をしては
	*/
	
	//イベントフック開始
	HookEvent("player_disconnect", OnEventPlayerDisconnect);
	//デバッグ用、チャット監視
	HookEvent("player_say", Event_Chat);
	
	//Cvar生成
	ninzuu = CreateConVar("sm_teamswitch_trigger", "2", "人数調整が始まる人数");
	//メニューを消すかどうかのフラグを立てる
	FLAG1 = 0;
	
}

/*
！から始まるチャットコマンドは、SourceModの機能です
RegAdminCmdを使用してください。
例えばsm_debugという名称のコマンドを作成すると、!debugで呼び出すことができます。
*/
public Action:Event_Chat(Handle:event, const String:eventname[], bool:dontBroadcast)
{
	//デバッグ用
	new String:text[200];
	GetEventString(event, "text", text, 200);
	if(strcmp(text,"!debug")==0)
	{
		check();
	}
}

/*
OnClientDisconectという関数が用意されています。
https://sm.alliedmods.net/new-api/clients/OnClientDisconnect
そちらの使用を推奨します。

また、チームの人数変更を監視するのが目的と推察しますが
その場合切断よりチーム変更（観戦移動を含む）の方がよろしいかと思います。
"player_team"イベントをフックしてください。
https://wiki.alliedmods.net/Generic_Source_Events#player_team
*/

public Action:OnEventPlayerDisconnect(Handle:event, const String:name[], bool:dont_broadcast)
{	//通常のトリガ
	check();
}
	
public Action check()
{
	//初期化
	REDs = 0;
	BLUs = 0;
	
	/*
	GetMaxClients()
	This function will be deprecated in a future release. Use the MaxClients variable instead.
	(この関数は、将来のリリースで廃止される予定です。代わりにMaxClients変数を使用します。)
	*/
	
	//for(int x=1;x <= GetMaxClients();x++)
	for(int x=1;x <= MaxClients;x++)
	{	
		//ゲーム内にいるか
		if(IsClientInGame(x))
		{	
			//チームは赤か、青か。
			if(GetClientTeam(x) == TFTeam_Red)
			{
				REDs++;
			}
			
			if(GetClientTeam(x) == TFTeam_Blue)
			{
				BLUs++;
			}
		}
	}
	//とりあえず引き算
	int y = REDs - BLUs;
	
	int a = GetConVarInt(ninzuu);
	
	//人数差が負になってたら正にする
	if(y <= -1)
	{
		y = y * -1;
	}
	
	if(y >= a)
	{
		//↓が移動を呼びかける処理につながる
		showpanel();
		//デバッグ用
		PrintToServer("人数差が%d人なので移動処理を開始しました",y);
	}
	else
	{
		/*
		動作意図がちょっと分からない…
		人数移動処理を行った後、メニューが残ったままの人に対応してるのだと思うけど
		ここに再突入する条件がplayer_disconnectイベントのため、誰かが切断しない限りここには来ない…
		移動処理の後に再度Check()を呼び出すとかするべきなのと
		menu用の変数がローカルなので、多分もう閉じることはできなくなっている
		（再突入したら新しくmenu変数を宣言してメニューを作成しているので、
		Cancelしているmenuと開いたままになっているmenuは別モノ)
		*/
		FLAG1 = 1;
		showpanel();
	}
}

public Action showpanel()
{
	
	//メニュー生成
	Menu menu = new Menu(MenuHandler1,MENU_ACTIONS_ALL)
	new int:sukunai = 0;
	//人数が少ないチームは？
	if(BLUs <= REDs)
	{
		sukunai = 0;
	}
	else
	{
		sukunai = 1;
	}
	//タイトル設定
	if(sukunai == 0)
	{
		menu.SetTitle("BLUチームがピンチ！\nチームを移動して助けに行こう！\n ") ;
	}
	else
	{
		menu.SetTitle("REDチームがピンチ！\nチームを移動して助けに行こう！\n ") ;
	}

	//項目追加
	menu.AddItem(YES,"移動する！");
	menu.AddItem(NO,"移動しない");
	//終了ボタンは表示しない
	menu.ExitButton = false;
	//すべてのクライアントに対して行う
	for(int x=1;x <= GetMaxClients();x++)
	{	
		//ゲーム内にいるか？
		if(IsClientInGame(x))
		{	//かつ、人数の多いチームにいるか？
			if(sukunai == 0)
			{
				if(GetClientTeam(x) == TFTeam_Red)
					{
						menu.Display(x, 30);
					}
			}
			else
			{
				if(GetClientTeam(x) == TFTeam_Blue)
					{
						menu.Display(x, 30);
					}
			}
		}
	}

	if(FLAG1 == 1)
	{
		/*
		誰かが移動した後に再度Checkが行われた場合と見たけど、
		上記の通り多分閉じれません…
		
		
		グローバル変数でメニュー用の変数(menu)を宣言し、
		不要になった時点でCancelMenu(menu) ※menu.Cancel()に同義
		メニューの表示が残ることがある（消えることもある）が、メニューの選択結果が反映されなくなる
		
		使い終わったメニュー変数はINVALID_HANDLEやnullを入れて初期化しておくこと（不要とは思うが）
		*/
		menu.Cancel();
		FLAG1 = 0;
	}
}
public int MenuHandler1(Menu menu, MenuAction action, int param1, int param2)
{
	switch(action)
	{
		case MenuAction_Start:
		{
			PrintToServer("チーム移動を呼びかけました");
		}
  
		case MenuAction_Select:
		{
			new String:answer[255];
			menu.GetItem(param2, answer, sizeof(answer));
			if (StrEqual(answer, YES))
			{
				//チーム変更
				if(BLUs <= REDs)
				{
					TF2_ChangeClientTeam(param1,TFTeam_Blue);
					
				}

				else
				{
					TF2_ChangeClientTeam(param1,TFTeam_Red);
				}
				//チーム変更後はすぐにリスポーンする
				TF2_RespawnPlayer(param1);
				//移動したことをチャットで表示
				char[] name = "";		//えっこれで宣言できるの！？　変数サイズどうなるんだこれ！
				GetClientName(param1,name,255);
				PrintToChatAll("%sがチームを移動した！",name);
				
			}
			else
			{
				
			}
			/*
			全員のメニューが終了してる保証は無いので再度表示するのは早いかもしれない
			人数差がなくなるまでメニュー開いたままで、人数差が無くなったら閉じる処理に変えれば不要になるはず
			*/
			
			showpanel();
		}
		/*
		多分メニューのページにも閉じるように記載があったと思う
		*/
		//メニュー処理が終了した
		case MenuAction_End:
		{
			CloseHandle(menu);	//終了したらハンドルを閉じておく
		}

	}
 	//エラー回避
	return 0;
}
