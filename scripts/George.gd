
extends KinematicBody2D

export var MoveSpeed = 50
export var AnimationFPS = 5
export(NodePath) var CharacterNode
export(NodePath) var ToolAnimatorNode

signal CharacterActionSignal

const DIRECTION = {"S":0, "W":1, "N":2, "E":3}
const DIRECTION_ARRAY = ["S", "W", "N", "E"]

var DeltaPos = Vector2(0, 0)
var CharacterDirection = DIRECTION.S
var IsCharacterMoving = false
var SpriteAnimationFrame = 0
var TimeSinceFrameUpdate = 0
var ToolName = "Pickaxe"

var Constants
var CharacterSprite
var ToolAnimator

func _ready():
	if CharacterNode != null:
		CharacterSprite = get_node(CharacterNode)
	else:
		print("George::_ready - CharacterNode is null")
	Constants = get_node("/root/Constants")
	ToolAnimator = get_node(ToolAnimatorNode)
	set_process(true)
	set_process_input(true)

func _process(delta):
	TimeSinceFrameUpdate += delta
	var PrevDeltaPos = DeltaPos
	DeltaPos = Vector2(0, 0)
	InputTick(delta)
	ProcessMovement(delta)
	DetermineIsMoving()
	ProcessAnimation(delta)

# Process input on event
func _input(event):
	ProcessInput_Actions(event)

# Process input every tick
func InputTick(delta):
	ProcessInput_Movement()
	ProcessInput_Tools()
	
func ProcessInput_Actions(event):
	if event.is_action_pressed("character_action_main"):
		var ActionPosition = get_pos()
		if CharacterDirection == DIRECTION.S:
			ActionPosition.y += Constants.TILE_SIZE
		elif CharacterDirection == DIRECTION.N:
			ActionPosition.y -= Constants.TILE_SIZE
		elif CharacterDirection == DIRECTION.E:
			ActionPosition.x += Constants.TILE_SIZE
		elif CharacterDirection == DIRECTION.W:
			ActionPosition.x -= Constants.TILE_SIZE
		emit_signal("CharacterActionSignal", self, "Generic", ActionPosition)

func ProcessInput_Tools():
	if Input.is_action_pressed("character_tool_main"):
		var AnimationName = ToolName + "_" + DIRECTION_ARRAY[CharacterDirection]
		if ToolAnimator != null && !ToolAnimator.is_playing() && ToolAnimator.has_animation(AnimationName):
			ToolAnimator.play(AnimationName)
		# @TODO Handle tilling within the hoe tool

func ProcessInput_Movement():
	var NormalDelta = Vector2(0, 0)
	if Input.is_action_pressed("character_move_up"):
		CharacterDirection = DIRECTION.N
		NormalDelta.y = -1
	elif Input.is_action_pressed("character_move_down"):
		CharacterDirection = DIRECTION.S
		NormalDelta.y = 1
	if Input.is_action_pressed("character_move_left"):
		CharacterDirection = DIRECTION.W
		NormalDelta.x = -1
	elif Input.is_action_pressed("character_move_right"):
		CharacterDirection = DIRECTION.E
		NormalDelta.x = 1
	# Limit diagonal speed to max speed
	DeltaPos = NormalDelta.normalized() * MoveSpeed

func ProcessMovement(delta):
	var motion = move(DeltaPos * delta)
	if (is_colliding()):
		var normal = get_collision_normal()
		motion = normal.slide(motion)
		DeltaPos = normal.slide(DeltaPos)
		move(motion)

func DetermineIsMoving():
	IsCharacterMoving = DeltaPos.length_squared() != 0
	
func GetActionArea():
	return get_node("ActionAreas/ActionArea_" + DIRECTION_ARRAY[CharacterDirection])

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