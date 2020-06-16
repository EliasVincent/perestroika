extends Node2D

var myBody = preload("res://scenes/tests/Person.tscn")
var myPerson = preload("res://scenes/tests/Player.tscn")
onready var enemiesFolder = get_node("/root/Main/Enemies")

var dict := {}

signal hasDied

func _ready():
	PlayerData.FAME = PlayerData.StartFAME
	PlayerData.Health = PlayerData.StartHealth # resets the health when retrying
	randomize() # randomizes the seed, otherwise the RnG would always be the same

	var numOfSpawns = 1000
	for i in numOfSpawns:
		var grabbedInstance = myBody.instance()
		grabbedInstance.position = Vector2(rand_range(0, 800), rand_range(0, 800))
		enemiesFolder.add_child(grabbedInstance)
	
func _process(delta):			
	if PlayerData.Health <= 0:
		$AnimationPlayer.play("player_death")

func playerDeath():
	get_tree().change_scene("res://scenes/UI/GameOverPanel.tscn")
	
func emitDeath():
	emit_signal("hasDied")
