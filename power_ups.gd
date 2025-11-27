extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gravity_scale = 0.3  
	$sprite.animation = "power"
	$sprite.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
