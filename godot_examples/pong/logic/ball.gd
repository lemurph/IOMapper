extends Area2D

const DEFAULT_SPEED = 100

var direction = Vector2.LEFT

onready var _initial_pos = position
onready var _speed = DEFAULT_SPEED

func _process(delta):
	_speed += delta * 2
	position += _speed * delta * direction


func reset():
	direction = Vector2.LEFT
	position = _initial_pos
	_speed = DEFAULT_SPEED
