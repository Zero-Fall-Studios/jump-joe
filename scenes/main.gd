extends Node2D
	
func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("quit"):
		get_tree().quit()
