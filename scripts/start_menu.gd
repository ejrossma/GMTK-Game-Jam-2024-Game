extends CanvasLayer

signal game_start
var look_for_player_input = true

func button_pressed():
	game_start.emit()
	get_tree().paused = false
	hide()
	
