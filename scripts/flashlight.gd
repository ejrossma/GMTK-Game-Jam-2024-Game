extends Node2D

#signals
signal need_battery_refill
signal update_ui(amt: float)

#size of light
var intensity := 75
var max_intensity = 150
var min_intensity = 75

#how fast will the intensity of the light change
var intensity_increment = 2.5

#player mouse input
var left_mouse_held := false
var right_mouse_held := false

#battery health
var battery_health = 100
var max_battery_health = 100

#how fast do batteries drain (bigger number drains faster)
var battery_usage_coefficient = 0.0002

#how far can the light go (updates the target_position y value)
var light_distance := -100

#how much damage does the light deal
var light_damage = 25

#enemies to deal damage to
var enemies_in_light : Array[Node2D] = []

#used for smooth change in light shape
var tween

# Adjust this until the base of the cone sits on the flashlight.
var base_light_offset := Vector2(128, 0)

var game_manager

func _ready():
	game_manager = get_tree().get_root().get_child(0)
	appear()

func _process(delta: float):
	update_battery()
	
	#update intensity
	if left_mouse_held and intensity < max_intensity:
		increase_intensity(intensity_increment)
	elif right_mouse_held and intensity > min_intensity:
		decrease_intensity(intensity_increment)
		
	damage_enemies(delta)
	
func _unhandled_input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			left_mouse_held = event.pressed
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			right_mouse_held = event.pressed
	
func increase_intensity(increment: int):
	intensity+=increment
	intensity = min(intensity, max_intensity)
	appear()
	
func decrease_intensity(increment: int):
	intensity-=increment
	intensity = max(intensity, min_intensity)
	appear()
	
func damage_enemies(delta: float) -> void:
	for enemy in enemies_in_light:
		if is_instance_valid(enemy):
			enemy.take_damage(light_damage * delta)
	
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
	var light_scale := intensity / 100.0
	var texture_size = $PointLight2D.texture.get_size()
	
	var target_offset := Vector2(texture_size.x * 0.5 * light_scale, 0)
	
	if tween:
		tween.kill()
		
	tween = create_tween()
	tween.set_parallel(true)
	
	tween.tween_property($PointLight2D, "texture_scale", light_scale, 0.2)
	tween.tween_property($PointLight2D, "offset", target_offset, 0.2)
	
	$PointLight2D/Area2D.scale = Vector2(light_scale, light_scale)
	
	#if tween:
	#	tween.kill()
	#tween = create_tween()
	#tween.tween_property($PointLight2D, "texture_scale", intensity/100, 0.2)


func _on_area_entered(body: Node2D) -> void:
	var enemy = body.get_parent()
	
	if enemy.is_in_group("player"):
		return
	
	if enemy.has_method("take_damage"):
		enemies_in_light.append(enemy)
	
func _on_area_exited(body: Node2D) -> void:
	var enemy = body.get_parent()
	
	if enemy.is_in_group("player"):
		return
	
	if enemy.has_method("take_damage"):
		enemies_in_light.erase(enemy)
