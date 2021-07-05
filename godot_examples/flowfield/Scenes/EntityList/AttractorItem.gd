extends Control


var attractor = null
signal removed


# Called when the node enters the scene tree for the first time.
func _ready():
	if not attractor:
		queue_free()
		return
	$Strength.value = attractor.force
	$Radius.value = attractor.hole_radius

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_PauseButton_toggled(button_pressed):
	attractor.attracting = not button_pressed


func _on_DeleteButton_pressed():
	emit_signal("removed", self)
	attractor.queue_free()
	self.queue_free()


func _on_ColorPicker_color_changed(color):
	attractor.particle_color = color


func _on_Strength_value_changed(value):
	attractor.force = value


func _on_Radius_value_changed(value):
	attractor.hole_radius = value
	attractor.update_scale()
