extends Node2D

@onready var http = $HTTPRequest
@onready var line_edit = $LineEdit
var API_BASE_URL = "https://caballero026.me/api"  # Para producción
# var API_BASE_URL = "http://localhost:8081/api"  # Para desarrollo
# Configuración SIMPLIFICADA - usa siempre ruta relativa
func _ready():
	if not http.request_completed.is_connected(_on_http_request_request_completed):
		http.request_completed.connect(_on_http_request_request_completed)
	
	print("✅ Juego listo - API en: /api")

func _on_button_pressed():
	enviar_usuario()

func enviar_usuario():
	var usuario = line_edit.text.strip_edges()
	if usuario == "":
		return
	
	# USAR RUTA RELATIVA - Esto funciona en cualquier entorno
	var url = API_BASE_URL + "/api/guardar_usuario"
	
	var datos = {"nombre": usuario}
	var json_body = JSON.stringify(datos)
	var headers = ["Content-Type: application/json", "Accept: application/json"]

	print("📡 URL:", url)
	print("📦 Datos:", datos)
	
	var error = http.request(url, headers, HTTPClient.METHOD_POST, json_body)
	if error != OK:
		print("❌ Error al enviar petición:", error)
	else:
		print("📨 Enviando usuario a la API...")

func _on_http_request_request_completed(result, response_code, headers, body):
	print("=== RESPUESTA API ===")
	print("Resultado:", result)
	print("Código HTTP:", response_code)
	print("Headers:", headers)
	print("Body:", body.get_string_from_utf8())
	print("====================")

	if response_code == 200:
		Global.usuario = line_edit.text.strip_edges()
		print("✅ Usuario guardado:", Global.usuario)
		get_tree().change_scene_to_file("res://mundo.tscn")
	else:
		print("❌ Error en la API. Código:", response_code)
