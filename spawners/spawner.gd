extends Area2D

@onready var collision_shape : CollisionShape2D = $CollisionShape2D
@onready var sprite : Sprite2D = $Sprite2D

var selected = false
var is_mouse_over = false
var center : Vector2

func _ready():
	visible = false
	selected = false
	if collision_shape:
		collision_shape.shape = RectangleShape2D.new()
	var _on_input_event = Callable(self, "_on_input_event")
	connect("input_event", _on_input_event)
		
func _on_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("left_click"):if collision_shape:
		selected = true	
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
		
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			selected = false
			Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func _physics_process(delta):
	if selected:
		global_position = get_global_mouse_position() - center
		
func spawn(x : float, y : float, w: float = 0, h: float = 0):
	position = Vector2(x, y)
	if sprite:
		sprite.region_rect = Rect2(0, 0, w, h)
		
	if collision_shape:
		collision_shape.position = Vector2(w / 2, h / 2)
		collision_shape.shape.extents = Vector2(w / 2, h / 2)
		collision_shape.disabled = false
		
	visible = true
	
	center.x = sprite.get_rect().size.x / 2
	center.y = sprite.get_rect().size.y / 2
	
func get_size():
	return sprite.region_rect.size
	
