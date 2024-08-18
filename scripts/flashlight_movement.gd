extends Sprite2D

@onready var flashlight = $Flashlight

var perimeter_radius = 12.5
var look_radius = 25.0
var tween
var time:= 0.0

func _process(delta: float):
	time+=delta

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	move_flashlight()
	
func move_flashlight():
	
	#use mouse position to determine where flashlight should be
	var player_to_mouse = (get_global_mouse_position() - self.global_position).normalized()
	var new_position = Vector2(player_to_mouse.x * perimeter_radius, player_to_mouse.y * perimeter_radius)
	flashlight.position = new_position
	
	#doesn't work when mouse goes within radius
	flashlight.look_at(get_global_mouse_position())
	
	#rotate flashlight to pointed opposite direction of player (can use a vector from player to flashlight)
	#if tween:
	#	tween.kill()
	#tween.create_tween()
	#tween.tween_property(flashlight, "rotation", get_local_mouse_position().angle(), 0.05)
	#flashlight.rotation += 90.0
