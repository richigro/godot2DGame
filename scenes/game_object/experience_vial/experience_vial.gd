extends Node2D


func _ready():
	$Area2D.area_entered.connect(on_area_entered)
	
	
func on_area_entered(other_area: Area2D):
	# adds one to the global experience counter
	GameEvents.emit_experience_vial_collected(1)
	# free object from memory
	queue_free()

