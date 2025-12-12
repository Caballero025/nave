extends Node2D

@onready var http = $HTTPRequest
@onready var line_edit = $LineEdit

func _ready():
	if not http.request_completed.is_connected(_on_http_request_request_completed):
		http.request_completed.connect(_on_http_request_request_completed)

func _on_button_pressed():
	enviar_usuario()

func enviar_usuario():
	var usuario = line_edit.text.strip_edges()
	if usuario == "":
		return
	
	var url = "http://127.0.0.1:8000/guardar_usuario"
	var datos = {"nombre": usuario}
	var json_body = JSON.stringify(datos)
	var headers = ["Content-Type: application/json"]

	var error = http.request(url, headers, HTTPClient.METHOD_POST, json_body)
	if error != OK:
		print("❌ Error al enviar petición:", error)
	else:
		print("📨 Enviando usuario a la API...")

func _on_http_request_request_completed(result, response_code, headers, body):
	print("Código HTTP:", response_code)
	print("Respuesta:", body.get_string_from_utf8())

	if response_code == 200:
		Global.usuario  = line_edit.text.strip_edges()
		get_tree().change_scene_to_file("res://mundo.tscn")
