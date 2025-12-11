extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func actualizar_vida(porcentaje):
	print("Actualizar animación según vida: ", porcentaje)
	if porcentaje > 75:
		$AnimatedSprite2D.animation = "vida_full"
	elif porcentaje > 50:
		$AnimatedSprite2D.animation = "vida_75"
	elif porcentaje > 25:
		$AnimatedSprite2D.animation = "vida_50"
	elif porcentaje > 0:
		$AnimatedSprite2D.animation = "vida_25"
	else:
		$AnimatedSprite2D.animation = "vida_10"

	$AnimatedSprite2D.play()
