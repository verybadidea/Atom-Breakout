'* Initial date = ????-??-??
'* Last revision = 2018-09-28
'* Indent = tab

const as string KEY_UP = chr(255) & "H"
const as string KEY_DN = chr(255) & "P"
const as string KEY_LE = chr(255) & "K"
const as string KEY_RI = chr(255) & "M"
const as string KEY_BACK = chr(8)
const as string KEY_ENTER = chr(13)
const as string KEY_ESC = chr(27)
const as string KEY_SPC = chr(32)

function waitForKey() as string
	dim as string key = inkey
	while key = ""
		key = inkey
		sleep 1,1
	wend
	return key
end function

'~ const as ushort KEY_UP = &h48FF
'~ const as ushort KEY_RI = &h4DFF
'~ const as ushort KEY_DN = &h50FF
'~ const as ushort KEY_LE = &h4BFF
'~ const as ushort KEY_W = &h77
'~ const as ushort KEY_A = &h61
'~ const as ushort KEY_S = &h73
'~ const as ushort KEY_D = &h64
'~ const as ushort KEY_ENTER = &h0D
'~ const as ushort KEY_ESC = &h1B
'~ const as ushort KEY_TAB = &h09
'~ const as ushort KEY_BACK = &h08
'~ const as ushort KEY_SPACE = &h20

'~ function waitKeyCode() as ushort
	'~ return getkey() 'getkey is weird
'~ end function

'~ function pollKeyCode() as ushort
	'~ dim as string key = inkey()
	'~ if (key = "") then return 0
	'~ if (key[0] = 255) then
		'~ return *cast(ushort ptr, strptr(key))
		'~ 'return (key[1] shl 8) or key[0]
	'~ else
		'~ return key[0]
	'~ end if
'~ end function

#include once "fbgfx.bi"

'Class for extended multikey functionality
type multikey_type
	private:
		m_oldKey(127) as boolean
		m_newKey(127) as boolean
	public:
		declare function down(byval as long) as boolean
		declare function pressed(byval as long) as boolean
		declare function released(byval as long) as boolean
end type

'Returns whether a key is being held
function multikey_type.down(byval index as long) as boolean
	return cbool(multiKey(index))
end function

'Returns whether a key was pressed
function multikey_type.pressed(byval index as long) as boolean
	m_oldKey(index) = m_newKey(index)
	m_newKey(index) = cbool(multiKey(index))
	return (m_oldKey(index) = false) andalso (m_newKey(index) = true)
end function

'Returns whether a key was released
function multikey_type.released(byval index as long) as boolean
	m_oldKey(index) = m_newKey(index)
	m_newKey(index) = cbool(multiKey(index))
	return (m_oldKey(index) = true) andalso (m_newKey(index) = false)
end function

'-------------------------------------------------------------------------------

'Example use:
'~ dim as multikey_type mkey

'~ do
	'~ if mkey.released(FB.SC_UP) then _
		'~ print "mkey.released(FB.SC_UP)"
	'~ if mkey.down(FB.SC_DOWN) then _
		'~ print "mkey.down(FB.SC_DOWN)"
	'~ if mkey.pressed(FB.SC_LEFT) then _
		'~ print "mkey.pressed(FB.SC_LEFT)"
	'~ if mkey.down(FB.SC_RIGHT) then _
		'~ print "mkey.down(FB.SC_RIGHT)"
	'~ sleep(1, 1)
'~ loop until mkey.pressed(FB.SC_ESCAPE)


