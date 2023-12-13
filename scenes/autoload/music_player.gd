extends AudioStreamPlayer


func _ready():
	finished.connect(on_finished)
	$Timer.timeout.connect(on_timer_timeout)


# this function will run when the song reaches the end
func on_finished():
	$Timer.start()


func on_timer_timeout():
	play()
