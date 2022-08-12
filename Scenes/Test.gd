extends Control

onready var progressBar2 = $TextureProgress2
onready var progressBar3 = $TextureProgress3
onready var tween = $Tween2

signal updateDoor(value)

# Called when the node enters the scene tree for the first time.
func _ready():
	move()

func move():
	tween.interpolate_property(progressBar2, "value",
	0, 100, 2, 0, Tween.EASE_IN_OUT)
	tween.start()

# warning-ignore:unused_argument
func _on_Tween_tween_completed(object, key):
	if object.get_name() == "TextureProgress":
		tween.interpolate_property(progressBar2, "value",
		0, 100, 0.5, 0, Tween.EASE_IN_OUT)
		tween.start()
		tween.interpolate_property(progressBar3, "value",
		0, 100, 0.5, 0, Tween.EASE_IN_OUT)
		tween.start()

func _on_Tween_tween_all_completed():
	emit_signal("updateDoor", "open")

