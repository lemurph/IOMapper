extends Node2D

var dev = gdMprDevice.new()
export var rotation_speed = PI
export var x_pos = 0
export var y_pos = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	dev.init("orbit")
	dev.add_sig(gdMprDevice.INCOMING, "input_X", 1, gdMprDevice.INT32)
	dev.add_sig(gdMprDevice.INCOMING, "input_Y", 1, gdMprDevice.INT32)
	dev.set_value_int("input_X", 0)
	dev.set_value_int("input_Y", 0)


func _physics_process(delta):
	dev.poll()
	x_pos = delta # This is blah
	x_pos = dev.value_int("input_X")
	y_pos = dev.value_int("input_Y")
##	print(x_pos)
#	$Sprite/Orbit.position.x = int(x_pos * 100)
#	$Sprite/Orbit.position.y = int(y_pos * 100)
