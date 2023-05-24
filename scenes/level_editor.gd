extends Node2D

var joe_template : PackedScene = load("res://spawners/spawner_joe.tscn")
var enemy_template : PackedScene = load("res://spawners/spawner_enemy.tscn")
var ledge_template : PackedScene = load("res://spawners/spawner_ledge.tscn")
var exit_template : PackedScene = load("res://spawners/spawner_exit.tscn")

@onready var joe_btn = %JoeBtn
@onready var exit_btn = %ExitBtn
@onready var ledge_btn = %LedgeBtn
@onready var enemy_btn = %EnemyBtn
@onready var level_select = $CanvasLayer/LevelSelect
@onready var editor_controls = $CanvasLayer/EditorControls
@onready var toast : Toast = $Toast

var selected_level_name : String
var root
var joe
var exit
var enemies = []
var ledges = []
var pool_size = 20
var ledge_index = 0
var enemy_index = 0

func _ready():
	root = get_node("/root/level_editor/Level")
	
	instantiate_actors()
	hide_editor_controls()
	show_level_select()
	
	var _on_level_selected = Callable(self, "_on_level_selected")
	level_select.connect("level_selected", _on_level_selected)
	
func instantiate_actors():
	joe = joe_template.instantiate()
	exit = exit_template.instantiate()
	for i in pool_size:
		var enemy = enemy_template.instantiate()
		enemies.append(enemy)
		var ledge = ledge_template.instantiate()
		ledges.append(ledge)
	
func _on_level_selected(name : String):
	selected_level_name = name
	level_select.visible = false
	load_level()

func show_level_select():
	level_select.visible = true
	editor_controls.visible = false
	remove_actors()
	
func hide_editor_controls():
	editor_controls.visible = false
	
func load_level():
	editor_controls.visible = true
	
	var file = FileAccess.open("res://assets/levels/" + selected_level_name + ".json", FileAccess.READ)
	var json = JSON.parse_string(file.get_as_text())
	
	for item in json:
		if item._type == 'joe':
			spawn_joe(Vector2(float(item._left), float(item._top)))
		elif item._type == 'enemy':
			spawn_enemy(Vector2(float(item._left), float(item._top)))
		elif item._type == 'ledge':
			spawn_ledge(Vector2(float(item._left), float(item._top)), Vector2(float(item._width), float(item._height)))
		elif item._type == 'exit':
			spawn_exit(Vector2(float(item._left), float(item._top)))
	
func remove_actors():
	root.remove_child(joe)
	root.remove_child(exit)
	for i in pool_size:
		var enemy = enemies[i]
		root.remove_child(enemy)
		var ledge = ledges[i]
		root.remove_child(ledge)
	
func spawn_joe(pos : Vector2):
	root.add_child(joe)
	joe.spawn(pos.x, pos.y, 24, 36)
		
func spawn_exit(pos : Vector2):
	root.add_child(exit)
	exit.spawn(pos.x, pos.y, 30, 30)
	
func spawn_ledge(pos : Vector2, size : Vector2):
	var ledge = ledges[ledge_index]
	root.add_child(ledge)
	ledge.spawn(pos.x, pos.y, size.x, size.y)
	ledge_index += 1
	if (ledge_index > ledges.size() - 1):
		ledge_index = 0
	
func spawn_enemy(pos : Vector2):
	var enemy = enemies[enemy_index]
	root.add_child(enemy)
	enemy.spawn(pos.x, pos.y, 25, 35)
	enemy_index += 1
	if (enemy_index > enemies.size() - 1):
		enemy_index = 0

func _on_joe_btn_pressed():
	spawn_joe(Vector2(100, 100))

func _on_exit_btn_pressed():
	spawn_exit(Vector2(100, 100))

func _on_ledge_btn_pressed():
	spawn_ledge(Vector2(100, 100), Vector2(100, 5))

func _on_enemy_btn_pressed():
	spawn_enemy(Vector2(100, 100))

func _on_save_btn_pressed():
	var data = []
	if (joe.is_inside_tree()):
		data.push_back({
			"_type": "joe",
			"_width": "25",
			"_height": "35",
			"_left": joe.position.x,
			"_top": joe.position.y
		})
	if (exit.is_inside_tree()):
		data.push_back({
			"_type": "exit",
			"_width": "30",
			"_height": "30",
			"_left": exit.position.x,
			"_top": exit.position.y
		})
	for i in pool_size:
		var enemy = enemies[i]
		if (enemy.is_inside_tree()):
			data.push_back({
				"_type": "enemy",
				"_width": "25",
				"_height": "35",
				"_left": enemy.position.x,
				"_top": enemy.position.y
			})
		var ledge = ledges[i]
		if (ledge.is_inside_tree()):
			var size : Vector2 = ledge.get_size()
			data.push_back({
				"_type": "ledge",
				"_width": size.x,
				"_height": size.y,
				"_left": ledge.position.x,
				"_top": ledge.position.y
			})
	var json_string = JSON.stringify(data)
	var file = FileAccess.open("res://assets/levels/" + selected_level_name + ".json", FileAccess.WRITE)
	file.store_string(json_string)
	toast.show_toast("You have successfully saved the level")

func _on_level_select_btn_pressed():
	show_level_select()
