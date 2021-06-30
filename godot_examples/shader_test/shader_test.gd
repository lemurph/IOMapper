extends MeshInstance


var dev = IOMapper.new()
var height = 0.5
var material = load("res://shader_test_material.tres")
var height_sig

func _ready():
	dev.init("shader")
	height_sig = dev.add_sig(IOMapper.INCOMING, "shader_height", 1, IOMapper.FLOAT)


func _process(delta):
	dev.poll()
	height = height_sig.get_value_float(0)
	material.set_shader_param("height_scale", height)
