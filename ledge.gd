extends StaticBody2D

@onready var collision_shape : CollisionShape2D = $CollisionShape2D
@onready var sprite : Sprite2D = $Sprite2D

func _ready():
	visible = false

func spawn(x : float, y : float, w : float, h : float):
	position = Vector2(x, y)
	sprite.region_rect = Rect2(0, 0, w, h)

	collision_shape.shape = RectangleShape2D.new()
	collision_shape.position = Vector2(w / 2, h / 2)
	collision_shape.shape.extents = Vector2(w / 2, h / 2)
	collision_shape.one_way_collision = true
	
	visible = true
