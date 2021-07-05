extends Control


var resolution = 48
var hz = 11500
var points = []

# Called when the node enters the scene tree for the first time.
func _ready():
	create_points()

func create_points():
	points = []
	for r in range(resolution):
		var hz_range = {
			"hz_start": r * (hz / resolution),
			"hz_end": (r + 1) * (hz / resolution),
			"x": ($Panel.rect_size.x / resolution) / 2 + r * ($Panel.rect_size.x / resolution),
			"value": 0.0
		}
		points.append(hz_range)

func _draw():
	var p_h = $Panel.rect_size.y
	var last_point = Vector2(0, p_h)
	for p in points:
		var next_point = Vector2(p["x"], p_h - p["value"] * p_h)
		draw_line(last_point, next_point, Color.white, 3.0, true)
		last_point = next_point

func _update():
	var spectrum = AudioServer.get_bus_effect_instance(0,0)
	for p in points:
		p["value"] = spectrum.get_magnitude_for_frequency_range(p["hz_start"], p["hz_end"]).length() * 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _process(delta):
	self._update()
	self.update()
	
