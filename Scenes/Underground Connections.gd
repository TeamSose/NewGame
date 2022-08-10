extends TileMap

onready var tilemap = self
onready var navigation2d = $Navigation2D
onready var line2d = $Line2D
			#1. Row
var tiles = {Vector2(0,0):[],
			Vector2(1,0):[], 
			Vector2(2,0):[],
			Vector2(3,0):[],
			#2. Row
			Vector2(0,1):[],
			Vector2(1,1):[],
			Vector2(2,1):[],
			Vector2(3,1):[],
			#3. Row
			Vector2(0,2):[],
			Vector2(1,2):[],
			Vector2(2,2):[],
			Vector2(3,2):[],
			#4. Row
			Vector2(0,3):[],
			Vector2(1,3):[],
			Vector2(2,3):[],
			Vector2(3,3):[]}

# Called when the node enters the scene tree for the first time.
func _ready():
	test()

func test():
	var array = self.get_used_cells()
	var newPath = navigation2d.get_simple_path(tilemap.map_to_world(array.front()),tilemap.map_to_world(array.back()))
	
	line2d.points = newPath

func search():
	var array = self.get_used_cells()
	for i in array:
		tiles.get(get_cell_autotile_coord(i.x,i.y)).append(i)
	for j in tiles.keys():
		print(str(j) + " " +str(tiles.get(j)))
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
