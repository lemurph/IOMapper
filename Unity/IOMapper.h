/* IOMapper.h */

#ifndef IOMAPPER_H
#define IOMAPPER_H

#include "mapper_cpp.h"
#include <map> 
#include <string>

extern "C" {

/*class CDevice {
    public:
        CDevice() { };
        void MyFunction(int aParam1) { };
};

class CManager {
    
    private:
        CManager() { };
        ~CManager() { };
        static CManager* m_Instance;
        int m_NextID;
        std::map<int,CDevice*> m_Objects;
    
    public:
        static CManager* Get() {
            if (!m_Instance)
                m_Instance = new CManager();
            return m_Instance;
        }
    
        static void Destroy() {
            if (m_Instance)
                delete m_Instance;
            m_Instance = NULL;
        }

        int CreateDevice() {
            m_Objects[m_NextID] = new CDevice();
            return m_NextID++;
        }
    
        CSomeClass* GetDevice(int ID) {
            if (m_Objects.find(ID) == m_Objects.end())
                return NULL;
            return m_Objects[ID];
        }
    
        void DeleteDevice(int ID) {
            std::map<int,CDevice*>::iterator iter = m_Objects.find(ID);
            if (iter == m_Objects.end()) 
                return;
            delete iter->second;
            m_Objects.erase(iter);
        }
        
};*/



class IOMapper {

    protected:


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

        class Signal {

            protected:

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

                void set_value_int(int32_t value, int id);
                void set_value_float(float value, int id);
                void set_value_double(double value, int id);
                //void set_value_vector2(Vector2 values, int id);
                //void set_value_vector3(Vector3 values, int id);

                int32_t get_value_int(int id);
                float get_value_float(mapper::Signal* sig);
                double get_value_double(int id);
                //Vector2 get_value_vector2(int id);
                //Vector3 get_value_vector3(int id);

                void reserve_instances(int num_reservations);

                bool is_active(int id);

                Signal(mapper::Signal signal);
                Signal();
                ~Signal();

        };


        
        // Method headers go here
        mapper::Device* create_device(const char* name);

        void init(std::string name);
        int poll_blocking(int block_ms);
        int poll(mapper::Device* dev);
        bool ready();

        // Optional fields have been omitted for now
        mapper::Signal add_sig(mapper::Device* dev, const char* name, int length); 
    
        IOMapper();
        ~IOMapper();

};
}

#endif // IOMAPPER