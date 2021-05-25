extends Node2D


var dev1 = GodotMapper.new();

# Called when the node enters the scene tree for the first time.
func _ready():
	dev1.init("test1")
	dev1.poll()
