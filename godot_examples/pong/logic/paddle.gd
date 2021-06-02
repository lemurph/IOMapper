extends Area2D

const MOVE_SPEED = 100

var _ball_dir
var _up
var _down
var dev = gdMprDevice.new()

onready var _screen_size_y = get_viewport_rect().size.y

# Called when the node enters the scene tree for the first time.
func _ready():
	dev.init("player_control")
	dev.add_sig(gdMprDevice.INCOMING, "player", 1, gdMprDevice.INT32)
	dev.set_value_int("player", 0)
	
	var n = name.to_lower()
	_up = n + "_move_up"
	_down = n + "_move_down"
	if n == "left":
		_ball_dir = 1
	else:
		_ball_dir = -1


func _process(delta):
	dev.poll()
	# Move up and down based on input.
	var input = dev.value_int("player")
	position.y = clamp(position.y + input * MOVE_SPEED * delta, 16, _screen_size_y - 16)


func _on_area_entered(area):
	if area.name == "Ball":
		# Assign new direction.
		area.direction = Vector2(_ball_dir, randf() * 2 - 1).normalized()
