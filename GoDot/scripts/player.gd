extends Area2D

class_name Player

const PLAYER_START_POSITION = Vector2(0, 418)
const POSITION_INCREMENT = 64

@onready var sprite_2d = $Sprite2D
@onready var animation_player = $AnimationPlayer

@export var camera: Camera2D

@export var speed = 40


var new_position: Vector2 = Vector2.ZERO
var camera_bounds = {
	"left": 0,
	"right": 0,
	"bottom": 0
}

# Called when the node enters the scene tree for the first time.
func _ready():
	var camera_rect = camera.get_viewport_rect()
	camera_bounds.left = camera.position.x - camera_rect.size.x / 2
	camera_bounds.right = camera_bounds.left + camera_rect.size.x
	camera_bounds.bottom = camera.position.y + camera_rect.size.y / 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if new_position == Vector2.ZERO:
		return
	position = lerp(position, new_position, speed * delta)
	
	if absf((position - new_position).length()) < 0.001:
		position = round(position)
	else:
		animation_player.play("jump")

func _input(event):
	
	var position_candidate
	
	if Input.is_action_just_pressed("down"):
		position_candidate = Vector2.DOWN * POSITION_INCREMENT + position
		sprite_2d.rotation_degrees = 180
	
	elif Input.is_action_just_pressed("up"):
		position_candidate = Vector2.UP * POSITION_INCREMENT + position
		sprite_2d.rotation_degrees = 0
	
	elif Input.is_action_just_pressed("right"):
		position_candidate = Vector2.RIGHT * POSITION_INCREMENT + position
		sprite_2d.rotation_degrees = 90
	
	elif Input.is_action_just_pressed("left"):
		position_candidate = Vector2.LEFT * POSITION_INCREMENT + position
		sprite_2d.rotation_degrees = 270
	if !position_candidate:
		return
		
	if position_candidate.x > camera_bounds.right or position_candidate.x < camera_bounds.left or position_candidate.y > camera_bounds.bottom - POSITION_INCREMENT:
		return
	
	new_position = position_candidate
