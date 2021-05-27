extends Node2D


var dev = GodotMapper.new()
export var rotation_speed = PI
var x = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	dev.init("test1")
	dev.add_sig("OUT", "output", 1, "INT32")
	#dev.add_sig("IN", "input", 1, "FLOAT")
	$Timer.connect("timeout", self, "_on_Timer_timeout")
	$Timer.start()

func _physics_process(delta):
	dev.poll()
	if (Input.is_action_pressed("ui_right")):
		print(x)
		x = 99
	if (Input.is_action_pressed("ui_left")):
		print(x)
		x = 1
	dev.set_value("output", int(x))
	#rotation_speed = dev.value("input") 
	#$Sprite/Orbit.rotation += float(rotation_speed) * delta

func _on_Timer_timeout():
	pass
	#print(dev.value("output"), " ", typeof(dev.value("output")))

