extends Area


func _ready():
	connect("body_enter", self, "on_body_enter");

func on_body_enter(body):
	if body extends KinematicBody && body in get_tree().get_nodes_in_group("player"):
		globals.game.end_game();
		queue_free();