# godot-mapper

godopt_mapper is a module for the Godot game engine. This module is designed to implement libmapper functionality within Godot, enabling the creation of custom devices and signals using GDScript. The devices and signals created this way are accessible by other libmapper-enabled devices on the local network.

INSTALLATION:

        In order to compile modules with Godot, you must build Godot from source. This module is currently designed to work with the 3.x branch of the Godot source. After configuring and installing libmapper, as well as building Godot, the module can be installed by copying the 'godot_mapper' folder from this repository into the 'modules' folder of the godot build. You must then rebuild Godot, and the module should be functional.

            Installation Recap:
                1. Configure/Install Libmapper
                2. Build Godot form source (Branch 3.x)
                3. Copy 'godot_mapper' folder from this repository into the 'modules' folder of the 
                    Godot build.
                4. Check functionality using example projects from 'godot_examples'

USAGE:
    - TODO

KNOWN BUGS:
    - Using mismatched types for value_xxxx() and value_set_xxxx() functions may cause a crash at runtime.

	
