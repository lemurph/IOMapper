/* IOMapper.h */

#ifndef IOMAPPER_H
#define IOMAPPER_H

#include "core/reference.h"
#include "core/func_ref.h"
#include "core/variant.h"
#include "core/engine.h"
#include "scene/main/node.h"
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

        class Signal : public Reference {
        GDCLASS(Signal, Reference);

        protected:
            // Required for binding methods to godot 
            static void _bind_methods();

        public:
            mapper::Signal sig;

            // Set/get property method headers
            void set_property_int(Property property, int value);
            void set_property_float(Property property, float value);
            void set_property_double(Property property, double value);
            int32_t get_property_int(Property property);
            float get_property_float(Property property);
            double get_property_double(Property property);

            void set_bounds(float min, float max);

            // Godot method binding fails when using templates, method overloading, or copying into Variant type.
            void set_value(Variant var, int id);

            int32_t get_value_int(int id);
            float get_value_float(int id);
            double get_value_double(int id);
            Vector2 get_value_vector2(int id);
            Vector3 get_value_vector3(int id);

            void reserve_instances(int num_reservations);

            bool is_active(int id);

            Signal(mapper::Signal signal);
            Signal();
            ~Signal();

        };

        mapper::Device* dev;
        
        // Method headers go here

        void init(String name);
        int poll_blocking(int block_ms);
        int poll();
        bool ready();

        // Optional fields have been omitted for now
        Ref<IOMapper::Signal> add_sig(Direction direction, String name, int length, Type type); 
    
        IOMapper();
        ~IOMapper();

};




VARIANT_ENUM_CAST(IOMapper::Direction);
VARIANT_ENUM_CAST(IOMapper::Type);
VARIANT_ENUM_CAST(IOMapper::Property);

#endif // IOMAPPER_H
