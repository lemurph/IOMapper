tool
extends VisualScriptCustomNode

# The name of the custom node as it appears in the search.
func _get_caption():
	return "IOMapper Directions/Types"

func _get_category():
	return "IOMapper"

# The text displayed after the input port / sequence arrow.
func _get_text():
	return ""

func _get_input_value_port_count():
	return 0

# The types of the inputs per index starting from 0.
func _get_input_value_port_type(idx):
	pass

func _get_output_value_port_count():
	return 5

# The types of outputs per index starting from 0.
func _get_output_value_port_type(idx):
	if (idx == 0):
		return TYPE_STRING
	if (idx == 1):
		return TYPE_STRING
	if (idx == 2):
		return TYPE_STRING
	if (idx == 3):
		return TYPE_STRING
	else:
		return TYPE_STRING

# The text displayed before each output node per index.
func _get_output_value_port_name(idx):
	if (idx == 0):
		return "Direction: Incoming"
	if (idx == 1):
		return "Direction: Outgoing"
	if (idx == 2):
		return "Type: Integer"
	if (idx == 3):
		return "Type: Float"
	else:
		return "Type: Double"

func _get_input_value_port_name(idx):
	pass

func _has_input_sequence_port():
	return false

# The number of output sequence ports to use
# (has to be at least one if you have an input sequence port).
func _get_output_sequence_port_count():
	return 0

func _get_output_sequence_port_text(idx):
	return 0

func _step(inputs, outputs, start_mode, working_mem):
	# start_mode can be checked to see if it is the first time _step is called.
	# This is useful if you only want to do an operation once.
	
	# working_memory is persistent between _step calls.

	# The inputs array contains the value of the input ports.

	# The outputs array is used to set the data of the output ports.
	outputs[0] = "Incoming"
	outputs[1] = "Outgoing"
	outputs[2] = "int"
	outputs[3] = "float"
	outputs[4] = "double"
	
	


	# Return the error string if an error occurred, else the id of the next sequence port.
	return 0
