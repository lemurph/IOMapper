extends Node2D

onready var height = get_viewport_rect().size.y
var dev = IOMapper.new()

var player1_y
var player2_y
# Change this to increase it to more units/second

# Called when the node enters the scene tree for the first time.
func _ready():
	dev.init("pong")
	player1_y = dev.add_sig(IOMapper.INCOMING, "player1_y", 1, IOMapper.FLOAT)
	player2_y = dev.add_sig(IOMapper.INCOMING, "player2_y", 1, IOMapper.FLOAT)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	dev.poll()
	var p1_y = player1_y.get_value_float()
	var p2_y = player2_y.get_value_float()
	
	$Left.position.y = p1_y * height
	$Right.position.y = p2_y * height
