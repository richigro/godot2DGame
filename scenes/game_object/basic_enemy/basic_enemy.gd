extends CharacterBody2D

const MAX_SPEED = 50

@onready var health_component: HealthComponent = $HealthComponent


func _process(delta):
	var direction = get_direction_to_player()
	# this property comes from the class of CharacterBody2D which we are extending
	velocity = direction * MAX_SPEED
	move_and_slide()


func get_direction_to_player():
	var player_node = get_tree().get_first_node_in_group("player") as Node2D
	if player_node != null:
		# vector substraction to get a direction. The second global postion belongs to this entity.
		# we normalized this to turn it into a normalized vector
		return (player_node.global_position - global_position).normalized()
	# if the player_node is null
	return Vector2.ZERO
