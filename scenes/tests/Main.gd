extends Node2D

var myBody = preload("res://scenes/tests/Person.tscn")

func _ready():
	var numOfSpawns = 500
	for i in numOfSpawns:
		var grabbedInstance = myBody.instance()
		grabbedInstance.position = Vector2(rand_range(0, 800), rand_range(0, 800))
		self.add_child(grabbedInstance)
	
	
	
