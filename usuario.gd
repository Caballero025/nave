extends Node2D

@onready var http = $HTTPRequest
@onready var line_edit = $LineEdit

# Configuración según entorno
var config = {
	"development": {
		"api_url": "http://localhost:8081/api",
		"game_url": "http://localhost:8080"
	},
	"production": {
		"api_url": "https://caballero026.me/api",
		"game_url": "https://caballero026.me"
	}
}

func _ready():
	if not http.request_completed.is_connected(_on_http_request_request_completed):
		http.request_completed.connect(_on_http_request_request_completed)
	
	# Detectar entorno automáticamente
	var current_env = "development" if OS.has_feature("debug") else "production"
	print("Entorno:", current_env)

func _on_button_pressed():
	enviar_usuario()

func enviar_usuario():
	var usuario = line_edit.text.strip_edges()
	if usuario == "":
		return
	
	# Usar URL según entorno (cambia según necesidad)
	var api_url = config["development"]["api_url"]  # Cambia a "production" cuando despliegues
	
	var url = api_url + "/guardar_usuario"
	
	var datos = {"nombre": usuario}
	var json_body = JSON.stringify(datos)
	var headers = ["Content-Type: application/json"]

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
		# Mostrar mensaje de error al usuario
