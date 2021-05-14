/* DEVICE.cpp */

#include "device.h"

#include <mapper_cpp.h>

// Add godot module methods here
mapper::Device dev;

// Constructors
Device::Device(String name) {

    //convert Godot String to Godot CharString to C string
    dev = new mapper::Device(name.ascii().get_data());
}

Device::Device(){}



/* Example:
bool TTS::say_text(String p_txt) {

    //convert Godot String to Godot CharString to C string
    return festival_say_text(p_txt.ascii().get_data());
} */

int Device::poll_blocking(int block_ms) {
    return dev.poll(block_ms);
}

int Device::poll() {
    return dev.poll();
}

bool Device::ready() {
    return dev.ready();
}

/*
int DEVICE::free() {
    return dev.free();
}
ERROR: mapper::DEVICE has no member free()?????
*/




// Bind methods from above:
void Device::_bind_methods() {

    // Example: ClassDB::bind_method(D_METHOD("say_text", "txt"), &DEVICE::say_text);
    ClassDB::bind_method(D_METHOD("poll_blocking", "block_ms"), &Device::poll_blocking);
    ClassDB::bind_method(D_METHOD("poll"), &Device::poll);
    ClassDB::bind_method(D_METHOD("ready"), &Device::ready);
}

