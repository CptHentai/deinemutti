///scr_create_dungeon4(Cellsize, Rooms, Room size MAX, Room size MIN)

// Setup some variables
var cellsize        = argument0;
var rooms           = argument1;
var room_size_max   = argument2;
var room_size_min   = argument3;
var current_rooms   = 0;
var phase           = 1;

// Set up some constants
var FLOOR       = -5;
var WALL        = -6;
var VOID        = -7;
var DOOR        = -8;
var CORRIDOR    = -9;


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
var initial_size = irandom_range(room_size_min,room_size_max);
if !(initial_size mod 2 == 0) initial_size -= 1;
for (var xx = -(initial_size / 2); xx < (initial_size / 2); xx++) {
    for (var yy = -(initial_size / 2); yy < (initial_size / 2); yy++) {
        ds_grid_set(grid, cx + xx, cy + yy, FLOOR);
    }
}

// Create rest of dungeon
do {
    // Init some variables
    var door_on_side = 0;
    
    
    // Phase 1: Find random wall
    if (phase == 1) {
        var wall_found = 0;
        do {
            random_width = irandom(width);
            random_height = irandom(height);
            if (ds_grid_get(grid, random_width, random_height) == FLOOR || ds_grid_get(grid, random_width, random_height) == CORRIDOR) {
                if (ds_grid_get(grid, random_width + 1, random_height) == VOID) {
                    wall_found = 1;
                    door_on_side = 0;
                    ds_grid_set(grid, random_width + 1, random_height, DOOR);
                    
                } else if (ds_grid_get(grid, random_width - 1, random_height) == VOID) {
                    wall_found = 1;
                    door_on_side = 1;
                    ds_grid_set(grid, random_width - 1, random_height, DOOR);
                    
                } else if (ds_grid_get(grid, random_width, random_height + 1) == VOID) {
                    wall_found = 1;
                    door_on_side = 2;
                    ds_grid_set(grid, random_width, random_height + 1, DOOR);
                    
                } else if (ds_grid_get(grid, random_width, random_height - 1) == VOID) {
                    wall_found = 1;
                    door_on_side = 3;
                    ds_grid_set(grid, random_width, random_height - 1, DOOR);
                }
            } 
        } until (wall_found == 1);
        phase = 2;
        
    }
    
    // Phase 2: Scan area to make sure its okay to place a corridor (choose corridor size)
    if (phase == 2) {
        corridor_size = irandom_range(3,10);
        phase = 3;
        
        // Right Side
        if (door_on_side == 0) {
            for (var i = 0; i < corridor_size; i++) {
                for (var j = 0; j < hallwaysize + 1; j++) {
                    if (ds_grid_get(grid, (random_width + 2) + i, (random_height - floor(hallwaysize / 2)) + j) == FLOOR    ||
                        ds_grid_get(grid, (random_width + 2) + i, (random_height - floor(hallwaysize / 2)) + j) == WALL     ||
                        ds_grid_get(grid, (random_width + 2) + i, (random_height - floor(hallwaysize / 2)) + j) == CORRIDOR) {
                            ds_grid_set(grid, random_width + 1, random_height, VOID);
                            phase = 1;
                    }
                }
            }
        }
        // Left Side
        if (door_on_side == 1) {
            for (var i = 0; i < corridor_size; i++) {
                for (var j = 0; j < hallwaysize + 1; j++) {
                    if (ds_grid_get(grid, (random_width - 2) - i, (random_height - floor(hallwaysize / 2)) + j) == FLOOR    ||
                        ds_grid_get(grid, (random_width - 2) - i, (random_height - floor(hallwaysize / 2)) + j) == WALL     ||
                        ds_grid_get(grid, (random_width - 2) - i, (random_height - floor(hallwaysize / 2)) + j) == CORRIDOR) {
                            ds_grid_set(grid, random_width - 1, random_height, VOID);
                            phase = 1;
                    }
                }
            }
        }
        // Down Side
        if (door_on_side == 2) {
            for (var i = 0; i < corridor_size; i++) {
                for (var j = 0; j < hallwaysize + 1; j++) {
                    if (ds_grid_get(grid, random_width - floor(hallwaysize / 2) + j, (random_height + 2) + i) == FLOOR    ||
                        ds_grid_get(grid, random_width - floor(hallwaysize / 2) + j, (random_height + 2) + i) == WALL     ||
                        ds_grid_get(grid, random_width - floor(hallwaysize / 2) + j, (random_height + 2) + i) == CORRIDOR) {
                            ds_grid_set(grid, random_width, random_height + 1, VOID);
                            phase = 1;
                    }
                }
            }        
        }
        
        // Up Side
        if (door_on_side == 3) {
            for (var i = 0; i < corridor_size; i++) {
                for (var j = 0; j < hallwaysize + 1; j++) {
                    if (ds_grid_get(grid, random_width - floor(hallwaysize / 2) + j, (random_height - 2) - i) == FLOOR    ||
                        ds_grid_get(grid, random_width - floor(hallwaysize / 2) + j, (random_height - 2) - i) == WALL     ||
                        ds_grid_get(grid, random_width - floor(hallwaysize / 2) + j, (random_height - 2) - i) == CORRIDOR) {
                            ds_grid_set(grid, random_width, random_height - 1, VOID);
                            phase = 1;
                    }
                }
            }        
        }
    }
    
    // Phase 3: If clear, place new corridor
    if (phase == 3) {
        // Right Size
        if (door_on_side == 0) {
            for (var i = 0; i < corridor_size; i++) {
                ds_grid_set(grid, (random_width + 2) + i, random_height, CORRIDOR);
            }        
        }
        
        // Left Side
        if (door_on_side == 1) {
            for (var i = 0; i < corridor_size; i++) {
                ds_grid_set(grid, (random_width - 2) - i, random_height, CORRIDOR);
            }         
        }
        
        // Down Side
        if (door_on_side == 2) {
            for (var i = 0; i < corridor_size; i++) {
                ds_grid_set(grid, random_width, (random_height + 2) + i, CORRIDOR);
            }         
        }        
        // Up Side
        if (door_on_side == 3) {
             for (var i = 0; i < corridor_size; i++) {
                ds_grid_set(grid, random_width, (random_height - 2) - i, CORRIDOR);
            }
        }
        phase = 4;    
    }
    
    // Phase 4: Find random wall in corridor
    if (phase == 4) {
        var corridor_wall_found = 0;
        side = irandom(1);
        do {
            corridor_random_width = irandom(width);
            corridor_random_height = irandom(height);
            if (ds_grid_get(grid, corridor_random_width, corridor_random_height) == CORRIDOR) {
            
            
                // Right Side
                if (door_on_side == 0) {
                    // Up Side
                    if (side == 0) {
                        ds_grid_set(grid, corridor_random_width, corridor_random_height - 1, DOOR);
                    }
                    // Down Side
                    if (side == 1) {
                        ds_grid_set(grid, corridor_random_width, corridor_random_height + 1, DOOR);
                    }   
                }
                // Left Side
                if (door_on_side == 1) {
                    // Up Side
                    if (side == 0) {
                        ds_grid_set(grid, corridor_random_width, corridor_random_height - 1, DOOR);
                    }
                    // Down Side
                    if (side == 1) {
                        ds_grid_set(grid, corridor_random_width, corridor_random_height + 1, DOOR);
                    }                 
                }
                // Down Side
                if (door_on_side == 2) {
                    // Right Side
                    if (side == 0) {
                        ds_grid_set(grid, corridor_random_width + 1, corridor_random_height, DOOR);
                    }
                    // Left Side
                    if (side == 1) {
                        ds_grid_set(grid, corridor_random_width - 1, corridor_random_height, DOOR);
                    }                 
                }
                // Up Side
                if (door_on_side == 3) {
                    // Right Side
                    if (side == 0) {
                        ds_grid_set(grid, corridor_random_width + 1, corridor_random_height, DOOR);
                    }
                    // Left Side
                    if (side == 1) {
                        ds_grid_set(grid, corridor_random_width - 1, corridor_random_height, DOOR);
                    }                 
                }
                corridor_wall_found = 1;
            } 
        } until (corridor_wall_found == 1);
        phase = 5;
    }
    
    // Phase 5: Scan area to make sure its okay to place a room (choose room size, type)
    if (phase == 5) {
        
        // Variables
        rm_height = irandom_range(room_size_min,room_size_max);
        rm_width = irandom_range(room_size_min,room_size_max);
        phase = 6;
        
        // ##### RIGHT SIDE #####
        if (door_on_side == 0) {
            // Up Side
            if (side == 0) {
                for (var i = 0; i < rm_height; i++) {
                    for (var j = 0; j < rm_width; j++) {
                        if (ds_grid_get(grid, (corridor_random_width - floor(rm_width / 2)) + j, ((corridor_random_height - 1) - rm_height) + i) == FLOOR ||
                            ds_grid_get(grid, (corridor_random_width - floor(rm_width / 2)) + j, ((corridor_random_height - 1) - rm_height) + i) == WALL  ||
                            ds_grid_get(grid, (corridor_random_width - floor(rm_width / 2)) + j, ((corridor_random_height - 1) - rm_height) + i) == CORRIDOR) {  
                                ds_grid_set(grid, corridor_random_width, corridor_random_height, CORRIDOR);
                                // Set phase back to 4
                                phase = 4;
                        } 
                    }
                }
            }
            // Down Side
            if (side == 1) {
                for (var i = 0; i < rm_height; i++) {
                    for (var j = 0; j < rm_width; j++) {
                        if (ds_grid_get(grid, (corridor_random_width - floor(rm_width / 2)) + j, ((corridor_random_height + 1) + rm_height) - i) == FLOOR ||
                            ds_grid_get(grid, (corridor_random_width - floor(rm_width / 2)) + j, ((corridor_random_height + 1) + rm_height) - i) == WALL  ||
                            ds_grid_get(grid, (corridor_random_width - floor(rm_width / 2)) + j, ((corridor_random_height + 1) + rm_height) - i) == CORRIDOR) {
                                ds_grid_set(grid, corridor_random_width, corridor_random_height, CORRIDOR);
                                // Set phase back to 4
                                phase = 4;
                        }                         
                    }
                }            
            }
        }
        
        // ##### LEFT SIDE #####
        if (door_on_side == 1) {
            // Up Side
            if (side == 0) {
                for (var i = 0; i < rm_height; i++) {
                    for (var j = 0; j < rm_width; j++) {
                        if (ds_grid_get(grid, (corridor_random_width - floor(rm_width / 2)) + j, ((corridor_random_height - 1) - rm_height) + i) == FLOOR ||
                            ds_grid_get(grid, (corridor_random_width - floor(rm_width / 2)) + j, ((corridor_random_height - 1) - rm_height) + i) == WALL  ||
                            ds_grid_get(grid, (corridor_random_width - floor(rm_width / 2)) + j, ((corridor_random_height - 1) - rm_height) + i) == CORRIDOR) {
                                ds_grid_set(grid, corridor_random_width, corridor_random_height, CORRIDOR);
                                // Set phase back to 4
                                phase = 4;
                        }
                    }
                }                    
            }
            // Down Side
            if (side == 1) {
                for (var i = 0; i < rm_height; i++) {
                    for (var j = 0; j < rm_width; j++) {
                        if (ds_grid_get(grid, (corridor_random_width - floor(rm_width / 2)) + j, ((corridor_random_height + 1) + rm_width) - i) == FLOOR ||
                            ds_grid_get(grid, (corridor_random_width - floor(rm_width / 2)) + j, ((corridor_random_height + 1) + rm_width) - i) == WALL  ||
                            ds_grid_get(grid, (corridor_random_width - floor(rm_width / 2)) + j, ((corridor_random_height + 1) + rm_width) - i) == CORRIDOR) {
                                ds_grid_set(grid, corridor_random_width, corridor_random_height, CORRIDOR);
                                // Set phase back to 4
                                phase = 4;
                        }
                    }
                }             
            }        
        }        
        // ##### DOWN SIDE #####
        if (door_on_side == 2) {
            // Right Side
            if (side == 0) {
                for (var i = 0; i < rm_height; i++) {
                    for (var j = 0; j < rm_width; j++) {
                        if (ds_grid_get(grid, ((corridor_random_width + 1) + 1) + j, (corridor_random_height - floor(rm_height / 2)) + i) == FLOOR ||
                            ds_grid_get(grid, ((corridor_random_width + 1) + 1) + j, (corridor_random_height - floor(rm_height / 2)) + i) == WALL  ||
                            ds_grid_get(grid, ((corridor_random_width + 1) + 1) + j, (corridor_random_height - floor(rm_height / 2)) + i) == CORRIDOR) {
                                ds_grid_set(grid, corridor_random_width, corridor_random_height, CORRIDOR);
                                // Set phase back to 4
                                phase = 4;
                        }
                    }
                }             
            }
            // Left Side
            if (side == 1) {
                 for (var i = 0; i < rm_height; i++) {
                    for (var j = 0; j < rm_width; j++) {
                        if (ds_grid_get(grid, ((corridor_random_width - 1) - 1) - j, (corridor_random_height - floor(rm_height / 2)) + i) == FLOOR ||
                            ds_grid_get(grid, ((corridor_random_width - 1) - 1) - j, (corridor_random_height - floor(rm_height / 2)) + i) == WALL  ||
                            ds_grid_get(grid, ((corridor_random_width - 1) - 1) - j, (corridor_random_height - floor(rm_height / 2)) + i) == CORRIDOR) {
                                ds_grid_set(grid, corridor_random_width, corridor_random_height, CORRIDOR);
                                // Set phase back to 4
                                phase = 4;
                        }
                    }
                }            
            }        
        }        
        // ##### UP SIDE #####
        if (door_on_side == 3) {
            // Right Side
            if (side == 0) {
                for (var i = 0; i < rm_height; i++) {
                    for (var j = 0; j < rm_width; j++) {
                        if (ds_grid_get(grid, ((corridor_random_width + 1) + 1) + j, (corridor_random_height - floor(rm_height / 2)) + i) == FLOOR ||
                            ds_grid_get(grid, ((corridor_random_width + 1) + 1) + j, (corridor_random_height - floor(rm_height / 2)) + i) == WALL  ||
                            ds_grid_get(grid, ((corridor_random_width + 1) + 1) + j, (corridor_random_height - floor(rm_height / 2)) + i) == CORRIDOR) {
                                ds_grid_set(grid, corridor_random_width, corridor_random_height, CORRIDOR);
                                // Set phase back to 4
                                phase = 4;
                        }
                    }
                }            
            }
            // Left Side
            if (side == 1) {
                 for (var i = 0; i < rm_height; i++) {
                    for (var j = 0; j < rm_width; j++) {
                        if (ds_grid_get(grid, ((corridor_random_width - 1) - 1) - j, (corridor_random_height - floor(rm_height / 2)) + i) == FLOOR ||
                            ds_grid_get(grid, ((corridor_random_width - 1) - 1) - j, (corridor_random_height - floor(rm_height / 2)) + i) == WALL  ||
                            ds_grid_get(grid, ((corridor_random_width - 1) - 1) - j, (corridor_random_height - floor(rm_height / 2)) + i) == CORRIDOR) {
                                ds_grid_set(grid, corridor_random_width, corridor_random_height, CORRIDOR);
                                // Set phase back to 4
                                phase = 4;
                        }
                    }
                }            
            }        
        }
    }
    
    // Phase 6: if clear, place new room
    if (phase == 6) {
        // ##### RIGHT SIDE #####
        if (door_on_side == 0) {
            // Up Side
            if (side == 0) {
                for (var i = 0; i < rm_height; i++) {
                    for (var j = 0; j < rm_width; j++) {
                        ds_grid_set(grid, (corridor_random_width - floor(rm_width / 2)) + j, ((corridor_random_height - 1) - rm_height) + i, FLOOR);
                    }
                }
            }
            // Down Side
            if (side == 1) {
                for (var i = 0; i < rm_height; i++) {
                    for (var j = 0; j < rm_width; j++) {
                        ds_grid_set(grid, (corridor_random_width - floor(rm_width / 2)) + j, ((corridor_random_height + 1) + rm_height) - i, FLOOR);
                    }
                }            
            }
            current_rooms++;
            phase = 1;
        }
        
        // ##### LEFT SIDE #####
        if (door_on_side == 1) {
            // Up Side
            if (side == 0) {
                for (var i = 0; i < rm_height; i++) {
                    for (var j = 0; j < rm_width; j++) {
                        ds_grid_set(grid, (corridor_random_width - floor(rm_width / 2)) + j, ((corridor_random_height - 1) - rm_height) + i, FLOOR);
                    }
                }                    
            }
            // Down Side
            if (side == 1) {
                for (var i = 0; i < rm_height; i++) {
                    for (var j = 0; j < rm_width; j++) {
                        ds_grid_set(grid, (corridor_random_width - floor(rm_width / 2)) + j, ((corridor_random_height + 1) + rm_height) - i, FLOOR);
                    }
                }             
            }
            current_rooms++;
            phase = 1;   
        }        
        // ##### DOWN SIDE #####
        if (door_on_side == 2) {
            // Right Side
            if (side == 0) {
                for (var i = 0; i < rm_height; i++) {
                    for (var j = 0; j < rm_width; j++) {
                        ds_grid_set(grid, ((corridor_random_width + 1) + 1) + j, (corridor_random_height - floor(rm_height / 2)) + i, FLOOR);
                    }
                }             
            }
            // Left Side
            if (side == 1) {
                 for (var i = 0; i < rm_height; i++) {
                    for (var j = 0; j < rm_width; j++) {
                        ds_grid_set(grid, ((corridor_random_width - 1) - 1) - j, (corridor_random_height - floor(rm_height / 2)) + i, FLOOR);
                    }
                }            
            }
            current_rooms++;
            phase = 1;        
        }        
        // ##### UP SIDE #####
        if (door_on_side == 3) {
            // Right Side
            if (side == 0) {
                for (var i = 0; i < rm_height; i++) {
                    for (var j = 0; j < rm_width; j++) {
                        ds_grid_set(grid, ((corridor_random_width + 1) + 1) + j, (corridor_random_height - floor(rm_height / 2)) + i, FLOOR);
                    }
                }            
            }
            // Left Side
            if (side == 1) {
                 for (var i = 0; i < rm_height; i++) {
                    for (var j = 0; j < rm_width; j++) {
                        ds_grid_set(grid, ((corridor_random_width - 1) - 1) - j, (corridor_random_height - floor(rm_height / 2)) + i, FLOOR);
                    }
                }            
            } 
            current_rooms++;
            phase = 1;    
        }        
    }

} until ( current_rooms = rooms );

// Convert everything to floor
for (var i = 0; i < height; i++) {
    for (var j = 0; j < width; j++) {
        if (ds_grid_get(grid, j, i) == CORRIDOR) ds_grid_set(grid, j, i, FLOOR);
        if (ds_grid_get(grid, j, i) == DOOR) ds_grid_set(grid, j, i, FLOOR);
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
            // Draw Wall
            tile_add(bg_wall, 0, 0, cellsize, cellsize, xx * cellsize, yy * cellsize, 0);
        }
    }
}  
