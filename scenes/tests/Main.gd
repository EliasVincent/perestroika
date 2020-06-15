extends Node2D

var myBody = preload("res://scenes/tests/Person.tscn")
var myPerson = preload("res://scenes/tests/Player.tscn")
onready var enemiesFolder = get_node("/root/Main/Enemies")

var dict := {}

func _ready():	
	var numOfSpawns = 1000
	for i in numOfSpawns:
		var grabbedInstance = myBody.instance()
		grabbedInstance.position = Vector2(rand_range(0, 800), rand_range(0, 800))
		enemiesFolder.add_child(grabbedInstance)
	createChunks()
		
func createChunks():
	var raster_size := Vector2(1, 1) # 50x50 pixel
	for enemy in get_tree().get_nodes_in_group("enemy"):
		var cell = (enemy.global_position / raster_size).floor()
		
		if not dict.has(cell):
			dict[cell] = [] 
			dict[cell].append(enemy)
	
func _process(delta):
	for array in dict.values():
		var defendingUsers = []
		var attackingUsers = []
		for i in array:
			if i.currentState == i.State.DEFEND:
				var temp = [i]
				defendingUsers += temp
			if i.currentState == i.State.ATTACK:
				var temp = [i]
				attackingUsers += temp
		for user in attackingUsers:
			print(user)
			user.get_node("Sprite").modulate = Color(0, 1, 0)
	
