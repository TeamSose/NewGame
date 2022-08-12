extends Node2D

onready var tween = $Tween

const bar = preload("res://TextureProgress.tscn")
var calculated = false
var middleStops = []
var selfStarts = ["LRB", "TRB", "TLRB", "TLB", "TLR"]
var stopPoints = ["RB", "LRB", "LB", "TRB", "TLRB", "TLB", "TR", "TLR", "TL", "MB", "MT", "MR", "ML"]
var startPoints = ["MB", "MT", "MR", "ML"]
			#1. Row
var tiles = {Vector2(4,1):["RB", [Vector2(1,0), Vector2(0,1)]],
			Vector2(1,0):["LRB", [Vector2(-1,0), Vector2(1,0), Vector2(0,1)]], 
			Vector2(2,0):["LB", [Vector2(-1,0), Vector2(0,1)]],
			Vector2(3,0):["MB", [Vector2(0,1)]],
			Vector2(0,1):["TRB", [Vector2(0,1), Vector2(0,-1), Vector2(1,0)]],
			Vector2(1,1):["TLRB", [Vector2(0,1), Vector2(0,-1), Vector2(1,0), Vector2(-1,0)]],
			Vector2(2,1):["TLB", [Vector2(0,1), Vector2(0,-1), Vector2(-1,0)]],
			Vector2(3,1):["TB", [Vector2(0,1), Vector2(0,-1)]],
			Vector2(0,2):["TR", [Vector2(1,0), Vector2(0,-1)]],
			Vector2(1,2):["TLR", [Vector2(-1,0), Vector2(1,0), Vector2(0,-1)]],
			Vector2(2,2):["TL", [Vector2(-1,0), Vector2(0,-1)]],
			Vector2(3,2):["MT", [Vector2(0,-1)]],
			Vector2(0,3):["MR", [Vector2(1,0)]],
			Vector2(1,3):["LR", [Vector2(-1,0), Vector2(1,0)]],
			Vector2(2,3):["ML", [Vector2(-1,0)]],
			Vector2(3,3):["M"]}

onready var board = $"Underground Connections"
onready var astarDebug = $Control2
onready var player = $Player2
onready var line = $Line2D

var usersWithTile = []
var energyGivers = []
var energyUsers = []
var possibleStartPoints = []
var starts = []
var ends = []
var possibleEndPoints = []
var array = []
var start_point = Vector2.ZERO
var end_point = Vector2.ZERO

func _ready():
	energyGivers = get_tree().get_nodes_in_group("Giver")
	energyUsers = get_tree().get_nodes_in_group("User")
	#MusicController.play_music()
	astarDebug.visible = !astarDebug.visible
	array = board.get_used_cells()
	for i in array:
		if stopPoints.has(tiles.get(board.get_cell_autotile_coord(i.x,i.y))):
			possibleEndPoints.append(i)
		if startPoints.has(tiles.get(board.get_cell_autotile_coord(i.x,i.y))):
			possibleStartPoints.append(i)
	for j in energyGivers:
		#print(j.position)
		for k in array:
			if j.position == board.map_to_world(k):
				starts.append(k)
	for l in energyUsers:
		#print(l.position)
		for m in array:
			if !startPoints.has(tiles.get(board.get_cell_autotile_coord(m.x,m.y))[0]) && l.position == board.map_to_world(m):
				middleStops.append(m)
				usersWithTile.append([l, m])
			elif l.position == board.map_to_world(m):
				ends.append(m)
				usersWithTile.append([l, m])
	run_test()
	#sort()
	generate()
	connect_Users()
# warning-ignore:unused_argument
var animated = []
func fill():
	animated = []
	for connetion in all_connections[0]:
		animated.append([connetion[2], false])

func _input(event):
	if Input.is_action_just_pressed("mouse_left"):
		fill()
		_on_Tween_tween_completed(null, null)
	if Input.is_action_just_pressed("mouse_right"):
		for l in lines:
			l.value = 100

func connect_Users():
	for user in usersWithTile:
		for connection in all_connections:
			for c in connection:
				if c[1] == user[1]:
					c[2].connect("active", user[0], "update_Door")
		
func generate():
	#var connection = all_connections.duplicate()[1]
	print(all_connections[0])
	for connection in all_connections:
		if connection != null:
			for c in connection:
				c.append(updateLine(c[0], c[1]))

var lines = []
func updateLine(start, end):
	var test = bar.instance()
	test.rect_size.y = 2
	test.value = 0
	if start.y == end.y && start.x < end.x:
		test.rect_position = board.map_to_world(start,false) + Vector2(9,7)
		test.rect_size.x = board.map_to_world(end,false).x - board.map_to_world(start,false).x
	
	if start.y == end.y && start.x > end.x:
		test.rect_position = board.map_to_world(start,false) + Vector2(7,9)
		test.rect_rotation = 180
		test.rect_size.x = board.map_to_world(start,false).x - board.map_to_world(end,false).x
	
	if start.x == end.x && start.y < end.y:
		test.rect_position = board.map_to_world(start,false) + Vector2(9,7)
		test.rect_rotation = 90
		test.rect_size.x = board.map_to_world(end,false).y - board.map_to_world(start,false).y + 2
	
	if start.x == end.x && start.y > end.y:
		test.rect_position = board.map_to_world(start,false) + Vector2(7,7)
		test.rect_rotation = -90
		test.rect_size.x = board.map_to_world(start,false).y - board.map_to_world(end,false).y
	add_child(test)
	lines.append(test)
	return test

# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_Tween_tween_completed(object, key):
	var next = get_next_bar()
	if next != null:
		animate(next)
		
func animate(bar):
	tween.interpolate_property(bar, "value",
	0, 100, 0.5, 0, Tween.EASE_IN_OUT)
	tween.start()

func get_next_bar():
	for a in animated:
		if a[1] == false:
			a[1] = true
			return a[0]

var result = []
var temp = []
var all_connections = []
func run_test():
	var surrounding_tiles = []
	all_connections = []
	for k in starts:
		temp = [k]
		result = []
		test(k, k, surrounding_tiles)
		#print(surrounding_tiles)
		all_connections.append(result)
		#print(result)
	#for i in all_connections:
		#print(i)
	calculated = true
	print("calculated")
func test(start_tile, current_tile, list):
	var tests = tiles.get(board.get_cell_autotile_coord(current_tile.x,current_tile.y))[1]
	for i in tests:
		var target_tile = current_tile + i
		if board.get_cell_autotile_coord(target_tile.x,target_tile.y) != Vector2.ZERO:
			if selfStarts.has(tiles.get(board.get_cell_autotile_coord(target_tile.x,target_tile.y))[0]) && target_tile != start_tile:
				list.append(target_tile)
				temp.append(target_tile)
				result.append(temp)
				temp = [target_tile]
				test(target_tile, target_tile, list)
			if !list.has(target_tile) && !starts.has(target_tile):
				list.append(target_tile)
				if stopPoints.has(tiles.get(board.get_cell_autotile_coord(target_tile.x,target_tile.y))[0]) || middleStops.has(target_tile):
					temp.append(target_tile)
					result.append(temp)
					temp = [target_tile]
				if ends.has(target_tile):
					#result.append(temp)
					temp = [start_tile]
				test(start_tile, target_tile, list)
				
				
func sort():
	var temps = all_connections.duplicate()
	var seen : Array
	var double : Array
	for connection in temps:
		for c in connection:
			var index = temps.find(connection,0)
			if !seen.has(c[1]):
				seen.append(c[1])
			else:
				double.append_array(c)
				temps.remove(index)
	if !double.empty():
		var c = temps.find(double[1], 0)
		temps[c].insert(0, double)
	all_connections = temps
	print("sorted")
	
