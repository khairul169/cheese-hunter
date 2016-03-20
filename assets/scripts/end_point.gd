extends Area


func _ready():
	connect("body_enter", self, "on_body_enter");

func on_body_enter(body):
	if body extends KinematicBody && body in get_tree().get_nodes_in_group("player"):
		globals.game.get_node("gfx/second_interface").show();
		if globals.score > globals.high_score:
			globals.high_score = globals.score;
			globals.game.get_node("gfx/second_interface/etc").set_text(str("New Highscore: ", int(globals.high_score)));
			globals.game.get_node("gfx/second_interface/etc").show();
		globals.player.freeze = true;
		queue_free();