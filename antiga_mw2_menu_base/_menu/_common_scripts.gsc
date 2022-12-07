#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

#include _menu\_overFlowFix;

/* 
	Hud Scripts 
*/

createText(font, fontscale, align, relative, x, y, sort, color, alpha, glowColor, glowAlpha, text)
{
	textElem = CreateFontString( font, fontscale );
	textElem setPoint( align, relative, x, y );
	textElem.sort = sort;
	textElem.type = "text";
	textElem setSafeText(text);
	textElem.color = color;
	textElem.alpha = alpha;
	textElem.glowColor = glowColor;
	textElem.glowAlpha = glowAlpha;
	textElem.hideWhenInMenu = true;
	return textElem;
}

createRectangle(align, relative, x, y, width, height, color, alpha, sorting, shadero)
{
	barElemBG = newClientHudElem( self );
	barElemBG.elemType = "bar";
	if ( !level.splitScreen )
	{
		barElemBG.x = -2;
		barElemBG.y = -2;
	}
	barElemBG.width = width;
	barElemBG.height = height;
	barElemBG.align = align;
	barElemBG.relative = relative;
	barElemBG.xOffset = 0;
	barElemBG.yOffset = 0;
	barElemBG.children = [];
	barElemBG.color = color;
	if(isDefined(alpha))
		barElemBG.alpha = alpha;
	else
		barElemBG.alpha = 1;
	barElemBG setShader( shadero, width , height );
	barElemBG.hidden = false;
	barElemBG.sort = sorting;
	barElemBG setPoint(align,relative,x,y);
	return barElemBG;
}

action_monitor(client,shader_elem,notifier)
{
	client endon("disconnect");
	switch(notifier)
	{
	   case "Update":
	       client waittill_any("Update","close_menu");
	   break;
	   
	   case "Close":
	       client waittill_any("close_menu");
	   break;
	}
	shader_elem destroy();
}

/*
	Other Useful Utilities
*/

is_bot()
{
	assert( isDefined( self ) );
	assert( isPlayer( self ) );

	return ( ( isDefined( self.pers["isBot"] ) && self.pers["isBot"] ) || isSubStr( self getguid() + "", "bot" ) );
}

hook_returns(bool)
{
	if(isDefined(bool))
		return true;
	else
		return false;
}

bool_2_text(bool)
{
    if(isDefined(bool))
        return "^2On";
    else
        return "^1Off";
}

getTrueName(playerName)
{
	if(!isDefined(playerName))
		playerName = self.name;

	if (isSubStr(playerName, "]"))
	{
		name = strTok(playerName, "]");
		return name[name.size - 1];
	}
	else
		return playerName;
}

ActionSlot_OneButtonPressed()
{
	self endon("disconnect");
	self notifyOnPlayerCommand("actionslot 1", "+actionslot 1");
	for(;;)
	{
		self waittill("actionslot 1");
		self.actionslot1pressed = true;
		waitframe();
		self.actionslot1pressed = false;
	}
}

ActionSlot_TwoButtonPressed()
{
	self endon("disconnect");
	self notifyOnPlayerCommand("actionslot 2", "+actionslot 2");
	for(;;)
	{
		self waittill("actionslot 2");
		self.actionslot2pressed = true;
		waitframe();
		self.actionslot2pressed = false;
	}
}

/*
	Test Functions
*/

test_function(input)
{
	if(isDefined(input))
		self iPrintLn("Test Function with: " +input);
	else
		self iPrintLn("Test Function without input.");
}

test_toggle()
{
	if(!self.toggle_test)
		self.toggle_test = true;
	else
		self.toggle_test = false;
}

update_text()
{
	if(self.updateText == "N/A")
		self.updateText = "RTM Update!";
	else if(self.updateText == "RTM Update!")
		self.updateText = "N/A";
}