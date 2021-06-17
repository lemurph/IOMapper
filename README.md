# IOMapper

IOMapper is a module for the [Godot game engine](https://github.com/godotengine/godot). This module is designed to implement [libmapper](https://github.com/libmapper/libmapper) functionality within Godot, enabling the creation of custom devices and signals using GDScript. The devices and signals created this way are accessible by other libmapper-enabled devices on the local network.

## Installation:
In order to compile modules with Godot, you must build Godot from source. This module is
currently designed to work with the 3.x branch of the Godot source. After configuring and
installing libmapper, as well as building Godot, the module can be installed by copying the
'godot_mapper' folder from this repository into the 'modules' folder of the godot build. 
You must then rebuild Godot, and the module should be functional.

            Installation Recap:
                1. Configure/Install libmapper
                2. Build Godot from source (Branch 3.x)
                3. Copy 'godot_mapper' folder from this repository into the 'modules' folder of the 
                    Godot build.
                4. Check functionality using example projects from 'godot_examples'

## Usage:

A functional tutorial can be found in godot_examples/tutorial.

All IOMapper devices must be stored in a variable and call the init(String name) method in the Godot script's _ready() fuction. This is also where all signals should be assigned to the device:
    	      
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


## Known Bugs:
   - Using mismatched types for *get_value_xxxx()* and *set_value_xxxx()* functions may cause a crash at runtime.
   - If a mapped device is lost while the project is running there will likely be a crash.
   - All signals must be assigned a value upon creation or there will be a crash.

	
