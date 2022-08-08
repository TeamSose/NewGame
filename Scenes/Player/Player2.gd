extends Area2D

const EXPLOSION = preload("res://Scenes/Effects/WallCollision.tscn")

onready var rayCast = $RayCast2D
onready var tween = $Tween

var box = null
var stop = false
var direction = Vector2.DOWN
var oneBlock = null
var twoBlock = null
var tile_size = 16
var inputs = {"right": Vector2.RIGHT,
			"left": Vector2.LEFT,
			"up": Vector2.UP,
			"down": Vector2.DOWN}
func _ready():
	pass
	#position = position.snapped(Vector2.ONE * tile_size)
	#position += Vector2.ONE * tile_size/2

func check_dir(check_direction):
	rayCast.cast_to = check_direction * tile_size
	rayCast.force_raycast_update()
	var collision = rayCast.get_collider()
	if collision != null:
		if collision.is_in_group("Moveable"):
			return collision.check_dir(check_direction)
		elif collision.is_in_group("NotMovable"):
			return false

func check_Rays():
	rayCast.cast_to = direction * tile_size
	rayCast.force_raycast_update()
	oneBlock = rayCast.get_collider()
	
	rayCast.cast_to = direction * tile_size * 2
	rayCast.force_raycast_update()
	twoBlock = rayCast.get_collider()

func _unhandled_input(event):
	if tween.is_active():
		return
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			direction = inputs.get(dir)
			move()

func move():
	check_Rays()
	if oneBlock == null:
		move_tween(direction, 10, 5)
	if check_dir(direction):
		move_tween(direction, 0, 3)
		oneBlock.move_Box(direction, 0, 3)
	
func move_tween(dir, tween_effect, speed):
	tween.interpolate_property(self, "position",
	position, position + dir * tile_size,
	1.0/speed, tween_effect, Tween.EASE_IN_OUT)
	tween.start()
