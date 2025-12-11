extends Area2D

var velocidad = 3500
var tarjeta_scene = preload("res://tarjeta.tscn")
var explosion = preload("res://explosion.tscn")


func _process(delta):
	position.y -= velocidad * delta  

func _on_Bala_body_entered(body):
	queue_free() 


func _on_body_entered(body):
	var pos = body.global_position
	if body.is_in_group("meteor"):
		body.queue_free()
		var explo = explosion.instantiate()
		explo.global_position = pos
		get_tree().current_scene.add_child(explo) 
		queue_free()
	
	elif body.is_in_group("powerups"):
		print("Chocó powerup")
		# lógica de powerup
	
		if body.has_meta("taken"):
			return
		
		body.set_meta("taken", true)
	

		# Desactiva colisión mientras se procesa
		$CollisionShape2D.set_deferred("disabled", true)


			
			

		# Crear tarjeta según posición del powerup
		call_deferred("_crear_tarjeta", pos)

		# Eliminar este objeto powerup
		body.call_deferred("queue_free")
	 
func _crear_tarjeta(pos):
	var tarjeta = tarjeta_scene.instantiate()
	tarjeta.global_position = pos
	get_tree().current_scene.add_child(tarjeta)
