extends Panel
signal file_selected
var world = null
var freq_ranges = {
	"sub_bass": [20, 60],
	"bass": [60, 250],
	"low_mid": [250, 500],
	"mid": [500, 2000],
	"upper_mid": [2000, 4000],
	"presence": [4000, 6000],
	"brilliance": [6000, 20000]
}


# Called when the node enters the scene tree for the first time.
func _ready():
	$BarUpdate.wait_time = 1.0 / 30.0
	world = get_parent().get_parent().get_parent()
	$BassList.add_item("rotation")
	$BassList.add_item("particle size")
	$BassList.add_item("opacity")
	$BassList.add_item("brightness")
	$BassList.add_item("random color")
	$BassList.add_item("initial boost")
	$BassList.select(0, false)
	$BassList.select(1, false)
	$DiskantList.add_item("rotation")
	$DiskantList.add_item("particle size")
	$DiskantList.add_item("opacity")
	$DiskantList.add_item("brightness")
	$DiskantList.add_item("random color")
	$DiskantList.add_item("initial boost")
	$DiskantList.select(0, false)
	$DiskantList.select(3, false)
	$DiskantList.select(5, false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass # Replace with function body.


func update_bars(delta):
	var bass = 0.0
	var diskant = 0.0
	var total = 0.0
	if world.music_mode_enabled or world.microphone_active:
		bass = world.bass_level
		diskant = world.diskant_level
		total = world.music_intensity
	$BassBar/Tween.interpolate_property($BassBar, "value", $BassBar.value, bass, delta, Tween.TRANS_BOUNCE)
	$BassBar/Tween.start()
	$DiskantBar/Tween.interpolate_property($DiskantBar, "value", $DiskantBar.value, diskant, delta, Tween.TRANS_BOUNCE)
	$DiskantBar/Tween.start()
	$TotalBar/Tween.interpolate_property($TotalBar, "value", $TotalBar.value, total, delta, Tween.TRANS_BOUNCE)
	$TotalBar/Tween.start()
	#$DiskantBar/Tween.interpolate_property($DiskantBar, "value", $DiskantBar.value, diskant, delta)
	#$TotalBar/Tween.interpolate_property($BassBar, "value", $BassBar.value, total, delta)
	var i = 0
	var spectrum = AudioServer.get_bus_effect_instance(AudioServer.get_bus_index("Record"), 1)
	if not spectrum:
		return
	for r in freq_ranges:
		var bar = $Visualizer.get_child(i)
		var low = freq_ranges[r][0]
		var high = freq_ranges[r][1]
		var val = spectrum.get_magnitude_for_frequency_range(low, high) * world.microphone_sensitivity
		bar.get_node("Tween").interpolate_property(
			bar, "value", bar.value, min(1.0, (val.x + val.y)), delta * 3, Tween.EASE_OUT
		)
		bar.get_node("Tween").start()
		i += 1

func _on_FileDialog_file_selected(path):
	emit_signal("file_selected", path)
	$Label.text = path.split("/")[-1].replace(".ogg", "")
	$CheckBox.pressed = true


func _on_Button2_pressed():
	$FileDialog.popup()


func _on_CheckBox_toggled(button_pressed):
	if button_pressed:
		self.modulate.a = 1.0
	else:
		self.modulate.a = 0.66


func _on_BarUpdate_timeout():
	var dt = $BarUpdate.wait_time
	update_bars(dt)
