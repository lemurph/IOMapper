extends Node2D


var dev = IOMapper.new()
var light1_color
var light1_energy

var light2_color
var light2_energy

var light3_color
var light3_energy


# Called when the node enters the scene tree for the first time.
func _ready():
	dev.init("Lights")
	
	light1_color = dev.add_sig(IOMapper.INCOMING, "light1_color", 3, IOMapper.FLOAT)
	light1_energy = dev.add_sig(IOMapper.INCOMING, "light1_energy", 1, IOMapper.FLOAT)
	
	light2_color = dev.add_sig(IOMapper.INCOMING, "light2_color", 3, IOMapper.FLOAT)
	light2_energy = dev.add_sig(IOMapper.INCOMING, "light2_energy", 1, IOMapper.FLOAT)
	
	light3_color = dev.add_sig(IOMapper.INCOMING, "light3_color", 3, IOMapper.FLOAT)
	light3_energy = dev.add_sig(IOMapper.INCOMING, "light3_energy", 1, IOMapper.FLOAT)
	

func _process(_delta):
	dev.poll()
	
	$light1.color = light1_color.get_value_vector3()
	$light1.energy = light1_color.get_value_float()

	$light2.color = light2_color.get_value_vector3()
	$light2.energy = light2_color.get_value_float()

	$light3.color = light3_color.get_value_vector3()
	$light3.energy = light3_color.get_value_float()
