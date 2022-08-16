extends Node2D

const bar = preload("res://TextureProgress.tscn")

onready var bars = get_node("Bars")
onready var tilemap = get_node("Cables")
var lines = []
var result = []
var temp = []
var ends = ["MB", "MT", "MR", "ML", "LRB", "TRB", "TLRB", "TLB", "TLR"]
var stopPoints = ["RB", "LB", "TR", "TL"]
var tiles = {8:["RB", [Vector2(1,0), Vector2(0,1)]],
			1:["LRB", [Vector2(-1,0), Vector2(1,0), Vector2(0,1)]], 
			2:["LB", [Vector2(-1,0), Vector2(0,1)]],
			3:["MB", [Vector2(0,1)]],
			4:["TRB", [Vector2(1,0)]],
			5:["TLRB", [Vector2(0,1), Vector2(0,-1), Vector2(1,0), Vector2(-1,0)]],
			6:["TLB", [Vector2(0,1), Vector2(0,-1), Vector2(-1,0)]],
			7:["TB", [Vector2(0,1), Vector2(0,-1)]],
			9:["TR", [Vector2(1,0), Vector2(0,-1)]],
			10:["TLR", [Vector2(-1,0), Vector2(1,0), Vector2(0,-1)]],
			11:["TL", [Vector2(-1,0), Vector2(0,-1)]],
			12:["MT", [Vector2(0,-1)]],
			13:["MR", [Vector2(1,0)]],
			14:["LR", [Vector2(-1,0), Vector2(1,0)]],
			15:["ML", [Vector2(-1,0)]],
			16:["M"]}
			
# Called when the node enters the scene tree for the first time.
func _ready():
	for x in get_tree().get_nodes_in_group("Giver"):
		connect("ready", x, "startup")
	for y in get_tree().get_nodes_in_group("User"):
		connect("ready", y, "startup")

func run_test(start):
	var surrounding_tiles = []
	temp = [start]
	result = []
	test(start, start, surrounding_tiles)
	#print(surrounding_tiles)
	#all_connections.append(result)
	return result
	#for i in all_connections:
		#print(i)
	print("calculated")
	
func test(start_tile, current_tile, list):
	var tests = tiles.get($Cables.get_cellv(current_tile))[1]
	for i in tests:
		var target_tile = current_tile + i
		if $Cables.get_cellv(target_tile) != 0:
			if !list.has(target_tile) && target_tile != start_tile:
				list.append(target_tile)
				if stopPoints.has(tiles.get($Cables.get_cellv(target_tile))[0]):
					temp.append(target_tile)
					result.append(temp)
					temp = [target_tile]
				if ends.has(tiles.get($Cables.get_cellv(target_tile))[0]):
					temp.append(target_tile)
					result.append(temp)
					return
					
				test(start_tile, target_tile, list)

func generate(connection):
	lines = []
	if connection != null:
		for c in connection:
			c.append(updateLine(c[0], c[1], lines))
		return lines

func delete_connection(connection):
	for c in connection:
		connection.erase(c)

func updateLine(start, end, list):
	var test = bar.instance()
	test.rect_size.y = 2
	test.value = 0
	if start.y == end.y && start.x < end.x:
		test.rect_position = $Cables.map_to_world(start,false) + Vector2(9,7)
		test.rect_size.x = $Cables.map_to_world(end,false).x - $Cables.map_to_world(start,false).x
	
	if start.y == end.y && start.x > end.x:
		test.rect_position = $Cables.map_to_world(start,false) + Vector2(7,9)
		test.rect_rotation = 180
		test.rect_size.x = $Cables.map_to_world(start,false).x - $Cables.map_to_world(end,false).x
	
	if start.x == end.x && start.y < end.y:
		test.rect_position = $Cables.map_to_world(start,false) + Vector2(9,7)
		test.rect_rotation = 90
		test.rect_size.x = $Cables.map_to_world(end,false).y - $Cables.map_to_world(start,false).y + 2
	
	if start.x == end.x && start.y > end.y:
		test.rect_position = $Cables.map_to_world(start,false) + Vector2(7,7)
		test.rect_rotation = -90
		test.rect_size.x = $Cables.map_to_world(start,false).y - $Cables.map_to_world(end,false).y
	bars.add_child(test)
	lines.append([test, false])
	return test
