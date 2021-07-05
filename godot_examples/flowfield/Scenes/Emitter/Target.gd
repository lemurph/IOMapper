extends Node2D

var drag_offset = Vector2()
var is_dragging = false
signal target_moved


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if is_dragging:
		self.position = get_global_mouse_position() + drag_offset
		emit_signal("target_moved", self.position)



func _on_TextureButton_button_down():
	drag_offset = self.position - get_global_mouse_position()
	is_dragging = true


func _on_TextureButton_button_up():
	is_dragging = false
