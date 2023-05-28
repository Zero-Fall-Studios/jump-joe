extends Area2D

@onready var collision_shape : CollisionShape2D = $CollisionShape2D
@onready var sprite : Sprite2D = $Sprite2D

var selected = false
var is_mouse_over = false
var center : Vector2
var can_expand = false

func _ready():
	
	connect("mouse_entered", Callable(self, "_on_mouse_enter"))
	connect("mouse_exited", Callable(self, "_on_mouse_exit"))
	connect("input_event", Callable(self, "_on_input_event"))
	
	hide()
	selected = false
	if collision_shape:
		collision_shape.shape = RectangleShape2D.new()
		
func _on_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("left_click"):
		selected = true	
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
		
func _on_mouse_enter():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	
func _on_mouse_exit():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
		
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			if selected:
				selected = false
				Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func _physics_process(_delta):
	if selected:
		global_position = get_global_mouse_position() - center
		if can_expand:
			if Input.is_action_pressed("expand"):
				spawn(position.x, position.y, sprite.get_rect().size.x + 5, sprite.get_rect().size.y)
			if Input.is_action_pressed("shrink"):
				spawn(position.x, position.y, sprite.get_rect().size.x - 5, sprite.get_rect().size.y)
			
		
func spawn(x : float, y : float, w: float = 0, h: float = 0):
	position = Vector2(x, y)
	if sprite:
		sprite.region_rect = Rect2(0, 0, w, h)
		
	if collision_shape:
		collision_shape.position = Vector2(w / 2, h / 2)
		collision_shape.shape.extents = Vector2(w / 2, h / 2)
		collision_shape.disabled = false
	
	center.x = sprite.get_rect().size.x / 2
	center.y = sprite.get_rect().size.y / 2
	
	show()
	
func get_size():
	return sprite.region_rect.size
	
