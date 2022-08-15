extends Area2D

const EXPLOSION = preload("res://Scenes/Effects/WallCollision.tscn")

onready var rayCast = $RayCast2D
onready var tween = $Tween
onready var MoveSound = $MoveSound
onready var ExplosionSound = $ExplosionSound

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

func check_dir(check_direction):
	rayCast.cast_to = check_direction * tile_size
	rayCast.force_raycast_update()
	var collision = rayCast.get_collider()
	if collision != null:
		if collision.is_in_group("Moveable"):
			return collision.check_dir(check_direction)
		elif collision.is_in_group("NotMoveable"):
			return false

func check_explosion():
	if twoBlock != null && oneBlock == null:
		if twoBlock.is_in_group("NotMoveable") || twoBlock.check_dir(direction) == false:
			var x = EXPLOSION.instance()
			get_parent().add_child(x)
			x.position = global_position + direction * tile_size * 1.5
			x.look_at(global_position)
			x.boom()
			ExplosionSound.play()

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
			check_move()

func check_move():
	check_Rays()
	#check_explosion()
	if oneBlock == null:
		MoveSound.play()
		move_tween(direction, 10, 5)
	if check_dir(direction):
		MoveSound.play()
		move_tween(direction, 0, 3)
		oneBlock.move(direction, 0, 3)
	else:
		pass
		#check_explosion()
	
func move_tween(dir, tween_effect, speed):
	tween.interpolate_property(self, "position",
	position, position + dir * tile_size,
	1.0/speed, tween_effect, Tween.EASE_IN_OUT)
	tween.start()
