tool
extends Control

export var nextScene: PackedScene


func _ready():
	pass

func _on_Play_Button_pressed():
	get_tree().change_scene_to(nextScene)

func _on_Jam_Link_Button_pressed():
	OS.shell_open("https://itch.io/jam/godot-wild-jam-22")

func _on_About_Button_pressed():
	$"About Button/AboutDialog".popup_centered()

func _on_Source_Link_Button_pressed():
	OS.shell_open("https://github.com/EliasVincent/godot-wild-jam-22-game")


func _on_Tutorial_Button_pressed():
	get_tree().change_scene("res://scenes/UI/Tutorial Cutscene.tscn")
	
func _process(delta):
	if Input.is_action_just_pressed("start_button"):
		get_tree().change_scene_to(nextScene)
