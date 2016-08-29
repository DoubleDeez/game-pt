
extends AnimatedSprite

export var MoveSpeed = 50

var DeltaPos = Vector2(0, 0)

func _ready():
    set_process(true)

func _process(delta):
	var PrevDeltaPos = DeltaPos
	DeltaPos = Vector2(0, 0)
	ProcessInput()
	ProcessIdleState(PrevDeltaPos)
	
	set_pos(get_pos() + DeltaPos * delta)
	
func ProcessInput():
	if Input.is_action_pressed("character_move_up"):
		print("up")
		DeltaPos.y -= MoveSpeed
		play("Up")
	if Input.is_action_pressed("character_move_down"):
		print("down")
		DeltaPos.y += MoveSpeed
		play("Down")
	if Input.is_action_pressed("character_move_left"):
		print("left")
		DeltaPos.x -= MoveSpeed
		play("Left")
	if Input.is_action_pressed("character_move_right"):
		print("right")
		DeltaPos.x += MoveSpeed
		play("Right")
		
func ProcessIdleState(PrevDeltaPos):
	if DeltaPos.length_squared() == 0:
		if PrevDeltaPos.y < 0:
			play("Up_idle")
		if PrevDeltaPos.y > 0:
			play("Down_idle")
		if PrevDeltaPos.x < 0:
			play("Left_idle")
		if PrevDeltaPos.x > 0:
			play("Right_idle")