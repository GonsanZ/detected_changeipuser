#include <amxmodx>
#include <fakemeta>

#define MAX_PLAYERS 32

new ipRecord[MAX_PLAYERS+1][16]; // guarda IPs
new steamIDRecord[MAX_PLAYERS+1][32]; // guarda SteamID para referencia

public plugin_init()
{
    register_plugin("IP Change Detector", "1.0", "GonsanZ");
    register_event("HLTV", "event_hltv", "a");
    register_event("SayText", "event_saytext", "a");

    register_event("player_disconnect", "event_player_disconnect", "a");
    register_event("player_connect", "event_player_connect", "a");
}

// Cuando el jugador se conecta
public event_player_connect(id)
{
    if (!is_user_connected(id)) return;
    
    // Obtener IP y SteamID
    get_user_ip(id, ipRecord[id], 16);
    get_user_authid(id, steamIDRecord[id], 32);
}

// Cuando el jugador se desconecta
public event_player_disconnect(id)
{
    if (!is_user_connected(id)) return;
    
    // Guardamos la IP antes que desconecte para comparar luego
    get_user_ip(id, ipRecord[id], 16);
}

// Hook cuando jugador entra para detectar cambio IP
public client_putinserver(id)
{
    if (!is_user_connected(id)) return;
    
    new currentIP[16];
    new currentSteamID[32];
    
    get_user_ip(id, currentIP, 16);
    get_user_authid(id, currentSteamID, 32);
    
    // Comparamos si el steamID ya tiene IP guardada
    if (strcmp(currentSteamID, steamIDRecord[id], false) == 0)
    {
        if (strcmp(currentIP, ipRecord[id], false) != 0)
        {
            // Cambio de IP detectado
            client_print(0, print_chat, "[IP Detector] El jugador %s cambió IP! Ant: %s, Nueva: %s", get_user_name(id), ipRecord[id], currentIP);
            // Actualizamos IP guardada
            strcopy(ipRecord[id], 16, currentIP);
        }
    }
    else
    {
        // Nuevo jugador, guardamos datos
        strcopy(steamIDRecord[id], 32, currentSteamID);
        strcopy(ipRecord[id], 16, currentIP);
    }
}
