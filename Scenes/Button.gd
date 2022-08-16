extends Area2D

export(NodePath) onready var tilemap = get_node("../Cables")
export(NodePath) onready var world = get_node("..")

var power = false
var tile = null
var connection = null
var cables = null
export var active = false setget set_active
var cables_copy = null
export var powerState = false
signal power(value)

func startup():
	for t in tilemap.get_used_cells():
		if tilemap.map_to_world(t) == self.position:
			tile = t
			connection = world.run_test(tile)
			cables = world.generate(connection)

func _unhandled_input(event):
	if Input.is_action_just_pressed("mouse_right"):
		world.tilemap.set_cellv(Vector2(8,3), 15)
		world.delete_connection(connection)
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
			emit_signal("power", false)
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
			emit_signal("power", true)
			

func animate(bar, maxValue):
	$Tween.interpolate_property(bar, "value",
	bar.value, maxValue, 0.5, 0, Tween.EASE_IN_OUT)
	$Tween.start()

func _on_Button_area_entered(area):
	if area.is_in_group("DoorOpen"):
		self.set_active(true)

func _on_Button_area_exited(area):
	if area.is_in_group("DoorOpen"):
		self.set_active(false)



