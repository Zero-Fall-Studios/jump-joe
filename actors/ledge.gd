extends StaticBody2D

@onready var collision_shape : CollisionShape2D = $CollisionShape2D
@onready var sprite : Sprite2D = $Sprite2D

func _ready():
	hide()
	collision_shape.shape = RectangleShape2D.new()
	collision_shape.one_way_collision = true

func spawn(x : float, y : float, w : float, h : float):
	position = Vector2(x, y)
	if sprite:
		sprite.region_rect = Rect2(0, 0, w, h)
		
	if collision_shape:
		collision_shape.position = Vector2(w / 2, h / 2)
		collision_shape.shape.extents = Vector2(w / 2, h / 2)
		collision_shape.disabled = false
		collision_shape.one_way_collision = true
		
	show()
