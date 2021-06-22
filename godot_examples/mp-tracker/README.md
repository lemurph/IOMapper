# MediaPipe Follower

This is a simple example that makes the Godot Sprite follow the location of your index finger trip as tracked by **mediapipe**.

Note: To run this example, you will need to install the mediapipe python package to your machine.

```bash
pip3 install mediapipe
```

## To Run

To run this example, ensure that the Godot Scene is running as expected and then run the hand-tracking script with:

```bash
./mediapipe-tracker.py
```

And then connect the two libmapper signals using two **umapper** commands:

```bash
./umapper -M hand_tracker.1/index_x orbit.1/input_X
```

```bash
./umapper -M hand_tracker.1/index_y orbit.1/input_Y
```

You should be good to go after this point!!
