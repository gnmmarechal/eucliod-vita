--Rewrite of Eucliod's index.lua for lpp-vita
-- By gnmmarechal


-- Setting directories
local appdir = "ux0:/data/Eucliod"

local scrdir = appdir.."/screenshots"
local lvldir = appdir.."/levels"

-- Colours
local c_white = Color.new(255,255,255)
local c_light = Color.new(178,216,255)
local c_red = Color.new(255,0,0)
local c_ship = Color.new(76,165,255)
local c_bg = Color.new(28,84,140)
local c_black = Color.new(0,0,0)
local c_green = Color.new(0,255,0)

-- Game stuff

theme = 1

themedb = {}
themedb.ship = {}
themedb.enemy = {}
themedb.bullet = {}
themedb.null = {}
themedb.bg = {}
themedb.hit1 = {}
themedb.hit2 = {}

themedb.ship[0] = Color.new(180,180,180)
themedb.enemy[0] = Color.new(200,200,200)
themedb.bullet[0] = Color.new(255,255,255)
themedb.null[0] = Color.new(230,230,230)
themedb.bg[0] = Color.new(0,0,0)
themedb.hit1[0] = 200
themedb.hit2[0] = 255

themedb.ship[1] = Color.new(76,165,245)
themedb.enemy[1] = Color.new(142,173,204)
themedb.bullet[1] = Color.new(178,216,255)
themedb.null[1] = Color.new(178,216,235)
themedb.bg[1] = Color.new(28,84,140)
themedb.hit1[1] = 204
themedb.hit2[1] = 255

themedb.ship[2] = Color.new(76,245,136)
themedb.enemy[2] = Color.new(142,204,173)
themedb.bullet[2] = Color.new(178,255,204)
themedb.null[2] = Color.new(178,235,203)
themedb.bg[2] = Color.new(27,137,64)
themedb.hit1[2] = 173
themedb.hit2[2] = 204

themedb.ship[3] = Color.new(245,76,76)
themedb.enemy[3] = Color.new(204,142,142)
themedb.bullet[3] = Color.new(255,178,178)
themedb.null[3] = Color.new(235,178,177)
themedb.bg[3] = Color.new(135,27,27)
themedb.hit1[3] = 142
themedb.hit2[3] = 178


-- Localize all most used functions and variables so they will be accessed faster
local Graphics_drawImage = Screen.drawImage
local Screen_flip = Screen.flip
local Graphics_drawPartialImage = Screen.drawPartialImage
local Graphics_drawLine = Screen.drawLine
local Graphics_fillRect = Screen.fillRect
local Graphics_initBlend = Screen.initBlend
local Graphics_termBlend = Screen.termBlend
local Controls_read = Controls.read
local Controls_check = Controls.check
local Controls_readTouch = Controls.readTouch
local KEY_CROSS = SCE_CTRL_CROSS
local KEY_SQUARE = SCE_CTRL_SQUARE
local KEY_TRIANGLE = SCE_CTRL_TRIANGLE
local KEY_CIRCLE = SCE_CTRL_CIRCLE
local KEY_START = SCE_CTRL_START
local KEY_SELECT = SCE_CTRL_SELECT