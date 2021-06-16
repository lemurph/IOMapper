extends Node2D

onready var height = get_viewport_rect().size.y
var dev = gdMprDevice.new()

# Change this to increase it to more units/second

# Called when the node enters the scene tree for the first time.
func _ready():
	dev.init("pong")
	dev.add_sig(gdMprDevice.INCOMING, "player1_y", 1, gdMprDevice.FLOAT)
	dev.add_sig(gdMprDevice.INCOMING, "player2_y", 1, gdMprDevice.FLOAT)
	dev.set_value_float("player1_y", 1)
	dev.set_value_float("player2_y", 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	dev.poll()
	var p1_y = dev.get_value_float("player1_y")
	var p2_y = dev.get_value_float("player2_y")
	
	$Left.position.y = p1_y * height
	$Right.position.y = p2_y * height
