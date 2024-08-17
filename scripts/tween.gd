extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var tween = create_tween().set_loops(INF)
	tween.tween_property($CharacterBody2D/Body, "scale", Vector2(1.05,1.05), 0.5)
	tween.tween_property($CharacterBody2D/Body, "scale", Vector2(1,1), 0.5)
	
func _process(delta):
	pass
