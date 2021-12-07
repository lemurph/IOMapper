extends Area2D

func _on_wall_area_entered(area):
	if area.name == "Ball":
		#oops, ball went out of game place, reset
		var lScore = get_node("../Score1")
		var score = int(lScore.text)
		lScore.text = str(score + 1)
		area.reset()
