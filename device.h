/* device.h */

#ifndef DEVICE_H
#define DEVICE_H

#include "core/reference.h"
#include <mapper_cpp.h>

class Device : public Reference {
    GDCLASS(Device, Reference);

    protected:
        // Required for binding methods to godot 
        static void _bind_methods();

    public:
        // Method headers go here
        //Example: bool say_text(String p_txt);

        int poll_blocking(int block_ms);
        int poll();
        bool ready();
        int free();
        void init(String name);

        // Optional fields have been omitted for now
        void add_sig(String direction, String name, int length, String datatype);
 


        Device();
};

#endif // DEVICE_H