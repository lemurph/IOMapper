extends Node2D


var dev = IOMapper.new()
export var rotation_speed = PI

# Called when the node enters the scene tree for the first time.
func _ready():
	dev.init("orbit")
	dev.add_sig(IOMapper.INCOMING, "input", 1, IOMapper.INT32)
	dev.set_value_int("input", 50)


func _physics_process(delta):
	dev.poll()
	rotation_speed = dev.get_value_int("input") - 50
	$Sprite/Orbit.rotation += float(rotation_speed) * delta
