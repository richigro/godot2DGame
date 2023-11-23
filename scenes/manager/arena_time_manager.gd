extends Node

# assigns a node to a variable only when the node becomes ready
@onready var timer = $Timer as Timer

func get_time_elapsed():
	return timer.wait_time - timer.time_left


