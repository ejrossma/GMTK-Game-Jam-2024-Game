extends Node2D

const BATTERY_SCENE = preload("res://scenes/battery.tscn")
const HEAL_SCENE = preload("res://scenes/heal.tscn")

var health = 100

var game_manager

func _ready():
	game_manager = get_tree().get_root().get_child(0)

func take_damage(damage: int):
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
