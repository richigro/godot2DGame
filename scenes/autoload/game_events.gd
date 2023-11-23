extends Node

# This node is emitting this signal named experience vial collected, for
# other nodes to listen
signal experience_vial_collected(number: float)

func emit_experience_vial_collected(number: float):
	# emit our own custom signal
	experience_vial_collected.emit(number)
