extends Node2D


var dev = gdMprDevice.new()
var radius = 2.0

func _ready():
	dev.init("fire")
	dev.add_sig(gdMprDevice.INCOMING, "radius", 1, gdMprDevice.FLOAT)
	dev.set_value_float("radius", 2.0)


func _process(delta):
	dev.poll()
	radius = dev.value_float("radius")
	$Flame.process_material.set_emission_sphere_radius(radius)
