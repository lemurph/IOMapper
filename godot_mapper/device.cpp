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
    
}

mapper::Signal GodotMapper::sig_get(String name) {
    for (int i = 0; i < signals.size(); i++ ) {
        std::string prop_name = signals[i].property("name");
        if (prop_name == name.ascii().get_data()) {
            return signals[i];
        }
    }
    std::cout << "Signal not found: Value not set" << std::endl;
    return NULL;
}


void GodotMapper::set_value_float(String signalName, float value) {
    sig_get(signalName).set_value(value);
}

void GodotMapper::set_value_int(String signalName, int32_t value) {
    sig_get(signalName).set_value(value);
}

void GodotMapper::set_value_double(String signalName, double value) {
    sig_get(signalName).set_value(value);
}

int32_t GodotMapper::value_int(String signalName) {
    int32_t value;
    mapper::Signal sig = sig_get(signalName);
    memcpy(&value, sig.value(), sizeof(sig.value()));

    return value;
}

float GodotMapper::value_float(String signalName) {
    float value;
    mapper::Signal sig = sig_get(signalName);
    memcpy(&value, sig.value(), sizeof(sig.value()));

    return value;
}

double GodotMapper::value_double(String signalName) {
    double value;
    mapper::Signal sig = sig_get(signalName);
    memcpy(&value, sig.value(), sizeof(sig.value()));

    return value;
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
    ClassDB::bind_method(D_METHOD("set_value_int", "signalName", "value"), &GodotMapper::set_value_int);
    ClassDB::bind_method(D_METHOD("set_value_float", "signalName", "value"), &GodotMapper::set_value_float);
    ClassDB::bind_method(D_METHOD("set_value_double", "signalName", "value"), &GodotMapper::set_value_double);
    ClassDB::bind_method(D_METHOD("value_int", "signalName"), &GodotMapper::value_int);
    ClassDB::bind_method(D_METHOD("value_float", "signalName"), &GodotMapper::value_float);
    ClassDB::bind_method(D_METHOD("value_double", "signalName"), &GodotMapper::value_double);
}

