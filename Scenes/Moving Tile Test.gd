extends Area2D

onready var rayCast = $RayCast2D
onready var tween = $Tween

var tile_size = 16

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
