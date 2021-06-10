# Particle Fire Example

This example uses a libmapper device to control the radius of a 2d particle fire effect in Godot.

## Slider

To use with hand-tracking, first you need to run the Godot scene and then:

```bash
./tkgui.py

# Connect via libmapper
./umapper -M tkgui.1/output fire.1/radius
```

## Hand-tracking

To use with hand-tracking, first you need to run the Godot scene and then:

```bash
./mediapipe-tracker.py

# Connect via libmapper
./umapper -M hand_tracker.1/index-thumb-distance fire.1/radius
./umapper -M hand_tracker.1/position fire.1/pos
```
