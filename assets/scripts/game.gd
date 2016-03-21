extends Node

var timer = 0.0;

func _init():
	globals.cheese = 0;
	globals.total_cheese = 0;
	globals.score = 0;
	
	randomize();
	globals.levels_parts = rand_range(1,8);

func _ready():
	globals.game = self;
	globals.player = get_node("env/player");
	
	get_node("gfx/high_score").set_text(str("High Score: ", int(globals.high_score)));
	get_node("gfx/second_interface/btnNewGame").connect("pressed", self, "on_btnNewGame_pressed");
	get_node("gfx/second_interface/btnMenu").connect("pressed", self, "on_btnMenu_pressed");
	
	set_process_input(false);
	
	play();

func _input(ie):
	if ie.type == InputEvent.KEY:
		if ie.pressed && ie.scancode == KEY_ESCAPE:
			end_game();

func on_btnNewGame_pressed():
	get_tree().reload_current_scene();

func on_btnMenu_pressed():
	transition.fade_to("res://assets/scenes/mainmenu.scn");

func play():
	get_node("gfx/main_interface").show();
	timer = 4.0;
	set_process(true);

func _process(delta):
	timer -= delta;
	if timer <= 0.0:
		start_game();
		set_process_input(true);
		set_process(false);
	else:
		get_node("gfx/main_interface/title").set_text(str(int(timer)));

func start_game():
	get_node("gfx/main_interface").hide();
	get_node("env/player").freeze = false;

func end_game():
	globals.game.get_node("gfx/second_interface").show();
	if globals.score > globals.high_score:
		globals.high_score = globals.score;
		globals.game.get_node("gfx/second_interface/etc").set_text(str("New Highscore: ", int(globals.high_score)));
		globals.game.get_node("gfx/second_interface/etc").show();
	globals.player.freeze = true;