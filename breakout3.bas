'=== Atom breakout ===

#include once "inc/mouse_v01.bi"
#include once "inc/keyboard_v01.bi"
#include once "inc/sgl2d_v01.bi"
#include once "inc/loopTimer.bi"

const SCRN_W = 800, SCRN_H = 600
const as double MIN_DT = 2.0 / 1000 's

#include once "ball_type.bi"

'-------------------------------------------------------------------------------

sub setScreen(w as integer, h as integer)
	screenres w, h, 32
	width w \ 8, h \ 16
end sub

sub clearScreen(c as ulong)
	line(0, 0)-(SCRN_W - 1, SCRN_H - 1), c, bf
end sub

function toInt(p as sgl2d) as int2d
	return type<int2d>(p.x, p.y)
end function

function toSgl(p as int2d) as sgl2d
	return type<sgl2d>(p.x, p.y)
end function

function SgnSqr(a as single) as single
	return sgn(a) * a * a
end function

'-------------------------------------------------------------------------------

const BRICK_X_NUM = 12, BRICK_Y_NUM = 6

dim as string key
dim as integer quit
dim as mouseType mouse
dim as ball_type paddle
dim as ball_type ball
dim as ball_type brick(BRICK_X_NUM - 1, BRICK_Y_NUM - 1)
dim as loop_timer_type loopTimer
dim as int2d lastValidMousePos = type(SCRN_W \ 2, 0.9 * SCRN_H)
dim as integer yMinMouse = 0.8 * SCRN_H
dim as integer xi, yi, x, y
dim as integer numSteps, iStep
dim as double dtStep 's

setScreen(SCRN_W, SCRN_H)

paddle.init(type(0.5 * SCRN_W, 0.9 * SCRN_H), 30, 2000, 1000, 0.1, 10.0, rgb(127, 0, 0))
ball.init(type(0.5 * SCRN_W, 0.6 * SCRN_H), 10, 1000, 0.5, 1, 0.25, rgb(0, 127, 0))
ball.yMax = SCRN_H * 2

for yi = 0 to BRICK_Y_NUM - 1
	y = 0.05 * SCRN_H + 0.5 * SCRN_H * ((0.5 + yi) / BRICK_Y_NUM)
	for xi = 0 to BRICK_X_NUM - 1
		x = 0.1 * SCRN_W + 0.8 * SCRN_W * ((0.5 + xi) / BRICK_X_NUM)
		brick(xi, yi).init(type(x, y), 15, 1000, 1000, 0.2, 5.0, rgb(127, 127, 0))
		brick(xi, yi).setTarget(type(x, y))
		brick(xi, yi).intFmax = 1e3
	next
next

loopTimer.init()
while quit = 0
	key = inkey
	select case key
		case KEY_ESC : quit = 1
	end select

	handleMouse(mouse)
	if mouse.buttons <> -1 then
		lastValidMousePos = mouse.pos
		if lastValidMousePos.y < yMinMouse then lastValidMousePos.y = yMinMouse
	end if 

	'take smaller time steps for updates
	numSteps = int(loopTimer.dt / MIN_DT) + 1 'ceiling, at least 1 step
	dtStep = loopTimer.dt / numSteps
	for iStep = 0 to numSteps - 1
		'check inter-collisions
		ballColl(ball, paddle)
		for yi = 0 to BRICK_Y_NUM - 1
			for xi = 0 to BRICK_X_NUM - 1
				ballColl(ball, brick(xi, yi))
			next
		next
		'paddle / bat
		paddle.boundColl()
		paddle.setTarget(toSgl(lastValidMousePos))
		paddle.update(dtStep)
		'ball / bullet
		ball.boundColl()
		ball.setTarget(paddle.p)
		ball.update(dtStep)
		'update bricks
		for yi = 0 to BRICK_Y_NUM - 1
			for xi = 0 to BRICK_X_NUM - 1
				brick(xi, yi).update(dtStep)
			next
		next
	next
	if ball.p.y > SCRN_H then quit = 1

	screenlock
	line(0, 0)-(SCRN_W - 1, 0.8 * SCRN_H - 1), &h000000, bf
	line(0, 0.8 * SCRN_H)-(SCRN_W - 1, SCRN_H - 1), &h202020, bf
	for yi = 0 to BRICK_Y_NUM - 1
		for xi = 0 to BRICK_X_NUM - 1
			brick(xi, yi).draw_()
		next
	next
	paddle.draw_()
	ball.draw_()
	locate 1, 1 : print "Use mouse, <esc> to exit";
	screenunlock

	sleep 15
	loopTimer.update()
wend

draw string (0.5 * SCRN_W - 36, 0.65 * SCRN_H), "GAME OVER", &he0e0e0
while inkey = "" : wend

'Todo: Add spin
