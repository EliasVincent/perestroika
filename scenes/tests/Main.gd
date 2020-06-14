extends Node2D

var myBody = preload("res://scenes/tests/Person.tscn")
var myPerson = preload("res://scenes/tests/Player.tscn")
onready var enemiesFolder = get_node("/root/Main/Enemies")

func _ready():	
	var numOfSpawns = 1000
	for i in numOfSpawns:
		var grabbedInstance = myBody.instance()
		grabbedInstance.position = Vector2(rand_range(0, 800), rand_range(0, 800))
		enemiesFolder.add_child(grabbedInstance)
	
