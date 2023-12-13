extends Node2D

@onready var collision_shape_2d = $Area2D/CollisionShape2D
@onready var sprite = $Sprite2D



func _ready():
	$Area2D.area_entered.connect(on_area_entered)


func tween_collect(percent: float, start_position: Vector2):
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	# start_position is the start position of the vial when the player entered its area
	global_position = start_position.lerp(player.global_position, percent)
	var direction_from_start = player.global_position - start_position
	
	var target_rotation = direction_from_start.angle() + deg_to_rad(90)
	# will help with smoothness of animation
	rotation = lerp_angle(rotation, target_rotation, 1 - exp(-2 * get_process_delta_time()))


func disable_collition():
	collision_shape_2d.disabled = true


func collect():
	# adds one to the global experience counter
	GameEvents.emit_experience_vial_collected(1)
	# free object from memory
	queue_free()


func on_area_entered(other_area: Area2D):
	# this is the only way to disable a collision shape inside of a function that runs
	# because of the area_entered signal.Other methods will result in an error
	Callable(disable_collition).call_deferred()
	# animate vials moving towards palyer
	var tween = create_tween()
	# runs all the tween methods below at the same time in parallel
	tween.set_parallel()
	# we bind to be able to pass in a second argument to our tween_collect function
	# the global_position of the experience vial
	tween.tween_method(tween_collect.bind(global_position), 0.0, 1.0, 0.5)\
	.set_ease(Tween.EASE_IN)\
	.set_trans(Tween.TRANS_BACK)
	# set delay so that it starts after the previous tween method
	tween.tween_property(sprite, "scale", Vector2.ZERO, 0.05).set_delay(0.45)
	# tween.chain waits for previous tweens to finish before running the next tween method
	tween.chain()
	tween.tween_callback(collect)
	# play random pick up sound effect
	$RandomStreamPlayer2DComponent.play_random()

