sardinia
========

Moderator program for 1865 Sardinia board game

This program helps in playing the board game '1865 Sardinia' by Gotha games. It is an 18xx-type board game, 
the moderator program takes care of bank and stock management and thus shortens the game play.

At current state, the moderator program should include all rules and I am not aware of any functional bugs.
If you find any, please let me now.

Typically you want to present the screen to all players. For this, you can adjust the GUI (drag the tables
to a size fitting your screen) and change the font size by pressing 'cmd +' and 'cmd -'. Currently, 
the table headers have a fixed height. I didn't manage changing the height programatically, to do this
properly, one needs to subclass the view of the table header and change it accordingly. I didn't come
around doing this yet...

You can save and load games, you can also go back N. I hope the rest is self explaining...

If have any input, want to participate, etc. please let me know.

Jan Norden
