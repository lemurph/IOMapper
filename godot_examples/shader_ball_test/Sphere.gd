extends MeshInstance


var dev = IOMapper.new()
var R = 0.0
var G = 0.0
var B = 0.0
var rgb_sig
var physics_sig
var sleep = 1
var material = get_surface_material(0)

func _ready():
	dev.init("shader_ball")
	physics_sig = dev.add_sig(IOMapper.INCOMING, "physics", 1, IOMapper.INT32)
	rgb_sig = dev.add_sig(IOMapper.INCOMING, "RGB", 3, IOMapper.FLOAT)


func _process(delta):
	dev.poll()
	sleep = physics_sig.get_value_int()
	get_node("../..").set_sleeping(sleep)
	var rgb_vector = rgb_sig.get_value_vector3()
	material.set_shader_param("R", rgb_vector.x)
	material.set_shader_param("G", rgb_vector.y)
	material.set_shader_param("B", rgb_vector.z)
