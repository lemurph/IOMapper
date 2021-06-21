# IOMapper

IOMapper is a module for the [Godot game engine](https://github.com/godotengine/godot). This module is designed to implement [libmapper](https://github.com/libmapper/libmapper) functionality within Godot, enabling the creation of custom devices and signals using GDScript. The devices and signals created this way are accessible by other libmapper-enabled devices on the local network.

## Installation:
In order to compile modules with Godot, you must build Godot from source. This module is
currently designed to work with the 3.x branch of the Godot source. 

The module and it's submodule can easily be cloned using one command: `git clone --recurse-submodules https://github.com/lemurph/IOMapper`

libmapper must then be installed in the 'IOMapper/libmapper' submodule folder, then the 'IOMapper' folder of this repository must be copied into the 'modules' folder of the Godot build.

Once this is done, Godot can be rebuilt, and the module should be functional.

            Installation Recap:
                1. Configure/Install libmapper
                2. Build Godot from source (Branch 3.x)
                3. Copy 'godot_mapper' folder from this repository into the 'modules' folder of the 
                    Godot build.
                4. Check functionality using example projects from 'godot_examples'

## Usage:

A functional tutorial can be found in godot_examples/tutorial.

All IOMapper devices must be stored in a variable and call the init(String name) method in the Godot script's `_ready()` fuction. This is also where all signals should be assigned to the device:
    	      
	   Ex. # Creating device and signals     
            
  	          var dev = IOMapper.new()
              
              func _ready():
                dev.init("test_device")
                dev.add_sig(IOMapper.INCOMING, "test_in", 1, IOMapper.FLOAT)
                # For now signals must be assigned a value on creation or the program will crash
                dev.set_value_float("test_in", 0.0)
    
Next, we need to know how to access the signal values:
    	
	   Ex. # Polling the device and accessing signal values

              func _process(_delta):
                # The device must be continuously polled in the program's main loop
                dev.poll()

                # Storing the signal value
                var value = dev.get_value_float("test_in")

                # Use value for whatever purpose necessary


## Functions:

#### Here is a list of functions for IOMapper:
| Fucntion Header | Description  |
|------------------|--------------|
| void init(String name)  | The init() method must be called on an IOMapper device once it is created |
| int poll()  | The poll() method must be called at the beginning of a looping function such as `_process` or `_physics_process` to ensure signals are up to date.  |
| bool ready()  | The ready function returns *True* if the device is fully initialized, *False* otherwise. |
| void add_sig(Direction direction, String name, int length, Type type)  | The add_sig() method is used to add a signal to a device. The `direction` property can be either `IOMapper.INCOMING` or `IOMapper.OUTGOING`. The `type` parameter can be `IOMapper.INT32`, `IOMapper.FLOAT`, or `IOMapper.DOUBLE`. |
| void set_property_**TYPE**(String sigName, Property property, **TYPE** value)  | The set_property_**TYPE**() method is used to set the property of a signal. The `property` parameter can be any of the properties listed below. **TYPE** must match the type of the property being set. |
| **TYPE** get_property_**TYPE**(String sigName, Property property)  | The get_property_**TYPE**() method is used to retrieve the property of a signal. The `property` parameter can be any of the properties listed below. **TYPE** must match the type of the property being retrieved. |
| void set_value_**TYPE**(String signalName, **TYPE** value)  | The set_value_**TYPE**() method is used to set the value of a signal. **TYPE** must match the type of the signal of which the value is being set, can be either float, int, or double. |
| **TYPE** get_value_**TYPE**(String signalName) | The get_value_**TYPE**() method is used to retrieve the value of a signal. **TYPE** must match the type of the signal of which the value is being retreived, can be either float, int, or double. |

### Here is a list of properties available to the set/get_property methods. These must be called in the form `IOMapper.<PropertyName>`:

```
CALIBRATING	LENGTH		NUM_MAPS		PROCESS_LOCATION	TYPE
DEVICE		LIBVERSION	NUM_MAPS_IN		PROTOCOL		UNIT
DIRECTION	LINKED		NUM_MAPS_OUT		RATE			USE_INSTANCES
EXPRESSION	MAX		NUM_SIGNALS_IN		SCOPE			VERSION
HOST		MIN		NUM_SIGNALS_OUT		SIGNALS			
ID		MUTED		ORDINAL			STATUS			
IS_LOCAL	NAME		PERIOD			STEAL_MODE			
JITTER		NUM_INSTANCES	PORT			SYNCED			
```


## Known Bugs:
   - Using mismatched types for *get_value_xxxx()* and *set_value_xxxx()* functions may cause a crash at runtime.
   - If a mapped device is lost while the project is running there will likely be a crash.
   - All signals must be assigned a value upon creation or there will be a crash.

	
