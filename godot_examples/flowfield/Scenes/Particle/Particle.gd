extends Node2D

var direction = Vector2()
var velocity = Vector2()
var target_position = Vector2()
var t = Timer.new()
var SPEED = 300.0
var LIFETIME = 15.0
var world = null
var speed_delta = 1.0 / 144
var delete_margin = 0
var initial_position = Vector2()
var initial_angle = Vector2()
var initial_color = Color()
var spiral_spawn = false
var spiral_radius = 30.0
var spiral_strength = 10.0
var initial_boost_duration = 0.0
var base_scale = Vector2(1.0, 1.0)
var current_custom_value = 0.0


func _ready():
	world = get_parent().get_parent().get_parent()
	initial_position = self.position
	t.connect("timeout", self, "queue_free")
	t.wait_time = LIFETIME
	add_child(t)
	if not spiral_spawn:
		t.start()
	speed_delta = 1.0 / 144
	initial_color = $Sprite.modulate


func check_bounds():
	var p = self.position
	var dm = delete_margin
	var ws = world.world_size
	if p.x < -dm or p.x > ws.x + dm or p.y < -dm or p.y > ws.y + dm:
		queue_free()


func set_color(c):
	$Sprite.modulate = c
	$Trail.modulate = c


func _process(delta):
	if world.use_custom_texture:
		self.check_bounds()
	delta = min(speed_delta, delta)
	var current_position = self.position
	if spiral_spawn:
		var spiral_direction = Vector2()
		var prog = (self.position - initial_position).length()
		if prog >= spiral_radius:
			spiral_spawn = false
			t.start()
		else:
			prog = prog / spiral_radius
			spiral_direction = initial_angle.rotated(PI * spiral_strength * prog)
			self.velocity = -spiral_direction * SPEED * (0.5 + 4.5 * prog)
	else:
		var flow_direction = world.get_vector_from_noise(current_position)
		var adherence = world.flow_adherence - (world.flow_adherence * world.music_intensity / 3) * world.music_impact
		self.velocity += flow_direction * SPEED * delta * adherence

	for a in get_tree().get_nodes_in_group("attractors"):
		if not a.attracting:
			continue
		var dist_v = a.position - self.position
		if dist_v.length() > a.force_radius:
			continue
		elif dist_v.length() < a.hole_radius:
			queue_free()
		var strength = pow(dist_v.length() / a.force_radius, -1)
		self.velocity += dist_v.normalized() * a.force * strength * delta
	if not spiral_spawn:
		if initial_boost_duration <= 0.0:
			self.velocity = self.velocity.clamped(SPEED)
		else:
			self.velocity = self.velocity.clamped(SPEED + SPEED * initial_boost_duration * 2)
			initial_boost_duration -= delta
	
	var v = self.velocity
	if world.angularity > 0.0:
		var count = floor(self.velocity.angle() / world.angularity)
		var new_v = Vector2(1, 0).rotated(count * world.angularity)
		new_v *= self.velocity.length()
		v = new_v
	
	if t.time_left < 5.0:
		var new_c = initial_color
		new_c.a *= t.time_left / 5.0
		set_color(new_c)

	$Trail.position = -v.normalized() * 2
	self.position += (v * delta)

