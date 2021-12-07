extends Area2D

func _on_wall_area_entered(area):
	if area.name == "Ball":
		#oops, ball went out of game place, reset
		var rScore = get_node("../Score2")
		var score = int(rScore.text)
		rScore.text = str(score + 1)
		area.reset()
