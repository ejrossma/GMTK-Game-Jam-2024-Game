extends CharacterBody2D

#speed
var speed = 32

func _physics_process(delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed
	
	#if moving play walk animation
	if velocity == Vector2.ZERO:
		$AnimatedSprite2D.play("idle")
	else:
		$AnimatedSprite2D.play("walk")
	
	#flip sprite depending on direction
	if velocity.x > 0.0:
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true
	
	move_and_slide()

