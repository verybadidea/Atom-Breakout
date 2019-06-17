type ball_type
	dim as sgl2d p 'position
	dim as sgl2d v 'velocity
	dim as sgl2d F 'force [N]
	dim as single r = 15 'raduis [px]
	dim as single kc = 1000 'compression spring constant [N/px]
	dim as single ka = 1 'attraction spring constant [N/px]
	dim as single m = 1.0 'mass [kg]
	dim as single b = 0.5 'Linear drag coexficient [N/(px/s)]
	dim as single intF, intFmax = -1
	dim as single xMin = 0, xMax = SCRN_W-1
	dim as single yMin = 0, yMax = SCRN_H-1
	dim as ulong colour
	dim as ulong active = 1
	dim as sgl2d pt 'target pos
	declare sub init(p as sgl2d, r as single, kc as  single, ka as  single, m as single, b as single, c as ulong)
	declare sub boundColl() 'wall / boundary collisions 
	declare sub setTarget(targetPos as sgl2d)
	declare sub update(dt as double)
	declare sub draw_()
end type

sub ball_type.init(p as sgl2d, r as single, kc as  single, ka as  single, m as single, b as single, c as ulong)
	this.p = p
	this.r = r
	this.kc = kc
	this.ka = ka
	this.m = m
	this.b = b
	this.colour = c
end sub

sub ball_type.boundColl()
	dim as single edgeDist
	edgeDist = (p.x - r) - xMin
	if (edgeDist < 0) then F.x -= kc * edgeDist
	edgeDist = (p.y - r) - yMin
	if (edgeDist < 0) then F.y -= kc * edgeDist
	edgeDist = xMax - (p.x + r)
	if (edgeDist < 0) then F.x += kc * edgeDist
	edgeDist = yMax - (p.y + r)
	if (edgeDist < 0) then F.y += kc * edgeDist
end sub

sub ball_type.setTarget(targetPos as sgl2d)
	pt = targetPos
end sub

sub ball_type.update(dt as double)
	dim as sgl2d a 'acceleration
	dim as sgl2d dp = pt - p 'delta position
	F += dp * ka 'F = k * x
	if intFmax > 0 then
		intF += len(F) * dt
		if intF > intFmax then active = 0
	end if
	F -= v * b 'drag
	a = F / m 'F = m * a -> a = F  / m
	v += a * dt
	'if len(v) > vMax then v *= (vMax / len(v))
	p += v * dt
	F = type(0, 0) 'reset for next run
end sub

sub ball_type.draw_()
	if active = 1 then
		circle (p.x, p.y), r, colour,,,,f
		if intFmax > 0 then
			dim as integer damage = 9 - int(10 * (intF / intFmax))
			draw string (p.x - 3, p.y - 7), str(damage), rgb(255, 255, 0)
		end if
	end if
end sub

'-------------------------------------------------------------------------------

sub ballColl(byref b1 as ball_type, byref b2 as ball_type)
	if (b1.active = 1) and (b2.active = 1) then
		dim as single dx = b1.p.x - b2.p.x
		dim as single dy = b1.p.y - b2.p.y
		dim as single cntrDist = sqr(dx * dx + dy * dy)
		dim as single edgeDist = cntrDist - (b1.r + b2.r)
		if(edgeDist < 0) then
			dim as single factor = edgeDist / cntrDist
			dim as single F1 = b1.kc * factor
			b1.F.x -= F1 * dx
			b1.F.y -= F1 * dy
			dim as single F2 = b2.kc * factor
			b2.F.x += F2 * dx
			b2.F.y += F2 * dy
		end if
	end if
end sub
