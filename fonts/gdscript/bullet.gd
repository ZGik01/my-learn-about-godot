extends Area2D

var direction=Vector2.RIGHT
var speed=500

func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _physics_process(delta: float) -> void:
	position+=direction*speed*delta
		
	var a=position.x>get_viewport_rect().size.x 
	var b=position.y>get_viewport_rect().size.y 
	if a or b or position.x<0 or position.y<0:
		queue_free()
	
func _on_body_entered(body):
	if body.has_method("mob_take_damage"):
		body.mob_take_damage()
		queue_free()
