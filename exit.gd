extends Area2D

func _ready():
	visible = false

func _on_body_entered(body):
	if body.is_in_group("player"):
		Globals.next_level()
		
func spawn(x : float, y : float):
	position = Vector2(x, y)	
	visible = true
