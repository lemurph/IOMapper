# godot-mapper

godot_mapper is a module for the [Godot game engine](https://github.com/godotengine/godot). This module is designed to implement [libmapper](https://github.com/libmapper/libmapper) functionality within Godot, enabling the creation of custom devices and signals using GDScript. The devices and signals created this way are accessible by other libmapper-enabled devices on the local network.

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
   - TODO

## Known Bugs:
   - Using mismatched types for *value_xxxx()* and *value_set_xxxx()* functions may cause a crash at runtime.
   - If a mapped device is lost while the project is running there will likely be a crash.
   - All signals must be assigned a value upon creation or there will be a crash.

	
