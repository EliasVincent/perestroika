extends Node2D

var myBody = preload("res://scenes/tests/Person.tscn")

func _ready():
	var numOfSpawns = 5
	for i in numOfSpawns:
		var grabbedInstance = myBody.instance()
		self.add_child(grabbedInstance)
	
	
	
