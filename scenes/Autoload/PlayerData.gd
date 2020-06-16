extends Node

export var Health: = 100
export var StartHealth: = 100

export var FAME: = 150
export var StartFAME: = 150

func play_hit_by_enemy_audio():
	$HitByEnemyAudioPlayer.play()
