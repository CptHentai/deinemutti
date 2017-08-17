/// scr_create_dungeon(cell size, reps, carver, size)


// Set up the Arguments
var cellsize    = argument0;
var reps        = argument1;
var carver      = argument2;
var size        = argument3;


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

// Create the player
instance_create(cx * cellsize + 16, cy * cellsize + 16, obj_player);

// Give controller random direction
var cdir = irandom(3);

// Odds variable for changing directon
var odds = 1;

repeat(reps) {
    // Place floor tile at controller position
    if (carver == 0 || carver == 1) {
        var start = floor(-(size / 2));     // The start variable is ued to place the carver, no matter how big it is in the center of the controller x and y position
        for (var i = 0; i <= size; i++) {
            // Plus Carver (works kind of like square carver but a bit better)
            if (carver = 0) {
                ds_grid_set(grid, cx + start, cy, FLOOR);
                ds_grid_set(grid, cx, cy + start, FLOOR);
            }
            // Diagonal Carver (My personal favorite)
            if (carver = 1) {
                ds_grid_set(grid, cx + start, cy + start, FLOOR);
            }
            start++;    // add 1 to start
        }
    }
    // Square Carver (lags a bit more when creating the dungeon due to the nested for loop
    if (carver = 2) {
        for (var xx = floor(-((size + 1) / 2)); xx < ((size + 1) / 2); xx++) {
            for (var yy = floor(-((size + 1) / 2)); yy < ((size + 1) / 2); yy++) {
                ds_grid_set(grid, cx + xx, cy + yy, FLOOR);     // Add the floor tile
            }
        }
    }
    // Randomize the directon
    if (irandom(odds) == odds) {    // 1/2 chance to change direction
        cdir = irandom(3);          // Change direction to any direction
    }
    
    // Move controller
    var xdir = lengthdir_x(1,cdir * 90);    // Gets appropriate direction to move based on cdir (Ex: 1(cdir) * 90 = 90 so they move up
    var ydir = lengthdir_y(1,cdir * 90);    // Do the same with above
    cx += xdir;                             // Add the xdir to controller x pos
    cy += ydir;                             // Add the ydir to controller y pos
    
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
            if (ds_grid_get(grid, xx + 1, yy) != FLOOR) ds_grid_set(grid, xx + 1, yy, WALL);    // Add the Right Wall
            if (ds_grid_get(grid, xx - 1, yy) != FLOOR) ds_grid_set(grid, xx - 1, yy, WALL);    // Add the Left Wall
            if (ds_grid_get(grid, xx, yy + 1) != FLOOR) ds_grid_set(grid, xx, yy + 1, WALL);    // Add the Top Wall
            if (ds_grid_get(grid, xx, yy - 1) != FLOOR) ds_grid_set(grid, xx, yy - 1, WALL);    // Add the Bottom Wall
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
            // Draw Wall
            tile_add(bg_wall, 0, 0, cellsize, cellsize, xx * cellsize, yy * cellsize, 0);
        }
    }
}
