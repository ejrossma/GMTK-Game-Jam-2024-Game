extends AnimatedSprite2D

@onready var flashlight = $Flashlight

var perimeter_radius = 15
var look_radius = 25.0
var tween
var time:= 0.0

func _process(delta: float):
	time+=delta

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	move_flashlight()
	
func move_flashlight():
	
	#use mouse position to determine where flashlight should be
	var player_to_mouse = (get_global_mouse_position() - self.global_position).normalized()
	var new_position = Vector2(player_to_mouse.x * perimeter_radius, player_to_mouse.y * perimeter_radius)
	flashlight.position = new_position
	flashlight.rotation = player_to_mouse.angle()
