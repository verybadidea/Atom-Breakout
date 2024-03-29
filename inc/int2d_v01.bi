'* Initial date = ????-??-??
'* Last revision = 2018-09-28
'* Indent = tab

type int2d
	as integer x, y
	declare operator cast () as string
end type

operator = (a as int2d, b as int2d) as boolean
	if a.x <> b.x then return false
	if a.y <> b.y then return false
	return true
end operator

operator <> (a as int2d, b as int2d) as boolean
	if a.x = b.x and a.y = b.y then return false
	return true
end operator

' "x, y"
operator int2d.cast () as string
  return str(x) & "," & str(y)
end operator

' a + b 
operator + (a as int2d, b as int2d) as int2d
	return type(a.x + b.x, a.y + b.y)
end operator

' a - b
operator - (a as int2d, b as int2d) as int2d
	return type(a.x - b.x, a.y - b.y)
end operator

' -a
operator - (a as int2d) as int2d
	return type(-a.x, -a.y)
end operator

' a * b
operator * (a as int2d, b as int2d) as int2d
	return type(a.x * b.x, a.y * b.y)
end operator

' a * mul
operator * (a as int2d, mul as integer) as int2d
	return type(a.x * mul, a.y * mul)
end operator

' a \ b
operator \ (a as int2d, b as int2d) as int2d
	return type(a.x \ b.x, a.y \ b.y)
end operator

' a \ div
operator \ (a as int2d, div as integer) as int2d
	return type(a.x \ div, a.y \ div)
end operator
