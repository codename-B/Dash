// Player States Enum
enum PLAYERSTATE {
    IDLE,
    WALKING,
    PREJUMP,  // New state for jump wind-up
    JUMPING,
    LANDING,  // New state for landing animation
    DEAD
}
state = PLAYERSTATE.IDLE;

start_x = 96
start_y = 352
// Movement & Physics
walk_speed = 2.5;
jump_force = 14;
gravity_force = 0.5;
vsp = 0;

// Scroll variables that tiles will read
h_scroll = 0;
v_scroll = 0;