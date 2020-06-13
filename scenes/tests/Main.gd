extends Node2D

var myBody = preload("res://scenes/tests/RigidBody2D.tscn")

func _ready():
	var numOfSpawns = 5
	for i in numOfSpawns:
		var grabbedInstance = myBody.instance()
		self.add_child(grabbedInstance)
	
	
	
