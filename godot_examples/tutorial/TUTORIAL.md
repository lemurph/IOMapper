## Tkinter GUI Slider Tutorial
This project is a simple case of creating a device and adding a signal that can be changed by another device on the network. In this case, we have a godot icon orbiting another godot icon, we will be controlling it's rotation using a Tkinter slider.

First, you will need to run the tkgui.py program. This program requires the tkinter python module as well as libmapper in order to run. You can run the program using the command `./tkgui.py` in this tutorial directory. `NOTE: the tkinter module is imported as 'Tkinter' in Python2 and 'tkinter' in Python3. This means it may be necessary to run the program using the command 'python3 tkgui.py' in order for python to recognize the import statement.` 

Second, you must run the Godot scene. This can be done by imprting the project file into Godot and either pressing 'F5' or clicking on the play button in the top right.

At this point, with both programs running, we should have two devices exposed to the network with a single signal each. Now we must map these signals; the slider's output signal must be mapped to the Godot Scene's input signal. We can do this one of two ways. The first way is to use [umapper](https://github.com/malloch/umapper), a lightweight command-line libmapper mapping tool, and the second way is to use [webmapper](https://github.com/libmapper/webmapper), a web-based mapping GUI. For the sake of this tutorial we will be using webmapper as it offers more robust control over the mappings.

Cloning the [webmapper](https://github.com/libmapper/webmapper) repository and running ./webmapper.py (or `python3 webmapper.py` if Python3 isn't your default version) should open your default browser with the address `http://localhost:50000/`. webmapper is currently only known to be stable with chrome/chromium based browsers. The webpage should load and present you with the text "waiting for devices", or show the devices currently connected to the network if there are any.

Mapping the signals at this point should be as easy as selecting any suitable view for webmapper and then clicking and dragging an arrow from the output signal to the input signal, creating the map. The tkinter slider should now control the orbit of the Godot icon. When the slider's value is 50 the icon should be stationary, with values less than 50 causing the orbit to go increasingly fast in a counter-clockwise direction, and values greater than 50 causing a clockwise rotation.
    
