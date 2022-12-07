#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

#include _menu\_overFlowFix;
#include _menu\_common_scripts;
#include _menu\_structure;

_setup_menu()
{
	self.antiga = [];
	self.Scroller = [];
	self.hasMenu = false;
	self.antiga["Menu"]["Open"] = false;
	self.MenuMaxSize = 12;
	self.MenuMaxSizeHalf = 6;
	self.MenuMaxSizeHalfOne = 7;
}

_give_menu(client)
{
	if(client.hasMenu)
	{
		_remove_menu(client);
	}
	client.hasMenu = true;
	client thread init_menu();
}

_remove_menu(client)
{
	if(client.antiga["Menu"]["Open"])
	{
		client _close_menu();
		waitframe();
	}
	client notify("Close_Out_Menu");
	client.hasMenu = false;
}

/*
	Initializing Menu & Menu Monitoring
*/

init_menu()
{
	self endon("disconnect");
	self endon("Close_Out_Menu");
	for(;;)
	{
		if(!self.antiga["Menu"]["Open"] && self.hasMenu)
		{
			if(self.actionslot1pressed && self adsButtonPressed())
			{
				self thread _menu_monitor();
				wait 0.15;
				self notify("Menu_Active");
			}
		}
		waitframe();
	}
}

_menu_monitor()
{
	self endon("disconnect");
	self endon("Close_Out_Menu");
	self endon("close_menu");
	
	self waittill("Menu_Active");
	self _open_menu();
	
	while(self.antiga["Menu"]["Open"])
	{
		if(self.actionslot1pressed || self.actionslot2pressed)
		{
			self.Scroller[self.antiga["CurrentMenu"]] -= self.actionslot1pressed;
			self.Scroller[self.antiga["CurrentMenu"]] += self.actionslot2pressed;
			self _scroll_update();
			wait 0.15;
		}
		if(self UseButtonPressed())
		{
			input1 = self.antiga[self.antiga["CurrentMenu"]].inp1[self.Scroller[self.antiga["CurrentMenu"]]];
			input2 = self.antiga[self.antiga["CurrentMenu"]].inp2[self.Scroller[self.antiga["CurrentMenu"]]];
			input3 = self.antiga[self.antiga["CurrentMenu"]].inp3[self.Scroller[self.antiga["CurrentMenu"]]];
			currentSelectedFunction = self.antiga[self.antiga["CurrentMenu"]].func[self.Scroller[self.antiga["CurrentMenu"]]];
			if(isDefined(self.antiga[self.antiga["CurrentMenu"]].status[self.Scroller[self.antiga["CurrentMenu"]]]))
				self thread [[currentSelectedFunction]](input1,input2,input3);
			else
				self thread [[currentSelectedFunction]](input1,input2,input3);
			self _load_menu_struct();
			self _scroll_update();
			if(isDefined(self.antiga[self.antiga["CurrentMenu"]].toggle[self.Scroller[self.antiga["CurrentMenu"]]]))
			{
				self _update_toggles();
				self _scroll_update();
			}
			wait 0.25;
		}
		if(self MeleeButtonPressed())
		{
			if(self.antiga[self.antiga["CurrentMenu"]].parent=="Exit")
				self _close_menu();
			else
				self thread _load_menu(self.antiga[self.antiga["CurrentMenu"]].parent);
			
			wait 0.25;
		}
		waitframe();
	}
	//waitframe();
}

/*
	Opening & Closing Menu
*/

_open_menu()
{
	if(!isDefined(self.antiga["CurrentMenu"]))
		self.antiga["CurrentMenu"] = "main";
	self _menu_hud();
	self _load_menu(self.antiga["CurrentMenu"]);
	self.antiga["Menu"]["Open"] = true;
}

_close_menu()
{
	self.antiga["Menu"]["Open"] = false;
	self notify("close_menu");
}


/*
	Drawing Menu
*/

_menu_hud()
{
	self.antiga["Title"] = createText("console",1.5,"CENTER","TOP",0,100,0,(1,1,1),1,(122/255,167/255,255/255),1,"@mp_rust");
	self.antiga["Title"].foreground = true;
	thread action_monitor(self,self.antiga["Title"],"Close");
	self.antiga["BG"] = createRectangle("CENTER","CENTER",0,0,200,260,(0,0,0),(1/1.75),0,"white");
	thread action_monitor(self,self.antiga["BG"],"Close");
	self.antiga["Line"] = [];
	self.antiga["Line"][0] = createRectangle("CENTER","CENTER",0,-130,202,3,(122/255,167/255,255/255),1,0,"white");//Top
	self.antiga["Line"][1] = createRectangle("CENTER","CENTER",0,130,202,3,(122/255,167/255,255/255),1,0,"white");//Bottom
	self.antiga["Line"][2] = createRectangle("CENTER","CENTER",-100,0,3,260,(122/255,167/255,255/255),1,0,"white");//Left
	self.antiga["Line"][3] = createRectangle("CENTER","CENTER",100,0,3,260,(122/255,167/255,255/255),1,0,"white");//Right
	self.antiga["Line"][4] = createRectangle("CENTER","CENTER",0,-85,202,3,(122/255,167/255,255/255),1,0,"white");//Middle
	for(i=0;i<self.antiga["Line"].size;i++)
	{
		thread action_monitor(self,self.antiga["Line"][i],"Close");
	}
	self.antiga["Scrollbar"] = createRectangle("CENTER","TOP",0,130,200,15,(122/255,167/255,255/255),1,0,"white");
	thread action_monitor(self,self.antiga["Scrollbar"],"Close");
}

/*
	Sub Menu Functions
*/

_load_menu(menu)
{
	self notify("Update");
	self _load_menu_struct();
	self.antiga["CurrentMenu"] = menu;
	if(!isDefined(self.Scroller[self.antiga["CurrentMenu"]])){
		self.Scroller[self.antiga["CurrentMenu"]] = 0;}
	self _menu_text();
	self _update_toggles();
	self _scroll_update();
}

_menu_text()
{
	self.antiga["Title"] setSafeText("@mp_rust");
	self.antiga["Text"] = [];
	for(i=0;i<self.MenuMaxSize;i++)
	{
		self.antiga["Text"][i] = createText("default",1.2,"CENTER","TOP",0,130+(18*i),0,(1,1,1),1,(0,0,0),0,self.antiga[self.antiga["CurrentMenu"]].text[i]);
		self.antiga["Text"][i].foreground = true;
		thread action_monitor(self,self.antiga["Text"][i],"Update");
	}
}

/*
	Scrolling & Toggle Functions
*/

_scroll_update()
{
	if(self.Scroller[self.antiga["CurrentMenu"]]<0)
		self.Scroller[self.antiga["CurrentMenu"]] = self.antiga[self.antiga["CurrentMenu"]].text.size-1;

	if(self.Scroller[self.antiga["CurrentMenu"]]>self.antiga[self.antiga["CurrentMenu"]].text.size-1)
		self.Scroller[self.antiga["CurrentMenu"]] = 0;

	if(!isDefined(self.antiga[self.antiga["CurrentMenu"]].text[self.Scroller[self.antiga["CurrentMenu"]]-self.MenuMaxSizeHalf])||self.antiga[self.antiga["CurrentMenu"]].text.size<=self.MenuMaxSize)
	{
		for(i=0;i<self.MenuMaxSize;i++)
		{
			if(isDefined(self.antiga[self.antiga["CurrentMenu"]].text[i]))
				self.antiga["Text"][i] setText(self.antiga[self.antiga["CurrentMenu"]].text[i]);
			else
				self.antiga["Text"][i] setText("");
			if(isDefined(self.antiga[self.antiga["CurrentMenu"]].toggle[i]))
			{
				if(self.antiga[self.antiga["CurrentMenu"]].toggle[i]==true)
					self.antiga["Text"][i] setSafeText(self.antiga[self.antiga["CurrentMenu"]].text[i]+": ^7[^2ON^7]");
				else
					self.antiga["Text"][i] setSafeText(self.antiga[self.antiga["CurrentMenu"]].text[i]+": ^7[^1OFF^7]");
			}
		}
		self.antiga["Scrollbar"].y = 130+(18*self.Scroller[self.antiga["CurrentMenu"]]);
	}
	else
	{
		if(isDefined(self.antiga[self.antiga["CurrentMenu"]].text[self.Scroller[self.antiga["CurrentMenu"]]+self.MenuMaxSizeHalf]))
		{
			mp_rust = 0;
			for(i=self.Scroller[self.antiga["CurrentMenu"]]-self.MenuMaxSizeHalf;i<self.Scroller[self.antiga["CurrentMenu"]]+self.MenuMaxSizeHalfOne;i++)
			{
				if(isDefined(self.antiga[self.antiga["CurrentMenu"]].text[i]))
					self.antiga["Text"][mp_rust] setText(self.antiga[self.antiga["CurrentMenu"]].text[i]);
				else
					self.antiga["Text"][mp_rust] setText("");
				if(isDefined(self.antiga[self.antiga["CurrentMenu"]].toggle[i]))
				{
					if(self.antiga[self.antiga["CurrentMenu"]].toggle[i]==true)
						self.antiga["Text"][mp_rust] setSafeText(self.antiga[self.antiga["CurrentMenu"]].text[i]+": ^7[^2ON^7]");
					else
						self.antiga["Text"][mp_rust] setSafeText(self.antiga[self.antiga["CurrentMenu"]].text[i]+": ^7[^1OFF^7]");
				}
				mp_rust++;
			}           
			self.antiga["Scrollbar"].y = 130+(18*self.MenuMaxSizeHalf);
		}
		else
		{
			for(i=0;i<self.MenuMaxSize;i++)
			{
				self.antiga["Text"][i] setText(self.antiga[self.antiga["CurrentMenu"]].text[self.antiga[self.antiga["CurrentMenu"]].text.size+(i-self.MenuMaxSize)]);
				if(isDefined(self.antiga[self.antiga["CurrentMenu"]].toggle[self.antiga[self.antiga["CurrentMenu"]].text.size+(i-self.MenuMaxSize)]))
				{
					if(self.antiga[self.antiga["CurrentMenu"]].toggle[self.antiga[self.antiga["CurrentMenu"]].text.size+(i-self.MenuMaxSize)]==true)
						self.antiga["Text"][i] setSafeText(self.antiga[self.antiga["CurrentMenu"]].text[i]+": ^7[^2ON^7]");
					else
						self.antiga["Text"][i] setSafeText(self.antiga[self.antiga["CurrentMenu"]].text[i]+": ^7[^1OFF^7]");
				}
			}
			self.antiga["Scrollbar"].y = 130+(18*((self.Scroller[self.antiga["CurrentMenu"]]-self.antiga[self.antiga["CurrentMenu"]].text.size)+self.MenuMaxSize));
		}
	}
}

_update_toggles()
{
	for(i=0;i<self.antiga[self.antiga["CurrentMenu"]].text.size;i++)
	{
		if(isDefined(self.antiga[self.antiga["CurrentMenu"]].toggle[i]))
		{
			self _load_menu_struct();
			if(self.antiga[self.antiga["CurrentMenu"]].toggle[i]==true)
				self.antiga["Text"][i] setSafeText(self.antiga[self.antiga["CurrentMenu"]].text[i]+"^7[^2ON^7]");
			else
				self.antiga["Text"][i] setSafeText(self.antiga[self.antiga["CurrentMenu"]].text[i]+"^7[^1OFF^7]");
		}
		else
			self.antiga["Text"][i] setSafeText(self.antiga[self.antiga["CurrentMenu"]].text[i]);
	}
}