tool
extends VisualScriptCustomNode

var dev = IOMapper.new()

# The name of the custom node as it appears in the search.
func _get_caption():
	return "Create IOMapper Device"

func _get_category():
	return "IOMapper"

# The text displayed after the input port / sequence arrow.
func _get_text():
	return ""

func _get_input_value_port_count():
	return 1

func _get_input_value_port_name(idx):
	return "Device Name"

# The types of the inputs per index starting from 0.
func _get_input_value_port_type(idx):
	return TYPE_STRING

func _get_output_value_port_count():
	return 0

# The types of outputs per index starting from 0.
func _get_output_value_port_type(idx):
	return IOMapper

# The text displayed before each output node per index.
func _get_output_value_port_name(idx):
	return "Device"

func _has_input_sequence_port():
	return false

# The number of output sequence ports to use
# (has to be at least one if you have an input sequence port).
func _get_output_sequence_port_count():
	return 1

func _get_output_sequence_port_text(idx):
	return "Device"

func _process():
	dev.poll()

func _step(inputs, outputs, start_mode, working_mem):
	# start_mode can be checked to see if it is the first time _step is called.
	# This is useful if you only want to do an operation once.
	
	if (start_mode == START_MODE_BEGIN_SEQUENCE):
		dev.init(inputs[0])
	# working_memory is persistent between _step calls.

	# The inputs array contains the value of the input ports.

	# The outputs array is used to set the data of the output ports.
	dev.poll()
	outputs[0] = dev

	# Return the error string if an error occurred, else the id of the next sequence port.
	return 0
