extends Area2D

var game_manager

func _ready():
	game_manager = get_tree().get_root().get_child(0)

func _on_body_entered(body):
	if body.name == "PlayerBody":
		game_manager.get_child(0).pickup_battery()
		queue_free()
