extends Node2D

var dev = IOMapper.new()
var Adherence_sig
var ParticleRadius_sig
var FieldRotation_sig
var Angularity_sig
var SpawnRate_sig
var Emitter_pos_sig
var Rotation_sig
var Spread_sig
var Speed_sig
var Hue_sig
var Attractor_pos_sig
var a

var world_size = Vector2(1000, 1000)
var emitter_scene = preload("res://Scenes/Emitter/Emitter.tscn")
var attractor_scene = preload("res://Scenes/Attractor/Attractor.tscn")
var emitter_icon = preload("res://Scenes/Emitter/emitter_icon.png")
var attractor_icon = preload("res://Scenes/Attractor/attractor_icon.png")
var MAX_PARTICLES = 2000
var viewport = null
var board = TextureRect.new()
var particle_color = Color.white
var music_pos = 0.0
var particle_speed = 250
var particle_scale = 0.25
var angularity = 0.0
var spread = 0.0
var target_pos = Vector2()
var paused = false
var music_mode_enabled = false
var music_intensity = 0.0
var music_impact = 1.0
var music_color_impact = 1.0
var microphone_active = false
var microphone_sensitivity = 2.5
var color_change_speed = 0.33
var flow_adherence = 1.0
var spawn_rate = 0.02
var menu_visible = true
var noise_field = OpenSimplexNoise.new()
var noise_field_detail = OpenSimplexNoise.new()
var noise_field_temp = OpenSimplexNoise.new()
var noise_field_detail_temp = OpenSimplexNoise.new()
var noise_octaves = 8.0
var noise_period = 512.0
var noise_persistence = 0.75
var noise_lacunarity = 2.0
var noise_detail_ratio = 0.0
var noise_detail_scale = 0.74
var noise_z_level = 0.0
var noise_texture = Image
var custom_texture = Image
var use_custom_texture = false
var current_custom_value = 0.0
var noise_seed = 0
var field_rotation = 0.0
var bass_level = 0.0
var diskant_level = 0.0

signal emitter_added
signal attractor_added

func _ready():
	# Initiate device and add signals
	dev.init("flow_field")
	Adherence_sig = dev.add_sig(IOMapper.INCOMING, "adherence", 1, IOMapper.FLOAT)
	Adherence_sig.set_value_float(0.5)
	
	ParticleRadius_sig = dev.add_sig(IOMapper.INCOMING, "particle_radius", 1, IOMapper.FLOAT)
	ParticleRadius_sig.set_value_float(0.5)
	
	FieldRotation_sig = dev.add_sig(IOMapper.INCOMING, "field_rotation", 1, IOMapper.FLOAT)
	FieldRotation_sig.set_value_float(0.5)
	
	Angularity_sig = dev.add_sig(IOMapper.INCOMING, "angularity", 1, IOMapper.FLOAT)
	Angularity_sig.set_value_float(0.5)
	
	SpawnRate_sig = dev.add_sig(IOMapper.INCOMING, "spawnrate", 1, IOMapper.FLOAT)
	SpawnRate_sig.set_value_float(1)
	
	Rotation_sig = dev.add_sig(IOMapper.INCOMING, "rotation", 2, IOMapper.FLOAT)
	Rotation_sig.set_value_float(0.5)
	
	Spread_sig = dev.add_sig(IOMapper.INCOMING, "spread", 1, IOMapper.FLOAT)
	Spread_sig.set_value_float(0.5)
	
	Speed_sig = dev.add_sig(IOMapper.INCOMING, "speed", 1, IOMapper.FLOAT)
	Speed_sig.set_value_float(0.5)
	
	Hue_sig = dev.add_sig(IOMapper.INCOMING, "hue", 1, IOMapper.FLOAT)
	Attractor_pos_sig = dev.add_sig(IOMapper.INCOMING, "attractor_pos", 2, IOMapper.FLOAT)
	
	# Reserve instances and set starting values
	Emitter_pos_sig = dev.add_sig(IOMapper.INCOMING, "emitter_pos", 2, IOMapper.FLOAT)
	Emitter_pos_sig.reserve_instances(5)
	#for x in 5:
	#	Emitter_pos_sig.set_value_vector2(Vector2(0.5, 0.5), x)
	
	a = attractor_scene.instance()
	viewport = $ViewportContainer/Viewport
	self.initiate_viewport()
	add_child(self.board)
	setup_noise()
	self.world_size = viewport.size

func get_modified_noise_from_pos(pos, temp=false):
	var base_value = 0.0
	var nf = noise_field
	var nfd = noise_field_detail
	if temp:
		nf = noise_field_temp
		nfd = noise_field_detail_temp
	if use_custom_texture:
		var cv = custom_texture.get_pixel(
			int(clamp(pos.x, 0, world_size.x - 1)),
			int(clamp(pos.y, 0, world_size.y - 1))
		)
		base_value = (cv.r + cv.g + cv.b) / 3
	else:
		base_value = nf.get_noise_3d(pos.x, pos.y, noise_z_level)

	var blended_value = base_value + nfd.get_noise_3d(
		pos.x / noise_detail_scale, pos.y / noise_detail_scale, noise_z_level
	)
	blended_value /= 2
	return lerp(base_value, blended_value, noise_detail_ratio)

func get_vector_from_noise(pos):
	var noise_value = get_modified_noise_from_pos(pos)
	var flow_direction = noise_value * PI * 4 + field_rotation + ((PI * 2 * bass_level) - (PI * 2 * diskant_level)) * music_impact
	return Vector2(0, 1.0).rotated(flow_direction)

func setup_noise():
	if not noise_seed:
		randomize()
		noise_seed = randi()
	update_temp_noise()
	apply_noise()
	update_noise_texture()

func update_temp_noise():
	noise_field_temp.seed = noise_seed
	noise_field_temp.octaves = noise_octaves
	noise_field_temp.period = noise_period
	noise_field_temp.lacunarity = noise_lacunarity
	noise_field_temp.persistence = noise_persistence
	noise_field_detail_temp.seed = noise_seed
	noise_field_detail_temp.octaves = noise_octaves
	noise_field_detail_temp.period = noise_period / 2
	noise_field_detail_temp.lacunarity = noise_lacunarity
	noise_field_detail_temp.persistence = noise_persistence
	update_noise_texture()

func apply_noise():
	noise_field.seed = noise_field_temp.seed
	noise_field.octaves = noise_field_temp.octaves
	noise_field.period = noise_field_temp.period
	noise_field.persistence = noise_field_temp.persistence
	noise_field_detail.seed = noise_field_detail_temp.seed
	noise_field_detail.octaves = noise_field_detail_temp.octaves
	noise_field_detail.period = noise_field_detail_temp.period
	noise_field_detail.persistence = noise_field_detail_temp.persistence

func update_noise_texture():
	var preview_size = Vector2(170, 96)
	var t = ImageTexture.new()

	var blend = Image.new()
	blend.create(170, 96, true, Image.FORMAT_RGBAF)
	blend.fill(Color.black)
	blend.lock()
	var r = Vector2(3840, 2160) / preview_size
	for x in preview_size.x:
		for y in preview_size.y:
			var bv = get_modified_noise_from_pos(Vector2(x * r.x, y * r.y), true) + 0.5
			blend.set_pixel(x, y, Color.white * bv)
	var emitter_img = emitter_icon.get_data()
	for e in get_tree().get_nodes_in_group("emitters"):
		var p = Vector2(int(e.position.x / r.x), int(e.position.y / r.y))
		var c = Color.lightblue
		blend.set_pixelv(p, Color.blue)
		blend.set_pixelv(p + Vector2.UP + Vector2.LEFT, c)
		blend.set_pixelv(p + Vector2.UP, c)
		blend.set_pixelv(p + Vector2.UP + Vector2.RIGHT, c)
		blend.set_pixelv(p + Vector2.RIGHT, c)
		blend.set_pixelv(p + Vector2.DOWN + Vector2.RIGHT, c)
		blend.set_pixelv(p + Vector2.DOWN, c)
		blend.set_pixelv(p + Vector2.DOWN + Vector2.LEFT, c)
		blend.set_pixelv(p + Vector2.LEFT, c)
	for a in get_tree().get_nodes_in_group("attractors"):
		var p = Vector2(int(a.position.x / r.x), int(a.position.y / r.y))
		var c = Color.pink
		blend.set_pixelv(p, Color.red)
		blend.set_pixelv(p + Vector2.UP + Vector2.LEFT, c)
		blend.set_pixelv(p + Vector2.UP, c)
		blend.set_pixelv(p + Vector2.UP + Vector2.RIGHT, c)
		blend.set_pixelv(p + Vector2.RIGHT, c)
		blend.set_pixelv(p + Vector2.DOWN + Vector2.RIGHT, c)
		blend.set_pixelv(p + Vector2.DOWN, c)
		blend.set_pixelv(p + Vector2.DOWN + Vector2.LEFT, c)
		blend.set_pixelv(p + Vector2.LEFT, c)
	t.create_from_image(blend)

	$CanvasLayer/Panel/Panel/NoisePreview.texture = t

func seed_from_string(s):
	var tot = 0
	var ascii = s.to_ascii()
	for a in ascii:
		tot += a
	tot *= len(s)
	return tot

func initiate_viewport():
	viewport.render_target_clear_mode = Viewport.CLEAR_MODE_ONLY_NEXT_FRAME
	var rt = viewport.get_texture()
	board.set_texture(rt)


func color_from_music(c):
	var new_c = Color()
	new_c = c.darkened(0.5 - bass_level / 2)
	#new_c.s = 0.3 + music_intensity * 0.66
	new_c.a = 0.5 + music_intensity / 2
	new_c = new_c.lightened(diskant_level)
	return lerp(c, new_c, music_color_impact)

func get_bass_level():
	var spectrum = AudioServer.get_bus_effect_instance(0,0)
	var bass = spectrum.get_magnitude_for_frequency_range(0, 400)
	return min(1.0, (bass.x + bass.y) * 3)


func update_music_levels():
	if not music_mode_enabled and not microphone_active:
		bass_level = 0.0
		diskant_level = 0.0
		music_intensity = 0.0
		return
	var b_range = [0, 150]
	var d_range = [4000, 20000]
	var t_range = [0, 20000]
	var spectrum = AudioServer.get_bus_effect_instance(0, 0)
	var bass = spectrum.get_magnitude_for_frequency_range(b_range[0], b_range[1])
	var diskant = spectrum.get_magnitude_for_frequency_range(d_range[0], d_range[1])
	var total = spectrum.get_magnitude_for_frequency_range(t_range[0], t_range[1])
	if microphone_active:
		var mic_spectrum = AudioServer.get_bus_effect_instance(AudioServer.get_bus_index("Record"), 1)
		bass = mic_spectrum.get_magnitude_for_frequency_range(b_range[0], b_range[1]) * microphone_sensitivity
		diskant = mic_spectrum.get_magnitude_for_frequency_range(d_range[0] + 1000, d_range[1]) * microphone_sensitivity / 2
		total = mic_spectrum.get_magnitude_for_frequency_range(t_range[0], t_range[1]) * microphone_sensitivity

	bass_level = min(1.0, (bass.x + bass.y) * 2)
	diskant_level = min(1.0, (diskant.x + diskant.y) * 32)
	music_intensity = min(1.0, (total.x + total.y) * 3)


func _process(delta):
	# Poll device to ensure signals are up to date
	dev.poll()
	
	# Change properties according to incoming signal values
	_on_Adherence_value_changed(Adherence_sig.get_value_float())
	_on_ParticleRadius_value_changed(ParticleRadius_sig.get_value_float())
	_on_FieldRotation_value_changed(FieldRotation_sig.get_value_float())
	_on_Angularity_value_changed(Angularity_sig.get_value_float())
	_on_SpawnRate_value_changed(SpawnRate_sig.get_value_float())
	
	# Change sliders to match signal values
	$CanvasLayer/Panel/Adherence.value =Adherence_sig.get_value_float()
	$CanvasLayer/Panel/ParticleRadius.value = ParticleRadius_sig.get_value_float()
	$CanvasLayer/Panel/FieldRotation.value = FieldRotation_sig.get_value_float()
	$CanvasLayer/Panel/Angularity.value = Angularity_sig.get_value_float()
	$CanvasLayer/Panel/SpawnRate.value = SpawnRate_sig.get_value_float()
	
	# Set position for attractor
	var pos2 = Attractor_pos_sig.get_value_vector2()
	a.position = Vector2(pos2.x * world_size.x, pos2.y * world_size.y)
	
	# Loop through active emitters
	var id = 0
	for e in get_tree().get_nodes_in_group("emitters"):
		
		# Update emitter with instance id
		if Emitter_pos_sig.is_active(id):
			var pos = Emitter_pos_sig.get_value_vector2(id)
			e.position = Vector2(pos.x * world_size.x, pos.y * world_size.y)
			#print(pos)
		
		# Set emitter-specific properties to respective signal values
		e.target_speed = Speed_sig.get_value_float() * e.MAX_SPEED
		e.spread = Spread_sig.get_value_float()
		e.particle_color.h = Hue_sig.get_value_float()
		id += 1
	
	update_music_levels()
	if Input.is_action_just_pressed("toggle_menu"):
		menu_visible = not menu_visible
		if menu_visible:
			$CanvasLayer/Panel/AnimationPlayer.play("pop_in")
		else:
			$CanvasLayer/Panel/AnimationPlayer.play("pop_out")

func _input(event):
	if event is InputEventMouseMotion and Input.is_action_pressed("camera_drag"):
		$Camera2D.position -= event.relative
	if Input.is_action_just_pressed("camera_zoom_in") and $Camera2D.zoom > Vector2(0.2, 0.2):
		$Camera2D.zoom -= Vector2(0.1, 0.1)
	if Input.is_action_just_pressed("camera_zoom_out") and $Camera2D.zoom < Vector2(2.0, 2.0):
		$Camera2D.zoom += Vector2(0.1, 0.1)


func _on_ColorPickerButton_color_changed(color):
	self.particle_color = color

func _on_ColorPickerButton2_color_changed(color):
	VisualServer.set_default_clear_color(color)
	for p in get_tree().get_nodes_in_group("particles"):
		p.queue_free()
	self.initiate_viewport()


func _on_Button_pressed():
	for p in get_tree().get_nodes_in_group("particles"):
		p.queue_free()
	self.initiate_viewport()




func _on_Button2_pressed():
	apply_noise()


func _on_PreviewButton_pressed():
	update_temp_noise()
	update_noise_texture()

func _on_HSlider_value_changed(value):
	self.particle_speed = value


func _on_Button3_pressed():
	self.paused = not self.paused


func _on_CheckBox_toggled(button_pressed):
	if button_pressed and not music_mode_enabled:
		music_mode_enabled = true
		$AudioStreamPlayer2D.play()
		$AudioStreamPlayer2D.seek(music_pos)
	elif not button_pressed and music_mode_enabled:
		music_mode_enabled = false
		music_pos = $AudioStreamPlayer2D.get_playback_position()
		$AudioStreamPlayer2D.stop()


func _on_Spread_value_changed(value):
	spread = deg2rad(value)


func _on_Target_target_moved(v):
	self.target_pos = v


func _on_Adherence_value_changed(value):
	flow_adherence = value



func _on_SpawnRate_value_changed(value):
	spawn_rate = value


func _on_OctaveSlider_value_changed(value):
	noise_octaves = value
	update_temp_noise()


func _on_PeriodSlider_value_changed(value):
	noise_period = value
	update_temp_noise()


func _on_PersistenceSlider_value_changed(value):
	noise_persistence = value
	update_temp_noise()



func _on_MusicControl_file_selected(path):
	music_pos = 0.0
	music_mode_enabled = true
	$AudioStreamPlayer2D.stream = load(path)
	$AudioStreamPlayer2D.play()


func _on_SaveButton_pressed():
	$CanvasLayer/Panel/SaveDialog.popup()


func _on_SaveDialog_file_selected(path):
	var t = viewport.get_texture().get_data()
	for a in get_tree().get_nodes_in_group("attractors"):
		var ht = a.get_hole_texture().get_data()
		ht.resize(ht.get_width() * a.scale.x, ht.get_height() * a.scale.y)
		var r = Rect2(Vector2(), ht.get_size())
		t.blend_rect_mask(ht, ht, r, a.position - ht.get_size() / 2)
	t.save_png(path)



func _on_ParticleRadius_value_changed(value):
	particle_scale = value
	for e in get_tree().get_nodes_in_group("emitters"):
		e.particle_scale = particle_scale



func _on_DetailScaleSlider_value_changed(value):
	noise_detail_scale = value
	update_temp_noise()


func _on_DetailStrengthSlider_value_changed(value):
	noise_detail_ratio = value
	update_temp_noise()


func _on_FieldRotation_value_changed(value):
	field_rotation = value


func _on_LacunaritySlider_value_changed(value):
	noise_lacunarity = value
	update_temp_noise()


func _on_LoadImage_pressed():
	$CanvasLayer/Panel/Panel/LoadImage/LoadImageFileDialog.popup()


func _on_LoadImageFileDialog_file_selected(path):
	var ni = Image.new()
	ni.load(path)
	ni.resize(world_size.x, world_size.y)
	custom_texture = ni
	custom_texture.lock()
	use_custom_texture = true
	update_noise_texture()


func _on_SeedEdit_text_entered(new_text):
	noise_seed = seed_from_string(new_text)
	update_temp_noise()
	use_custom_texture = false
	update_noise_texture()


func _on_ZSlider_value_changed(value):
	noise_z_level = value
	update_noise_texture()


func _on_MusicImpactSlider_value_changed(value):
	music_impact = value


func _on_MusicColorSlider_value_changed(value):
	color_change_speed = value


func _on_MusicColorImpactSlider_value_changed(value):
	music_color_impact = value


func _on_Angularity_value_changed(value):
	angularity = deg2rad(value)



func _on_NewEmitterButton_pressed():
	var e = emitter_scene.instance()
	e.position = world_size / 2
	self.add_child(e)
	emit_signal("emitter_added", e)



func _on_MicControl_toggled(button_pressed):
	microphone_active = button_pressed


func _on_NewAttractorButton_pressed():
	# Changed functionality to only support one attractor for now
	var a = attractor_scene.instance()
	a.position = world_size / 2
	self.add_child(a)
	emit_signal("attractor_added", a)
