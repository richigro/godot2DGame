extends Node
# this line allow us to cast things to health componet 
class_name HealthComponent

# sends a signal to whoever's listening that the thing died.
signal died

@export var max_health: float = 10
var current_health

func _ready():
	current_health = max_health

func damage(damage_amount: float):
	# substract the damage delt until zero
	current_health = max(current_health - damage_amount, 0)
	# take the check_death function and only call it on the next idle frame
	Callable(check_death).call_deferred()


func check_death():
	if current_health == 0:
		died.emit()
		# The owner is the root node of the scene that this node exist in
		owner.queue_free()
