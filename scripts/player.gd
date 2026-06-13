extends Node2D

#health
var health = 100
var max_health = 100
signal out_of_health
#battery storage
var batteries_remaining = 1
var max_batteries = 3
signal out_of_batteries
signal refill_granted

var damage_tween: Tween

var game_manager

func _ready():
	game_manager = get_tree().get_root().get_child(0)
	
func take_damage(dmg: int):
	health-=dmg
	
	#visual for taking damage
	$PlayerBody/AnimatedSprite2D.modulate = Color(1, 1, 1, 1)
	
	#set parallel to do both a color and an alpha fade out
	damage_tween = create_tween()
	damage_tween.set_parallel(true)
	
	#set properties
	damage_tween.tween_property($PlayerBody/AnimatedSprite2D, "modulate:a", 0.25, 0.12)
	damage_tween.tween_property($PlayerBody/AnimatedSprite2D, "modulate", Color(1, 0, 0, 0.25), 0.12)
	
	damage_tween.chain()
	damage_tween.tween_property($PlayerBody/AnimatedSprite2D, "modulate:a", 1.0, 0.18)
	damage_tween.tween_property($PlayerBody/AnimatedSprite2D, "modulate", Color(1, 1, 1, 1), 0.18)
	
	if health < 0:
		#game over
		out_of_health.emit()
		
	game_manager.update_player(health, batteries_remaining)

func heal(amt: int):
	health = maxi(health+amt, max_health)
	game_manager.update_player(health, batteries_remaining)
	
func pickup_battery():
	batteries_remaining+=1
	game_manager.update_player(health, batteries_remaining)

func refill_battery():
	if batteries_remaining == 0:
		out_of_batteries.emit()
	else:
		batteries_remaining-=1
		refill_granted.emit()
	game_manager.update_player(health, batteries_remaining)
