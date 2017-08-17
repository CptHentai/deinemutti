///scr_save_dungeon(Save Name)
var section = argument0;

ini_open("dungeon.ini");    // Open the INI

var dump = ds_grid_write(grid);
ini_write_string(string(section),"dump",string(dump));

ini_close();    // Close the INI
