extends Node2D


var dev = GodotMapper.new()
export var rotation_speed = PI

# Called when the node enters the scene tree for the first time.
func _ready():
	dev.init("test1")
	dev.add_sig("OUT", "output", 1, "FLOAT")
	dev.add_sig("IN", "input", 1, "FLOAT")
	$Timer.connect("timeout", self, "_on_Timer_timeout")
	$Timer.start()

func _physics_process(delta):
	dev.poll()
	rotation_speed = dev.value("input") 
	$Sprite/Orbit.rotation += float(rotation_speed) * delta

func _on_Timer_timeout():
	print(dev.value("input"), " ", typeof(dev.value("input")))

