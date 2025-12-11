extends Node2D


@onready var power_scene := preload("res://power_ups.tscn")
@onready var player_scene := preload("res://nave.tscn")
@onready var meteor_scene := preload("res://meteoro.tscn")
@onready var GameOverScene = preload("res://game_over.tscn")
@onready var barra_vida = preload("res://barra_vida.tscn")

var player   # <--- AQUÍ guardamos el jugador
var last_positions: Array = []
var barra

func _ready():
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
	var game_over = GameOverScene.instantiate()
	get_tree().root.get_child(0).queue_free()  # elimina la escena actual
	get_tree().root.add_child(game_over)       # agrega Game Over  # Godot 4: funciona si GameOverScene es PackedScene
 # o cualquier otra acción
