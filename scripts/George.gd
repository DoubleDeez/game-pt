
extends KinematicBody2D

export var MoveSpeed = 50
export var AnimationFPS = 5
export(NodePath) var CharacterNode

signal CharacterActionSignal

const DIRECTION = {"S":0, "W":1, "N":2, "E":3}

var DeltaPos = Vector2(0, 0)
var CharacterDirection = DIRECTION.S
var IsCharacterMoving = false
var SpriteAnimationFrame = 0
var CharacterSprite
var TimeSinceFrameUpdate = 0

func _ready():
	if CharacterNode != null:
		CharacterSprite = get_node(CharacterNode)
	else:
		print("Geroge::_ready - CharacterNode is null")
	set_process(true)

func _process(delta):
	TimeSinceFrameUpdate += delta
	var PrevDeltaPos = DeltaPos
	DeltaPos = Vector2(0, 0)
	ProcessInput()
	ProcessMovement(delta)
	if DeltaPos.length_squared() != 0 || PrevDeltaPos.length_squared() != 0:
		DetermineIsMoving()
		ProcessAnimation(delta)
	
func ProcessInput():
	ProcessInput_Movement()
	ProcessInput_Actions()
		
func ProcessInput_Actions():
	if Input.is_action_just_pressed("character_action_main"):
		emit_signal("CharacterActionSignal", self, "Generic")
		
func ProcessInput_Movement():
	if Input.is_action_pressed("character_move_up"):
		CharacterDirection = DIRECTION.N
		DeltaPos.y -= MoveSpeed
	if Input.is_action_pressed("character_move_down"):
		CharacterDirection = DIRECTION.S
		DeltaPos.y += MoveSpeed
	if Input.is_action_pressed("character_move_left"):
		CharacterDirection = DIRECTION.W
		DeltaPos.x -= MoveSpeed
	if Input.is_action_pressed("character_move_right"):
		CharacterDirection = DIRECTION.E
		DeltaPos.x += MoveSpeed
	
func ProcessMovement(delta):
	var motion = move(DeltaPos * delta)
	if (is_colliding()):
		var normal = get_collision_normal()
		motion = normal.slide(motion)
		DeltaPos = normal.slide(DeltaPos)
		move(motion)
		
func DetermineIsMoving():
	IsCharacterMoving = DeltaPos.length_squared() != 0
	
func ProcessAnimation(delta):
	if CharacterSprite != null:
		if IsCharacterMoving:
			if TimeSinceFrameUpdate >= (1.0/AnimationFPS):
				SpriteAnimationFrame = (SpriteAnimationFrame + 1) % CharacterSprite.get_vframes()
				TimeSinceFrameUpdate = 0
		else:
			SpriteAnimationFrame = 0
		CharacterSprite.set_frame(CharacterDirection + SpriteAnimationFrame * CharacterSprite.get_vframes())
	else:
		print("Geroge::ProcessAnimation - CharacterSprite is null")