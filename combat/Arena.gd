# script arena
extends Node

var width
var height
var someone_died = 0

export (float) var size_multiplier = 1.0

var debug = false

onready var DebugNode = $Debug/DebugNode
onready var Battlefield = $Battlefield
onready var Pause = $Pause/EndBattle
onready var SpawnPlayers = $SpawnPositions/Players

const Ship = preload("res://actors/battlers/Ship.tscn")

signal screensize_changed(screensize)
var run_time = 0

func compute_arena_size():
	"""
	compute the battlefield size
	"""
	width = OS.window_size.x * size_multiplier
	height = OS.window_size.y * size_multiplier
	emit_signal("screensize_changed", Vector2(width, height))
	print(width, " ", height, "  ")
	return true
	
func _ready():
	compute_arena_size()
	# in order to get the size
	get_tree().get_root().connect("size_changed", self, "compute_arena_size")
	run_time = OS.get_ticks_msec()
	
	# get number of players
	# n_players = get_num_players()
	
	# Analytics
	analytics.start_elapsed_time()
	
	# setup spawners
	for spawner in Battlefield.get_children():
		if spawner.is_in_group("spawner"):
			spawner.spawn()
			
	for player in SpawnPlayers.get_children():
		var ship = Ship.instance()
		ship.position = player.position
		ship.rotation = player.rotation
		ship.height = height
		ship.width = width
		Battlefield.add_child(ship)
		connect("screensize_changed", ship, "update_wraparound")
		
	
func _unhandled_input(event):
	var debug_pressed = event.is_action_pressed("debug")
	if debug_pressed:
		debug = not debug
		OS.window_fullscreen = !OS.window_fullscreen
		DebugNode.visible = debug
		
	# reset by command only through debug
	if event.is_action_pressed('continue') and debug:
		reset()
	
func reset(level):
	someone_died = false
	get_tree().change_scene_to(load("res://screens/game_screen/levels/"+level))
	#get_tree().reload_current_scene()

func get_num_players():
	return 4


func _on_mantiacs_background_item_rect_changed():
	print("changed")