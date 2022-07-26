extends Area2D

onready var rayCast = $RayCast2D
onready var tween = $Tween
onready var sprite = $Sprite
export(NodePath) onready var tilemap = get_node("../Cables")
export(NodePath) onready var world = get_node("..")
export(NodePath) onready var inputTop = get_node(inputTop)
export(NodePath) onready var inputBottom = get_node(inputBottom)

var cables_copy = null
var connection = null
var cables = null
var tile = null
var powerState = false
var state = 0
var tile_size = 16
var temp = null
var topState = false
var bottomState = false
export var power = false
export var active = false setget set_active

func startup():
	for t in tilemap.get_used_cells():
		if tilemap.map_to_world(t) == self.position:
			tile = t
	connection = world.run_test(tile)
	cables = world.generate(connection)

func set_active(value):
	if value != active:
		active = value
		if active:
			cables_copy = cables.duplicate(true)
			powerState = false
			_on_Tween_tween_completed(null, null)
		else:
			cables_copy = cables.duplicate(true)
			powerState = true
			power = false
			_on_Tween_tween_completed(null, null)

func get_next_bar():
	#print(cables_copy)
	var c = null
	if powerState:
		c = cables_copy.pop_back()
	else:
		c = cables_copy.pop_front()
	if c != null:
		c[1] = !c[1]
		return c[0]

func _on_Tween_tween_completed(object, key):
	var next = get_next_bar()
	if next != null:
		if powerState:
			animate(next, 0)
		else:
			animate(next, 100)
	else:
		if powerState == false:
			power = true

func animate(bar, maxValue):
	$Tween.interpolate_property(bar, "value",
	bar.value, maxValue, 0.5, 0, Tween.EASE_IN_OUT)
	$Tween.start()

func _physics_process(delta):
	check_State()

func check_State():
	if inputTop.power == true && inputBottom.power == true:
		updateState(3)
		self.set_active(true)
	else:
		self.set_active(false)
		if inputTop.power == true && inputBottom.power != true:
			updateState(1)
		if inputTop.power != true && inputBottom.power == true:
			updateState(2)
		if inputTop.power != true && inputBottom.power != true:
			updateState(0)
			
	

func updateState(state):
	match (state):
		0: sprite.set_texture(load("res://AND(OFF,OFF).png"))
		1: sprite.set_texture(load("res://AND(ON,OFF).png"))
		2: sprite.set_texture(load("res://AND(OFF,ON).png"))
		3: sprite.set_texture(load("res://AND(ON,ON).png"))

func check_dir(direction):
	rayCast.cast_to = direction * tile_size
	rayCast.force_raycast_update()
	var collision = rayCast.get_collider()
	if collision != null:
		if collision.is_in_group("Moveable"):
			return collision.check_dir(direction)
		elif collision.is_in_group("NotMoveable"):
			return false
	else:
		return true
		
func move(dir, tween_effect, speed):
	tween.interpolate_property(self, "position",
	self.position, self.position + dir * tile_size,
	1.0/speed, tween_effect, Tween.EASE_IN_OUT)
	
	rayCast.cast_to = dir * tile_size
	rayCast.force_raycast_update()
	var collision = rayCast.get_collider()
	if collision != null:
		if collision.is_in_group("Moveable"):
			collision.move(dir, tween_effect, speed)
			
	tween.start()
