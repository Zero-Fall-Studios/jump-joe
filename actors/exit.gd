extends Area2D

@onready var timer : Timer = $Timer

var size
var screen_size
var width
var height

func _ready():
	hide()
	timer.stop()
	size = $Sprite2D.get_rect().size
	width = size.x / 2
	height = size.y / 2
	screen_size = get_viewport_rect().size

func _on_body_entered(body):
	if body.is_in_group("player"):
		Globals.next_level()
		
func spawn(x : float, y : float, w : float, h : float):
	position = Vector2(x, y)	
	timer.stop()
	show()

func _on_timer_timeout():
	var x = randi_range(width, screen_size.x - width)
	var y = randi_range(height, screen_size.y - height)
	position = Vector2(x, y)
	
func random():
	timer.start()
