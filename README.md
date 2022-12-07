# Antiga's GSC Menu Bases

All of these menu bases are intended to elimate the use of ModMenu12. The bases have a excellent overflow and they all run very stable. If any issues arise, please report the bugs to me directly on twitter @mp_rust.

# Feature Set
- Clean UI/Layout.
- Unlimited Scrolling.
- Menu Toggles [On/Off].
- Real Time Text Updates.
- Stable Overflow [From Infinity Loader].
- Players Menu.

# How To Use
- Creating A New Menu:
  - self create_menu("namehere","menutitlehere","Exit");
  	- Namehere is the reference name to that menu. menutitlehere is the title of the menu. Exit is what is used to close completely out of the menu.
		- self add_option("main","Test Function",::test_function);

- Creating An Option Within The Menu:
	- self add_option("namehere","nameoffunction",::actualfuntion,"inputrequired");
		- Namehere is the reference name to that menu. nameoffunction is the name of the actual function. ::actualfunction is where you call the function. inputrequired is meant if you need to add additional values to that function.

- Creating A Toggle Option Within The Menu:
  - self add_toggle_option("namehere","nameoffunction",::actualfuntion,self.toggle_test);
  	- Namehere is the reference name to that menu. nameoffunction is the name of the actual function. ::actualfunction is where you call the function. self.toggle_test is the bool that is required to be set to 1 for on or 0 for off.

- Creating A Sub Menu:
	- self add_option("namehere","nameofsub",::_load_menu,"referencesubmenuname");
		- Namehere is the reference name to that menu. nameofsub is the Sub Menu's name. ::_load_menu loads the actual sub menu via function. referencesubmenuname is the reference name to the sub menu.
    
- Real Time Text Updates Example:
  - self add_option("namehere","Real Time Update Text: " +self.updateText,::actualfuntion);
   	- self.updateText is what is updating on the menu option.
