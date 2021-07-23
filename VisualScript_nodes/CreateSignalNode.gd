tool
extends VisualScriptCustomNode

# The name of the custom node as it appears in the search.
func _get_caption():
	return "Create IOMapper Signal"

func _get_category():
	return "IOMapper"

# The text displayed after the input port / sequence arrow.
func _get_text():
	return "Device"

func _get_input_value_port_count():
	return 4

# The types of the inputs per index starting from 0.
func _get_input_value_port_type(idx):
	if (idx == 0):
		return TYPE_STRING
	if (idx == 1):
		return TYPE_STRING
	if (idx == 2):
		return TYPE_INT
	else:
		return TYPE_STRING

func _get_output_value_port_count():
	return 1

# The types of outputs per index starting from 0.
func _get_output_value_port_type(idx):
	return IOMapper

# The text displayed before each output node per index.
func _get_output_value_port_name(idx):
	return "Signal"

func _get_input_value_port_name(idx):
	if (idx == 0):
		return "IOMapper Direction"
	if (idx == 1):
		return "Signal Name"
	if (idx == 2):
		return "Length"
	else:
		return "Type"

func _has_input_sequence_port():
	return true

# The number of output sequence ports to use
# (has to be at least one if you have an input sequence port).
func _get_output_sequence_port_count():
	return 1

func _get_output_sequence_port_text(idx):
	return "Device"

func _step(inputs, outputs, start_mode, working_mem):
	# start_mode can be checked to see if it is the first time _step is called.
	# This is useful if you only want to do an operation once.
	var direction
	var type
	
	if (start_mode == 0):
		if (inputs[1] == "Incoming"):
			direction = IOMapper.INCOMING
		elif (inputs[1] == "Outgoing"):
			direction = IOMapper.OUTGOING
		
		if (inputs[5] == "int"):
			type = IOMapper.INT32
		elif (inputs[5] == "float"):
			type = IOMapper.FLOAT
		elif (inputs[5] == "double"):
			type = IOMapper.DOUBLE
		
		var dev = inputs[0]
		outputs[0] = dev.add_sig(direction, inputs[2], inputs[3], type)
	# working_memory is persistent between _step calls.

	# The inputs array contains the value of the input ports.

	# The outputs array is used to set the data of the output ports.



	# Return the error string if an error occurred, else the id of the next sequence port.
	return 0
