type loop_timer_type
	'private:
	dim as double tNow
	dim as double tPrev
	dim as double dt
	dim as double dtAvg
	public:
	declare sub init()
	declare sub update()
end type

sub loop_timer_type.init()
	tNow = timer
	tPrev = tNow
	dt = 0.0
	dtAvg = 0.0
end sub

sub loop_timer_type.update()
	tPrev = tNow
	tNow = timer
	dt = tNow - tPrev
	dtAvg = 0.95 * dtAvg + 0.05 * dt
end sub
