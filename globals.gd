extends Node

var joe_template : PackedScene = load("res://actors/joe.tscn")
var enemy_template : PackedScene = load("res://actors/enemy.tscn")
var ledge_template : PackedScene = load("res://actors/ledge.tscn")
var fake_ledge_template : PackedScene = load("res://actors/fake_ledge.tscn")
var hidden_ledge_template : PackedScene = load("res://actors/hidden_ledge.tscn")
var exit_template : PackedScene = load("res://actors/exit.tscn")

var level = 1
var root

var joe
var exit
var bottom_ledge
var enemies = []
var ledges = []
var fake_ledges = []
var hidden_ledges = []
var pool_size = 20
var ledge_index = 0
var enemy_index = 0
var fake_ledge_index = 0
var hidden_ledge_index = 0
var loading_level = false

signal level_change(level_number)

func load(_root):
	root = _root
	instantiate_actors()

func instantiate_actors():
	joe = joe_template.instantiate()
	exit = exit_template.instantiate()
	bottom_ledge = ledge_template.instantiate()
	for i in pool_size:
		var enemy = enemy_template.instantiate()
		enemies.append(enemy)
		var ledge = ledge_template.instantiate()
		ledges.append(ledge)
		var fake_ledge = fake_ledge_template.instantiate()
		fake_ledges.append(fake_ledge)
		var hidden_ledge = hidden_ledge_template.instantiate()
		hidden_ledges.append(hidden_ledge)
	
func start_game():
	load_level()
	
func load_level():
	loading_level = true
	remove_actors()
	build_level()
	level_change.emit(level)
	loading_level = false
	
func next_level():
	if not loading_level:
		level += 1
		if level > 10:
			level = 1
		load_level()
	
func prev_level():
	if not loading_level:
		level -= 1
		if level < 1:
			level = 10
		load_level()
	
func restart_level():
	if not loading_level:
		load_level()
	
func remove_actors():
	root.remove_child(joe)
	root.remove_child(exit)
	root.remove_child(bottom_ledge)
	for i in pool_size:
		var enemy = enemies[i]
		root.remove_child(enemy)
		var ledge = ledges[i]
		root.remove_child(ledge)
		var fake_ledge = fake_ledges[i]
		root.remove_child(fake_ledge)
		var hidden_ledge = hidden_ledges[i]
		root.remove_child(hidden_ledge)
		
func spawn_floor():
	root.add_child(bottom_ledge)
	bottom_ledge.spawn(0, 500, 700, 5)
	
func spawn_joe(pos : Vector2):
	root.add_child(joe)
	joe.spawn(pos.x, pos.y, 24, 36)
		
func spawn_exit(pos : Vector2, random: bool):
	root.add_child(exit)
	exit.spawn(pos.x, pos.y, 30, 30)
	if random:
		exit.random()
	
func spawn_ledge(pos : Vector2, size : Vector2):
	var ledge = ledges[ledge_index]
	root.add_child(ledge)
	ledge.spawn(pos.x, pos.y, size.x, size.y)
	ledge_index += 1
	if (ledge_index > ledges.size() - 1):
		ledge_index = 0

func spawn_fake_ledge(pos : Vector2, size : Vector2):
	var fake_ledge = fake_ledges[fake_ledge_index]
	root.add_child(fake_ledge)
	fake_ledge.spawn(pos.x, pos.y, size.x, size.y)
	fake_ledge_index += 1
	if (fake_ledge_index > fake_ledges.size() - 1):
		fake_ledge_index = 0

func spawn_hidden_ledge(pos : Vector2, size : Vector2):
	var hidden_ledge = hidden_ledges[hidden_ledge_index]
	root.add_child(hidden_ledge)
	hidden_ledge.spawn(pos.x, pos.y, size.x, size.y)
	hidden_ledge_index += 1
	if (hidden_ledge_index > hidden_ledges.size() - 1):
		hidden_ledge_index = 0
	
func spawn_enemy(pos : Vector2):
	var enemy = enemies[enemy_index]
	root.add_child(enemy)
	enemy.spawn(pos.x, pos.y, 25, 35)
	enemy_index += 1
	if (enemy_index > enemies.size() - 1):
		enemy_index = 0
	
func build_level():
	spawn_floor()
	
	var file = FileAccess.open("res://assets/levels/level-" + str(level) + ".json", FileAccess.READ)
	var json = JSON.parse_string(file.get_as_text())
	
	for item in json:
		if item._type == 'joe':
			spawn_joe(Vector2(float(item._left), float(item._top)))
		elif item._type == 'enemy':
			spawn_enemy(Vector2(float(item._left), float(item._top)))
		elif item._type == 'ledge':
			spawn_ledge(Vector2(float(item._left), float(item._top)), Vector2(float(item._width), float(item._height)))
		elif item._type == 'fake':
			spawn_fake_ledge(Vector2(float(item._left), float(item._top)), Vector2(float(item._width), float(item._height)))
		elif item._type == 'hidden':
			spawn_hidden_ledge(Vector2(float(item._left), float(item._top)), Vector2(float(item._width), float(item._height)))
		elif item._type == 'exit':
			if "_random" in item:
				spawn_exit(Vector2(float(item._left), float(item._top)), true)
			else:
				spawn_exit(Vector2(float(item._left), float(item._top)), false)
	
