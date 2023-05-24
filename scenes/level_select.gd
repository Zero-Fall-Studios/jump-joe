extends Control

@onready var list : ItemList = $MarginContainer/VBoxContainer/ItemList
@onready var create_new_btn : Button = $MarginContainer/VBoxContainer/HBoxContainer/Button
@onready var create_new_file_field : LineEdit = $MarginContainer/VBoxContainer/HBoxContainer/LineEdit

signal level_selected(name : String)

var create_new_file_name : String

func _ready():
	add_level_names()
	
	var _on_item_clicked = Callable(self, "_on_item_clicked")
	list.connect("item_clicked", _on_item_clicked)
	
	create_new_btn.disabled = true
	
func _on_item_clicked(index, at_position, mouse_button_index):
	var name = list.get_item_text(index)
	level_selected.emit(name)
	
func add_level_names():
	list.clear()
	var dir = DirAccess.open("res://assets/levels")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
#				print("Found directory: " + file_name)
				pass
			else:
#				print("Found file: " + file_name)
				list.add_item(file_name.split('.')[0])
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

func _on_button_pressed():
	var file = FileAccess.open("res://assets/levels/" + create_new_file_name + ".json", FileAccess.WRITE)
	file.store_string("[]")
	add_level_names()
	create_new_file_field.clear()

func _on_line_edit_text_changed(new_text : String):
	create_new_btn.disabled = new_text.strip_edges(true, true).length() == 0
	create_new_file_name = new_text.strip_edges(true, true)

func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")
