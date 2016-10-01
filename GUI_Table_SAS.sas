%Let fpath = C:\Path\To\Working\Directory;

** ASSIGN CATALOG LIBRARY;
libname GUItable "&fpath";

** READ IN INC DATA;
proc import
	datafile = "&fpath\DATA\IncData.csv"
	out = IncData
	dbms = csv;
run;

** LAUNCH FRAME;
proc display CATALOG=GUItable.Catalog.Gui_table.frame;
run;
