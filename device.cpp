/* DEVICE.cpp */

#include "device.h"


mapper::Device dev;

Device::Device() {

}

// mapper::Device causes errors on build when used as return type
void Device::init(String name) {
    dev = new mapper::Device(name.ascii().get_data());
    //return dev;
}

// mapper::Signal causes errors on build when used as return type
void Device::add_sig(String direction, String name, int length, String datatype) {
    
    mapper::Direction dir;
    mapper::Type type;

    // Validate direction field and change type to mapper namespace
    if (direction != "IN" && direction != "OUT") {
        std::cout << "Field 'direction' in add_sig() must be 'IN' or 'OUT'";
        return;
    }
    else if (direction == "IN") {
        dir = mapper::Direction::INCOMING;
    }
    else if (direction =="OUT") {
        dir = mapper::Direction::OUTGOING;
    }

    // Validate datatype field and change type to mapper namespace
    if (datatype != "INT32" && datatype != "FLOAT" && datatype != "DOUBLE") {
        std::cout << "Field 'datatype' in add_sig() must be 'INT32', 'FLOAT', or 'DOUBLE'";
        return;
    }
    else if (datatype == "INT32") {
        type = mapper::Type::INT32;
    }
    else if (datatype == "FLOAT") {
        type = mapper::Type::FLOAT;
    }
    else if (datatype == "DOUBLE") {
        type = mapper::Type::DOUBLE;
    }

    mapper::Signal signal;
    signal = dev.add_signal(dir, name.ascii().get_data(), length, type);

    //return signal;
}

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
ERROR: mapper::Device has no member free()?????
*/




// Bind methods from above:
void Device::_bind_methods() {

    // Example: ClassDB::bind_method(D_METHOD("say_text", "txt"), &Device::say_text);
    ClassDB::bind_method(D_METHOD("poll_blocking", "block_ms"), &Device::poll_blocking);
    ClassDB::bind_method(D_METHOD("poll"), &Device::poll);
    ClassDB::bind_method(D_METHOD("ready"), &Device::ready);
    ClassDB::bind_method(D_METHOD("init", "name"), &Device::init);
    ClassDB::bind_method(D_METHOD("add_sig", "direction", "name", "length", "datatype"), &Device::add_sig);
}

