extends Area2D

var velocidad = 3500
var tarjeta_scene = preload("res://tarjeta.tscn")

func _process(delta):
	position.y -= velocidad * delta  

func _on_Bala_body_entered(body):
	queue_free() 


func _on_body_entered(body):
	if not body.is_in_group("powerups"):
		return
	if body.has_meta("taken"):
		return
	body.set_meta("taken", true)
	var pos = body.global_position

	$CollisionShape2D.set_deferred("disabled", true)
	body.call_deferred("queue_free")

	call_deferred("_crear_tarjeta", pos)
	call_deferred("queue_free")

func _crear_tarjeta(pos):
	var tarjeta = tarjeta_scene.instantiate()
	tarjeta.global_position = pos
	get_tree().current_scene.add_child(tarjeta)
