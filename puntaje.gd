extends Node2D

var score = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_meteoro_destruido():
	score += 1
	$ScoreLabel.text = str(score).pad_zeros(2)  # Siempre tendrá 2 dígitos
