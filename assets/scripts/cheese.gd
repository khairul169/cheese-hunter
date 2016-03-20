extends Area

var purging = false;

func _ready():
	purging = false;
	globals.total_cheese += 1;
	connect("body_enter", self, "on_body_enter");

func on_body_enter(body):
	if body extends KinematicBody && body in get_tree().get_nodes_in_group("player") && !purging:
		globals.cheese += 1;
		randomize();
		globals.score += rand_range(75,100);
		purging = true;
		get_node("AnimationPlayer").play("menghilang");

func remove():
	queue_free();