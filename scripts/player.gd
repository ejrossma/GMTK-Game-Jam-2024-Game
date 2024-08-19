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

signal update_battery(amt: float)
signal update_player(hth: int, rmn: int)
	
func take_damage(dmg: int):
	health-=dmg
	if health < 0:
		#game over
		out_of_health.emit()
	emit_signal("update_player", health, batteries_remaining)

func heal(amt: int):
	health = maxi(health+amt, max_health)

func refill_battery():
	if batteries_remaining == 0:
		out_of_batteries.emit()
	else:
		batteries_remaining-=1
		refill_granted.emit()
		emit_signal("update_player", health, batteries_remaining)

func _on_flashlight_update_ui(amt):
	emit_signal("update_battery", amt)
