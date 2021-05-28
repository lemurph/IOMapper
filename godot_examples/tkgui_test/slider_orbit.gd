extends Node2D


var dev = GodotMapper.new()
export var rotation_speed = PI

# Called when the node enters the scene tree for the first time.
func _ready():
	dev.init("test1")
	#dev.add_sig("OUT", "output", 1, "INT32")
	dev.add_sig("IN", "input", 1, "INT32")
	dev.set_value_int("input", 50)
	$Timer.connect("timeout", self, "_on_Timer_timeout")
	$Timer.start()

func _physics_process(delta):
	dev.poll()
	rotation_speed = dev.value_int("input") - 50
	$Sprite/Orbit.rotation += float(rotation_speed) * delta

func _on_Timer_timeout():
	pass
	#print(dev.value("output"), " ", typeof(dev.value("output")))

