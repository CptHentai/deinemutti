/// scrItemHover(icon,name,type,dmg,desc,quality,bonus1,bonus2,req);

// Variables
icon = argument0;
name = argument1;
type = argument2;
dmg = argument3;
desc = argument4;
quality = argument5;
bonus1 = argument6;
bonus2 = argument7;
req = argument8;

// Draw the item description at the mouse

// Set the colors for the background and the outline
hudbg = make_color_rgb(67, 71, 107); // set the hud bg to a dark-tint blue
hudbg2 = quality; // make the outline the same as the quality
bonuscolor = make_color_rgb(94,234,121); // make the bonus qualities green
// Make the HUD BG translucent
draw_set_alpha(0.8); // HALF translucent
draw_rectangle_colour(mouse_x+20,mouse_y,mouse_x+270,mouse_y+170,hudbg,hudbg,hudbg,hudbg,0);
draw_set_alpha(1); // set alpha back
draw_rectangle_colour(mouse_x+20,mouse_y,mouse_x+270,mouse_y+170,hudbg2,hudbg2,hudbg2,hudbg2,1);
// Draw the weapon icon
draw_sprite(icon,0,mouse_x+44,mouse_y+24);
// Set the font for the name
draw_set_font(fntHud);
// Draw the name
draw_text_ext_colour(mouse_x+25+40,mouse_y+5,string(name),0,245,quality,quality,quality,quality,1);
// Set the font for the content
draw_set_font(fntHud2);
// Draw the type of weapon
draw_text_ext_colour(mouse_x+25+40,mouse_y+25,string(type),0,100,quality,quality,quality,quality,1);
// Draw the damage for the weapon
draw_text_ext_colour(mouse_x+25,mouse_y+45,string(dmg),0,245,bonuscolor,bonuscolor,bonuscolor,bonuscolor,1);
// Draw the description for the weapon
draw_text_ext_colour(mouse_x+25,mouse_y+65,string(desc),20,245,c_white,c_white,c_white,c_white,1);
// Draw the bonus 1
draw_text_ext_colour(mouse_x+25,mouse_y+105,string(bonus1),0,100,bonuscolor,bonuscolor,bonuscolor,bonuscolor,1);
// Draw the bonus 2
draw_text_ext_colour(mouse_x+25,mouse_y+125,string(bonus2),0,100,bonuscolor,bonuscolor,bonuscolor,bonuscolor,1);
// Set the font for the requirements
draw_set_font(fntHud3);
// Draw the requirements for the weapon
draw_text_ext_colour(mouse_x+25,mouse_y+145,string(req),0,245,c_red,c_red,c_red,c_red,1);