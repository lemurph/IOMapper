extends MeshInstance


var dev = gdMprDevice.new()
var height = 0.5
var material = load("res://shader_test_material.tres")

func _ready():
	dev.init("shader")
	dev.add_sig(gdMprDevice.INCOMING, "shader_height", 1, gdMprDevice.FLOAT)
	dev.set_value_float("shader_height", 0.5)


func _process(delta):
	dev.poll()
	height = dev.value_float("shader_height")
	material.set_shader_param("height_scale", height)
