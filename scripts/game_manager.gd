extends Node2D

const ENEMY_SCENE = preload("res://scenes/enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	#start paused so player can read controls
	get_tree().paused = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawn_enemy():
	#spawn 2 enemies 25% of the time
	var spawn_odds = randf_range(0, 1.0)
	var num_to_spawn = 1
	if (spawn_odds < 0.25):
		num_to_spawn = 2
	
	for i in num_to_spawn:
		var enemy = ENEMY_SCENE.instantiate()
		#enemy must spawn 50 to 100 units away from player
		enemy.position = generate_enemy_position()
		add_child(enemy)
	
func generate_enemy_position():
	var player = $Player
	var min_distance = 60
	var max_distance = 110
	var dir = randi_range(0,3)
	#0 is left (-50 to -100, -50 to 50)
	if dir == 0:
		return Vector2(randf_range(-min_distance, -max_distance)+player.global_position.x, randf_range(-50.0, 50)+player.global_position.y)
	#1 is up (-50 to 50, 50 to 100)
	if dir == 1:
		return Vector2(randf_range(-50.0, 50.0)+player.global_position.x, randf_range(min_distance, max_distance)+player.global_position.y)
	#2 is down (-50 to 50, -50 to -100)
	if dir == 2:
		return Vector2(randf_range(-50.0, 50.0)+player.global_position.x, randf_range(-min_distance, -max_distance)+player.global_position.y)
	#3 is right (50 to 100, -50 to 50)
	if dir == 3:
		return Vector2(randf_range(min_distance, max_distance)+player.global_position.x, randf_range(-50.0, 50)+player.global_position.y)

func game_start():
	$Camera2D/Ui.show()
	
func game_restart():
	get_tree().reload_current_scene()

func game_over():
	get_tree().paused = true
	$Camera2D/GameOver.show()

