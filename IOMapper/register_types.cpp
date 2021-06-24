/* register_types.cpp */

#include "register_types.h"

#include "core/class_db.h"
#include "IOMapper.h"


void register_IOMapper_types() {
    ClassDB::register_class<IOMapper>();
    ClassDB::register_class<IOMapper::Signal>();
}

void unregister_IOMapper_types() {
    
}