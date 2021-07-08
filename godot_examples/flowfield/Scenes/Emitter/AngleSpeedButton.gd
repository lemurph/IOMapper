extends TextureButton

var dragging = false
export var drag_offset = Vector2()
signal angle_changed
signal speed_changed


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	#if dragging:
		var mp = get_parent().get_parent().get_parent().get_local_mouse_position()
		get_parent().position = mp + drag_offset
		get_parent().position = get_parent().position.normalized() * 91.0

		var v = get_parent().position.normalized()
		emit_signal("angle_changed", v)
		get_parent().rotation = v.angle() + PI / 2


func _on_AngleSpeedButton_button_down():
	drag_offset = get_parent().position - get_parent().get_parent().get_parent().get_local_mouse_position()
	dragging = true
	


func _on_AngleSpeedButton_button_up():
	dragging = false


