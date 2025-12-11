extends Area2D

var explosion = preload("res://explosion.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.animation = "rayo"
	$AnimatedSprite2D.play()


func _on_body_entered(body):
	if body.is_in_group("powerups"):
		body.queue_free()
	if body.is_in_group("meteor"):
		var pos = body.global_position
		body.queue_free()
		var explo = explosion.instantiate()
		explo.global_position = pos
		get_tree().current_scene.add_child(explo) 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
