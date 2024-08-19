extends Area2D

func _on_body_entered(body):
	if body.name == "Player":
		get_tree().get_root().get_node("Player").batteries_remaining+=1
		queue_free()
