JSimpleModule
=============

This is an extension for OMNeT++ that makes it possible to write model components
a.k.a. simple modules in Java. JSimpleModule was originally written for OMNeT++ 3.3,
then it was part of the OMNeT++ 4.0 through 4.6. It lives on as a separate project.

IMPORTANT:

- Any particular JSimpleModule version is tied to a specific OMNeT++ release.
  You should always use matching versions. THE CURRENT MASTER IS FOR OMNeT++ 4.6.

- Use a released JSimpleModule version if you can. If you check out the repo instead,
  you need to build it (see the `src/` folder) before use.

The `src/` directory contains sources of JSimpleModule. See the `README` file in it
for instructions.

Before use, you need to install JDT (Java Development Tools for Eclipse) into
the OMNeT++ IDE, which can be done via by choosing Help -> Software Updates ->
Find and install... from the menu, and selecting the "Eclipse Project Updates" URL.

The `jsimple` and `jsamples` directories are Eclipse projects that can be imported
into the IDE once JSimpleModule is built from source, and JDT is installed.

Further details in `jsimple/README` -- read it before you start programming!

Enjoy,
Andras

