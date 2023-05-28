extends StaticBody2D

@onready var sprite : Sprite2D = $Sprite2D

func _ready():
	hide()

func spawn(x : float, y : float, w : float, h : float):
	position = Vector2(x, y)
	if sprite:
		sprite.region_rect = Rect2(0, 0, w, h)
		
	show()
