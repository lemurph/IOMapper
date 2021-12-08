extends Area2D

const DEFAULT_SPEED = 100

var direction = Vector2.LEFT

onready var _initial_pos = position
onready var _speed = DEFAULT_SPEED

var rng = RandomNumberGenerator.new()

var start = false
func _ready():
	 rng.randomize()
	
func _process(delta):
	if start:
		_speed += delta * 2
		position += _speed * delta * direction


func reset(player_reset=false):
	if player_reset:
		start = false
	var rn = rng.randi()
	if rn % 2 == 0:
		direction = Vector2.LEFT
	else:
		direction = Vector2.RIGHT
	position = _initial_pos
	_speed = DEFAULT_SPEED

func start():
	start = true
