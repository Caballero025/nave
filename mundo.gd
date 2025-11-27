extends Node2D


@onready var power_scene := preload("res://power_ups.tscn")
@onready var player_scene := preload("res://nave.tscn")

func _ready():
	spawn_player()

func spawn_player():
	var player = player_scene.instantiate()
	player.position = Vector2(240, 400)  # posición inicial
	add_child(player)


func _on_power_timer_timeout():
	var power = power_scene.instantiate()

	var spawn_point = $PowerPath/PowerSpawnPoint
	spawn_point.progress_ratio = randf()

	power.position = spawn_point.position

	# No rotarlo
	power.rotation = 0

	# Caída (solo hacia abajo)
	power.linear_velocity = Vector2(0, randf_range(150, 250))

	add_child(power)
