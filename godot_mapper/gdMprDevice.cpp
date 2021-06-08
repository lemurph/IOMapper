/* gdMprDevice.cpp */

#include "gdMprDevice.h"


gdMprDevice::gdMprDevice() {

}

gdMprDevice::~gdMprDevice() {
    delete dev;
}

// mapper::gdMprDevice causes errors on build when used as return type
void gdMprDevice::init(String name) {
    dev = new mapper::Device(name.ascii().get_data());
}

// mapper::Signal causes errors on build when used as return type
void gdMprDevice::add_sig(Direction dir, String name, int length, Type type) {
    
    mapper::Signal sig = dev->add_signal((mapper::Direction)dir, name.ascii().get_data(),
                                         length, (mapper::Type)type);
    signals.emplace_back(sig);
}


// Methods for setting signal properties
void gdMprDevice::set_property_int(String sigName, Property property, int value) {
    sig_get(sigName).set_property((mapper::Property)property, value);
}
void gdMprDevice::set_property_float(String sigName, Property property, float value) {
    sig_get(sigName).set_property((mapper::Property)property, value);
}
void gdMprDevice::set_property_double(String sigName, Property property, double value) {
    sig_get(sigName).set_property((mapper::Property)property, value);
}

// Methods for getting signal properties
int32_t gdMprDevice::get_property_int(String sigName, Property property) {
    return (int32_t)sig_get(sigName).property((mapper::Property)property);
}
float gdMprDevice::get_property_float(String sigName, Property property) {
    return (float)sig_get(sigName).property((mapper::Property)property);
}
double gdMprDevice::get_property_double(String sigName, Property property) {
    return (double)sig_get(sigName).property((mapper::Property)property);
}

// Helper method for retrieving signal by name
mapper::Signal gdMprDevice::sig_get(String name) {

    for (int i = 0; i < signals.size(); i++ ) {
        std::string prop_name = signals[i].property("name");
        if (prop_name == name.ascii().get_data()) {
            return signals[i];
        }
    }
    std::cout << "Signal not found: Value not set" << std::endl;
    return NULL;
}


// Signal value set functions
void gdMprDevice::set_value_float(String signalName, float value) {
    sig_get(signalName).set_value(value);
}

void gdMprDevice::set_value_int(String signalName, int32_t value) {
    sig_get(signalName).set_value(value);
}

void gdMprDevice::set_value_double(String signalName, double value) {
    sig_get(signalName).set_value(value);
}




// Signal value get functions
int32_t gdMprDevice::get_value_int(String signalName) {
    int32_t value; 
    mapper::Signal sig = sig_get(signalName);
    memcpy(&value, sig.value(), sizeof(sig.value()));

    return value;
}

float gdMprDevice::get_value_float(String signalName) {
    float value;
    mapper::Signal sig = sig_get(signalName);
    memcpy(&value, sig.value(), sizeof(sig.value()));

    return value;
}

double gdMprDevice::get_value_double(String signalName) {
    double value;
    mapper::Signal sig = sig_get(signalName);
    memcpy(&value, sig.value(), sizeof(sig.value()));

    return value;
}





int gdMprDevice::poll_blocking(int block_ms) {
    return dev->poll(block_ms);
}

int gdMprDevice::poll() {
    return dev->poll();
}

bool gdMprDevice::ready() {
    return dev->ready();
}


// Bind methods from above:
void gdMprDevice::_bind_methods() {

    ClassDB::bind_method(D_METHOD("poll_blocking", "block_ms"), &gdMprDevice::poll_blocking);
    ClassDB::bind_method(D_METHOD("poll"), &gdMprDevice::poll);
    ClassDB::bind_method(D_METHOD("ready"), &gdMprDevice::ready);
    ClassDB::bind_method(D_METHOD("init", "name"), &gdMprDevice::init);
    ClassDB::bind_method(D_METHOD("add_sig", "direction", "name", "length", "type"), &gdMprDevice::add_sig);
    ClassDB::bind_method(D_METHOD("set_property_int", "signalName", "property", "value"), &gdMprDevice::set_property_int);
    ClassDB::bind_method(D_METHOD("set_property_float", "signalName", "property", "value"), &gdMprDevice::set_property_float);
    ClassDB::bind_method(D_METHOD("set_property_double", "signalName", "property", "value"), &gdMprDevice::set_property_double);
    ClassDB::bind_method(D_METHOD("get_property_int", "signalName", "property"), &gdMprDevice::get_property_int);
    ClassDB::bind_method(D_METHOD("get_property_float", "signalName", "property"), &gdMprDevice::get_property_float);
    ClassDB::bind_method(D_METHOD("get_property_double", "signalName", "property"), &gdMprDevice::get_property_double);
    ClassDB::bind_method(D_METHOD("set_value_int", "signalName", "value"), &gdMprDevice::set_value_int);
    ClassDB::bind_method(D_METHOD("set_value_float", "signalName", "value"), &gdMprDevice::set_value_float);
    ClassDB::bind_method(D_METHOD("set_value_double", "signalName", "value"), &gdMprDevice::set_value_double);
    //ClassDB::bind_method(D_METHOD("set_value_int_array", "signalName", "values"), &gdMprDevice::set_value_int_array);
    ClassDB::bind_method(D_METHOD("get_value_int", "signalName"), &gdMprDevice::get_value_int);
    ClassDB::bind_method(D_METHOD("get_value_float", "signalName"), &gdMprDevice::get_value_float);
    ClassDB::bind_method(D_METHOD("get_value_double", "signalName"), &gdMprDevice::get_value_double);
    //ClassDB::bind_method(D_METHOD("value_int_array", "signalName"), &gdMprDevice::value_int_array);

    // Direction enum constants
    BIND_ENUM_CONSTANT(INCOMING);
    BIND_ENUM_CONSTANT(OUTGOING);

    // Type enum constants
    BIND_ENUM_CONSTANT(FLOAT);
    BIND_ENUM_CONSTANT(INT32);
    BIND_ENUM_CONSTANT(DOUBLE);

    // Property enum constants
    BIND_ENUM_CONSTANT(CALIBRATING);
    BIND_ENUM_CONSTANT(DEVICE);
    BIND_ENUM_CONSTANT(DIRECTION);
    BIND_ENUM_CONSTANT(EXPRESSION);
    BIND_ENUM_CONSTANT(HOST);
    BIND_ENUM_CONSTANT(ID);
    BIND_ENUM_CONSTANT(IS_LOCAL);
    BIND_ENUM_CONSTANT(JITTER);
    BIND_ENUM_CONSTANT(LENGTH);
    BIND_ENUM_CONSTANT(LIBVERSION);
    BIND_ENUM_CONSTANT(LINKED);
    BIND_ENUM_CONSTANT(LINKED);
    BIND_ENUM_CONSTANT(MAX);
    BIND_ENUM_CONSTANT(MIN);
    BIND_ENUM_CONSTANT(MUTED);
    BIND_ENUM_CONSTANT(NAME);
    BIND_ENUM_CONSTANT(NUM_INSTANCES);
    BIND_ENUM_CONSTANT(NUM_MAPS);
    BIND_ENUM_CONSTANT(NUM_MAPS_OUT);
    BIND_ENUM_CONSTANT(NUM_MAPS_IN);
    BIND_ENUM_CONSTANT(NUM_SIGNALS_IN);
    BIND_ENUM_CONSTANT(NUM_MAPS_OUT);
    BIND_ENUM_CONSTANT(ORDINAL);
    BIND_ENUM_CONSTANT(PERIOD);
    BIND_ENUM_CONSTANT(PORT);
    BIND_ENUM_CONSTANT(PROCESS_LOCATION);
    BIND_ENUM_CONSTANT(PROTOCOL);
    BIND_ENUM_CONSTANT(RATE);
    BIND_ENUM_CONSTANT(SCOPE);
    BIND_ENUM_CONSTANT(SIGNALS);
    BIND_ENUM_CONSTANT(STATUS);
    BIND_ENUM_CONSTANT(STEAL_MODE);
    BIND_ENUM_CONSTANT(SYNCED);
    BIND_ENUM_CONSTANT(TYPE);
    BIND_ENUM_CONSTANT(UNIT);
    BIND_ENUM_CONSTANT(USE_INSTANCES);
    BIND_ENUM_CONSTANT(VERSION);

}

