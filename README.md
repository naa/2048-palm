2048-palm
=========

2048 for Palm OS in Scheme (lispme)

I have written it several weeks ago after seeing original game on Hacker News.

Scheme interpreter/compiler for Palm OS is lispme http://lispme.de

To run the game you need to install LispMe, resource file 2048DB.prc and source files
2048.scm.pdb and mylib.scm.pdb to your PDA or emulator.

Then create new session, load "Standard library" memo, mylib.scm and 2048.scm files
and call function (go).

![]()

You can also create icon for the session in session preferences and run the game
from Palm launcher as an ordinary Palm application.

See "screens" folder for details.


If you want to edit code you can use any PalmDoc editor for PalmOS, e.g. SiEd, SrcEdit.
Or you can edit code on your PC and convert it to PalmDoc with txt2pdbdoc
https://packages.debian.org/wheezy/txt2pdbdoc

