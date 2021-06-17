extends Node2D

# Get window dimensions
var width = ProjectSettings.get_setting("display/window/size/width")
var height = ProjectSettings.get_setting("display/window/size/height")

var dev = IOMapper.new()

# Change this to increase it to more units/second
export var speed = 300 

# Called when the node enters the scene tree for the first time.
func _ready():
	dev.init("orbit")
	dev.add_sig(IOMapper.INCOMING, "input_XY", 2, IOMapper.FLOAT)

	# Script seems to break without these -- TODO: Ask Logan why? 
	dev.set_value_vector2("input_XY", Vector2(0.0, 0.0))


func _physics_process(delta):
	dev.poll()

	# Get vector from XY signal
	var coords = dev.get_value_vector2("input_XY")

	var new_pos = Vector2(coords.x * width, coords.y * height)
	
	# Move towards where the tracked values are (scaled to window dimensions)
	$Sprite.position = $Sprite.position.move_toward(new_pos, delta * speed)
	
