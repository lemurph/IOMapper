/* IOMapper.cpp */

#include "IOMapper.h"


extern "C" {
    
    /*int CreateDevice()
    {
        return CManager::Get()->CreateDevice();
    }
    
    void DeleteDevice(int ID)
    {
        CManager::Get()->DeleteDevice(ID);
    }
    
    // Example function
    void Device_MyFunction(int ID, int aParam1) {
        IOMapper* tmp = CManager::Get()->GetDevice(ID);
        if (tmp)
           tmp->MyFunction(aParam1);
    }*/

    IOMapper::IOMapper() {

    }

    IOMapper::~IOMapper() {

    }

    IOMapper::Signal::Signal() {

    }

    IOMapper::Signal::~Signal() {

    }

    // Must be called to initialize device
    mapper::Device* IOMapper::create_device(const char* name) {
        std::string dev_name(name);
        mapper::Device* dev = new mapper::Device(dev_name);
        return dev;
    }

    mapper::Signal IOMapper::add_sig(mapper::Device* dev, const char* name, int length){

        std::string sig_name(name);
        mapper::Signal sig = dev->add_signal(mapper::Direction::INCOMING, sig_name,
                                        length, mapper::Type::FLOAT);
        
        return &sig;
    }


    // Methods for setting signal properties
    /*void IOMapper::Signal::set_property_int(Property property, int value) {
        sig.set_property((mapper::Property)property, value);
    }
    void IOMapper::Signal::set_property_float(Property property, float value) {
        sig.set_property((mapper::Property)property, value);
    }
    void IOMapper::Signal::set_property_double(Property property, double value) {
        sig.set_property((mapper::Property)property, value);
    }

    void IOMapper::Signal::set_bounds(float min, float max) {
        sig.set_property(mapper::Property::MIN, min);
        sig.set_property(mapper::Property::MAX, max);
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
    void IOMapper::Signal::set_value_float(float value, int id) {
        sig.instance(id).set_value(value);
    }

    void IOMapper::Signal::set_value_int(int32_t value, int id) {
        sig.instance(id).set_value(value);
    }

    void IOMapper::Signal::set_value_double(double value, int id) {
        sig.instance(id).set_value(value);
    }


    void IOMapper::Signal::set_value_vector2(Vector2 values, int id) {
        if ((int)sig.property(mapper::Property::LENGTH) >= 2) {
            float sig_vector[2] = {values[0], values[1]};
            sig.instance(id).set_value(sig_vector, 2);
            return;
        }

        std::cerr << "Vector2 set method was called on signal with length < 2" << std::endl;
        return;
    }

    void IOMapper::Signal::set_value_vector3(Vector3 values, int id) {
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
    }*/

    float IOMapper::Signal::get_value_float(mapper::Signal* sig_ptr) {
        mapper::Signal sig = &sig_ptr;
        float *value = (float*)sig.value();
        return value ? *value : 0.0;
    }

    /*
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



    void IOMapper::Signal::reserve_instances(int num_reservations) {
        sig.reserve_instances(num_reservations);
    }

    bool IOMapper::Signal::is_active(int id) {
        return sig.instance(id).is_active();
    }

    int IOMapper::poll_blocking(int block_ms) {
        return dev->poll(block_ms);
    }
    
    bool IOMapper::ready() {
        return dev->ready();
    }
    */

    int IOMapper::poll(mapper::Device* dev) {
        return dev->poll();
    }

    
}


