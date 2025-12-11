extends RigidBody2D

func _ready():
	gravity_scale = 0
	$AnimatedSprite2D.play()
	
func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()
