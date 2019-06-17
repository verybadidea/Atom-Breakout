'* Initial date = 2018-09-30
'* Last revision = 2018-09-30
'* Indent = tab

type sgl2d
	as single x, y
	declare operator cast () as string
end type

' "x, y"
operator sgl2d.cast () as string
	return str(x) & "," & str(y)
end operator

' distance / lenth
operator len (a as sgl2d) as single
	return sqr(a.x * a.x + a.y * a.y)
end operator

' a = b ?
operator = (a as sgl2d, b as sgl2d) as boolean
	if a.x <> b.x then return false
	if a.y <> b.y then return false
	return true
end operator

' a != b ?
operator <> (a as sgl2d, b as sgl2d) as boolean
	if a.x = b.x and a.y = b.y then return false
	return true
end operator

' a + b 
operator + (a as sgl2d, b as sgl2d) as sgl2d
	return type(a.x + b.x, a.y + b.y)
end operator

' a - b
operator - (a as sgl2d, b as sgl2d) as sgl2d
	return type(a.x - b.x, a.y - b.y)
end operator

' -a
operator - (a as sgl2d) as sgl2d
	return type(-a.x, -a.y)
end operator

' a * b
operator * (a as sgl2d, b as sgl2d) as sgl2d
	return type(a.x * b.x, a.y * b.y)
end operator

' a * mul
operator * (a as sgl2d, mul as single) as sgl2d
	return type(a.x * mul, a.y * mul)
end operator

' a / div
operator / (a as sgl2d, div as single) as sgl2d
	return type(a.x / div, a.y / div)
end operator
