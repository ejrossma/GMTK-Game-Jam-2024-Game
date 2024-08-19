extends Area2D

func _on_body_entered(body):
	if body.name == "Player":
		get_tree().get_root().get_node("Player").heal(25)
		queue_free()
