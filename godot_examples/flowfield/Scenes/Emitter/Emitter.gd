extends Node2D

var ParticleScene = preload("res://Scenes/Particle/Particle.tscn")
var world = null
var times_per_sec = 60
var drag_offset = Vector2()
var is_dragging = false
var spread = 0.0
var target_angle = Vector2(0, -1)
var target_speed = 125.0
var hovering = false
var MAX_SPEED = 300.0
var auto_color_change = true
var particle_color = Color()
var particle_scale = 1.0
var music_color = Color()
var emitting = true
signal moved


# Called when the node enters the scene tree for the first time.
func _ready():
	world = get_parent()
	$Timer.wait_time = 1.0 / times_per_sec
	particle_color = Color.orangered
	particle_color.h = randf()
	particle_scale = world.particle_scale
	music_color = particle_color
	self.connect("moved", world, "update_noise_texture")
	emit_signal("moved")


func show():
	$VisibilityTween.interpolate_property(
		$Settings, "modulate", $Settings.modulate, Color(1.0, 1.0, 1.0, 1.0), 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT
	)
	$VisibilityTween.start()

func hide():
	$VisibilityTween.interpolate_property(
		$Settings, "modulate", $Settings.modulate, Color(1.0, 1.0, 1.0, 0.0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT
	)
	$VisibilityTween.start()

func _process(delta):
	if auto_color_change:
		var change = world.bass_level * delta * 0.5 * world.color_change_speed
		if not world.music_mode_enabled and not world.microphone_active:
			change = delta * world.color_change_speed * 0.5
		if self.particle_color.h + change > 1.0:
			self.particle_color.h = (self.particle_color.h + change) - 1.0
		else:
			self.particle_color.h += change
		$Settings/ColorPickerButton.color = self.particle_color

	if is_dragging:
		self.position = get_global_mouse_position() + drag_offset
#	else:
#		var mouse_dist = (get_global_mouse_position() - self.position).length()
##		if mouse_dist > 192.0:
##			$Settings.modulate = Color(1.0, 1.0, 1.0, 0.0)
#		if mouse_dist < 128.0:
#			self.show()
#		else:
#			self.hide()
			
			


func spawn_particle():
	if randf() < world.music_intensity + world.spawn_rate:

		var ps = ParticleScene.instance()
		ps.position = self.position
		var new_angle = target_angle.rotated(rand_range(-spread, spread))
		ps.velocity = new_angle * target_speed
		ps.initial_angle = new_angle
		ps.SPEED = target_speed
		if world.music_mode_enabled or world.microphone_active:
			var s = lerp(particle_scale, 0.5 + world.bass_level / 2, world.music_color_impact)
			ps.scale = Vector2(s, s) * particle_scale
#			if world.bass_level > 0.5:
#				ps.set_color(world.color_from_music(particle_color.contrasted()))
#			else:
			ps.set_color(world.color_from_music(particle_color))

			ps.velocity *= 1.0 + world.diskant_level * 5
			ps.initial_boost_duration = world.diskant_level * 2
		else:
			ps.set_color(particle_color)
			ps.scale = Vector2(particle_scale, particle_scale)
		world.viewport.add_child(ps)


func _on_Timer_timeout():
	if world.paused or not emitting:
		return
	var max_part = world.MAX_PARTICLES
#	if world.use_custom_texture:
#		max_part /= 2
	if len(get_tree().get_nodes_in_group("particles")) < max_part:
		self.spawn_particle()


func _on_MoveButton_button_down():
	drag_offset = self.position - get_global_mouse_position()
	is_dragging = true


func _on_MoveButton_button_up():
	is_dragging = false
	emit_signal("moved")


func _on_AngleSpeedButton_angle_changed(a):
	target_angle = a


func _on_AngleSpeedButton_speed_changed(s):
	target_speed = s * MAX_SPEED


func _on_ColorPickerButton_color_changed(color):
	particle_color = color



func _on_Settings_mouse_entered():
	self.show()


func _on_Settings_mouse_exited():
	if hovering:
		return
	var mp = get_global_mouse_position()
	if Rect2(self.position + $Settings.rect_position, $Settings.rect_size).has_point(mp):
		pass
	else:
		self.hide()


