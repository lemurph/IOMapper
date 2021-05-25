extends Node2D


var dev1 = GodotMapper.new();
var dev2 = GodotMapper.new();

# Called when the node enters the scene tree for the first time.
func _ready():
	print(dev1.init("test1"));
	dev2.init("test2");
	
	dev1.poll();
	#dev2.add_sig("IN", "test_in", 1, "FLOAT");
	#dev1.poll();
	#dev2.poll();
	
	

