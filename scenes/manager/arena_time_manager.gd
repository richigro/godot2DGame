extends Node

signal arena_difficulty_increased(arena_difficulty: int)

# how often in seconds we increase the game's difficulty
const DIFFICULTY_INTERVAL = 5

@export var end_screen_scene: PackedScene

# assigns a node to a variable only when the node becomes ready
@onready var timer = $Timer as Timer

var arena_difficulty = 0

func _ready():
	timer.timeout.connect(on_timer_timeout)

func _process(delta):
	# read the wait time on every frame
	var next_time_target = timer.wait_time - ((arena_difficulty + 1) * DIFFICULTY_INTERVAL)
	if timer.time_left <= next_time_target:
		arena_difficulty += 1
		arena_difficulty_increased.emit(arena_difficulty)

func get_time_elapsed():
	return timer.wait_time - timer.time_left


func on_timer_timeout():
	var end_screen_instance = end_screen_scene.instantiate()
	add_child(end_screen_instance)
