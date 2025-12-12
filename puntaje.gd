extends Node2D

var score = 0
@onready var http_score = HTTPRequest.new()
var score_enviandose = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(http_score)
	http_score.connect("request_completed", Callable(self, "_on_http_score_request_completed"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_meteoro_destruido():
	score += 1
	$ScoreLabel.text = str(score).pad_zeros(2)
	if score_enviandose:
		return  # No enviar mientras haya otra petición en proceso
	score_enviandose = true

	var url = "http://24.199.73.160/actualizar_score"
	var datos = {"nombre": Global.usuario, "score": score}
	var json_body = JSON.stringify(datos)
	var error = http_score.request(url, ["Content-Type: application/json"], HTTPClient.METHOD_POST, json_body)
	if error != OK:
		score_enviandose = false
		print("Error al enviar score:", error)

func _on_http_score_request_completed(result, response_code, headers, body):
	score_enviandose = false
