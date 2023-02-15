extends Node2D

@onready var level_label = $CanvasLayer/Label

func _ready():
	var callable = Callable(self, "_on_level_change")
	Globals.level_change.connect(callable)
	Globals.load()
	
func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("quit"):
		get_tree().quit()
	elif event.is_action_pressed("restart"):
		Globals.restart_level()
	elif event.is_action_pressed("next_level"):
		Globals.next_level()
		
func _on_level_change(level_number):
	level_label.text = "Level: " + str(level_number + 1)
