///scr_load_dungeon(Save Name, Cell Size)
var section = argument0;
var cellsize = argument1;

// ##### GET ALL OF THE DATA FROM THE INI FILES #####
ini_open("dungeon.ini");
var dump = ini_read_string(section,"dump",0);
ini_close();

// ##### CREATE THE DUNGEON #####
var width = (room_width div cellsize);
var height = (room_height div cellsize);
grid = ds_grid_create(width, height);
ds_grid_read(grid, dump);

// Set up some constants
var FLOOR       = -5;
var WALL        = -6;
var VOID        = -7;

// Draw the level
for (var yy = 0; yy < height; yy++) {
    for (var xx = 0; xx < width; xx++) {
        if (ds_grid_get(grid, xx, yy) == FLOOR) {
            // Draw Floor
            tile_add(bg_floor, 0, 0, cellsize, cellsize, xx * cellsize, yy * cellsize, 0)
        }
        if (ds_grid_get(grid, xx, yy) == WALL) {
            // Draw Wall
            tile_add(bg_wall, 0, 0, cellsize, cellsize, xx * cellsize, yy * cellsize, 0);
        }
    }
}