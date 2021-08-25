# IOMapper

IOMapper is a module for the [Godot game engine](https://github.com/godotengine/godot). This module is designed to implement [libmapper](https://github.com/libmapper/libmapper) functionality within Godot, enabling the creation of custom devices and signals using GDScript. The devices and signals created this way are accessible by other libmapper-enabled devices on the local network.

## Installation:
In order to compile modules with Godot, you must build Godot from source. This module is
currently designed to work with the 3.x branch of the Godot source. 

The module and it's submodule can easily be cloned using one command: `git clone --recurse-submodules https://github.com/lemurph/IOMapper`

libmapper must then be installed in the 'IOMapper/libmapper' submodule folder, then the 'IOMapper' folder of this repository must be copied into the 'modules' folder of the Godot build.

Once this is done, Godot can be rebuilt, and the module should be functional.

### Installation Recap:

1. Configure/Install libmapper
2. Build Godot from source (Branch 3.x)
3. Copy 'IOMapper' folder from this repository into the 'modules' folder of the Godot build.
4. Check functionality using example projects from 'godot_examples'

<br/><br/> 
<br/><br/>

## Usage:

A functional tutorial can be found in 'godot_examples/tutorial'.

All IOMapper devices must be stored in a variable and call the init() method in the Godot script's `_ready()` fuction. This is also where all signals should be assigned to the device:

```GDScript
Ex. # Creating device and signals     
            
var dev = IOMapper.new()
var sig

func _ready():
    dev.init("test_device")
    sig = dev.add_sig(IOMapper.INCOMING, "test_in", 1, IOMapper.FLOAT)
    # set a starting value for the signal if desired
    sig.set_value(0.0)
```
    
Next, we need to know how to access the signal values:

```GDScript
Ex. # Polling the device and accessing signal values

func _process(_delta):
    # The device must be continuously polled in the program's main loop
    dev.poll()

    # Storing the signal value
    var value = sig.get_value_float()

    # Use value for whatever purpose necessary
```
<br/><br/>
<br/><br/>

## Methods:

#### Here is a list of methods for IOMapper:
| Method Header | Description  |
|------------------|--------------|
| void init(String name)  | The init() method must be called on an IOMapper device once it is created |
| int poll()  | The poll() method must be called at the beginning of a looping function such as `_process` or `_physics_process` to ensure signals are up to date.  |
| bool ready()  | The ready function returns *True* if the device is fully initialized, *False* otherwise. |
| IOMapper::Signal add_sig(Direction direction, String name, int length, Type type)  | The add_sig() method is used to add a signal to a device. The `direction` property can be either `IOMapper.INCOMING` or `IOMapper.OUTGOING`. The `type` parameter can be `IOMapper.INT32`, `IOMapper.FLOAT`, or `IOMapper.DOUBLE`. This method returns a Signal that should be stored in a variable.|
_The following methods are to be called on a variable containing a signal_:
| void set_property_<_type_>(Property property, <_type_> value)  | The set_property_<_type_>() method is used to set the property of a signal. The `property` parameter can be any of the properties listed below. <_type_> must match the type of the property being set. |
| <_type_> get_property_<_type_>(Property property)  | The get_property_<_type_>() method is used to retrieve the property of a signal. The `property` parameter can be any of the properties listed below. <_type_> must match the type of the property being retrieved. |
| void set_value(<_type_> value, int instanceID)  | The set_value_<_type_>() method is used to set the value of a signal. <_type_> must match the type of the signal of which the value is being set, can be either float, int, or double. instanceID can be left empty to default to '0'. |
| void set_bounds(int min, int max)| Called on a signal to set min and max properties. |
| void set_steal_mode(Stealing mode)| Called on a signal to set the stealing mode for instances. |
| <_type_> get_value_<_type_>(int instanceID) | The get_value_<_type_>() method is used to retrieve the value of a signal. <_type_> must match the type of the signal of which the value is being retreived, can be either float, int, or double. instanceID can be left empty to default to '0'. |

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

<br/><br/>
<br/><br/>

## Instancing:
IOMapper supports libmappers signal instancing functionality. Instances are interchangable and ephemeral 'copies' of a signal, and can be used in applications such as a multi-touch surface where every touch represents an instance of a signal.

Here is an example of how to instance a Signal using IOMapper in Godot:
```GDScript
var dev = IOMapper.new()
var sig

func _ready():
    dev.init("test_device")
    sig = dev.add_sig(IOMapper.INCOMING, "example", 1, IOMapper.FLOAT)
    
    # Reserve desired number of instances
    sig.reserve_instances(5)
    # The value of any instance can be accessed by providing an id to the Signal get_value() method

func _process():
    dev.poll()	

    # We can now loop through a group of nodes and update each with a coresponding instance value
    var instance_id = 0
    for node in get_tree().get_nodes_in_group("example_group"):
		
    	# Update a property of each node with respective instance id
    	if sig.is_active(instance_id):
	    node.value_to_update = sig.get_value_int(instance_id)
        	
	instance_id += 1

```

<br/><br/>
<br/><br/>

## Known Bugs:

## Future Plans
   - Previous plans to add VisualScript support have been put on hold. The use of VisualScript seems to be uncommon in the Godot community, so this will be            something that will be consider further if there is any interest.
   - Porting IOMapper to Unity is currently the main focus of the project.

	
