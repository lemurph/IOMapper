extends Node

onready var ocean = $"../Ocean"
var dev = IOMapper.new()
var default = 0.1
export var scale = 1.0

var amplitude_sig
var steepness_sig
var wind_align_sig


# Called when the node enters the scene tree for the first time.
func _ready():
	dev.init("water")
	amplitude_sig = dev.add_sig(IOMapper.INCOMING, "amplitude", 1, IOMapper.FLOAT)
	steepness_sig = dev.add_sig(IOMapper.INCOMING, "steepness", 1, IOMapper.FLOAT)
	wind_align_sig = dev.add_sig(IOMapper.INCOMING, "wind_align", 1, IOMapper.FLOAT)
	amplitude_sig.set_value_float(0, default)
	steepness_sig.set_value_float(0, default)
	wind_align_sig.set_value_float(0, default)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	dev.poll()
	var amplitude = amplitude_sig.get_value_float(0)
	var steepness = steepness_sig.get_value_float(0)
	var wind_align = wind_align_sig.get_value_float(0)
	ocean.set_amplitude(amplitude * scale)
	ocean.set_steepness(steepness * scale)
	ocean.set_wind_align(wind_align * scale)
