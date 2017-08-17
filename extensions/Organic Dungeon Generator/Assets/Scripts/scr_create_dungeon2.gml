/// scr_create_dungeon2(Cell Size, Reps, Direction Frequency, Room size average, Room Frequency)

var cellsize        = argument0;
var reps            = argument1;
var dirfrequency    = argument2;
var roomsize        = argument3;
var roomfrequency   = argument4;;

// Set up some constants
var FLOOR       = -5;
var WALL        = -6;
var VOID        = -7;


// Set Grid width and height
var width = (room_width div cellsize);
var height = (room_height div cellsize);

// Create the Grid
grid = ds_grid_create(width,height);

// Fill Grid
ds_grid_set_region(grid,0,0,width - 1, height - 1, VOID);

// Randomize the Word
randomize();

// Create the controller in center of grid
var cx = (width div 2);
var cy = (height div 2);

// Create the inital Room
for (var xx = -(roomsize / 2); xx < (roomsize / 2); xx++) {
    for (var yy = -(roomsize / 2); yy < (roomsize / 2); yy++) {
        ds_grid_set(grid, cx + xx, cy + yy, FLOOR);
    }
}

// Create the player
instance_create(cx * cellsize + 16, cy * cellsize + 16, obj_player);

// Give the carver a random starting direction
var cdir = irandom(3);

// Odds variable for moving or creating various things
odds = 1;

// Create the room
repeat(reps) {

    // Place floor tile where we are
    ds_grid_set(grid, cx, cy, FLOOR);

    // Randomize the directon BUT make sure you cant turn around 180 degreese
    if (irandom(odds * dirfrequency) == odds) {
        // 0
        if (cdir = 0) {
            cdir = choose(0,1,3);
        }
        // 90
        if (cdir = 1) {
            cdir = choose(0,1,2);
        }
        // 180
        if (cdir = 2) {
            cdir = choose(1,2,3);   
        }
        // 270
        if (cdir = 3) {
            cdir = choose(0,2,3);
        }
    }
    // Create a room 
    if (irandom(odds * roomfrequency) == odds) {
        var roomsize1 = irandom_range(floor(roomsize * 0.5),floor(roomsize * 1.5));
        for (var xx = -roomsize1; xx < roomsize1; xx++) {
            for (var yy = -roomsize1; yy < roomsize1; yy++) {
                ds_grid_set(grid, cx + xx, cy + yy, FLOOR);
            }
        }
    }
    
    // Move controller
    var xdir = lengthdir_x(1,cdir * 90);
    var ydir = lengthdir_y(1,cdir * 90);
    cx += xdir;
    cy += ydir;
    
    // Make sure we dont move outside grid
    cx = clamp(cx, 1, width - 2);
    cy = clamp(cy, 1, height - 2);
}



// Check to see if there is a floor tile aginst the edge of the grid and change it to a wall
for (var yy = 0; yy < height; yy++) {
    for (var xx = 0; xx < width; xx++) {
        if (ds_grid_get(grid, xx, yy) == FLOOR) {
            if (xx = 0)      ds_grid_set(grid, xx, yy, WALL);        // Check the left wall
            if (xx = width -1)  ds_grid_set(grid, xx, yy, WALL);    // Check the right wall
            if (yy = 0)      ds_grid_set(grid, xx, yy, WALL);        // Check the top wall
            if (yy = height - 1) ds_grid_set(grid, xx, yy, WALL);   // Check the bottom wall
        }
    }
}

// Loop Through the grid and place the walls
for (var yy = 1; yy < height - 1; yy++) {
    for (var xx = 1; xx < width - 1; xx++) {
        if (ds_grid_get(grid, xx, yy) == FLOOR) {
            if (ds_grid_get(grid, xx + 1, yy) != FLOOR) ds_grid_set(grid, xx + 1, yy, WALL);
            if (ds_grid_get(grid, xx - 1, yy) != FLOOR) ds_grid_set(grid, xx - 1, yy, WALL);
            if (ds_grid_get(grid, xx, yy + 1) != FLOOR) ds_grid_set(grid, xx, yy + 1, WALL);
            if (ds_grid_get(grid, xx, yy - 1) != FLOOR) ds_grid_set(grid, xx, yy - 1, WALL);
        }
    }
}


// Draw the level
for (var yy = 0; yy < height; yy++) {
    for (var xx = 0; xx < width; xx++) {
        if (ds_grid_get(grid, xx, yy) == FLOOR) {
            // Draw Floor
            tile_add(bg_floor, 0, 0, cellsize, cellsize, xx * cellsize, yy * cellsize, 0)
        }
        if (ds_grid_get(grid, xx, yy) == WALL) {
            tile_add(bg_wall, 0, 0, cellsize, cellsize, xx * cellsize, yy * cellsize, 0);
        }
    }
}                    
