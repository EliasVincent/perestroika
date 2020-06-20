extends Node2D

var myBody = preload("res://scenes/tests/Person.tscn")
var myPerson = preload("res://scenes/tests/Player.tscn")
var tower = preload("res://scenes/tests/Tower.tscn")
onready var enemiesFolder = get_node("/root/Main/Enemies")
onready var towersFolder = get_node("/root/Main/Towers")


var dict := {}

signal hasDied

func _ready():

	
	PlayerData.FAME = PlayerData.StartFAME
	PlayerData.Health = PlayerData.StartHealth # resets the health when retrying
	randomize() # randomizes the seed, otherwise the RnG would always be the same
	
	#Random hole 1
	var xlength = rand_range(0, 200)
	var ylength = rand_range(0, 200)
	var xPos = rand_range(200, 1200)
	var yPos = rand_range(0, 1200)
	#Random hole 2
	var xlength2 = rand_range(0, 250)
	var ylength2 = rand_range(0, 250)
	var xPos2 = rand_range(300, 1100)
	var yPos2 = rand_range(0, 900)
	#Random hole 3
	var xlength3 = rand_range(0, 100)
	var ylength3 = rand_range(0, 100)
	var xPos3 = rand_range(400, 900)
	var yPos3 = rand_range(0, 900)
	
	#Tower Spawn
	var numOfTowers = 3
	for i in numOfTowers:
		var spawnedTower = tower.instance()
		spawnedTower.position = Vector2(rand_range(0, 900), rand_range(0, 900))
		towersFolder.add_child(spawnedTower)

	#Enemy Spawn
	var numOfSpawns = 1500
	for i in numOfSpawns:
		var grabbedInstance = myBody.instance()
		grabbedInstance.position = Vector2(rand_range(-200, 1200), rand_range(-200, 1200))
		while grabbedInstance.position.x < xPos + xlength and grabbedInstance.position.x > xPos - xlength and grabbedInstance.position.y < yPos + ylength and grabbedInstance.position.y > yPos - ylength:
			grabbedInstance.position = Vector2(rand_range(-200, 1200), rand_range(-200, 1200))
		while grabbedInstance.position.x < xPos2 + xlength2 and grabbedInstance.position.x > xPos2 - xlength2 and grabbedInstance.position.y < yPos2 + ylength2 and grabbedInstance.position.y > yPos2 - ylength2:
			grabbedInstance.position = Vector2(rand_range(-200, 1200), rand_range(-200, 1200))
		while grabbedInstance.position.x < xPos3 + xlength3 and grabbedInstance.position.x > xPos3 - xlength3 and grabbedInstance.position.y < yPos3 + ylength3 and grabbedInstance.position.y > yPos3 - ylength3:
			grabbedInstance.position = Vector2(rand_range(-200, 1200), rand_range(-200, 1200))
		enemiesFolder.add_child(grabbedInstance)
		
	for tower in get_tree().get_nodes_in_group("towers"):
		var randNum = rand_range(15, 30)
		for i in randNum:
			var grabbedInstance = myBody.instance()
			grabbedInstance.position = tower.position + Vector2(rand_range(-100, 100), rand_range(-100, 100))
			grabbedInstance.mad = true
			enemiesFolder.add_child(grabbedInstance)
	
func _process(delta):
	
	if PlayerData.Health <= 0:
		$AnimationPlayer.play("player_death")

func playerDeath():
	get_tree().change_scene("res://scenes/UI/GameOverPanel.tscn")
	
func emitDeath():
	emit_signal("hasDied")


func _on_CountDownTimer_timeout():
	$AnimationPlayer.play("player_death")
