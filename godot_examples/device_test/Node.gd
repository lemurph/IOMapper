extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var dev = GodotMapper.new();

# Called when the node enters the scene tree for the first time.
func _ready():
	dev.call_deferred("init", "test");
	dev.call_deferred("add_sig", "OUT", "test_out", 1, "FLOAT");


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	print(dev.ready());

