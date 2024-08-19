extends CanvasLayer

signal restart_game

func play_again():
	restart_game.emit()
