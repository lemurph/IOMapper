extends MeshInstance


var dev = gdMprDevice.new()
var R = 0.0
var G = 0.0
var B = 0.0
var sleep = 1
var material = get_surface_material(0)

func _ready():
	dev.init("shader_ball")
	dev.add_sig(gdMprDevice.INCOMING, "physics", 1, gdMprDevice.INT32)
	dev.add_sig(gdMprDevice.INCOMING, "r", 1, gdMprDevice.FLOAT)
	dev.add_sig(gdMprDevice.INCOMING, "g", 1, gdMprDevice.FLOAT)
	dev.add_sig(gdMprDevice.INCOMING, "b", 1, gdMprDevice.FLOAT)
	dev.set_value_float("physics", 0)
	dev.set_value_float("r", 0.0)
	dev.set_value_float("g", 0.0)
	dev.set_value_float("b", 0.0)


func _process(delta):
	dev.poll()
	R = dev.value_float("r")
	G = dev.value_float("g")
	B = dev.value_float("b")
	sleep = dev.value_int("physics")
	print(sleep)
	get_node("../..").set_sleeping(sleep)
	material.set_shader_param("R", R)
	material.set_shader_param("G", G)
	material.set_shader_param("B", B)
