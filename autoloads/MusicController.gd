extends Node


var standard_loop = load("res://TestLoop1.mp3")

func _ready():
	
	pass

func play_music():
	
	$Music.stream = standard_loop
	$Music.play()
