extends Node

var game = null;
var player = null;

var cheese = 0.0;
var total_cheese = 0;
var score = 0.0;
var high_score = 0.0;
var levels_parts = 1;

var savegame = File.new();
var save_path = "user://savegame.bin";

func _ready():
	get_tree().set_auto_accept_quit(false);
	load_savegame();

func _notification(what):
	if what == NOTIFICATION_UNPARENTED:
		save_savegame();

func load_savegame():
	var save_data;
	
	savegame.open_encrypted_with_pass(save_path, File.READ, "irul");
	save_data = savegame.get_var();
	savegame.close();
	
	if save_data != null:
		high_score = save_data.highscore;

func save_savegame():
	if score > high_score:
		high_score = score;
	
	var save_data = {"highscore":int(high_score)}
	
	savegame.open_encrypted_with_pass(save_path, File.WRITE, "irul");
	savegame.store_var(save_data);
	savegame.close();