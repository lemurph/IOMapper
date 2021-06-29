/* IOMapper.cpp */

#include "IOMapper.h"


IOMapper::IOMapper() {

}

IOMapper::~IOMapper() {
    delete dev;
}

IOMapper::Signal::Signal(mapper::Signal signal) {
    sig = signal;
}

IOMapper::Signal::Signal() {

}

IOMapper::Signal::~Signal() {

}

// Must be called to initialize device
void IOMapper::init(String name) {
    dev = new mapper::Device(name.ascii().get_data());
}

Ref<IOMapper::Signal> IOMapper::add_sig(Direction direction, String name, int length, Type type){

    mapper::Signal sig = dev->add_signal((mapper::Direction)direction, name.ascii().get_data(),
                                    length, (mapper::Type)type);

    return memnew(IOMapper::Signal(sig)); 
}


// Methods for setting signal properties
void IOMapper::Signal::set_property_int(Property property, int value) {
    sig.set_property((mapper::Property)property, value);
}
void IOMapper::Signal::set_property_float(Property property, float value) {
    sig.set_property((mapper::Property)property, value);
}
void IOMapper::Signal::set_property_double(Property property, double value) {
    sig.set_property((mapper::Property)property, value);
}

// Methods for getting signal properties
int32_t IOMapper::Signal::get_property_int(Property property) {
    return (int32_t)sig.property((mapper::Property)property);
}
float IOMapper::Signal::get_property_float(Property property) {
    return (float)sig.property((mapper::Property)property);
}
double IOMapper::Signal::get_property_double(Property property) {
    return (double)sig.property((mapper::Property)property);
}


// Signal value set methods
void IOMapper::Signal::set_value_float(int id, float value) {
    sig.instance(id).set_value(value);
}

void IOMapper::Signal::set_value_int(int id, int32_t value) {
    sig.instance(id).set_value(value);
}

void IOMapper::Signal::set_value_double(int id, double value) {
    sig.instance(id).set_value(value);
}

void IOMapper::Signal::set_value_vector2(int id, Vector2 values) {
    if ((int)sig.property(mapper::Property::LENGTH) >= 2) {
        float sig_vector[2] = {values[0], values[1]};
        sig.instance(id).set_value(sig_vector, 2);
        return;
    }

    std::cerr << "Vector2 set method was called on signal with length < 2" << std::endl;
    return;
}

void IOMapper::Signal::set_value_vector3(int id, Vector3 values) {
    if ((int)sig.property(mapper::Property::LENGTH) >= 3) {
        float sig_vector[3] = {values[0], values[1], values[2]};
        sig.instance(id).set_value(sig_vector, 3);
        return;
    }

    std::cerr << "Vector3 set method was called on signal with length < 3" << std::endl;
    return;
}



// Signal value retrieval methods
int32_t IOMapper::Signal::get_value_int(int id) {
    int32_t *value = (int32_t*)sig.instance(id).value();
    return value ? *value : 0;
}

float IOMapper::Signal::get_value_float(int id) {
    float *value = (float*)sig.instance(id).value();
    return value ? *value : 0.0;
}

double IOMapper::Signal::get_value_double(int id) {
    double *value = (double*)sig.instance(id).value();
    return value ? *value : 0.0;
}

Vector2 IOMapper::Signal::get_value_vector2(int id) {

    // Only attempt to copy array if signal length >= 2
    if ((int)sig.property(mapper::Property::LENGTH) >= 2) {
        float *value = (float*)sig.instance(id).value();
        return value ? Vector2(value[0], value[1]) : Vector2(0, 0);
    }

    std::cerr << "Vector2 get method was called on signal with length < 2" << std::endl;
    return Vector2(0, 0);
}

Vector3 IOMapper::Signal::get_value_vector3(int id) {

    // Only attempt to copy array if signal length is >= 3
    if ((int)sig.property(mapper::Property::LENGTH) >= 3) {
        float *value = (float*)sig.instance(id).value();
        return value ? Vector3(value[0], value[1], value[2]) : Vector3(0, 0, 0);
    }

    std::cerr << "Vector3 get method was called on signal with length < 3" << std::endl;
    return Vector3(0, 0, 0);
}





int IOMapper::poll_blocking(int block_ms) {
    return dev->poll(block_ms);
}

int IOMapper::poll() {
    return dev->poll();
}

bool IOMapper::ready() {
    return dev->ready();
}

void IOMapper::Signal::_bind_methods(){

    ClassDB::bind_method(D_METHOD("set_property_int","property", "value"), &IOMapper::Signal::set_property_int);
    ClassDB::bind_method(D_METHOD("set_property_float","property", "value"), &IOMapper::Signal::set_property_float);
    ClassDB::bind_method(D_METHOD("set_property_double","property", "value"), &IOMapper::Signal::set_property_double);
    ClassDB::bind_method(D_METHOD("get_property_int","property"), &IOMapper::Signal::get_property_int);
    ClassDB::bind_method(D_METHOD("get_property_float","property"), &IOMapper::Signal::get_property_float);
    ClassDB::bind_method(D_METHOD("get_property_double","property"), &IOMapper::Signal::get_property_double);
    ClassDB::bind_method(D_METHOD("set_value_int","id", "value"), &IOMapper::Signal::set_value_int);
    ClassDB::bind_method(D_METHOD("set_value_float","id", "value"), &IOMapper::Signal::set_value_float, DEFVAL(0), DEFVAL(0));
    ClassDB::bind_method(D_METHOD("set_value_double","id", "value"), &IOMapper::Signal::set_value_double, DEFVAL(0), DEFVAL(0));
    ClassDB::bind_method(D_METHOD("set_value_vector2","id", "values"), &IOMapper::Signal::set_value_vector2, DEFVAL(0), DEFVAL(Vector2(0, 0)));
    ClassDB::bind_method(D_METHOD("set_value_vector3","id", "values"), &IOMapper::Signal::set_value_vector3, DEFVAL(0), DEFVAL(Vector3(0, 0, 0)));
    ClassDB::bind_method(D_METHOD("get_value_int","id"), &IOMapper::Signal::get_value_int, DEFVAL(0));
    ClassDB::bind_method(D_METHOD("get_value_float","id"), &IOMapper::Signal::get_value_float, DEFVAL(0));
    ClassDB::bind_method(D_METHOD("get_value_double","id"), &IOMapper::Signal::get_value_double, DEFVAL(0));
    ClassDB::bind_method(D_METHOD("get_value_vector2","id"), &IOMapper::Signal::get_value_vector2, DEFVAL(0));
    ClassDB::bind_method(D_METHOD("get_value_vector3","id"), &IOMapper::Signal::get_value_vector3, DEFVAL(0));
}

// Bind methods from above:
void IOMapper::_bind_methods() {

    ClassDB::bind_method(D_METHOD("poll_blocking", "block_ms"), &IOMapper::poll_blocking);
    ClassDB::bind_method(D_METHOD("poll"), &IOMapper::poll);
    ClassDB::bind_method(D_METHOD("ready"), &IOMapper::ready);
    ClassDB::bind_method(D_METHOD("init", "name"), &IOMapper::init);
    ClassDB::bind_method(D_METHOD("add_sig", "direction", "name", "length", "type"), &IOMapper::add_sig);
    

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
    BIND_ENUM_CONSTANT(MAX);
    BIND_ENUM_CONSTANT(MIN);
    BIND_ENUM_CONSTANT(MUTED);
    BIND_ENUM_CONSTANT(NAME);
    BIND_ENUM_CONSTANT(NUM_INSTANCES);
    BIND_ENUM_CONSTANT(NUM_MAPS);
    BIND_ENUM_CONSTANT(NUM_MAPS_OUT);
    BIND_ENUM_CONSTANT(NUM_MAPS_IN);
    BIND_ENUM_CONSTANT(NUM_SIGNALS_IN);
    BIND_ENUM_CONSTANT(NUM_SIGNALS_OUT);
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

