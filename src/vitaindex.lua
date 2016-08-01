--Rewrite of Eucliod's index.lua for lpp-vita
-- By gnmmarechal


-- Setting directories
local appdir = "ux0:/data/Eucliod"
local rsrcdir = appdir.."/rsrc"
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
local Graphics_drawImage = Graphics.drawImage
local Screen_flip = Screen.flip
local Graphics_drawPartialImage = Graphics.drawPartialImage
local Graphics_drawLine = Graphics.drawLine
local Graphics_fillRect = Graphics.fillRect
local Graphics_initBlend = Graphics.initBlend
local Graphics_termBlend = Graphics.termBlend
local Controls_read = Controls.read
local Controls_check = Controls.check
local Controls_readTouch = Controls.readTouch
local KEY_CROSS = SCE_CTRL_CROSS
local KEY_SQUARE = SCE_CTRL_SQUARE
local KEY_TRIANGLE = SCE_CTRL_TRIANGLE
local KEY_CIRCLE = SCE_CTRL_CIRCLE
local KEY_START = SCE_CTRL_START
local KEY_SELECT = SCE_CTRL_SELECT

keymap={}; keymap2={}
keymap[KEY_CIRCLE]=0; keymap2[0] = KEY_CIRCLE
keymap[KEY_CROSS]=1; keymap2[1] = KEY_CROSS
keymap[KEY_SQUARE]=2; keymap2[2] = KEY_SQUARE 
keymap[KEY_TRIANGLE]=3; keymap2[3] = KEY_TRIANGLE 
keymap[SCE_CTRL_LTRIGGER]=4; keymap2[4] = SCE_CTRL_LTRIGGER 
keymap[SCE_CTRL_RTRIGGER]=5; keymap2[5] = SCE_CTRL_RTRIGGER
--keymap[KEY_ZL]=6; keymap2[6] = KEY_ZL 
--keymap[KEY_ZR]=7; keymap2[7] = KEY_ZR 

local KEY_FIRE = KEY_SQUARE
local KEY_FIRE2 = KEY_CROSS
local KEY_WEAPON = KEY_TRIANGLE
local KEY_FOCUS = SCE_CTRL_RTRIGGER



if System.doesFileExist(appdir.."/config.dat") then
	local file_config = io.open(appdir.."/config.dat",FREAD)
	local filesize = io.size(file_config)
	local str = io.read(file_config,0,filesize)
	io.close(file_config)
	
	local b_fire = tonumber(string.sub(str, 1,1)); if b_fire ~= nil and keymap2[b_fire]~=nil then KEY_FIRE = keymap2[b_fire] end
	--local b_altf = tonumber(string.sub(str, 1,1)); if b_altf ~= nil and keymap2[b_altf]~=nil then KEY_FIRE2 = keymap2[b_altf] end
	local b_wepo = tonumber(string.sub(str, 2,2)); if b_wepo ~= nil and keymap2[b_wepo]~=nil then KEY_WEAPON = keymap2[b_wepo] end
	local b_focu = tonumber(string.sub(str, 3,3)); if b_focu ~= nil and keymap2[b_focu]~=nil then KEY_FOCUS = keymap2[b_focu] end
	local theme_ = tonumber(string.sub(str, 4,4)); if theme_ ~= nil then theme = theme_ end
else
	local file_config = io.open(appdir.."/config.dat",FCREATE)
	io.write(file_config, 0, keymap[KEY_FIRE]..keymap[KEY_WEAPON]..keymap[KEY_FOCUS]..theme, 4)
	io.close(file_config)
end

Graphics_initBlend()

img_load = Graphics.loadImage(rsrcdir..'/load.png')
Graphics_fillRect(0, 960, 0, 544, themedb.bg[theme])
-- Unchanged coords
Graphics_drawPartialImage(154,86, 0,0, 92,86, img_load, themedb.ship[theme])
Graphics_drawPartialImage(154,86, 92,0, 92,86, img_load, themedb.bullet[theme])
Graphics_drawPartialImage(154,86, 184,0, 92,86, img_load)
Graphics_termBlend()
Screen_flip()

local pad = Controls_read()
local oldpad = pad