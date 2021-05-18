/* register_types.cpp */

#include "register_types.h"

#include "core/class_db.h"
#include "device.h"

void register_godot_mapper_types() {
    ClassDB::register_class<Device>();
}

void unregister_godot_mapper_types() {
    
}