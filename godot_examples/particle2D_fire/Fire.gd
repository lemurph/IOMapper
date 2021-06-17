extends Node2D


var dev = IOMapper.new()
var radius = 2.0

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
	dev.add_sig(IOMapper.INCOMING, "radius", 1, IOMapper.FLOAT)
	dev.add_sig(IOMapper.INCOMING, "pos", 2, IOMapper.FLOAT)
	dev.set_value_float("radius", 2.0)
	dev.set_value_vector2("pos", Vector2(-1.0, -1.0))


func _process(delta):
	dev.poll()
	radius = dev.get_value_float("radius")
	if (dev.get_value_vector2("pos") != Vector2(-1.0, -1.0)):
		var coords = dev.get_value_vector2("pos")
		var pos = Vector2(coords.x * width, coords.y * height)
		
		# Calling the root node using $Fire2D does not work, must use get_node(".")
		get_node(".").set_position(get_node(".").position.move_toward(pos, delta * speed))
	
	$Flame.process_material.set_emission_sphere_radius(radius * radius_scale)
