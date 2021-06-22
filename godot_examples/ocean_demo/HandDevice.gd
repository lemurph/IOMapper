extends Node

onready var ocean = $"../Ocean"
var dev = IOMapper.new()
var default = 0.1
export var scale = 1.0


# Called when the node enters the scene tree for the first time.
func _ready():
	dev.init("water")
	dev.add_sig(IOMapper.INCOMING, "amplitude", 1, IOMapper.FLOAT)
	dev.add_sig(IOMapper.INCOMING, "steepness", 1, IOMapper.FLOAT)
	dev.add_sig(IOMapper.INCOMING, "wind_align", 1, IOMapper.FLOAT)
	dev.set_value_float("amplitude", 0, default)
	dev.set_value_float("steepness", 0, default)
	dev.set_value_float("wind_align", 0, default)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	dev.poll()
	var amplitude = dev.get_value_float("amplitude", 0)
	var steepness = dev.get_value_float("steepness", 0)
	var wind_align = dev.get_value_float("wind_align", 0)
	ocean.set_amplitude(amplitude * scale)
	ocean.set_steepness(steepness * scale)
	ocean.set_wind_align(wind_align * scale)
