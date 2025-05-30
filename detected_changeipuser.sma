#include <amxmodx>
#include <fakemeta>

#define MAX_PLAYERS 32

new ipRecord[MAX_PLAYERS + 1][16];        // Almacena IPs sin puerto
new steamIDRecord[MAX_PLAYERS + 1][32];   // Almacena SteamIDs

public plugin_init()
{
    register_plugin("IP Change Detector", "1.0", "GonsanZ");
}

// Cuando el jugador se conecta (antes de entrar al juego)
public client_connect(id)
{
    if (!is_user_connected(id)) return;

    get_user_ip(id, ipRecord[id], charsmax(ipRecord[]), 1); // sin puerto
    get_user_authid(id, steamIDRecord[id], charsmax(steamIDRecord[]));
}

// Cuando el jugador entra completamente al servidor
public client_putinserver(id)
{
    if (!is_user_connected(id)) return;

    new currentIP[16];
    new currentSteamID[32];
    new playerName[32];

    get_user_ip(id, currentIP, charsmax(currentIP), 1); // sin puerto
    get_user_authid(id, currentSteamID, charsmax(currentSteamID));
    get_user_name(id, playerName, charsmax(playerName));

    // Compara con los datos guardados
    if (equal(currentSteamID, steamIDRecord[id]))
    {
        if (!equal(currentIP, ipRecord[id]))
        {
            client_print(0, print_chat, "[IP Detector] El jugador %s cambió su IP! Ant: %s, Nueva: %s", playerName, ipRecord[id], currentIP);
            copy(ipRecord[id], charsmax(ipRecord[]), currentIP);
        }
    }
    else
    {
        // Nuevo jugador o datos no coinciden
        copy(steamIDRecord[id], charsmax(steamIDRecord[]), currentSteamID);
        copy(ipRecord[id], charsmax(ipRecord[]), currentIP);
    }
}

// Limpiar datos cuando el jugador se desconecta
public client_disconnect(id)
{
    ipRecord[id][0] = 0;
    steamIDRecord[id][0] = 0;
}
