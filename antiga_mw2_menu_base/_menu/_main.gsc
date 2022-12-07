#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

#include _menu\_overFlowFix;
#include _menu\_common_scripts;
#include _menu\_menu;

init()
{
	/*
		Dvar Setter
	*/
	setDvar("testClients_doAttack", 0);
	setDvar("testClients_doMove", 0);
	setDvar("testClients_doReload", 0);
	setDvar("testClients_doCrouch", 0);
	setDvar("testClients_watchKillcam", 0);
	setDvar("nightVisionDisableEffects", 1);
	/*
		Level Thread Connecting Players
	*/
	thread on_player_connect();
}

on_player_connect()
{
	for(;;)
	{
		level waittill("connected",player);
		player thread overflowFixInit();
		player thread on_player_spawned();
		if(!player is_bot())
		{
			if(!isDefined(player.toggle_test))
				player.toggle_test = false;

			if(!isDefined(player.updateText))
				player.updateText = "N/A";
			/*
				Menu Threads
			*/
			player thread _setup_menu();
			player thread ActionSlot_OneButtonPressed();
			player thread ActionSlot_TwoButtonPressed();
			player _SetActionSlot( 1, "" );
			_give_menu(player);
		} 
		else 
		{
			/*
				Bot Functions
			*/
			player iPrintLn("I am a bot.");
		}
	}
}

on_player_spawned()
{
	self endon("disconnect");
	for(;;)
	{
		self waittill("spawned_player");

		if(!self is_bot())
			self iPrintLn("^2Welcome to: @mp_rust's GSC Menu Base!");
		else 
			self iPrintLn("I am a bot.");
	}
}