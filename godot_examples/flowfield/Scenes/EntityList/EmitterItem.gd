extends Control


var emitter = null
signal removed


# Called when the node enters the scene tree for the first time.
func _ready():
	if not emitter:
		queue_free()
		return
	$SpreadSlider.value = rad2deg(emitter.spread)
	$SpeedSlider.value = emitter.target_speed / emitter.MAX_SPEED
	$AutoColor.pressed = emitter.auto_color_change
	$ColorPicker.color = emitter.particle_color


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SpreadSlider_value_changed(value):
	emitter.spread = deg2rad(value)


func _on_SpeedSlider_value_changed(value):
	emitter.target_speed = value * emitter.MAX_SPEED


func _on_PauseButton_toggled(button_pressed):
	emitter.emitting = not button_pressed


func _on_DeleteButton_pressed():
	emit_signal("removed", self)
	emitter.queue_free()
	self.queue_free()


func _on_ColorPicker_color_changed(color):
	emitter.particle_color = color


func _on_AutoColor_toggled(button_pressed):
	emitter.auto_color_change = button_pressed


func _on_EmitterItem_mouse_entered():
	emitter.show()
	emitter.hovering = true


func _on_EmitterItem_mouse_exited():
	var mp = get_local_mouse_position()
	if Rect2(Vector2(), self.rect_size).has_point(mp):
		pass
	else:
		emitter.hide()
		emitter.hovering = false


func _on_ColorPicker_popup_closed():
	var mp = get_local_mouse_position()
	if Rect2(Vector2(), self.rect_size).has_point(mp):
		pass
	else:
		emitter.hide()
		emitter.hovering = false
