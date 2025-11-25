extends Area2D

@export var bala_scene: PackedScene = preload("res://bala.tscn")
@export var speed: int = 100
var mov = Vector2()
var limite

@onready var spawn_point: Marker2D = $Muzzle
@onready var spawn_poi: Marker2D = $Muzzle_izq

func _process(delta: float) -> void:
	mov = Vector2.ZERO
	
	if Input.is_action_pressed("ui_right"):
		mov.x += 1
		speed = 800
		$sprite.animation = "arriba"
		$sprite.play() 
	if not (Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right")):
		mov.y += 1
		speed = 200
		$sprite.animation = "detenido"
	if Input.is_action_pressed("ui_left"):
		mov.x -= 1
		speed = 800
		$sprite.animation = "arriba"
		$sprite.play() 
	if Input.is_action_pressed("ui_down"):
		mov.y += 1
		speed = 800

	if Input.is_action_pressed("ui_up"):
		mov.y -= 1
		speed = 800
		$sprite.animation = "arriba"
		$sprite.play() 

	if mov.length() > 0:
		mov = mov.normalized() * speed
	position += mov * delta
	position.x = clamp(position.x, 0, limite.x)
	position.y = clamp(position.y, 0, limite.y)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("disparar"):
		disparar()

func disparar() -> void:
	for muzzle in [$Muzzle_izq, $Muzzle]:
		var bala_instance = bala_scene.instantiate()
		bala_instance.global_position = muzzle.global_position
		bala_instance.rotation = muzzle.global_rotation
		get_parent().add_child(bala_instance)

func _ready() -> void:
	limite = get_viewport_rect().size

	
	
		
