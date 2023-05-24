extends Area2D

func _ready():
	hide()

func _on_body_entered(body):
	if body.is_in_group("player"):
		Globals.next_level()
		
func spawn(x : float, y : float, w : float, h : float):
	position = Vector2(x, y)	
	show()
