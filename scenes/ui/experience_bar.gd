extends CanvasLayer

# grab a reference to the experience manager node
@export var experience_manger: Node
# grab a reference to the progress bar, which is a grandchild node of this node
@onready var progress_bar = $MarginContainer/ProgressBar
# we need to listen the the event emitted by the 
func _ready():
	progress_bar.value = 0
	# connect to the signal emitted by the experience manager node
	experience_manger.experience_updated.connect(on_experience_updated)

func on_experience_updated(current_experience: float, target_experience: float):
	var percentage = current_experience / target_experience
	progress_bar.value = percentage
