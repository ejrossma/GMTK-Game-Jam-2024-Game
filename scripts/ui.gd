extends CanvasLayer

func update_battery(amt):
	$Battery.value = amt

func _on_player_update_player(hth, rmn):
	$Remaining.text = "Batteries: " + rmn
	$Health.value = hth
