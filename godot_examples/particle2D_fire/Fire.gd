extends Node2D


var dev = IOMapper.new()
var radius = 2.0
var radius_signal
var pos_signal

# Change this to increase it to more units/second
export var speed = 300 

# Get window dimensions
var width = ProjectSettings.get_setting("display/window/size/width")
var height = ProjectSettings.get_setting("display/window/size/height")

# This radius scale is to be used when connecting to various libmapper devices! TODO: Consider scaling on the other side of the libmapper map.
export var radius_scale = 200

# Initialize device and add signals
func _ready():
	dev.init("fire")
	radius_signal = dev.add_sig(IOMapper.INCOMING, "radius", 1, IOMapper.FLOAT)
	pos_signal = dev.add_sig(IOMapper.INCOMING, "pos", 2, IOMapper.FLOAT)

	# Hand tracker coords are from 0.0-1.0 scaled to the display, they will never be -1.0 
	pos_signal.set_value_vector2(0, Vector2(-1.0, -1.0))


func _process(delta):
	dev.poll()
	radius = radius_signal.get_value_float()

	# For when hand-tracker is connected
	if (pos_signal.get_value_vector2(0) != Vector2(-1.0, -1.0)):
		var coords = pos_signal.get_value_vector2(0)
		var pos = Vector2(coords.x * width, coords.y * height)
		
		# Calling the root node using $Fire2D does not work, must use get_node(".")
		get_node(".").set_position(get_node(".").position.move_toward(pos, delta * speed))
	
	$Flame.process_material.set_emission_sphere_radius(radius * radius_scale)
