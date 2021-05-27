/* device.h */

#ifndef GODOT_MAPPER_H
#define GODOT_MAPPER_H

#include "core/reference.h"
#include "core/func_ref.h"
#include "core/variant.h"
#include <mapper_cpp.h>


class GodotMapper : public Reference {
    GDCLASS(GodotMapper, Reference);

    protected:
        // Required for binding methods to godot 
        static void _bind_methods();


    public:

        // Struct for storing signal names
        struct SIGNAL {
            mapper::Signal sig;
            String name;
        };

        mapper::Device* dev;
        std::vector<struct SIGNAL> signals;

        // Method headers go here

        void init(String name);
        int poll_blocking(int block_ms);
        int poll();
        bool ready();

        // Optional fields have been omitted for now
        void add_sig(String direction, String name, int length, String datatype);
        
        // Temporarily using 'float' for testing
        void set_value(String sigName, float value);
        float value(String sigName);
            

        GodotMapper();
        ~GodotMapper();


};

#endif // GODOT_MAPPER_H