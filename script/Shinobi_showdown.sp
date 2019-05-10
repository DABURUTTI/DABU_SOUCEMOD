#include <sourcemod>
#include <tf2_stocks>
#include <sdkhooks>

ConVar stockEnable;

public Plugin myinfo = {
	name = "[TF2]Shinobi Showdown Games",
	author = "DABU",
	description = "This plugin made for Shinobi showdown games",
	version = "1",
	url = "ya"
}

public void OnPluginStart()
{
	HookEvent("player_spawn", Event_PlayerSpawn, EventHookMode_Post);
	HookEvent("post_inventory_application", Event_PlayerResup, EventHookMode_Post);

	stockEnable = CreateConVar("sm_disableweapon", "1", "Enables/Disables weapon whitelist");

	for (new i = 1; i <= MaxClients; i++)
	{
		if (IsClientInGame(i))
		{
			SDKHook(i, SDKHook_OnTakeDamage, OnTakeDamage);
		}
	}
}

public OnClientPutInServer(client)
{
	SDKHook(client, SDKHook_OnTakeDamage, OnTakeDamage);
}

public Action:OnTakeDamage(client, &attacker, &inflictor, &Float:damage, &damagetype)
{
	if(stockEnable.BoolValue)
	{
		if (damagetype == 2097154 || damagetype == 19005440 || damagetype == 2056)
		{
			return Plugin_Handled;
		}
		else
		{
			return Plugin_Continue;
		}
	}
}

public Action Event_PlayerSpawn(Event event, const char[] name, bool dontBroadcast) {
	int client = GetClientOfUserId(GetEventInt(event, "userid"))
	RemoveWeapons(client);
}

public Action Event_PlayerResup(Event event, const char[] name, bool dontBroadcast) {
	int client = GetClientOfUserId(GetEventInt(event, "userid"))
	RemoveWeapons(client);
}

public void RemoveWeapons(int client) {
	if(stockEnable.BoolValue) {
		int iWep;
		int iWepID;
		int x = 0
		while(GetPlayerWeaponSlot(client,x) != -1 )
		{

			iWep = GetPlayerWeaponSlot(client, x)
			if(iWep >= 0) {
				char classname[64];
				iWepID = GetEntProp(iWep, Prop_Send, "m_iItemDefinitionIndex");
				GetEntityClassname(iWep, classname, sizeof(classname));
				if (isBANwepon(classname,iWepID)) {
					PrintToChat(client, "\x07ff0000 [SM] %i:%s is not allowed",iWepID,classname);
					TF2_RemoveWeaponSlot(client, x);
				}
			}
			x++
		}
	}
}

public bool isBANwepon(char[] classname,int ID)
{
	if(ID == 355 || ID == 356  || ID == 224) return false;
	if(ID == 880 || ID == 939 || ID == 474 || ID == 1) return true;

	if(StrEqual(classname, "tf_weapon_rocketlauncher")
			|| StrEqual(classname, "tf_weapon_scattergun")
			|| StrEqual(classname, "tf_weapon_shotgun_pyro")
			|| StrEqual(classname, "tf_weapon_shotgun_soldier")
			|| StrEqual(classname, "tf_weapon_bat")
			|| StrEqual(classname, "tf_weapon_pistol_scout")
			|| StrEqual(classname, "tf_weapon_flamethrower")
			|| StrEqual(classname, "tf_weapon_grenadelauncher")
			|| StrEqual(classname, "tf_weapon_pipebomblauncher")
			|| StrEqual(classname, "tf_weapon_shovel")
			|| StrEqual(classname, "tf_weapon_fireaxe")
			|| StrEqual(classname, "tf_weapon_smg")
			|| StrEqual(classname, "tf_weapon_sniperrifle")
			|| StrEqual(classname, "tf_weapon_revolver")
			|| StrEqual(classname, "tf_weapon_knife")){
		return true;
	}
	else{
		return false;
	}
}
