extends Area2D

onready var rayCast = $RayCast2D
onready var tween = $Tween

var tile_size = 16

func check_dir(direction):
	rayCast.cast_to = direction * tile_size
	rayCast.force_raycast_update()
	var oneBlock = rayCast.get_collider()
	if oneBlock != null:
		if oneBlock.is_in_group("Moveable"):
			return oneBlock.check_dir(direction)
		elif oneBlock.is_in_group("NotMovable"):
			return false
	else:
		return true
		
func move_Box(dir, tween_effect, speed):
	tween.interpolate_property(self, "position",
	self.position, self.position + dir * tile_size,
	1.0/speed, tween_effect, Tween.EASE_IN_OUT)
	
	rayCast.cast_to = dir * tile_size
	rayCast.force_raycast_update()
	var collision = rayCast.get_collider()
	if collision != null:
		if collision.is_in_group("Moveable"):
			collision.move_Box(dir, tween_effect, speed)
			
	tween.start()
