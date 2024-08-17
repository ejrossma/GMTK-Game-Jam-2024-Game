extends RayCast2D

var intensity = 100
var is_casting = false
var tween

func _ready():
	set_physics_process(false)
	$Line2D.points[1] = Vector2.ZERO
	
func _unhandled_input(event: InputEvent):
	if event is InputEventMouseButton:
		self.is_casting = event.pressed
		set_is_casting(self.is_casting)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float):
	var cast_point := target_position
	force_raycast_update()
	
	if is_colliding():
		cast_point = to_local(get_collision_point())
		
	$Line2D.points[1] = cast_point

func set_is_casting(cast: bool):
	is_casting = cast
	
	if is_casting:
		appear()
	else:
		disappear()
	set_physics_process(is_casting)
	
func appear():
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property($Line2D, "width", intensity, 0.2)
	
func disappear():
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property($Line2D, "width", 0, 0.1)
