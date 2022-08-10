extends Node2D

onready var tween = $Tween

const bar = preload("res://TextureProgress.tscn")

var stopPoints = ["RB", "LB", "TRB", "TR", "TL", "TLR", "TLRB", "ML"]
			#1. Row
var tiles = {Vector2(4,1):"RB",
			Vector2(1,0):"LRB", 
			Vector2(2,0):"LB",
			Vector2(3,0):"MB",
			Vector2(0,1):"TRB",
			Vector2(1,1):"TLRB",
			Vector2(2,1):"TLB",
			Vector2(3,1):"TB",
			Vector2(0,2):"TR",
			Vector2(1,2):"TLR",
			Vector2(2,2):"TL",
			Vector2(3,2):"MT",
			Vector2(0,3):"MR",
			Vector2(1,3):"LR",
			Vector2(2,3):"ML",
			Vector2(3,3):"M"}

onready var board = $"Underground Connections"
onready var astarDebug = $Control2
onready var player = $Player2
onready var line = $Line2D

var endPoints = []
var array = []
var start_point = Vector2.ZERO
var end_point = Vector2.ZERO

func _ready():
	#MusicController.play_music()
	astarDebug.visible = !astarDebug.visible
	array = board.get_used_cells()
	for i in array:
		if stopPoints.has(tiles.get(board.get_cell_autotile_coord(i.x,i.y))):
			endPoints.append(i)
		if tiles.get(board.get_cell_autotile_coord(i.x,i.y)) == "MR":
			start_point = i
	print(get_surrounding_tiles(Vector2(2,6)))
	
func _input(event):
	if Input.is_action_pressed("mouse_left"):
		_on_Tween_tween_completed(null, null)

func updateLine(start, end):
	var path_points = board.get_astar_path_avoiding_obstacles(board.map_to_world(start), board.map_to_world(end))
	line.position = board.cell_size/2 # Use offset to move line to center of tiles
	line.points = path_points
	var test = bar.instance()
	test.rect_position = board.map_to_world(start) + Vector2(9,7)
	test.rect_size.x = board.map_to_world(end).x - board.map_to_world(start).x
	test.rect_size.y = 2
	if tiles.get(board.get_cell_autotile_coord(start.x,start.y)) == "LB":
		test.rect_rotation = 90
		test.rect_size.x = board.map_to_world(end).y - board.map_to_world(start).y + 2
	if tiles.get(board.get_cell_autotile_coord(start.x,start.y)) == "TL":
		test.rect_rotation = -90
		test.rect_size.x = board.map_to_world(end).y - board.map_to_world(start).y + 2
	add_child(test)
	tween.interpolate_property(test, "value",
	0, 100, 0.5, 0, Tween.EASE_IN_OUT)
	tween.start()

func _on_Tween_tween_completed(object, key):
	if !endPoints.empty():
		end_point = endPoints.pop_front()
		updateLine(start_point, end_point)
		start_point = end_point

#ALARM FUNCTION IST KAPUTT
func get_surrounding_tiles(current_tile):
	var surrounding_tiles = []
	var possible = [Vector2(0,-1), Vector2(-1,0), Vector2(0,1), Vector2(1,0)]
	var target_tile = Vector2.ZERO
	for k in possible:
		target_tile = current_tile + k
		if board.get_cell_autotile_coord(target_tile.x,target_tile.y) != Vector2.ZERO:
			surrounding_tiles.append(target_tile)
	for l in surrounding_tiles:
		for k in possible:
			target_tile = l + k
			if board.get_cell_autotile_coord(target_tile.x,target_tile.y) != Vector2.ZERO:
				surrounding_tiles.append(target_tile)
	
	return surrounding_tiles
