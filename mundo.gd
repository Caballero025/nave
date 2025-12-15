extends Node2D


@onready var power_scene := preload("res://power_ups.tscn")
@onready var player_scene := preload("res://nave.tscn")
@onready var meteor_scene := preload("res://meteoro.tscn")
@onready var GameOverScene = preload("res://game_over.tscn")
@onready var barra_vida = preload("res://barra_vida.tscn")
@onready var score = preload("res://puntaje.tscn")
@onready var http = $HTTPRequest
@onready var http_ping = HTTPRequest.new()
@onready var http_users = HTTPRequest.new()
var usuario_actual = ""
var timer_ping = Timer.new()
var player 
var last_positions: Array = []
var barra
var scor
var is_requesting_users = false
var timer_users = Timer.new()
var ping_en_proceso = false
var API_BASE_URL = "https://caballero026.me/api"  # Para producción
# var API_BASE_URL = "http://localhost:8081/api"  # Para desarrollo
func _ready():
	add_child(http_ping)
	add_child(http_users)
	http_ping.request_completed.connect(_on_http_ping_request_completed)
	http_users.request_completed.connect(_on_http_users_request_completed) 
	timer_ping.wait_time = 2
	timer_ping.one_shot = false
	timer_ping.autostart = true
	timer_ping.connect("timeout", Callable(self, "_ping_usuario"))
	timer_users.wait_time = 1
	timer_users.one_shot = false
	timer_users.autostart = true
	timer_users.connect("timeout", Callable(self, "actualizar_usuarios_online"))
	add_child(timer_users)
	add_child(timer_ping)
	if Global.usuario != "":
		$usuario.text = "Bienvenido, " + Global.usuario
		registrar_usuario()
	scor = score.instantiate()
	scor.position = Vector2(1050, 30)
	add_child(scor)
	
	barra = barra_vida.instantiate()
	barra.position = Vector2(10, 80)
	add_child(barra)

	# Instanciar nave
	player = player_scene.instantiate()
	player.position = Vector2(240, 400)
	add_child(player)

	# PASAR LA INSTANCIA de la barra a la nave
	player.set_barra_vida(barra)
	player.connect("died", Callable(self, "_on_died"))

	

	
	
func registrar_usuario():
	usuario_actual = Global.usuario
	var url = API_BASE_URL + "/api/login_usuario"
	var datos = {"nombre": usuario_actual}
	var json_body = JSON.stringify(datos)
	http.request(url, ["Content-Type: application/json"], HTTPClient.METHOD_POST, json_body)
	print("Usuario registrado:", Global.usuario)

func _ping_usuario():
	if usuario_actual != "" and not ping_en_proceso:
		ping_en_proceso = true
		var url = API_BASE_URL + "/api/ping_usuario"
		var datos = {"nombre": usuario_actual}
		var json_body = JSON.stringify(datos)
		var error = http_ping.request(url, ["Content-Type: application/json"], HTTPClient.METHOD_POST, json_body)
		if error != OK:
			ping_en_proceso = false
			print("Error al enviar ping:", error)

func _on_http_ping_request_completed(result, response_code, headers, body):
	ping_en_proceso = false

func actualizar_usuarios_online():
	if is_requesting_users:
		return # todavía está procesando
	is_requesting_users = true
	http_users.request(API_BASE_URL + "/api/usuarios_online", [], HTTPClient.METHOD_GET)

func _on_http_users_request_completed(result, response_code, headers, body):
	is_requesting_users = false
	if response_code == 200:
		var usuarios = JSON.parse_string(body.get_string_from_utf8())
		if typeof(usuarios) == TYPE_ARRAY:
			var texto = "Usuarios en línea:\n"
			for u in usuarios:
				texto += u.get("nombre", "N/A") + " - " + str(u.get("score", 0)) + "\n"
			$Label.text = texto
		else:
			print("❌ Error: JSON no es un array")
	else:
		print("❌ Error HTTP:", response_code)


func cerrar_juego():
	if usuario_actual != "":
		var url = API_BASE_URL + "/api/logout_usuario"
		
		var datos = {"nombre": usuario_actual}
		var json_body = JSON.stringify(datos)
		http.request(url, ["Content-Type: application/json"], HTTPClient.METHOD_POST, json_body)
func obtener_usuarios():
	var url = "/api/usuarios"  # tu API
	var error = http.request(url, [], HTTPClient.METHOD_GET)
	if error != OK:
		print("❌ Error al pedir usuarios:", error)


	
func _on_power_timer_timeout():
	var power = power_scene.instantiate()
	var spawn_point = $PowerPath/PowerSpawnPoint
	
	spawn_point.progress_ratio = randf()
	power.position = spawn_point.position
	power.rotation = 0
	power.linear_velocity = Vector2(0, randf_range(150, 250))

	add_child(power)

func _on_meteor_timer_timeout():
	var meteor_count = 3
	var min_distance = 0.12  # separación mínima en el path (0 a 1)

	for i in range(meteor_count):
		var pos = randf()

		# Evitar posiciones muy cercanas a las ya usadas
		var tries = 0
		while tries < 10:
			var too_close := false
			for p in last_positions:
				if abs(pos - p) < min_distance:
					too_close = true
					break

			if too_close:
				pos = randf()
				tries += 1
			else:
				break

		# Guardamos la posición usada
		last_positions.append(pos)
		if last_positions.size() > meteor_count:
			last_positions.pop_front()

		# Instanciar meteoro
		var meteor = meteor_scene.instantiate()

		var meteor_location = $PowerPath/PowerSpawnPoint
		meteor_location.progress_ratio = pos

		meteor.position = meteor_location.position
		meteor.rotation = 0
		meteor.linear_velocity = Vector2(0, randf_range(800.0, 2000.0))

		add_child(meteor)

func _on_died() -> void:
	print("¡La nave murió!")
	# No eliminar nada directo en este callback de colisión
	call_deferred("_cambiar_a_gameover")
 # o cualquier otra acción

func _cambiar_a_gameover():
	get_tree().change_scene_to_file("res://game_over.tscn")
