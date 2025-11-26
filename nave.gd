extends Area2D

@export var bala_scene: PackedScene = preload("res://bala.tscn")
@export var speed: int = 100
var mov = Vector2()
var limite
var num: int = 0
var esc: int = 0
var p = 0
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
			


			

	if mov.length() > 0:
		mov = mov.normalized() * speed
	position += mov * delta
	position.x = clamp(position.x, 0, limite.x)
	position.y = clamp(position.y, 0, limite.y)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("disparar"):
		if esc == 0:
			disparar()
		
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
	for muzzle in [$Muzzle_izq, $Muzzle]:
		var bala_instance = bala_scene.instantiate()
		bala_instance.global_position = muzzle.global_position
		bala_instance.rotation = muzzle.global_rotation
		get_parent().add_child(bala_instance)

func _ready() -> void:
	limite = get_viewport_rect().size
	

	
	
		
