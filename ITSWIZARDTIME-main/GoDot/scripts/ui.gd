extends CanvasLayer

class_name UI

const MAX_TIMER_VALUE = 30

signal timer_runs_out

@onready var life_container = %lifeContainer
@onready var timeout_timer = $"timeout Timer"
@onready var progress_bar = %ProgressBar

var life_texture = preload("res://Assets/FroggerIdle.png")
var lives_texture: Array[TextureRect] = []

func set_lives(lives_amount: int):
	for i in lives_amount:
		var texture_rect = TextureRect.new()
		texture_rect.custom_minimum_size = Vector2 (32,16)
		texture_rect.texture = life_texture
		texture_rect.texture_filter = TextureRect.TEXTURE_FILTER_NEAREST
		life_container.add_child(texture_rect)
		lives_texture.append(texture_rect)
		

func _ready():
	timeout_timer.timeout.connect(on_timeout)
	timeout_timer.start()
	
func on_timeout():
	var new_progress_bar_value = progress_bar.value - 1
	progress_bar.set_value(new_progress_bar_value)
	if new_progress_bar_value == 0:
		timer_runs_out.emit()
		timeout_timer.stop()

func reset_timer():
	progress_bar.set_value(MAX_TIMER_VALUE)
	timeout_timer.start()

func loose_life():
	var life_texture = lives_texture.pop_back()
	life_texture.queue_free()
