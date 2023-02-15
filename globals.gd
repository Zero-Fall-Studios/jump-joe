extends Node

var joe_template : PackedScene = load("res://joe.tscn")
var enemy_template : PackedScene = load("res://enemy.tscn")
var ledge_template : PackedScene = load("res://ledge.tscn")
var exit_template : PackedScene = load("res://exit.tscn")

var levels_data_file_name = "res://assets/data/levels.json"
var level = 0
var json
var root

var joe
var exit
var bottom_ledge
var enemies = []
var ledges = []
var pool_size = 20

signal level_change(level_number)

func _ready():
	root = get_node("/root/Main/Level")
	
	joe = joe_template.instantiate()
	root.add_child(joe)
	
	exit = exit_template.instantiate()
	root.add_child(exit)
	
	bottom_ledge = ledge_template.instantiate()
	root.add_child(bottom_ledge)
	
	var file = FileAccess.open(levels_data_file_name, FileAccess.READ)
	json = JSON.parse_string(file.get_as_text())
	
	for i in pool_size:
		var enemy = enemy_template.instantiate()
		enemies.append(enemy)
		root.add_child(enemy)
		var ledge = ledge_template.instantiate()
		ledges.append(ledge)
		root.add_child(ledge)
	
func load():
	hide_actors()
	build_level()
	level_change.emit(level)
	
func next_level():
	level += 1
	Globals.load()
	
func restart_level():
	Globals.load()
	
func hide_actors():
	joe.visible = false
	exit.visible = false
	bottom_ledge.visible = false
	for i in pool_size:
		var enemy = enemies[i]
		enemy.visible = false
		var ledge = ledges[i]
		ledge.visible = false
	
func build_level():
	bottom_ledge.spawn(0, 500, 700, 5)
	if level >= len(json.jumpjoe.level):
		return
	
	var items = json.jumpjoe.level[level].item
	var enemy_index = 0
	var ledge_index = 0
	for item in items:
		if item._type == 'joe':
			joe.spawn(float(item._left), float(item._top))
		elif item._type == 'enemy':
			var enemy = enemies[enemy_index]
			enemy_index += 1
			enemy.spawn(float(item._left), float(item._top))
		elif item._type == 'ledge':
			var ledge = ledges[ledge_index]
			ledge_index += 1
			ledge.spawn(float(item._left), float(item._top), float(item._width), float(item._height))
		elif item._type == 'exit':
			exit.spawn(float(item._left), float(item._top))
