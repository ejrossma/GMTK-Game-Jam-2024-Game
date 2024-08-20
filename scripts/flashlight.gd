extends Node2D

#signals
signal need_battery_refill
signal update_ui(amt: float)

#size of light
var intensity = 50
var max_intensity = 250
var min_intensity = 50
#how fast will the intensity of the light change
var intensity_increment = 5

#battery health
var battery_health = 100
var max_battery_health = 100
#how fast do batteries drain (bigger number drains faster)
var battery_usage_coefficient = 0.0001

#how far can the light go (updates the target_position y value)
var light_distance := -100
#how much damage does the light deal
var light_damage = 10

#used for smooth change in light shape
var tween

var game_manager

func _ready():
	game_manager = get_tree().get_root().get_child(0)

func _process(delta):
	update_battery()
	
func _unhandled_input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and intensity < max_intensity:
			increase_intensity(intensity_increment)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and intensity > min_intensity:
			decrease_intensity(intensity_increment)

func set_is_light_on(light_status: bool):
	appear()
	
func increase_intensity(increment: int):
	intensity+=increment
	appear()
	
func decrease_intensity(increment: int):
	intensity-=increment
	appear()
	
func update_battery():
	battery_health-=(intensity*battery_usage_coefficient)
	if battery_health < 0:
		need_battery_refill.emit()
	game_manager.update_battery(battery_health)

func refill_battery():
	battery_health = max_battery_health
	game_manager.update_battery(battery_health)

#turn on flashlight or update intensity
func appear():
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property($PointLight2D.texture, "width", intensity, 0.2)
