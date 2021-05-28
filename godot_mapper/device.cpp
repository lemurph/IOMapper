/* device.cpp */

#include "device.h"


GodotMapper::GodotMapper() {

}

GodotMapper::~GodotMapper() {
    delete dev;
}

// mapper::GodotMapper causes errors on build when used as return type
void GodotMapper::init(String name) {
    dev = new mapper::Device(name.ascii().get_data());

}

// mapper::Signal causes errors on build when used as return type
void GodotMapper::add_sig(String direction, String name, int length, String datatype) {
    mapper::Direction dir;
    mapper::Type type;


    // Validate datatype field and change type to mapper namespace
    if (datatype != "INT32" && datatype != "FLOAT" && datatype != "DOUBLE") {
        ERR_PRINT("Field 'datatype' in add_sig() must be 'INT32', 'FLOAT', or 'DOUBLE'");
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

    // Validate direction field and change type to mapper namespace
    if (direction != "IN" && direction != "OUT") {
        ERR_PRINT("Field 'direction' in add_sig() must be 'IN' or 'OUT'");
        return;
    }
    else if (direction == "IN") {
        dir = mapper::Direction::INCOMING;
    }
    else if (direction =="OUT") {
        dir = mapper::Direction::OUTGOING;
    }
    
    mapper::Signal sig = dev->add_signal(dir, name.ascii().get_data(), length, type);
    sig.set_property("name", name.ascii().get_data());
    signals.emplace_back(sig);
    //return signal;
}


void GodotMapper::set_value(String signalName, float value) {
    for (int i = 0; i < signals.size(); i++ ) {
        std::string prop_name = signals[i].property("name");
        if (prop_name == signalName.ascii().get_data()) {
            signals[i].set_value(value);
            return;
        }
    }
    std::cout << "Signal not found: Value not set" << std::endl;
}

float GodotMapper::value(String signalName) {
    for (int i = 0; i < signals.size(); i++ ) {
        std::string prop_name = signals[i].property("name");
        if (prop_name == signalName.ascii().get_data()) {
            return *(float*)signals[i].value();
        }
    }
    return -1;
}

int GodotMapper::poll_blocking(int block_ms) {
    return dev->poll(block_ms);
}

int GodotMapper::poll() {
    return dev->poll();
}

bool GodotMapper::ready() {
    return dev->ready();
}


// Bind methods from above:
void GodotMapper::_bind_methods() {

    ClassDB::bind_method(D_METHOD("poll_blocking", "block_ms"), &GodotMapper::poll_blocking);
    ClassDB::bind_method(D_METHOD("poll"), &GodotMapper::poll);
    ClassDB::bind_method(D_METHOD("ready"), &GodotMapper::ready);
    ClassDB::bind_method(D_METHOD("init", "name"), &GodotMapper::init);
    ClassDB::bind_method(D_METHOD("add_sig", "direction", "name", "length", "datatype"), &GodotMapper::add_sig);
    ClassDB::bind_method(D_METHOD("set_value", "signalName", "value"), &GodotMapper::set_value);
    ClassDB::bind_method(D_METHOD("value", "signalName"), &GodotMapper::value);
}

