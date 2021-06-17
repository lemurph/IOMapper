/* register_types.cpp */

#include "register_types.h"

#include "core/class_db.h"
#include "IOMapper.h"


void register_godot_mapper_types() {
    ClassDB::register_class<IOMapper>();
}

void unregister_godot_mapper_types() {
    
}