extends CanvasLayer
class_name Toast

@onready var container : CenterContainer = $CenterContainer
@onready var toast_label : Label = $CenterContainer/MarginContainer/MarginContainer/Label

func _ready():
	container.hide()

func show_toast(message: String, duration: float = 2.0):
	toast_label.text = message
	
	var y = container.position.y
	container.position = Vector2(container.position.x, y - 25)
	container.modulate.a = 0
	container.show()
	
	var tween = create_tween().set_parallel(true)
	tween.tween_property(container, "position", Vector2(container.position.x, y), 0.25)
	tween.tween_property(container, "modulate:a", 1, .5)
	tween.tween_interval(duration)
	tween.chain().tween_property(container, "modulate:a", 0, .5)
	tween.chain().tween_callback(toast_hide)
	
func toast_hide():
	container.hide()
