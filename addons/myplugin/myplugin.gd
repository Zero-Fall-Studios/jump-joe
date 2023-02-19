@tool
extends EditorPlugin

func _enter_tree():
	var callable = Callable(self, "print_hello_world")
	add_tool_menu_item("Create Level", callable)

func create_button() -> TextureButton:
	var button = TextureButton.new()
	button.set_text("Hello, world")
	var callable = Callable(self, "print_hello_world")
	button.connect("pressed", callable)
	return button

func print_hello_world() -> void:
	print("Hello, world!")
