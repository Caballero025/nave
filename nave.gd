extends Area2D

@export var speed: int = 100
var mov = Vector2()
var limite

func _ready() -> void:
		limite = get_viewport_rect().size
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	mov = Vector2()	
	
	if Input.is_action_pressed("ui_right"):
		mov.x += 1
		speed = 800	
		$sprite.animation = "arriba"
		$sprite.play() 
	if not (Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right")):
		mov.y += 0.1
		speed = 200
		$sprite.animation = "detenido"
	if Input.is_action_pressed("ui_left"):
		speed = 800
		$sprite.animation = "arriba"
		$sprite.play() 
		mov.x -= 1
	if Input.is_action_pressed("ui_down"):
		speed = 800
		$sprite.animation = "arriba"
		$sprite.play() 
		mov.y += 1
		$sprite.animation = "detenido"
	if Input.is_action_pressed("ui_up"):
		speed = 800
		$sprite.animation = "arriba"
		$sprite.play() 
		mov.y -= 1
	if mov.length() > 0:
		mov = mov.normalized() * speed
	position += mov * delta
	position.x = clamp(position.x,0,limite.x)
	position.y = clamp(position.y,0,limite.y)
	
	
		
