#pragma semicolon 1
//#pragma newdecls required
#pragma newdecls optional

#include <sdktools_functions>

public Plugin:myinfo = {
	name = "DoD:S Incendiary projectiles",
	author = "donkey",
	description = "Flammable projectiles for rockets and MG's",
	version = "1.0",
	url = "https://basemod.net"
};

float fMult;

public void OnPluginStart()
{
    ConVar cvar = CreateConVar("sm_igniter_mult", "0.3", "Ratio of burning duration to damage taken (0.0 - disable)", _, true, _, true, 10.0);
    cvar.AddChangeHook(CVarChange);
    CVarChange(cvar, NULL_STRING, NULL_STRING);

    AutoExecConfig(true, "igniter");
}

public void CVarChange(ConVar cvar, const char[] oldValue, const char[] newValue)
{
    fMult = cvar.FloatValue;

    static bool hooked;
    if(!(fMult == 0.0) == hooked)
        return;

    if(!(hooked = !hooked))
        UnhookEvent("player_hurt", Event_Hurt);
    else HookEvent("player_hurt", Event_Hurt);
}

public void Event_Hurt(Event event, const char[] name, bool dontBroadcast)
{
    static char wpn[16];
    event.GetString("weapon", wpn, sizeof(wpn));
    if(strcmp(wpn, "pschreck", false))
    if(strcmp(wpn, "bazooka", false))
    if(strcmp(wpn, "rocket_pschreck", false))
    if(strcmp(wpn, "rocket_bazooka", false))
    if(strcmp(wpn, "mg42", false))
    if(strcmp(wpn, "30cal", false)) 
        return;

    int attacker = GetClientOfUserId(event.GetInt("attacker"));
    int client = GetClientOfUserId(event.GetInt("userid"));
    if(client && attacker != client && IsPlayerAlive(client) && IsFakeClient(attacker) || IsFakeClient(client))
        IgniteEntity(client, 10.0);
}  
