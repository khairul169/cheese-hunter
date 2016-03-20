extends Node

func _init():
	globals.cheese = 0;
	globals.total_cheese = 0;
	globals.score = 0;

func _ready():
	globals.game = self;
	globals.player = get_node("env/player");
	
	get_node("gfx/high_score").set_text(str("High Score: ", int(globals.high_score)));
	get_node("gfx/main_interface").show();
	get_node("gfx/main_interface/Button").connect("pressed", self, "on_btnPlay_pressed");
	get_node("gfx/second_interface/Button").connect("pressed", self, "on_btnNewGame_pressed");

func on_btnPlay_pressed():
	get_node("gfx/main_interface").hide();
	get_node("env/player").freeze = false;

func on_btnNewGame_pressed():
	get_tree().reload_current_scene();