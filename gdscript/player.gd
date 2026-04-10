extends Area2D
signal hit
signal damage
@export var speed=400
@export var health=100
var screen_size
var bullet_scene=preload("res://scene/bullet.tscn")

func _ready() :
	screen_size=get_viewport_rect().size

func _process(delta):
# move logic
	var velocity = Vector2.ZERO 
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
# animated play logic
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
	
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index==MOUSE_BUTTON_LEFT and event.pressed:
		shoot()

func shoot():
	var bullet=bullet_scene.instantiate()
	bullet.position=position
	var mouse_pos=get_global_mouse_position()
	var dir=(mouse_pos-global_position).normalized()
	bullet.direction=dir
	get_parent().add_child(bullet)
# hit
func _on_body_entered(_body) :
	if health>0:
		health-=10
		damage.emit(health)
	if health==0:
		hide()
		hit.emit()
		# Must be deferred as we can't change physics properties on a physics callback.
		$CollisionShape2D.set_deferred("disabled", true)

# new scene
func start(pos):
	position = pos
	$CollisionShape2D.disabled = false
