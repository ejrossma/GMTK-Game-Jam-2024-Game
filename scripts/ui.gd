extends CanvasLayer

func update_battery(amt):
	$Battery.value = amt

func update_player(hth, rmn):
	$Remaining.text = str("Batteries: ", rmn)
	$Health.value = hth
