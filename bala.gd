extends Area2D

var velocidad = 3500

func _process(delta):
	position.y -= velocidad * delta  # Mueve la bala hacia arriba

func _on_Bala_body_entered(body):
	queue_free()  # Destruye la bala al chocar con algo

func _on_body_entered(body):
	if body.is_in_group("powerups"):
		body.queue_free()
