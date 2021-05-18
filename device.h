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
        mapper::Device dev;
        std::vector<mapper::Signal> signals;

        // Method headers go here

        void init(String name);
        int poll_blocking(int block_ms);
        int poll();
        bool ready();
        int free();
        //void set_value(float value);
        
        // Optional fields have been omitted for now
        void add_sig(String direction, String name, int length, String datatype);



        Device();
};

#endif // DEVICE_H