extends Area2D

var somethingIn = false

# Called when the node enters the scene tree for the first time.
func openDoor():
	$AnimationPlayer.play("Open")
	
func closeDoor():
	if !somethingIn:
		$AnimationPlayer.play("Close")

func _on_Door_area_entered(area):
	if area.is_in_group("DoorOpen"):
		somethingIn = true

func _on_Door_area_exited(area):
	if area.is_in_group("DoorOpen"):
		somethingIn = false

func update_Door(value):
	if value == true:
		openDoor()
	else:
		closeDoor()
