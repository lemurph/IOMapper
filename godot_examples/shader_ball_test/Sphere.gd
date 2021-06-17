extends MeshInstance


var dev = IOMapper.new()
var R = 0.0
var G = 0.0
var B = 0.0
var sleep = 1
var material = get_surface_material(0)

func _ready():
	dev.init("shader_ball")
	dev.add_sig(IOMapper.INCOMING, "physics", 1, IOMapper.INT32)
	dev.add_sig(IOMapper.INCOMING, "RGB", 3, IOMapper.FLOAT)
	dev.set_value_float("physics", 1)
	dev.set_value_vector3("RGB", Vector3(0.0, 0.0, 0.0))


func _process(delta):
	dev.poll()
	sleep = dev.get_value_int("physics")
	get_node("../..").set_sleeping(sleep)
	var rgb_vector = dev.get_value_vector3("RGB")
	material.set_shader_param("R", rgb_vector.x)
	material.set_shader_param("G", rgb_vector.y)
	material.set_shader_param("B", rgb_vector.z)
