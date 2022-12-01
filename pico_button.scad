resolution = 20; //[10, 20, 30, 50, 100]
$fn = resolution;

margin = 0.08;
padding = 0.2;
p_w = 21;
p_h = 51;
p_t = 1.0;
usb_dist_x = 8.0; // width of usb connector
usb_h = 2.7;
usb_ext_y = 1.3; // distance the usb connector hangs over the edge
post_offset_y = 2.4; // center of the hoe from the pico edge
post_dist_x = 11.4; // distance between holes
post_sup_d = 3.0; // amount of space supporting post.
post_r = 2.4 - 1.6; // radius of post
bootsel_btn_y = 12.5;
bootsel_btn_x = 15;
space_under_pico = usb_h + margin;
total_p_t = p_t + space_under_pico + margin;

shell_t = 1.7;

roundness = 3;

module rounded_plate(w, h, t, d) {
    translate([0, (d/2), 0])
    cube([w, (h-d), t]);
    translate([(d/2), 0, 0])
    cube([(w-d), h, t]);
    translate([(d/2), (d/2), 0])
    cylinder(h=t, d=d);
    translate([w-(d/2), (d/2), 0])
    cylinder(h=t, d=d);
    translate([(d/2), h-(d/2), 0])
    cylinder(h=t, d=d);
    translate([w-(d/2), h-(d/2), 0])
    cylinder(h=t, d=d);
}



module post() {
    color("red")
    translate([0, 0, 0]) {
        difference() {
            union() {
                //bottom
                translate([0, 0, 0])
                    cylinder(space_under_pico, d=post_sup_d);
                // post
                translate([0, 0, space_under_pico-margin])
                    cylinder(p_t+post_r, r=(.9*post_r));
                
                // knob on top
                translate([0, 0, space_under_pico+p_t+post_r+margin+margin])
                    sphere(d=post_r*2.2);
            }
            translate([0, 0, space_under_pico+p_t+post_r+margin+margin])
                cube([post_r*.4, 2.2, 2.2], center=true);
        }
    }
}


module pico() {
    color("green")
    difference() {
        cube([p_w, p_h, pt]);
    
        translate([(p_w/2)-(post_dist_x/2), post_offset_y, -.5])
            cylinder(p_t+1, post_r, post_r);
        
        translate([(p_w/2)+(post_dist_x/2), post_offset_y, -.5])
            cylinder(p_t+1, post_r, post_r);
        
        translate([(p_w/2)+(post_dist_x/2), p_h - post_offset_y, -.5])
            cylinder(p_t+1, post_r, post_r);
        
        translate([(p_w/2)-(post_dist_x/2), p_h - post_offset_y, -.5])
            cylinder(p_t+1, post_r, post_r);
    }
    
    color("#888888")
        translate([(p_w/2)-(usb_dist_x/2), -1*usb_ext_y, p_t])
            cube([usb_dist_x, 5.4, usb_h]);
            
    color("#aaaaaa")
        translate([bootsel_btn_x, bootsel_btn_y, p_t])
            cylinder(1.7, d=4);
}

module pi_shell() {
    difference() {
        rounded_plate(p_w + (2*shell_t) + (2*padding), p_h + (2*shell_t) + (2*padding), shell_t + total_p_t, roundness);
        
        translate([shell_t+margin, shell_t+margin, shell_t])
            cube([p_w+(2*margin)+(2*padding), p_h+(2*margin)+(2*padding), total_p_t+margin]);
        
        translate([shell_t+(p_w/2)-(usb_dist_x/2)-margin+padding, 0-margin, shell_t])
            cube([usb_dist_x+margin+margin, 5.4, usb_h*2]);
            
        translate([shell_t + p_w - bootsel_btn_x + padding, shell_t+bootsel_btn_y + padding, -1*margin])
            cylinder(shell_t + margin + margin, d=9);
    }
    
    translate([shell_t + padding, shell_t + padding, shell_t-margin]) {
        translate([(p_w/2)-(post_dist_x/2), p_h - post_offset_y, 0])
            post();
        translate([(p_w/2)+(post_dist_x/2), p_h - post_offset_y, 0])
            post();
        translate([(p_w/2)-(post_dist_x/2), post_offset_y, 0])
            post();
        translate([(p_w/2)+(post_dist_x/2), post_offset_y, 0])
            post();
    }
}

//translate([shell_t+padding, shell_t+padding, shell_t+space_under_pico])
//pico();

pi_shell();