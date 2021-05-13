/* register_types.cpp */

#include "register_types.h"

#include "core/class_db.h"
#include "godot_mapper.h"

void register_godot_mapper_types() {
    ClassDB::register_class<GODOT_MAPPER>();
}

void unregister_godot_mapper_types() {
    
}