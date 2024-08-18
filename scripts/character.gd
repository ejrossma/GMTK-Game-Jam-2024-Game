extends Node2D

#health
var health = 100
var max_health = 100
signal out_of_health
#speed
var speed = 5
var max_speed = 10
var acceleration = 1
#experience
var experience = 0
var experience_to_get_upgrade = 100
signal ready_for_upgrade
#battery storage
var batteries_remaining = 1
var max_batteries = 3
signal out_of_batteries
signal refill_granted

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _process(delta):
	pass
	
func take_damage(dmg: int):
	health-=dmg
	if health < 0:
		#game over
		out_of_health.emit()

func gain_experience(exp: int):
	experience+=exp
	if experience >= experience_to_get_upgrade:
		#upgrade time
		ready_for_upgrade.emit()

func refill_battery():
	if batteries_remaining == 0:
		out_of_batteries.emit()
	else:
		batteries_remaining-=1
		refill_granted.emit()
