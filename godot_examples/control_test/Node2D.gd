extends Node2D


var dev1 = GodotMapper.new()
export var rotation_speed = PI
var callback = funcref(self, "on_change")

# Called when the node enters the scene tree for the first time.
func _ready():
	dev1.init("test1")
	dev1.add_sig("OUT", "output", 1, "FLOAT")
	dev1.add_sig("IN", "input", 1, "FLOAT", callback)
	dev1.poll()

func _physics_process(delta):
	if Input.is_action_pressed("ui_up"):
		rotation_speed += 1;
		on_input(rotation_speed)
	elif Input.is_action_pressed("ui_down"):
		rotation_speed -= 1;
		on_input(rotation_speed * delta)

func on_input(x):
	dev1.set_value("output", x)

func on_change(value):
	$Sprite/Orbit.rotation += value
