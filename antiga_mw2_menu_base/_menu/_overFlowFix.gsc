#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include common_scripts\utility;

#include _menu\_common_scripts;
#include _menu\_menu;

/*
    Overflow from IL Menu Base
*/

overflowFixInit() 
{
    level.strings = [];
    level.overflowElem = createServerFontString("default", 1.5);
    level.overflowElem setSafeText("overflow");
    level.overflowElem.alpha = 0;
    thread overflowFixMonitor();
}

overflowFixMonitor() 
{
    for(;;) 
    {
        level waittill("string_added");
        if(level.strings.size >= 55) 
        {
            level.overflowElem clearAllTextAfterHudElem();
            level.strings = [];
            level notify("overflow_fixed");
        }
        wait 0.05;
    }
}

setSafeText(text)
{
    self.string = text;
    self setText(text);
    self thread fixString();
    self addString(text);
}

addString(string)
{
    level.strings[level.strings.size] = string;
    level notify("string_added");
}

fixString() 
{
    self notify("new_string");
    self endon("new_string");
    while(isDefined(self)) 
    {
        level waittill("overflow_fixed");
        self setSafeText(self.string);
    }
}