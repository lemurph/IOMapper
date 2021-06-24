extends Node2D


var dev = IOMapper.new()
export var rotation_speed = PI
var orbit

# Called when the node enters the scene tree for the first time.
func _ready():
	dev.init("orbit")
	orbit = dev.add_sig(IOMapper.INCOMING, "input", 1, IOMapper.INT32)
	orbit.set_value_int(0, 50)


func _physics_process(delta):
	dev.poll()
	rotation_speed = orbit.get_value_int(0) - 50
	$Sprite/Orbit.rotation += float(rotation_speed) * delta
