extends Area2D

@export var bala_scene: PackedScene = preload("res://bala.tscn")
@export var rayo_scene: PackedScene = preload("res://rayo.tscn")
@export var speed: int = 100
var mov = Vector2()
var limite
var num: int = 0
var esc: int = 0
var p = 0
var arm = 0
var rayo_instance: Node2D = null
var disparando_rayo := false

@onready var spawn_point: Marker2D = $Muzzle
@onready var spawn_poi: Marker2D = $Muzzle_izq

func _process(delta: float) -> void:
	mov = Vector2.ZERO
	
	if Input.is_action_pressed("ui_right"):
		if esc == 0:
			mov.x += 1
			speed = 1000
			$sprite.animation = "arriba"
			$sprite.play()
		else:
			mov.x += 1
			speed = 1000
			$sprite.animation = "arri_escu"
		
	if not (Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right")):
		if esc == 0:
			mov.y += 1
			speed = 200
			$sprite.animation = "detenido"
			$sprite.play()
		else: 
			mov.y += 1
			speed = 200
			$sprite.animation = "dete_escudo"
	if Input.is_action_pressed("ui_left"):
		if esc == 0:
			mov.x -= 1
			speed = 1000
			$sprite.animation = "arriba"
			$sprite.play()
		else:
			mov.x -= 1
			speed = 1000
			$sprite.animation = "arri_escu"
		
	if Input.is_action_pressed("ui_down"):
		mov.y += 1
		speed = 1000

	if Input.is_action_pressed("ui_up"):
		if esc == 0:
			mov.y -= 1
			speed = 1000
			$sprite.animation = "arriba"
			$sprite.play()
		else:
			mov.y -= 1
			speed = 1000
			$sprite.animation = "arri_escu"
			
	if arm == 1 and disparando_rayo and rayo_instance != null:
		rayo_instance.global_position = $Muzzlerarayo.global_position
		rayo_instance.rotation = $Muzzlerarayo.global_rotation

			

	if mov.length() > 0:
		mov = mov.normalized() * speed
	position += mov * delta
	position.x = clamp(position.x, 0, limite.x)
	position.y = clamp(position.y, 0, limite.y)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		
		# PRESIONAR clic
		if event.pressed:
			if arm == 0 and num == 0:
				# Disparo de balas normales
				disparar()
			elif arm == 1 and num == 0:
				# Comenzar rayo
				disparando_rayo = true
				disparar()  # crea el rayo una vez

		# SOLTAR clic
		else:
			if arm == 1:
				disparando_rayo = false
				eliminar_rayo()

		
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			if num == 0:
				esc = 1
				$sprite.animation= "escudo"
				$sprite.play()
				num = 1
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			if num == 1:
				num = 0
				$sprite.animation = "no_escudo"
				$sprite.play()
				esc = 0

func disparar() -> void:
	if arm == 0:
		# Balas normales
		for muzzle in [$Muzzle_izq, $Muzzle]:
			var bala_instance = bala_scene.instantiate()
			bala_instance.global_position = muzzle.global_position
			bala_instance.rotation = muzzle.global_rotation
			get_parent().add_child(bala_instance)

	elif arm == 1:
		# Rayo (solo se crea cuando comienza a disparar)
		if rayo_instance == null:
			rayo_instance = rayo_scene.instantiate()
			rayo_instance.global_position = $Muzzlerarayo.global_position
			rayo_instance.rotation = $Muzzlerarayo.global_rotation
			get_parent().add_child(rayo_instance)


func _ready() -> void:
	limite = get_viewport_rect().size

func eliminar_rayo():
	if rayo_instance != null:
		rayo_instance.queue_free()
		rayo_instance = null

func _on_body_entered(body):
	if body.is_in_group("powerups"):
		var direction = (body.global_position - global_position).normalized()
		var impulse = direction * 300  
		body.apply_impulse(impulse)
		
	if body.is_in_group("tarjeta"):
		arm = 1
		body.queue_free()
		poder_rayo()
		
func poder_rayo():
	await get_tree().create_timer(5.0).timeout
	eliminar_rayo()
	arm = 0
