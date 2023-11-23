extends Camera2D


var target_position = Vector2.ZERO # a vector with zero x and zero y component

func _ready():
	make_current()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# update our target position every frame
	acquire_target()
	# lerp = linear interpolate. This creates a small lag in the camera following the player, and thus it will
	# appear to be smoother, rather than if the camera was following the palyer instanteneously.
	# explanation here: https://www.rorydriscoll.com/2016/03/07/frame-rate-independent-damping-using-lerp/
	# This smoothing variable can be adjusted to get the right feeling for the camera following the player
	var smoothing_value = 20
	global_position = global_position.lerp(target_position, 1.0 - exp(-delta * smoothing_value))


func acquire_target():
	var player_nodes = get_tree().get_nodes_in_group("player")
	if player_nodes.size() > 0:
		var player = player_nodes[0] as Node2D
		target_position = player.global_position
