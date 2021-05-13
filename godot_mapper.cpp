/* godot_mapper.cpp */

#include "godot_mapper.h"

#include <mapper_cpp.h>

// Add godot module methods here

/* Example:
bool GODOT_MAPPER::(String p_txt) {

    //convert Godot String to Godot CharString to C string
    return festival_say_text(p_txt.ascii().get_data());
} */


// Bind methods from above:
void GODOT_MAPPER::_bind_methods() {

    // ClassDB::bind_method(D_METHOD("say_text", "txt"), &GODOT_MAPPER::say_text);
}

GODOT_MAPPER::GODOT_MAPPER() {
    // Constructor, intialize here
}