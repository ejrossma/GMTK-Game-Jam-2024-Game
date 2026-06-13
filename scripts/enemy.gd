extends Node2D

const BATTERY_SCENE = preload("res://scenes/battery.tscn")
const HEAL_SCENE = preload("res://scenes/heal.tscn")

var health = 100
var base_damage = 5

var move_speed := 24
var player: Node2D

#attack player
var ready_to_attack = false
var player_in_range = false

var game_manager

func _ready():
	game_manager = get_tree().get_root().get_child(0)
	player = game_manager.get_child(0)
	fade_in()
	
func _physics_process(delta: float) -> void:
	move_towards_player(delta)
	
func move_towards_player(delta: float) -> void:
	if player == null:
		return
		
	var direction = player.get_child(0).global_position - global_position
	
	if direction.length() == 0:
		return
		
	global_position += direction.normalized() * move_speed * delta
	
	
func fade_in():
	$Sprite2D.modulate.a = 0.0
	
	var tween := create_tween()
	tween.tween_property($Sprite2D, "modulate:a", 1.0, 0.5)

func take_damage(damage: float):
	health-=damage
	if health <= 0:
		die()
		
func die():
	#random chance to spawn battery
	if randf_range(0.0, 1.0) < 0.10:
		spawn_battery()
	#if didn't spawn battery then chance to spawn heal
	elif randf_range(0.0, 1.0) < 0.15:
		spawn_heal()
	queue_free()
	
func spawn_battery():
	var battery = BATTERY_SCENE.instantiate()
	battery.position = global_position
	game_manager.add_child(battery)

func spawn_heal():
	var heal = HEAL_SCENE.instantiate()
	heal.position = global_position
	game_manager.add_child(heal)
	
func attack_player():
	game_manager.get_child(0).take_damage(base_damage)
	ready_to_attack = false
	$AttackCooldownTimer.start()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "PlayerBody":
		player_in_range = true
		
		if ready_to_attack:
			attack_player()
			
func _on_body_exited(body: Node2D) -> void:
	if body.name == "PlayerBody":
		player_in_range = false

func _on_attack_cooldown_timer_timeout() -> void:
	ready_to_attack = true
	
	if player_in_range:
		attack_player()
