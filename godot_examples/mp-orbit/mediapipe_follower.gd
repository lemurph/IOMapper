extends Node2D

# Get window dimensions
var width = ProjectSettings.get_setting("display/window/size/width")
var height = ProjectSettings.get_setting("display/window/size/height")

var dev = gdMprDevice.new()

# I'm pretty sure these are unused, but too scared to remove
export var x_pos = 0
export var y_pos = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	dev.init("orbit")
	dev.add_sig(gdMprDevice.INCOMING, "input_X", 1, gdMprDevice.FLOAT)
	dev.add_sig(gdMprDevice.INCOMING, "input_Y", 1, gdMprDevice.FLOAT)

	# Script seems to break without these -- TODO: Ask Logan why? 
	dev.set_value_float("input_X", 0.0)
	dev.set_value_float("input_Y", 0.0)


func _physics_process(delta):
	dev.poll()

	# Get values from both X and Y signals
	var x_val = dev.value_float("input_X")
	var y_val = dev.value_float("input_Y")

	var new_pos = Vector2(x_val*width, y_val * height)
	print(new_pos)
	
	# Move towards where the tracked values are (scaled to window dimensions)
	var speed = 300 # Change this to increase it to more units/second
	$Sprite.position = $Sprite.position.move_toward(new_pos, delta * speed)	
