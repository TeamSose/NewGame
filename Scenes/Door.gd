extends Area2D

export(NodePath) onready var input = get_node(input)

var somethingIn = false
var open = false

func _physics_process(delta):
	update_Door()

func startup():
	pass
# Called when the node enters the scene tree for the first time.
func openDoor():
	$AnimationPlayer.play("Open")
	open = true
	
func closeDoor():
	if !somethingIn:
		$AnimationPlayer.play("Close")
		open = false

func _on_Door_area_entered(area):
	if area.is_in_group("DoorOpen"):
		somethingIn = true
		print("Something In")

func _on_Door_area_exited(area):
	if area.is_in_group("DoorOpen"):
		somethingIn = false
		print("Nothing In")

func update_Door():
	if input.power == true && open == false:
		openDoor()
	if input.power == false && open == true:
		closeDoor()
