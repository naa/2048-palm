2048-palm
=========

2048 for Palm OS in Scheme (lispme)

![Actual device](https://github.com/naa/2048-palm/raw/master/screens/clie.jpg)

I have written it several weeks ago after seeing original game on Hacker News.

Scheme interpreter/compiler for Palm OS is LispMe: http://lispme.de

To run the game you need to install LispMe, resource file 2048DB.prc and source files
2048.scm.pdb and mylib.scm.pdb to your PDA or emulator.

![Step one](https://github.com/naa/2048-palm/raw/master/screens/1.png)

Then create new session:

![Step two](https://github.com/naa/2048-palm/raw/master/screens/2.png)

You can also create icon for the session in session preferences and run the game
from Palm launcher as an ordinary Palm application.

Then load "Standard library" memo, mylib.scm and 2048.scm files:

![Step three](https://github.com/naa/2048-palm/raw/master/screens/3.png)
![Step four](https://github.com/naa/2048-palm/raw/master/screens/4.png)

and eval function call "(go)":

![Step five](https://github.com/naa/2048-palm/raw/master/screens/5.png)

![Final step](https://github.com/naa/2048-palm/raw/master/screens/6.png)


If you want to edit code you can use any PalmDoc editor for PalmOS, e.g. SiEd, SrcEdit.
Or you can edit code on your PC and convert it to PalmDoc with txt2pdbdoc
https://packages.debian.org/wheezy/txt2pdbdoc

