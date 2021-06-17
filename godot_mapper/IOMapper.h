/* IOMapper.h */

#ifndef GDMPR_DEVICE_H
#define GDMPR_DEVICE_H

#include "core/reference.h"
#include "core/func_ref.h"
#include "core/variant.h"
#include <mapper_cpp.h>


class IOMapper : public Reference {
    GDCLASS(IOMapper, Reference);

    protected:
        // Required for binding methods to godot 
        static void _bind_methods();


    public:
        enum Direction {
            INCOMING = (int)mapper::Direction::INCOMING,
            OUTGOING = (int)mapper::Direction::OUTGOING,
            ANY      = (int)mapper::Direction::ANY,
            BOTH     = (int)mapper::Direction::BOTH
        };

        enum Type {
            FLOAT   = (int)mapper::Type::FLOAT,
            INT32   = (int)mapper::Type::INT32,
            DOUBLE  = (int)mapper::Type::DOUBLE,
        };

        enum Property {
            CALIBRATING         = (int)mapper::Property::CALIBRATING,
            DEVICE              = (int)mapper::Property::DEVICE,
            DIRECTION           = (int)mapper::Property::DIRECTION,
            EXPRESSION          = (int)mapper::Property::EXPRESSION,
            HOST                = (int)mapper::Property::HOST,
            ID                  = (int)mapper::Property::ID,
            IS_LOCAL            = (int)mapper::Property::IS_LOCAL,
            JITTER              = (int)mapper::Property::JITTER,
            LENGTH              = (int)mapper::Property::LENGTH,
            LIBVERSION          = (int)mapper::Property::LIBVERSION,
            LINKED              = (int)mapper::Property::LINKED,
            MAX                 = (int)mapper::Property::MAX,
            MIN                 = (int)mapper::Property::MIN,
            MUTED               = (int)mapper::Property::MUTED,
            NAME                = (int)mapper::Property::NAME,
            NUM_INSTANCES       = (int)mapper::Property::NUM_INSTANCES,
            NUM_MAPS            = (int)mapper::Property::NUM_MAPS,
            NUM_MAPS_IN         = (int)mapper::Property::NUM_MAPS_IN,
            NUM_MAPS_OUT        = (int)mapper::Property::NUM_MAPS_OUT,
            NUM_SIGNALS_IN      = (int)mapper::Property::NUM_SIGNALS_IN,
            NUM_SIGNALS_OUT     = (int)mapper::Property::NUM_SIGNALS_OUT,
            ORDINAL             = (int)mapper::Property::ORDINAL,
            PERIOD              = (int)mapper::Property::PERIOD,
            PORT                = (int)mapper::Property::PORT,
            PROCESS_LOCATION    = (int)mapper::Property::PROCESS_LOCATION,
            PROTOCOL            = (int)mapper::Property::PROTOCOL,
            RATE                = (int)mapper::Property::RATE,
            SCOPE               = (int)mapper::Property::SCOPE,
            SIGNALS             = (int)mapper::Property::SIGNALS,
            STATUS              = (int)mapper::Property::STATUS,
            STEAL_MODE          = (int)mapper::Property::STEAL_MODE,
            SYNCED              = (int)mapper::Property::SYNCED,
            TYPE                = (int)mapper::Property::TYPE,
            UNIT                = (int)mapper::Property::UNIT,
            USE_INSTANCES       = (int)mapper::Property::USE_INSTANCES,
            VERSION             = (int)mapper::Property::VERSION,
        };

        mapper::Device* dev;
        std::vector<mapper::Signal> signals;

        
        
        // Method headers go here

        void init(String name);
        int poll_blocking(int block_ms);
        int poll();
        bool ready();

        // Optional fields have been omitted for now
        void add_sig(Direction direction, String name, int length, Type type);
        mapper::Signal sig_get(String name);
        void set_bounds(String sigName, int min, int max);

        // Set/get property method headers
        void set_property_int(String sigName, Property property, int value);
        void set_property_float(String sigName, Property property, float value);
        void set_property_double(String sigName, Property property, double value);
        int32_t get_property_int(String sigName, Property property);
        float get_property_float(String sigName, Property property);
        double get_property_double(String sigName, Property property);

        // Godot method binding fails when using templates, method overridding, or copying into Variant type.
        void set_value_int(String signalName, int32_t value);
        void set_value_float(String signalName, float value);
        void set_value_double(String signalName, double value);
        void set_value_vector2(String signalName, Vector2 values);
        void set_value_vector3(String signalName, Vector3 values);


        int32_t get_value_int(String signalName);
        float get_value_float(String signalName);
        double get_value_double(String signalName);
        Vector2 get_value_vector2(String signalName);
        Vector3 get_value_vector3(String signalName);

            

        IOMapper();
        ~IOMapper();


};

VARIANT_ENUM_CAST(IOMapper::Direction);
VARIANT_ENUM_CAST(IOMapper::Type);
VARIANT_ENUM_CAST(IOMapper::Property);

#endif // GDMPR_DEVICE_H
