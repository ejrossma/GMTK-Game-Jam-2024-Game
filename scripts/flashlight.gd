extends RayCast2D

#signals
signal need_battery_refill

#size of light
var intensity = 10
var max_intensity = 100
var min_intensity = 10
#how fast will the intensity of the light change
var intensity_increment = 5

#battery health
var battery_health = 100
var max_battery_health = 100
#how fast do batteries drain (bigger number drains faster)
var battery_usage_coefficient = 0.0005

#how far can the light go (updates the target_position y value)
var light_distance := -100
#how much damage does the light deal
var light_damage = 10

#is light on or off
var is_light_on = false

#used for smooth change in light shape
var tween

func _ready():
	set_physics_process(false)
	$Line2D.points[1] = Vector2.ZERO
	
func _process(delta):
	if is_light_on:
		update_battery()
		print(battery_health)
	
func _unhandled_input(event: InputEvent):
	if event is InputEventMouseButton:
		#toggle flashlight
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			set_is_light_on(not self.is_light_on)
		
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and intensity < max_intensity and is_light_on:
			increase_intensity(intensity_increment)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and intensity > min_intensity and is_light_on:
			decrease_intensity(intensity_increment)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float):
	var cast_point := Vector2(0, light_distance)
	force_raycast_update()
	$Line2D.points[1] = cast_point

func set_is_light_on(light_status: bool):
	is_light_on = light_status
	#toggle light
	if is_light_on:
		appear()
	else:
		disappear()
	set_physics_process(is_light_on)
	
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
	
func refill_battery():
	battery_health = max_battery_health
	
#turn on flashlight or update intensity
func appear():
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property($Line2D, "width", intensity, 0.2)
	
#turn off flashlight
func disappear():
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property($Line2D, "width", 0, 0.1)
