/* IOMapper.cpp */

#include "IOMapper.h"


IOMapper::IOMapper() {

}

IOMapper::~IOMapper() {
    delete dev;
}

// Must be called to initialize device
void IOMapper::init(String name) {
    dev = new mapper::Device(name.ascii().get_data());
}

// Called on the device to add a signal
void IOMapper::add_sig(Direction dir, String name, int length, Type type) {
    
    mapper::Signal sig = dev->add_signal((mapper::Direction)dir, name.ascii().get_data(),
                                         length, (mapper::Type)type);
    signals.emplace_back(sig);
}

// Helper method for retrieving signal by name
mapper::Signal IOMapper::sig_get(String name) {

    for (int i = 0; i < (int)signals.size(); i++ ) {
        std::string prop_name = signals[i].property("name");
        if (prop_name == name.ascii().get_data()) {
            return signals[i];
        }
    }
    std::cerr << "Signal not found: Value not set" << std::endl;
    return NULL;
}


// Methods for setting signal properties
void IOMapper::set_property_int(String sigName, Property property, int value) {
    sig_get(sigName).set_property((mapper::Property)property, value);
}
void IOMapper::set_property_float(String sigName, Property property, float value) {
    sig_get(sigName).set_property((mapper::Property)property, value);
}
void IOMapper::set_property_double(String sigName, Property property, double value) {
    sig_get(sigName).set_property((mapper::Property)property, value);
}

// Methods for getting signal properties
int32_t IOMapper::get_property_int(String sigName, Property property) {
    return (int32_t)sig_get(sigName).property((mapper::Property)property);
}
float IOMapper::get_property_float(String sigName, Property property) {
    return (float)sig_get(sigName).property((mapper::Property)property);
}
double IOMapper::get_property_double(String sigName, Property property) {
    return (double)sig_get(sigName).property((mapper::Property)property);
}


// Signal value set functions
void IOMapper::set_value_float(String signalName, float value) {
    sig_get(signalName).set_value(value);
}

void IOMapper::set_value_int(String signalName, int32_t value) {
    sig_get(signalName).set_value(value);
}

void IOMapper::set_value_double(String signalName, double value) {
    sig_get(signalName).set_value(value);
}

void IOMapper::set_value_vector2(String signalName, Vector2 values) {
    if (sig_get(signalName).property(mapper::Property::LENGTH) == 2) {
        float sig_vector[2];

        sig_vector[0] = values[0];
        sig_vector[1] = values[1];
        sig_get(signalName).set_value(sig_vector, 2);
        return;
    }

    std::cerr << "Vector2 set method was called on signal not of length 2" << std::endl;
    return;
}

void IOMapper::set_value_vector3(String signalName, Vector3 values) {
    if (sig_get(signalName).property(mapper::Property::LENGTH) == 3) {
        float sig_vector[3];

        sig_vector[0] = values[0];
        sig_vector[1] = values[1];
        sig_vector[2] = values[2];
        sig_get(signalName).set_value(sig_vector, 3);
    
        return;
    }

    std::cerr << "Vector3 set method was called on signal not of length 3" << std::endl;
    return;
}




// Signal value get functions
int32_t IOMapper::get_value_int(String signalName) {
    int32_t value; 
    mapper::Signal sig = sig_get(signalName);
    memcpy(&value, sig.value(), sizeof(sig.value()));

    return value;
}

float IOMapper::get_value_float(String signalName) {
    float value;
    mapper::Signal sig = sig_get(signalName);
    memcpy(&value, sig.value(), sizeof(sig.value()));

    return value;
}

double IOMapper::get_value_double(String signalName) {
    double value;
    mapper::Signal sig = sig_get(signalName);
    memcpy(&value, sig.value(), sizeof(sig.value()));

    return value;
}

Vector2 IOMapper::get_value_vector2(String signalName) {
    Vector2 godot_vector;
    mapper::Signal sig = sig_get(signalName);

    // Only attempt to copy array if signal length is 2
    if (sig.property(mapper::Property::LENGTH) == 2) {
        float array[2]; 
    
        memcpy(&array, sig.value(), sizeof(float)*2);
    

        godot_vector.x = array[0];
        godot_vector.y = array[1];

        return godot_vector;
    }

    std::cerr << "Vector2 get method was called on signal not of length 2" << std::endl;
    return Vector2(MAXFLOAT, MAXFLOAT);    
}

Vector3 IOMapper::get_value_vector3(String signalName) {
    Vector3 godot_vector;
    mapper::Signal sig = sig_get(signalName);

    // Only attempt to copy array if signal length is 3
    if (sig.property(mapper::Property::LENGTH) == 3) {
        float array[3]; 
        memcpy(&array, sig.value(), sizeof(float)*3);
        

        godot_vector.x = array[0];
        godot_vector.y = array[1];
        godot_vector.z = array[2];

        return godot_vector;
    }

    std::cerr << "Vector3 get method was called on signal not of length 3" << std::endl;
    return Vector3(MAXFLOAT, MAXFLOAT, MAXFLOAT);  
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


// Bind methods from above:
void IOMapper::_bind_methods() {

    ClassDB::bind_method(D_METHOD("poll_blocking", "block_ms"), &IOMapper::poll_blocking);
    ClassDB::bind_method(D_METHOD("poll"), &IOMapper::poll);
    ClassDB::bind_method(D_METHOD("ready"), &IOMapper::ready);
    ClassDB::bind_method(D_METHOD("init", "name"), &IOMapper::init);
    ClassDB::bind_method(D_METHOD("add_sig", "direction", "name", "length", "type"), &IOMapper::add_sig);
    ClassDB::bind_method(D_METHOD("set_property_int", "signalName", "property", "value"), &IOMapper::set_property_int);
    ClassDB::bind_method(D_METHOD("set_property_float", "signalName", "property", "value"), &IOMapper::set_property_float);
    ClassDB::bind_method(D_METHOD("set_property_double", "signalName", "property", "value"), &IOMapper::set_property_double);
    ClassDB::bind_method(D_METHOD("get_property_int", "signalName", "property"), &IOMapper::get_property_int);
    ClassDB::bind_method(D_METHOD("get_property_float", "signalName", "property"), &IOMapper::get_property_float);
    ClassDB::bind_method(D_METHOD("get_property_double", "signalName", "property"), &IOMapper::get_property_double);
    ClassDB::bind_method(D_METHOD("set_value_int", "signalName", "value"), &IOMapper::set_value_int);
    ClassDB::bind_method(D_METHOD("set_value_float", "signalName", "value"), &IOMapper::set_value_float);
    ClassDB::bind_method(D_METHOD("set_value_double", "signalName", "value"), &IOMapper::set_value_double);
    ClassDB::bind_method(D_METHOD("set_value_vector2", "signalName", "values"), &IOMapper::set_value_vector2);
    ClassDB::bind_method(D_METHOD("set_value_vector3", "signalName", "values"), &IOMapper::set_value_vector3);
    ClassDB::bind_method(D_METHOD("get_value_int", "signalName"), &IOMapper::get_value_int);
    ClassDB::bind_method(D_METHOD("get_value_float", "signalName"), &IOMapper::get_value_float);
    ClassDB::bind_method(D_METHOD("get_value_double", "signalName"), &IOMapper::get_value_double);
    ClassDB::bind_method(D_METHOD("get_value_vector2", "signalName"), &IOMapper::get_value_vector2);
    ClassDB::bind_method(D_METHOD("get_value_vector3", "signalName"), &IOMapper::get_value_vector3);

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

