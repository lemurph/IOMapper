extends Node2D
# Get window dimensions
var width = ProjectSettings.get_setting("display/window/size/width")
var height = ProjectSettings.get_setting("display/window/size/height")

var dev = IOMapper.new()
var input_XY

# Change this to increase it to more units/second
export var speed = 300 

# Called when the node enters the scene tree for the first time.
func _ready():
	dev.init("orbit")
	input_XY = dev.add_sig(IOMapper.INCOMING, "input_XY", 2, IOMapper.FLOAT)


func _physics_process(delta):
	dev.poll()

	# Get vector from XY signal
	var coords = input_XY.get_value_vector2()

	var new_pos = Vector2(coords.x * width, coords.y * height)
	
	# Move towards where the tracked values are (scaled to window dimensions)
	$Sprite.position = $Sprite.position.move_toward(new_pos, delta * speed)
	
