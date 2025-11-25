extends Area2D

var velocidad = 800

func _process(delta):
	position.y -= velocidad * delta  # Mueve la bala hacia arriba

func _on_Bala_body_entered(body):
	queue_free()  # Destruye la bala al chocar con algo
