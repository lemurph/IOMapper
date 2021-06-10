extends Node2D


var dev = gdMprDevice.new()
var radius = 2.0
# This radius scale is to be used when connecting to various libmapper devices! TODO: Consider scaling on the other side of the libmapper map.
export var radius_scale = 200

func _ready():
	dev.init("fire")
	dev.add_sig(gdMprDevice.INCOMING, "radius", 1, gdMprDevice.FLOAT)
	dev.set_value_float("radius", 2.0)


func _process(delta):
	dev.poll()
	radius = dev.get_value_float("radius") * radius_scale
	$Flame.process_material.set_emission_sphere_radius(radius)
