extends Node2D

var dev = GodotMapper.new()
var done = false
var value = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	dev.init("test")
	dev.add_sig("OUT", "test_out", 1, "FLOAT")
	


func _process(_delta):
	if (Input.is_action_pressed("ui_right")):
		value += 1
	elif (Input.is_action_pressed("ui_left")):
		value -= 1

	$Label.text = value
	dev.set_value("OUT", value)




# Called every frame. 'delta' is the elapsed tisme since the previous frame.
#func _process(delta):
#	pass
