/* godot_mapper.h */

#ifndef GODOT_MAPPER_H
#define GODOT_MAPPER_H

#include "core/reference.h"

class GODOT_MAPPER : public Reference {
    GDCLASS(GODOT_MAPPER, Reference);

protected:
    // Required bethods for binding method to godot 
    static void _bind_methods();

public:
    //methods go here
    //Example: bool say_text(String p_txt);

    GODOT_MAPPER();
};

#endif // GODOT_MAPPER_H