#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

#include _menu\_overFlowFix;
#include _menu\_common_scripts;
#include _menu\_menu;

_load_menu_struct()
{
	self _main_struct();
	self _player_struct();
}

_main_struct()
{
	self create_menu("main","@mp_rust","Exit");
	self add_option("main","Test Function",::test_function);
	self add_option("main","Test Function with Input",::test_function,"input_success");
	self add_option("main","Real Time Update Text: " +self.updateText,::update_text);
	self add_toggle_option("main","Test Toggle",::test_toggle,self.toggle_test);
	self add_option("main","Sub Menu",::_load_menu,"submenu");
	if(self isHost())
	{
		self add_option("main","Players Menu",::_load_menu,"players");
	}

	/*
		Sub Menu
	*/
	self create_menu("submenu","Sub Menu","main");
	self add_option("submenu","Option 1",::test_function);
	self add_option("submenu","Option 2",::test_function);
	
}

_player_struct()
{
	self create_menu("players","Players","main");
	for(i=0;i<level.players.size;i++)
	{
		player = level.players[i];
		name = player getTrueName();
		menu = "player_"+name;
		self add_option("players",name,::_load_menu,menu);
		self create_menu(menu,name,"players");
		self add_option(menu,"Kill",::test_function);
	}
}

create_menu(menu,title,parent)
{
	if(!isDefined(self.antiga))
		self.antiga = [];
	self.antiga[menu] = spawnStruct();
	self.antiga[menu].title = title;
	self.antiga[menu].parent = parent;
	self.antiga[menu].text = [];
	self.antiga[menu].func = [];
	self.antiga[menu].inp1 = [];
	self.antiga[menu].inp2 = [];
	self.antiga[menu].inp3 = [];
	self.antiga[menu].status = [];
	self.antiga[menu].toggle = [];
}

add_option(menu,text,func,inp,inp2,inp3)
{
	rust = self.antiga[menu].text.size;
	self.antiga[menu].text[rust] = text;
	self.antiga[menu].func[rust] = func;
	self.antiga[menu].inp1[rust] = inp;
	self.antiga[menu].inp2[rust] = inp2;
	self.antiga[menu].inp3[rust] = inp3;
}

add_toggle_option(menu,text,func,bool,inp,inp2,inp3)
{
	rust = self.antiga[menu].text.size;
	self.antiga[menu].text[rust] = text;
	self.antiga[menu].func[rust] = func;
	self.antiga[menu].inp1[rust] = inp;
	self.antiga[menu].inp2[rust] = inp2;
	self.antiga[menu].inp3[rust] = inp3;
	if(!isDefined(bool))
		self.antiga[menu].toggle[rust] = undefined;
	else
		self.antiga[menu].toggle[rust] = bool;
}