extends Camera


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var player = get_parent().get_node("Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	transform.origin.x = player.transform.origin.x/2
	pass
