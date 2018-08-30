extends "res://screens/basic_screen.gd"

func _ready():
	$VBoxContainer.add_constant_override("separation", 6)
	$VBoxContainer/StartCPU.grab_focus()
	persistance.load_game()
	"""
	if !bgm_creation.is_playing():
		bgm_creation.play()
	
	"""

func _on_Credits_pressed():
	change_scene("res://screens/credit_screen/credit_screen.tscn")

func _on_StartCPU_pressed():
	global.enemy = "CPU"
	change_scene()

func _on_StartHuman_pressed():
	global.enemy = "Human"
	change_scene()


func _on_Save_pressed():
	persistance.save_game()
	if persistance.load_game():
		$VBoxContainer/Save/Label.text = "good job!"
		global.reset()
