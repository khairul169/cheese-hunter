extends Camera

func _ready():
	set_process(true);

func _process(delta):
	var trans = get_global_transform();
	trans.origin = trans.origin.linear_interpolate(get_node("../player").get_global_transform().origin+Vector3(0,2,7), 2*delta);
	set_global_transform(trans);