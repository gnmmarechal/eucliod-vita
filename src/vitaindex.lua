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
	local str = io.read(file_config,filesize)
	io.close(file_config)
	
	local b_fire = tonumber(string.sub(str, 1,1)); if b_fire ~= nil and keymap2[b_fire]~=nil then KEY_FIRE = keymap2[b_fire] end
	--local b_altf = tonumber(string.sub(str, 1,1)); if b_altf ~= nil and keymap2[b_altf]~=nil then KEY_FIRE2 = keymap2[b_altf] end
	local b_wepo = tonumber(string.sub(str, 2,2)); if b_wepo ~= nil and keymap2[b_wepo]~=nil then KEY_WEAPON = keymap2[b_wepo] end
	local b_focu = tonumber(string.sub(str, 3,3)); if b_focu ~= nil and keymap2[b_focu]~=nil then KEY_FOCUS = keymap2[b_focu] end
	local theme_ = tonumber(string.sub(str, 4,4)); if theme_ ~= nil then theme = theme_ end
else
	local file_config = io.open(appdir.."/config.dat",FCREATE)
	io.write(file_config, keymap[KEY_FIRE]..keymap[KEY_WEAPON]..keymap[KEY_FOCUS]..theme, 4)
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

DEBUG = false
debugval1 = 0

if not (Controls_check(pad,KEY_SQUARE)) then
	new3ds = true
	System.setCpuSpeed(444)
	img_new3ds_mode = Graphics.loadImage(rsrcdir..'/new3ds_mode.png')
else
	new3ds = false
end

local i=0
local load_texvariable = {}
local load_wavvariable = {}
local load_filepath = {}

	i=i+1; load_texvariable[i]='img_ship_hawk'; load_filepath[i] = '/ship_hawk.png'
	i=i+1; load_texvariable[i]='img_ship_tiger'; load_filepath[i] = '/ship_tiger.png'
	i=i+1; load_texvariable[i]='img_ship_cicada'; load_filepath[i] = '/ship_cicada.png'
	i=i+1; load_texvariable[i]='img_ship_core'; load_filepath[i] = '/ship_core.png'
	i=i+1; load_texvariable[i]='img_ship_death'; load_filepath[i] = '/ship_death.png'
	
	i=i+1; load_texvariable[i]='img_menu_ship_select'; load_filepath[i] = '/menu_ship_select.png'
	i=i+1; load_texvariable[i]='img_menu_ship_speed'; load_filepath[i] = '/menu_ship_speed.png'
	i=i+1; load_texvariable[i]='img_menu_ship_name'; load_filepath[i] = '/menu_ship_name.png'
	
	i=i+1; load_texvariable[i]='img_menu_ship_weapon'; load_filepath[i] = '/menu_ship_weapon.png'
	
	i=i+1; load_texvariable[i]='img_en_death'; load_filepath[i] = '/en_death.png'
	i=i+1; load_texvariable[i]='img_boss_death'; load_filepath[i] = '/boss_death.png'
	i=i+1; load_texvariable[i]='img_en01'; load_filepath[i] = '/en01.png'
	i=i+1; load_texvariable[i]='img_en02'; load_filepath[i] = '/en02.png'
	i=i+1; load_texvariable[i]='img_en03'; load_filepath[i] = '/en03.png'
	i=i+1; load_texvariable[i]='img_en04'; load_filepath[i] = '/en04.png'
	i=i+1; load_texvariable[i]='img_en05'; load_filepath[i] = '/en05.png'
	i=i+1; load_texvariable[i]='img_en06'; load_filepath[i] = '/en06.png'
	i=i+1; load_texvariable[i]='img_en07'; load_filepath[i] = '/en07.png'
	i=i+1; load_texvariable[i]='img_en08'; load_filepath[i] = '/en08.png'
	i=i+1; load_texvariable[i]='img_boss01'; load_filepath[i] = '/boss01.png'
	i=i+1; load_texvariable[i]='img_boss02'; load_filepath[i] = '/boss02.png'
	
	i=i+1; load_texvariable[i]='img_bullet_death'; load_filepath[i] = '/bullet_death.png'
	i=i+1; load_texvariable[i]='img_bullet01'; load_filepath[i] = '/bullet01.png'
	i=i+1; load_texvariable[i]='img_bullet02'; load_filepath[i] = '/bullet02.png'
	i=i+1; load_texvariable[i]='img_bullet03'; load_filepath[i] = '/bullet03.png'
	i=i+1; load_texvariable[i]='img_bullet04'; load_filepath[i] = '/bullet04.png'
	i=i+1; load_texvariable[i]='img_bullet05a'; load_filepath[i] = '/bullet05a.png'
	i=i+1; load_texvariable[i]='img_bullet05b'; load_filepath[i] = '/bullet05b.png'
	i=i+1; load_texvariable[i]='img_bullet06'; load_filepath[i] = '/bullet06.png'
	i=i+1; load_texvariable[i]='img_bullet07'; load_filepath[i] = '/bullet07.png'
	i=i+1; load_texvariable[i]='img_bullet08'; load_filepath[i] = '/bullet08.png'
	
	i=i+1; load_texvariable[i]='img_shot01'; load_filepath[i] = '/shot01.png'
	i=i+1; load_texvariable[i]='img_shot02'; load_filepath[i] = '/shot02.png'
	i=i+1; load_texvariable[i]='img_shot03'; load_filepath[i] = '/shot03.png'
	i=i+1; load_texvariable[i]='img_shot04'; load_filepath[i] = '/shot04.png'
	i=i+1; load_texvariable[i]='img_shot05'; load_filepath[i] = '/shot05.png'
	
	i=i+1; load_texvariable[i]='img_menu_logo'; load_filepath[i] = '/menu_logo.png'
	i=i+1; load_texvariable[i]='img_menu_logo_options'; load_filepath[i] = '/menu_logo_options.png'
	
	i=i+1; load_texvariable[i]='img_menubutton'; load_filepath[i] = '/menubutton.png'
	i=i+1; load_texvariable[i]='img_menubutton_text'; load_filepath[i] = '/menubutton_text.png'
	
	i=i+1; load_texvariable[i]='img_rebind_keys'; load_filepath[i] = '/rebind_keys.png'
	i=i+1; load_texvariable[i]='img_menu_rebind'; load_filepath[i] = '/menu_rebind.png'
	i=i+1; load_texvariable[i]='img_map_selector'; load_filepath[i] = '/map_selector.png'
	i=i+1; load_texvariable[i]='img_menu_credits'; load_filepath[i] = '/menu_credits.png'
	
	i=i+1; load_texvariable[i]='img_diff_meter'; load_filepath[i] = '/diff_meter.png'
	i=i+1; load_texvariable[i]='img_diff_meter_pip'; load_filepath[i] = '/diff_meter_pip.png'
	i=i+1; load_texvariable[i]='img_menu_invalid'; load_filepath[i] = '/menu_invalid.png'
	i=i+1; load_texvariable[i]='img_warning'; load_filepath[i] = '/warning.png'
	i=i+1; load_texvariable[i]='img_clear'; load_filepath[i] = '/clear.png'
	
	i=i+1; load_texvariable[i]='img_font_numbers'; load_filepath[i] = '/font_numbers.png'
	
	i=i+1; load_texvariable[i]='img_boss_hp_bar'; load_filepath[i] = '/boss_hp_bar.png'
	i=i+1; load_texvariable[i]='img_score'; load_filepath[i] = '/score.png'
	
	i=i+1; load_texvariable[i]='img_r'; load_filepath[i] = '/r.png'
	
	i=i+1; load_wavvariable[i]='wav_gatlin'; load_filepath[i] = '/gatlin.wav'
	i=i+1; load_wavvariable[i]='wav_missile'; load_filepath[i] = '/missile.wav'
	i=i+1; load_wavvariable[i]='wav_photon'; load_filepath[i] = '/photon.wav'
	i=i+1; load_wavvariable[i]='wav_beam'; load_filepath[i] = '/beam.wav'
	i=i+1; load_wavvariable[i]='wav_seeker'; load_filepath[i] = '/seeker.wav'
	
	i=i+1; load_wavvariable[i]='wav_b01'; load_filepath[i] = '/b01.wav'
	i=i+1; load_wavvariable[i]='wav_b02'; load_filepath[i] = '/b02.wav'
	i=i+1; load_wavvariable[i]='wav_b03'; load_filepath[i] = '/b03.wav'
	i=i+1; load_wavvariable[i]='wav_b04'; load_filepath[i] = '/b04.wav'
	i=i+1; load_wavvariable[i]='wav_b07'; load_filepath[i] = '/b07.wav'
	
	i=i+1; load_wavvariable[i]='wav_en_death'; load_filepath[i] = '/en_death.wav'
	i=i+1; load_wavvariable[i]='wav_ship_death'; load_filepath[i] = '/ship_death.wav'
	i=i+1; load_wavvariable[i]='wav_explosion'; load_filepath[i] = '/explosion.wav'
	i=i+1; load_wavvariable[i]='wav_kill_bullets'; load_filepath[i] = '/kill_bullets.wav'
	i=i+1; load_wavvariable[i]='wav_warning'; load_filepath[i] = '/warning.wav'
	
	i=i+1; load_wavvariable[i]='wav_select'; load_filepath[i] = '/select.wav'
	
load_filecount = i+1

local i=0
local c_line = themedb.bullet[theme]

if Controls_check(pad,KEY_TRIANGLE) then
	DEBUG = true
	c_line = c_green
end

while i<load_filecount do --load them one by one on each frame of the loading screen
	if load_texvariable[i] ~= nil then --also make a debug catch to ensure you don't load two files to the same variable?
		if System.doesFileExist(appdir..load_filepath[i]) then
			_G[load_texvariable[i]] = Graphics.loadImage(appdir..load_filepath[i])
		else
			c_line = c_red --file doesn't exist
		end
	elseif load_wavvariable[i] ~= nil then
		if System.doesFileExist(wavdir..load_filepath[i]) then
			_G[load_wavvariable[i]] = Sound.openWav(wavdir..load_filepath[i])
		else
			c_line = c_red
		end
	end
	i=i+1
	Screen_waitVblankStart()
	Graphics_initBlend()
	Graphics_fillRect(0, 400, 0, 240, themedb.bg[theme])
	Graphics_drawPartialImage(154,86, 0,0, 92,86, img_load, themedb.ship[theme])
	Graphics_drawPartialImage(154,86, 92,0, 92,86, img_load, themedb.bullet[theme])
	Graphics_drawPartialImage(154,86, 184,0, 92,86, img_load)
	Graphics_drawLine(163, 163+math.ceil(i/load_filecount*76), 175, 175, c_line)
	if new3ds == true then
		Graphics_drawImage(140, 178, img_new3ds_mode, themedb.null[theme])
	end
	Graphics_termBlend()
	Screen_flip()
end

glyph_l = {}
glyph_r = {}
glyph_w = {}
function g_init(char, l, r)
	glyph_l[char] = l
	glyph_r[char] = r
	glyph_w[char] = r-l+1
end
g_init('0',1,8)
g_init('1',9,16)
g_init('2',17,25)
g_init('3',25,32)
g_init('4',33,40)
g_init('5',41,48)
g_init('6',49,56)
g_init('7',57,64)
g_init('8',65,72)
g_init('9',73,80)
g_init('.',81,88)

--remember to blend the gpu to what screen you want before calling this function, and termblend afterwards
function gpu_drawtext(x, y, text, col)
	local text_u = string.upper(text) --my font system is caps-only. This may be slowing down the system though, consider not having this failsafe (instead loading all strings in as uppercase by default)
	local i_str=0 --the current position in the string
	local i_chr='' --the current character in the string
	local str_width = 0 --width in pixels of the string
	local str_length = string.len(text)
	local cw --character width
	if col == nil then col = c_white end
	while i_str < str_length do
		i_str = i_str + 1
		i_chr = string.sub(text_u, i_str, i_str)
		cw = glyph_w[i_chr]
		if cw ~= nil then --as long as the character exists
			Graphics_drawPartialImage(x+str_width, y, glyph_l[i_chr], 1, cw, 14, img_font_numbers, col)
			str_width = str_width + cw + 2
		end
	end
end

dofile(appdir..'/ds_list_init.lua')
dofile(appdir..'/ds_queue_init.lua')

dofile(appdir..'/object.lua')
dofile(appdir..'/fps_init.lua')

function loadlevel(num)
	--if a level has been loaded, we need to clear it before loading the new one
	local i=0
	while larray.time[i] ~= nil do
		larray.time[i] = nil
		larray.enid[i] = nil
		larray.dir[i] = nil
		larray.pix[i] = nil
		i=i+1
	end

	local f = io.open(lvldir.."/level"..num..".dat",FREAD)
	local filesize = io.size(f)
	local str = io.read(f,filesize)
	io.close(f)
	
	--"|T-######|enemy|direction|px|"
	local i = 0
	local a = string.find(str, "|T-",1,true) --find the first new line
	local v = string.sub(str, 1, 4) --obtain version
	if v ~= "v001" then
		a=nil
		return true;
	else
		while a~=nil do --as long as there's more newlines
			local t = tonumber(string.sub(str, a+3, a+8)) --the six characters after T- is the time
			local en = string.sub(str, a+10, a+13) --enemy id
			local d = string.sub(str, a+15, a+15) --direction the enemy is coming from (T, L, R)
			local px = tonumber(string.sub(str, a+17, a+19))
			larray.time[i] = t
			larray.enid[i] = en
			larray.dir[i] = d
			larray.pix[i] = px
			i = i+1
			a = string.find(str, "|T-",a+5,true)
		end
	end
end

function onscreen(x,y)
	if x>-25 and x<425 and y>-5 and y<405 then
		return true
	else
		return false
	end
end

function graze(id,x,y,gdist) --shouldn't need to be said, but grazedist needs to be outside of the bullet hitbox on all sides
	local px,py = player_x,player_y
	if x>px-gdist and x<px+gdist and y>py-gdist and y<py+gdist then
		if obj.phase[id] == 0 and player_alive then
			obj.phase[id] = 1
			score=score+2
		end
		return true;
	end
end

larray = {}
larray.time = {}
larray.enid = {}
larray.dir = {}
larray.pix = {}

function menu_init()
	v_record = false
	menu = true
	menu_type = 'main'
	menu_selector = 0
	menu_selector2 = 0
	invalid_level = false
	if game_started == true then
		while bulletlist.size>0 do ds_list_delete(bulletlist,0) end
		while shotlist.size>0 do ds_list_delete(shotlist,0) end
		while enemylist.size>0 do ds_list_delete(enemylist,0) end
	else
		difficulty = 1
		level_select = 1
	end
	Graphics_initBlend() --clear bottom screen
	Graphics_termBlend()
end	


function game_init()
	if loadlevel(level_select) == true then --failed to load level because version mismatch
		menu = true
		invalid_level = true
	else
		difficulty = math.floor(difficulty)
		game_started = true
		w_beam_id = -1
		w_miss_side = 0
		player_x = 200
		player_x_calc = 200
		player_y = 200
		player_y_calc = 200
		player_shot = 0
		player_alive = true
		player_death = 0
		timer = 0
		spawnindex = 0
		warning_flash = 0
		stage_boss_hp = 0
		stage_boss_hp_max = 0
		stage_clear = -1
		score = 0
		spellcard_name = ''
	end
end

function angle(x1,y1,x2,y2)
	local rise = y2-y1
	local run = x2-x1
	local a = math.atan(run,rise)
	return math.deg(a)%360
end

function euc_speed(dir,sp) --euclidian speed
	local euc_x = (math.sin(math.rad(dir))*sp)
	local euc_y = (math.cos(math.rad(dir))*sp)
	return euc_x, euc_y;
end

function bullet01_create(ox, oy, odir, speed, spin)
	local o=object_create(ox, oy, 1, img_bullet01, bulletlist, odir)
	obj.xspeed[o], obj.yspeed[o] = euc_speed(odir,speed)
	if spin == nil then
		obj.var1[o] = 0
	else --the bullet curves
		obj.var1[o] = spin
		obj.var2[o] = speed --we need this for future x/yspeed adjustments
	end
end

--
function bullet02_create(ox, oy, speed)
	local o=object_create(ox, oy, 2, img_bullet02, bulletlist, 0)
	obj.xspeed[o], obj.yspeed[o] = euc_speed(0,speed)
end

function bullet03_create(ox, oy, speed)
	local o=object_create(ox, oy, 3, img_bullet03, bulletlist, 0)
	obj.xspeed[o], obj.yspeed[o] = euc_speed(0,speed)
end

function bullet04_create(ox, oy, speed, ifreq, mag, offset)
	local o=object_create(ox, oy, 4, img_bullet04, bulletlist, 0)
	obj.yspeed[o] = speed;
	obj.var1[o], obj.var2[o] = ifreq, mag; --inverse frequency, magnitude
	obj.clock[o] = offset*ifreq
	if offset<0.5 then
		obj.xspeed[o] = -mag*0.25 + offset*mag
	else
		obj.xspeed[o] = -mag*0.25 + (1-offset)*mag
	end
end

function bullet05_create(ox, oy, odir, speed) --this bullet is rather redundant
	local img = -1
	if odir == 45 then img = img_bullet05b
	elseif odir == 315 then img = img_bullet05a
	else img = img_r
	end
	local o=object_create(ox, oy, 5, img, bulletlist, odir)
	obj.xspeed[o], obj.yspeed[o] = euc_speed(odir,speed)
end

function bullet07_create(ox, oy, odir, speed, rot, rotspeed) --these bullets have an angular direction AND an orbit
	local o=object_create(ox, oy, 7, img_bullet07, bulletlist, rot)
	obj.xspeed[o], obj.yspeed[o] = euc_speed(odir,speed)
	obj.hp[o] = rotspeed*2
end

function bullet08_create(ox, oy, host, power) --beam
	local o=object_create(ox, oy, 8, img_bullet08, bulletlist, 0)
	obj.var1[o] = host
	obj.var2[o] = power
end

function effect_create(x, y, t)
	local g=0; local s
	if t=='end' then g=img_en_death; s=wav_en_death
	elseif t=='bod' then g=img_boss_death; s=wav_explosion
	elseif t=='bud' then g=img_bullet_death;
	else g=img_ship_death end
	object_create(x, y, t, g, fxlist)
	if s~= nil then Sound.play(s,NO_LOOP) end
end

function kill_bullets()
	while bulletlist.size>0 do
		local id = ds_list_find_value(bulletlist, 0)
		effect_create(obj.x[id], obj.y[id], 'bud')
		object_destroy(bulletlist, id)
		Sound.play(wav_kill_bullets,NO_LOOP)
	end
end

function kill_enemies()
	local i=0
	while enemylist.size>i do
		local id = ds_list_find_value(enemylist, i)
		if id < 100 then --a regular mob, not a boss
			object_destroy(enemylist, id)
		else
			i=i+1
		end
	end
end

shot_lib = {}
shot_lib.name = {}
shot_lib.speed = {}
shot_lib.dir = {}
shot_lib.graphic = {}
shot_lib.energy = {}
shot_lib.power = {}
shot_lib.width = {}
shot_lib.height = {}

shot_lib.name[1] = 'shot01'
shot_lib.speed[1]=8
shot_lib.dir[1] = 180
shot_lib.graphic[1] = img_shot01
shot_lib.power[1] = 4
shot_lib.width[1] = 7
shot_lib.height[1] = 3
shot_lib.energy[1] = 6

shot_lib.name[2] = 'shot02'
shot_lib.speed[2]=0
shot_lib.dir[2] = 180
shot_lib.graphic[2] = img_shot02
shot_lib.power[2] = 12
shot_lib.width[2] = 3
shot_lib.height[2] = 6
shot_lib.energy[2] = 16

shot_lib.name[3] = 'shot03'
shot_lib.speed[3]=4
shot_lib.dir[3] = 180
shot_lib.graphic[3] = img_shot03
shot_lib.power[3] = 8
shot_lib.width[3] = 9
shot_lib.height[3] = 9
shot_lib.energy[3] = 20

shot_lib.name[4] = 'shot04'
shot_lib.speed[4]=0
shot_lib.dir[4] = 180
shot_lib.graphic[4] = img_shot04
shot_lib.power[4] = 0.3
shot_lib.width[4] = 9
shot_lib.height[4] = 480 --probably fix this and the weapon sprite itself to not hit enemies behind you
shot_lib.energy[4] = 10

shot_lib.name[5] = 'shot05'
shot_lib.speed[5]=5
shot_lib.dir[5] = 180
shot_lib.graphic[5] = img_shot05
shot_lib.power[5] = 4.5
shot_lib.width[5] = 5
shot_lib.height[5] = 5
shot_lib.energy[5] = 18

ship_lib = {}
ship_lib.name = {}
ship_lib.graphic = {}
ship_lib.speed = {}
ship_lib.fspeed = {}
ship_lib.shot = {}
ship_lib.fshot = {}

ship_lib.name[1] = 'hawk'
ship_lib.graphic[1] = img_ship_hawk
ship_lib.speed[1] = 3
ship_lib.fspeed[1] = 1.5
ship_lib.shot[1] = 1
ship_lib.fshot[1] = 2

ship_lib.name[2] = 'tiger'
ship_lib.graphic[2] = img_ship_tiger
ship_lib.speed[2] = 2.5
ship_lib.fspeed[2] = 1.25
ship_lib.shot[2] = 1
ship_lib.fshot[2] = 5

ship_lib.name[3] = 'cicada'
ship_lib.graphic[3] = img_ship_cicada
ship_lib.speed[3] = 2.75
ship_lib.fspeed[3] = 1.25
ship_lib.shot[3] = 3
ship_lib.fshot[3] = 4

local enemy_lib_width = {}
local enemy_lib_height = {}
local enemy_lib_radius = {}

enemy_lib_width[1]=12
enemy_lib_height[1]=12

enemy_lib_width[2]=13
enemy_lib_height[2]=14

enemy_lib_width[3]=20
enemy_lib_height[3]=9

enemy_lib_width[4]=19
enemy_lib_height[4]=14

enemy_lib_width[5]=19
enemy_lib_height[5]=15

enemy_lib_width[6]=20
enemy_lib_height[6]=20
enemy_lib_radius[6]=10

enemy_lib_width[107]=17
enemy_lib_height[107]=3

enemy_lib_width[8]=31
enemy_lib_height[8]=31
enemy_lib_radius[8]=15

enemy_lib_width[201]=59
enemy_lib_height[201]=16

enemy_lib_width[202]=34
enemy_lib_height[202]=22

enemy_lib_width[203]=0
enemy_lib_height[203]=0

menu_init()
while true do
	Screen_waitVblankStart()
	Screen.refresh()
	pad = Controls_read()
	tx_old,ty_old = tx,ty
	tx,ty = Controls_readTouch()
	
	if (Controls_check(pad,KEY_SELECT)) and not (Controls_check(oldpad,KEY_SELECT)) then
		if DEBUG then
			if v_record == true then
				v_record = false
			else
				v_record = true
			end
		else
			local i=0
			while i<99 do
				if System.doesFileExist(scrdir.."/screenshot"..i..".jpg") then
					i=i+1
				else
					System.takeScreenshot(scrdir.."/screenshot"..i..".jpg",true)
					i=100
				end
			end
		end
	end
		
	if menu == true then --MENU SCREEN \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
		if menu_type == 'main' then
			if (Controls_check(pad,KEY_DUP)) and not (Controls_check(oldpad,KEY_DUP)) then
				menu_selector = math.max(0,menu_selector-1)
			elseif (Controls_check(pad,KEY_DDOWN)) and not (Controls_check(oldpad,KEY_DDOWN)) then
				menu_selector = math.min(4,menu_selector+1)
			end
			
			Graphics_initBlend()
			
			Graphics_fillRect(0, 400, 0, 240, themedb.bg[theme])
			Graphics_drawPartialImage(0,0, 0,0, 256,64, img_menu_logo, themedb.bullet[theme])
			Graphics_drawPartialImage(0,0, 256,0, 256,64, img_menu_logo, themedb.enemy[theme])
			--PLAY BUTTON
			if menu_selector == 0 then
				Graphics_drawPartialImage(50,70, 0, 0, 103,16, img_menubutton, themedb.bg[theme])
				Graphics_drawPartialImage(50,75, 0, 0, 103, 6, img_menubutton_text, themedb.bullet[theme])
				Graphics_drawPartialImage(50,70, 0,16, 103,16, img_menubutton, themedb.bullet[theme])
				if (Controls_check(pad,KEY_A)) and not (Controls_check(oldpad,KEY_A)) then
					if System.doesFileExist(lvldir.."/level"..level_select..".dat") then
						if loadlevel(level_select) == true then --failed to load level because version mismatch
							invalid_level = true
						else
							menu_type = 'ship'
						end
					else
						invalid_level = true
					end
				end
			else 
				Graphics_drawPartialImage(50,70, 0,0, 103,16, img_menubutton, themedb.ship[theme])
				Graphics_drawPartialImage(50,75, 0,0, 103, 6, img_menubutton_text, themedb.bg[theme])
			end
			
			if menu_selector == 1 then --DIFFICULTY SELECTION
				Graphics_drawPartialImage(50, 95, 0, 0,  103,16, img_menubutton, themedb.bg[theme])
				Graphics_drawPartialImage(50,100, 0,1*6, 103, 6, img_menubutton_text, themedb.bullet[theme])
				Graphics_drawPartialImage(50, 95, 0,16,  103,16, img_menubutton, themedb.bullet[theme])
				if (Controls_check(pad,KEY_DLEFT)) then
					difficulty = math.max(1,difficulty-0.125)
				elseif (Controls_check(pad,KEY_DRIGHT)) then
					difficulty = math.min(16,difficulty+0.125)
				end
			else 
				Graphics_drawPartialImage(50, 95, 0, 0,  103,16, img_menubutton, themedb.ship[theme])
				Graphics_drawPartialImage(50,100, 0,1*6, 103, 6, img_menubutton_text, themedb.bg[theme])
			end
			Graphics_drawImage(180, 95, img_diff_meter, themedb.enemy[theme])
			Graphics_drawPartialImage(180,95, 0,0, 6+(4*math.floor(difficulty)),16, img_diff_meter_pip, themedb.bullet[theme])
			
			if menu_selector == 2 then --LEVEL SELECTION
				Graphics_drawPartialImage(50,120, 0, 0,  103,16, img_menubutton, themedb.bg[theme])
				Graphics_drawPartialImage(50,125, 0,2*6, 103, 6, img_menubutton_text, themedb.bullet[theme])
				Graphics_drawPartialImage(50,120, 0,16,  103,16, img_menubutton, themedb.bullet[theme])
				if (Controls_check(pad,KEY_DLEFT)) then
					invalid_level = false
					if (Controls_check(pad,KEY_Y)) then
						level_select = math.max(0,level_select-1)
					elseif not (Controls_check(oldpad,KEY_DLEFT)) then
						level_select = math.max(0,level_select-1)
					end
				end
				if (Controls_check(pad,KEY_DRIGHT)) then
					invalid_level = false
					if (Controls_check(pad,KEY_Y)) then
						level_select = level_select + 1
					elseif not (Controls_check(oldpad,KEY_DRIGHT)) then
						level_select = level_select + 1
					end
				end
			else 
				Graphics_drawPartialImage(50,120, 0, 0,  103,16, img_menubutton, themedb.ship[theme])
				Graphics_drawPartialImage(50,125, 0,2*6, 103, 6, img_menubutton_text, themedb.bg[theme])
			end
			gpu_drawtext(180,122, tostring(level_select), themedb.bullet[theme])
			if invalid_level then
				Graphics_drawImage(180, 140,img_menu_invalid, themedb.null[theme])
			end
			
			--options
			if menu_selector == 3 then
				Graphics_drawPartialImage(50,145, 0, 0,  103,16, img_menubutton, themedb.bg[theme])
				Graphics_drawPartialImage(50,150, 0,3*6, 103, 6, img_menubutton_text, themedb.bullet[theme])
				Graphics_drawPartialImage(50,145, 0,16,  103,16, img_menubutton, themedb.bullet[theme])
				if (Controls_check(pad,KEY_A)) and not (Controls_check(oldpad,KEY_A)) then
					menu_type = 'options'
					menu_selector = 0
				end
			else
				Graphics_drawPartialImage(50,145, 0, 0,  103,16, img_menubutton, themedb.ship[theme])
				Graphics_drawPartialImage(50,150, 0,3*6, 103, 6, img_menubutton_text, themedb.bg[theme])
			end
			
			--exit
			if menu_selector == 4 then
				Graphics_drawPartialImage(50,170, 0, 0,  103,16, img_menubutton, themedb.bg[theme])
				Graphics_drawPartialImage(50,175, 0,4*6, 103, 6, img_menubutton_text, themedb.bullet[theme])
				Graphics_drawPartialImage(50,170, 0,16,  103,16, img_menubutton, themedb.bullet[theme])
				if (Controls_check(pad,KEY_A)) and not (Controls_check(oldpad,KEY_A)) then
					Graphics.term()
					System.exit()
				end
			else 
				Graphics_drawPartialImage(50,170, 0, 0,  103,16, img_menubutton, themedb.ship[theme])
				Graphics_drawPartialImage(50,175, 0,4*6, 103, 6, img_menubutton_text, themedb.bg[theme])
			end
			
			Graphics_termBlend()
			
		elseif menu_type == 'options' then --OPTIONS MENU \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
		
			if (Controls_check(pad,KEY_DUP)) and not (Controls_check(oldpad,KEY_DUP)) then
				menu_selector = math.max(0,menu_selector-1)
			elseif (Controls_check(pad,KEY_DDOWN)) and not (Controls_check(oldpad,KEY_DDOWN)) then
				menu_selector = math.min(2,menu_selector+1)
			end
			
			Graphics_initBlend()
			
			Graphics_fillRect(0, 400, 0, 240, themedb.bg[theme])
			Graphics_drawPartialImage(0,0, 0,0, 256,64, img_menu_logo_options, themedb.bullet[theme])
			Graphics_drawPartialImage(0,0, 256,0, 256,64, img_menu_logo_options, themedb.enemy[theme])
			Graphics_drawPartialImage(242,169, 0,0, 150,72, img_menu_credits, themedb.bullet[theme])
			Graphics_drawPartialImage(242,169, 150,0, 150,72, img_menu_credits, themedb.enemy[theme])
			
			if menu_selector == 0 then --KEYBINDS OPTION
				Graphics_drawPartialImage(50,70, 0, 0,  103,16, img_menubutton, themedb.bg[theme])
				Graphics_drawPartialImage(50,75, 0,5*6, 103, 6, img_menubutton_text, themedb.bullet[theme])
				Graphics_drawPartialImage(50,70, 0,16,  103,16, img_menubutton, themedb.bullet[theme])
				if (Controls_check(pad,KEY_A)) and not (Controls_check(oldpad,KEY_A)) then
					menu_type = 'keys'
					menu_selector = 0
				end
			else 
				Graphics_drawPartialImage(50,70, 0, 0,  103,16, img_menubutton, themedb.ship[theme])
				Graphics_drawPartialImage(50,75, 0,5*6, 103, 6, img_menubutton_text, themedb.bg[theme])
			end
			
			if menu_selector == 1 then --THEMES
				Graphics_drawPartialImage(50, 95, 0, 0,  103,16, img_menubutton, themedb.bg[theme])
				Graphics_drawPartialImage(50,100, 0,6*6, 103, 6, img_menubutton_text, themedb.bullet[theme])
				Graphics_drawPartialImage(50, 95, 0,16,  103,16, img_menubutton, themedb.bullet[theme])
				if (Controls_check(pad,KEY_DLEFT)) and not (Controls_check(oldpad,KEY_DLEFT)) then
					theme = math.max(0,theme-1)
				elseif (Controls_check(pad,KEY_DRIGHT)) and not (Controls_check(oldpad,KEY_DRIGHT)) then
					theme = math.min(3,theme+1)
				end
			else
				Graphics_drawPartialImage(50, 95, 0, 0,  103,16, img_menubutton, themedb.ship[theme])
				Graphics_drawPartialImage(50,100, 0,6*6, 103, 6, img_menubutton_text, themedb.bg[theme])
			end
			
			if menu_selector == 2 then --BACK
				Graphics_drawPartialImage(50,120, 0, 0,  103,16, img_menubutton, themedb.bg[theme])
				Graphics_drawPartialImage(50,125, 0,7*6, 103, 6, img_menubutton_text, themedb.bullet[theme])
				Graphics_drawPartialImage(50,120, 0,16,  103,16, img_menubutton, themedb.bullet[theme])
				if (Controls_check(pad,KEY_A)) and not (Controls_check(oldpad,KEY_A)) then
					menu_type = 'main'
					menu_selector = 0
					--save keybind and theme configurations
					local file_config = io.open(rotdir.."/config.dat",FCREATE)
					io.write(file_config, keymap[KEY_FIRE]..keymap[KEY_WEAPON]..keymap[KEY_FOCUS]..theme, 4)
					io.close(file_config)
				end
			else 
				Graphics_drawPartialImage(50,120, 0, 0,  103,16, img_menubutton, themedb.ship[theme])
				Graphics_drawPartialImage(50,125, 0,7*6, 103, 6, img_menubutton_text, themedb.bg[theme])
			end
			
			Graphics_termBlend()
			
		elseif menu_type == 'ship' then --SHIP SELECTION \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
			if (Controls_check(pad,KEY_DLEFT)) and not (Controls_check(oldpad,KEY_DLEFT)) then
				menu_selector = math.max(0,menu_selector-1)
			elseif (Controls_check(pad,KEY_DRIGHT)) and not (Controls_check(oldpad,KEY_DRIGHT)) then
				menu_selector = math.min(2,menu_selector+1)
			end
			if (Controls_check(pad,KEY_Y)) and not (Controls_check(oldpad,KEY_Y)) then
				if menu_selector2 == 0 then
					menu_selector2 = 1
				else
					menu_selector2 = 0
				end
			end
			if (Controls_check(pad,KEY_B)) and not (Controls_check(oldpad,KEY_B)) then
				menu_type = 'main'
				menu_selector = 0
			elseif (Controls_check(pad,KEY_A)) and not (Controls_check(oldpad,KEY_A)) then
				menu = false
				player_graphic = ship_lib.graphic[menu_selector+1]
				player_speed = ship_lib.speed[menu_selector+1]
				player_fspeed = ship_lib.fspeed[menu_selector+1]
				weapon1 = ship_lib.shot[menu_selector+1]
				if menu_selector2 == 0 then 
					weapon2 = ship_lib.fshot[menu_selector+1]
				else
					weapon2 = weapon1
				end
				game_init()
			end
			
			Graphics_initBlend()
			Graphics_fillRect(0, 400, 0, 240, themedb.bg[theme])
			Graphics_drawPartialImage(0,0, 0,0, 256,64, img_menu_logo, themedb.bullet[theme])
			Graphics_drawPartialImage(0,0, 256,0, 256,64, img_menu_logo, themedb.enemy[theme])
			Graphics_drawImage(135, 55, img_menu_ship_select, themedb.bullet[theme])
			Graphics.drawScaleImage(175+2, 74+2, ship_lib.graphic[menu_selector+1], 2, 2, themedb.ship[theme])
			Graphics.drawScaleImage(197,90, img_ship_core, 2, 2)
			
			Graphics_drawPartialImage(135+76,55+66, 0,6*menu_selector, 48,6, img_menu_ship_name, themedb.ship[theme])
			Graphics_drawPartialImage(135+76,55+75, 0,6*ship_lib.shot[menu_selector+1], 48,6, img_menu_ship_weapon, themedb.ship[theme])
			Graphics_drawPartialImage(135+76,55+84, 0, 0, 7*math.ceil(1.5*ship_lib.speed[menu_selector+1]), 6, img_menu_ship_speed, themedb.ship[theme])
			if menu_selector2 == 0 then
				Graphics_drawPartialImage(135+76,55+93, 0,6*ship_lib.fshot[menu_selector+1], 48,6, img_menu_ship_weapon, themedb.ship[theme])
			else
				Graphics_drawPartialImage(135+76,55+93, 0,0, 48,6, img_menu_ship_weapon, themedb.ship[theme])
			end
			Graphics_drawPartialImage(135+76,55+102, 0, 0, 7*math.ceil(1.5*ship_lib.fspeed[menu_selector+1]), 6, img_menu_ship_speed, themedb.ship[theme])
			
			Graphics_termBlend()
			
		elseif menu_type == 'keys' then --KEYBIND MENU \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
			if (Controls_check(pad,KEY_DUP)) and not (Controls_check(oldpad,KEY_DUP)) then
				menu_selector = math.max(0,menu_selector-1)
			elseif (Controls_check(pad,KEY_DDOWN)) and not (Controls_check(oldpad,KEY_DDOWN)) then
				menu_selector = math.min(3,menu_selector+1)
			end
			
			Graphics_initBlend()
			Graphics_fillRect(0, 400, 0, 240, themedb.bg[theme])
			Graphics_drawPartialImage(0,0, 0,0, 256,64, img_menu_logo_options, themedb.bullet[theme])
			Graphics_drawPartialImage(0,0, 256,0, 256,64, img_menu_logo_options, themedb.enemy[theme])
			Graphics_drawImage(135, 96, img_menu_rebind, themedb.bullet[theme])
			--Graphics_drawImage(x,y,draw autofire toggle)
			
			Graphics_drawImage(139, 100 + (10*menu_selector), img_map_selector, themedb.ship[theme])
			
			Graphics_drawPartialImage(249, 101, 12*keymap[KEY_FIRE],0, 12,8, img_rebind_keys, themedb.bullet[theme])
			Graphics_drawPartialImage(249, 111, 12*keymap[KEY_WEAPON],0, 12,8, img_rebind_keys, themedb.bullet[theme])
			Graphics_drawPartialImage(249, 121, 12*keymap[KEY_FOCUS],0, 12,8, img_rebind_keys, themedb.bullet[theme])
			
			local nkey=-1
			if (Controls_check(pad,KEY_A)) and not (Controls_check(oldpad,KEY_A)) then nkey = KEY_A
			elseif (Controls_check(pad,KEY_B)) and not (Controls_check(oldpad,KEY_B)) then nkey = KEY_B
			elseif (Controls_check(pad,KEY_X)) and not (Controls_check(oldpad,KEY_X)) then nkey = KEY_X
			elseif (Controls_check(pad,KEY_Y)) and not (Controls_check(oldpad,KEY_Y)) then nkey = KEY_Y
			elseif (Controls_check(pad,KEY_L)) and not (Controls_check(oldpad,KEY_L)) then nkey = KEY_L
			elseif (Controls_check(pad,KEY_R)) and not (Controls_check(oldpad,KEY_R)) then nkey = KEY_R
			elseif (Controls_check(pad,KEY_ZL)) and not (Controls_check(oldpad,KEY_ZL)) then nkey = KEY_ZL
			elseif (Controls_check(pad,KEY_ZR)) and not (Controls_check(oldpad,KEY_ZR)) then nkey = KEY_ZR
			end
			
			if menu_selector == 0 then
				if (Controls_check(pad,KEY_DLEFT)) and not (Controls_check(oldpad,KEY_DLEFT)) then
					autofire = false
				elseif (Controls_check(pad,KEY_DLEFT)) and not (Controls_check(oldpad,KEY_DLEFT)) then
					autofire = true
				end
			end
			
			if nkey ~= -1 then
				if menu_selector == 0 then KEY_FIRE = nkey
				elseif menu_selector == 1 then KEY_WEAPON = nkey
				elseif menu_selector == 2 then KEY_FOCUS = nkey
				elseif menu_selector == 3 and nkey == KEY_A then
					menu_type = 'options'
					menu_selector = 0
				end
			end
			Graphics_termBlend()
			
		end
		Screen_flip()
	else --GAMEPLAY \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\		
		--player controls
		if player_alive==true then
			local pspeed = player_speed
			local wep = weapon1
			if (Controls_check(pad,KEY_FOCUS)) then
				pspeed = player_fspeed
				wep = weapon2
			end
			if (Controls_check(pad,KEY_DUP)) then
				player_y_calc = math.max(10,player_y_calc - pspeed)
				player_y = math.floor(player_y_calc)
			elseif (Controls_check(pad,KEY_DDOWN)) then
				player_y_calc = math.min(230,player_y_calc + pspeed)
				player_y = math.floor(player_y_calc)
			end
			
			if (Controls_check(pad,KEY_DLEFT)) then
				player_x_calc = math.max(10,player_x_calc - pspeed)
				player_x = math.floor(player_x_calc)
			elseif (Controls_check(pad,KEY_DRIGHT)) then
				player_x_calc = math.min(390,player_x_calc + pspeed)
				player_x = math.floor(player_x_calc)
			end
			if (Controls_check(pad,KEY_FIRE)) then --show controls on bottom screen?
				
				if wep == 4 then
					if player_shot > 10 and player_shot < 100000 then
						player_shot = 100000
						w_beam_id = object_create(player_x, player_y, 4, img_shot04, shotlist, 180)
						obj.xspeed[w_beam_id], obj.yspeed[w_beam_id] = euc_speed(180,0)
						Sound.play(shot_lib.sfx[wep],LOOP)
					end
				elseif w_beam_id > -1 then
					player_shot = 0
					object_destroy(shotlist, w_beam_id)
					w_beam_id = -1
					Sound.pause(shot_lib.sfx[4])
				elseif wep == 2 then
					if player_shot > shot_lib.energy[wep] then
						player_shot = 0
						local wx = 0
						if w_miss_side == 0 then wx = -10; w_miss_side=1 else wx = 10; w_miss_side=0 end
						local o = object_create(player_x+wx, player_y, wep, shot_lib.graphic[wep], shotlist, shot_lib.dir[wep])
						obj.xspeed[o], obj.yspeed[o] = euc_speed(shot_lib.dir[wep],shot_lib.speed[wep])
						Sound.play(shot_lib.sfx[wep],NO_LOOP)
					end
				else
					if player_shot > shot_lib.energy[wep] then
						player_shot = 0
						local o = object_create(player_x, player_y, wep, shot_lib.graphic[wep], shotlist, shot_lib.dir[wep])
						obj.xspeed[o], obj.yspeed[o] = euc_speed(shot_lib.dir[wep],shot_lib.speed[wep])
						if shot_lib.sfx[wep] ~= nil then
							Sound.play(shot_lib.sfx[wep],NO_LOOP)
						end
					end
				end
				
			elseif Controls_check(oldpad,KEY_FIRE) then --Y was recently released
				if w_beam_id > -1 then
					player_shot = 0
					object_destroy(shotlist, w_beam_id)
					w_beam_id = -1
					Sound.pause(shot_lib.sfx[4])
				end
			end
			--if (Controls_check(pad,KEY_WEAPON)) and not (Controls_check(oldpad,KEY_WEAPON)) and w_beam_id < 0 then
			--	weapon = weapon + 1
			--	if weapon > 5 then weapon = 1 end
			--end
			player_shot = player_shot + 1
		else
			if w_beam_id > -1 then --change this code repeated 3 times to a "if stopbeam == true" clause
				player_shot = 0
				object_destroy(shotlist, w_beam_id)
				w_beam_id = -1
				Sound.pause(shot_lib.sfx[4])
			end
		end
		
		Graphics_initBlend() --\\\\\ MONKEY
		
		Graphics_fillRect(0, 400, 0, 240, themedb.bg[theme])
		--OBJECT EVENT LIST \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
		--player sprite and death animation
		if player_alive == true then
			local px=player_x
			local py=player_y
			Graphics_drawImage(px-11, py-8, player_graphic, themedb.ship[theme])
			Graphics_drawImage(px-1, py-1, img_ship_core)
			--player collision with bullets
		else
			player_death = player_death + 0.125
			if player_death < 4 then
				Graphics_drawPartialImage(player_x-16, player_y-16, math.floor(player_death)*33, 0, 33,33, img_ship_death, themedb.ship[theme])
			elseif player_death > 15 then
				menu_init()
			end
		end
		
		--enemy actions
		local i = 0
		while i<enemylist.size do 
			local id = ds_list_find_value(enemylist, i)
			local t = obj.type[id]
			local ox = obj.x[id]
			local oy = obj.y[id]
				
			if t == 1 then --enemy ship 1 (targeter)
				obj.target[id] = obj.target[id] - 2
				if obj.target[id] > 0 then
					obj.y[id] = oy + obj.yspeed[id]
					obj.x[id] = ox + obj.xspeed[id]
				elseif obj.target[id] < -1000 then
					obj.target[id] = 60
					obj.xspeed[id], obj.yspeed[id] = euc_speed((obj.dir[id]+180)%360, 2) --enemy goes byebye
				end
				Graphics_drawImage(obj.x[id]-6, obj.y[id]-6, img_en01, themedb.enemy[theme])
				obj.clock[id] = obj.clock[id] + 1
				if obj.clock[id] > 100 then
					obj.clock[id] = 0
					local targ_ = angle(ox,oy,player_x,player_y)
					bullet01_create(ox, oy+4, targ_, 1.5)
					if difficulty > 5 then
						bullet01_create(ox, oy+4, targ_+(30-difficulty), 1.5)
						bullet01_create(ox, oy+4, targ_-(30-difficulty), 1.5)
					end
					if difficulty > 10 then
						bullet01_create(ox, oy+4, targ_+2*(30-difficulty), 1.5)
						bullet01_create(ox, oy+4, targ_-2*(30-difficulty), 1.5)
					end
				end
				if obj.target[id] < 0 then
					if onscreen(ox,oy)==false then
						object_destroy(enemylist, id)
					end
				end					
				
			elseif t == 2 then --enemy ship 2 (bomber)
				obj.target[id] = obj.target[id] - 2
				if obj.target[id] > 0 then
					obj.y[id] = oy + obj.yspeed[id]
					obj.x[id] = ox + obj.xspeed[id]
				elseif obj.target[id] < -1000 then
					obj.target[id] = 60
					obj.xspeed[id], obj.yspeed[id] = euc_speed((obj.dir[id]+180)%360, 2) --enemy goes byebye
				end
					
				Graphics_drawImage(ox-6, oy-7, img_en02, themedb.enemy[theme])
				obj.clock[id] = obj.clock[id] + 1
				if obj.clock[id] > 128 then
					obj.clock[id] = difficulty*5
					bullet02_create(ox, oy, 1)
				end
				if obj.target[id] < 0 then
					if onscreen(ox,oy)==false then
						object_destroy(enemylist, id)
					end
				end		
				
			elseif t == 3 then --enemy ship 3 (strafer)
				obj.y[id] = oy + obj.yspeed[id]
				obj.x[id] = ox + obj.xspeed[id]
				Graphics_drawImage(ox-10, oy-4, img_en03, themedb.enemy[theme])
				obj.clock[id] = obj.clock[id] + 1
				if obj.clock[id] > 30 then
					obj.clock[id] = difficulty
					bullet03_create(ox, oy, 2.5)
				end
				obj.target[id] = obj.target[id] - 1
				if obj.target[id] < 0 then
					if onscreen(ox,oy)==false then
						object_destroy(enemylist, id)
					end
				end
				
			elseif t == 4 then --helix + v-fire ship
				obj.target[id] = obj.target[id] - 1
				if obj.target[id] > 0 then
					obj.y[id] = oy + obj.yspeed[id]
					obj.x[id] = ox + obj.xspeed[id]
				elseif obj.target[id] < -750 then
					obj.target[id] = 60
					obj.xspeed[id], obj.yspeed[id] = euc_speed((obj.dir[id]+180)%360, 1)
				elseif obj.target[id] < 0 then
					obj.clock[id] = obj.clock[id] + 1
				end
				local cl = obj.clock[id]
				Graphics_drawImage(ox-9, oy-7, img_en04, themedb.enemy[theme])
				if timer%math.ceil(30-(difficulty))==0 then
					if (cl>60 and cl<175) or cl>230 then
						bullet04_create(ox, oy, 2, 100, 10, 0)
						bullet04_create(ox, oy, 2, 100, 10, 0.5)
					end
					if cl> 145 and cl< 260 then
						bullet05_create(ox, oy, 45, 3)
						bullet05_create(ox, oy, 315, 3)
					end
						
					if cl>260 then
						obj.clock[id] = 60
					end
				end
				if obj.target[id] < 0 then
					if onscreen(ox,oy)==false then
						object_destroy(enemylist, id)
					end
				end
			
			elseif t == 5 then --kamikaze 'en05'
				obj.target[id] = obj.target[id] - 0.5
				if obj.target[id] > 0 then
					obj.y[id] = oy + obj.yspeed[id]
					obj.x[id] = ox + obj.xspeed[id]
				end
				Graphics_drawImage(ox-10, oy-7, img_en05, themedb.enemy[theme])
				if obj.target[id] < -20 then
					local i=timer%(360/(3+difficulty))
					while i<360 do
						bullet01_create(ox, oy, i, 0.5)
						i=i+(360/(3+difficulty))
					end
					effect_create(ox, oy, 'bod')
					object_destroy(enemylist, id) --self destruct
				end
				
			elseif t == 6 then --asteroid 'en06'
				if obj.var1[id] == 0 then
					obj.var2[id] = (timer%4)*math.rad(90) --choose a random rotation
					obj.var1[id] = 1
				end
				obj.target[id] = obj.target[id] - 0.5
				obj.y[id] = oy + obj.yspeed[id]
				obj.x[id] = ox + obj.xspeed[id]
				Graphics.drawImageExtended(ox,oy, obj.graphic[id]*20,0, 20,20, obj.var2[id], 1,1, img_en06, themedb.enemy[theme]) --draw extended always draws with origin at centre
				if obj.target[id] < -10 then
					if not onscreen(ox,oy) then
						obj.clock[id] = obj.clock[id] + 1
						if obj.clock[id] > 40 then
							object_destroy(enemylist, id) --self destruct
						end
					end
				end
				
			elseif t ==107 then --odin
				obj.target[id] = obj.target[id] - 1
				if obj.target[id] > 0 then
					obj.y[id] = oy + obj.yspeed[id]
					obj.x[id] = ox + obj.xspeed[id]
				end
				Graphics_drawImage(math.floor(ox-8), math.floor(oy-6), img_en07, themedb.enemy[theme])
				obj.clock[id] = obj.clock[id] + 1
				
				if obj.var2[id] == 1 then --if shield engaged
					obj.var1[id] = obj.var1[id] + 0.08
					--projecting shield???
					if obj.clock[id] > 180  then --engage beam if charged
						obj.var2[id] = 2 --var2 means that beam mode has been engaged
						local pow = math.min(3,(math.ceil(obj.var1[id]*0.1)))
						obj.var1[id] = pow*10
						bullet08_create(ox, oy+10, id, pow)
						--start moving
						local sp_=0
						local dir_=0
						local tar_=0
						if (ox<=350 and ox>=50) or (ox<50 and player_x>=ox) or (ox>350 and player_x<=ox) then
							if ox>player_x then
								dir_=270; sp_=0.5; tar_ = 2*(ox-50)
							else dir_=90; sp_=0.5; tar_ = 2*(350-ox) end
							obj.target[id]=tar_
							obj.dir[id]=dir_
							obj.xspeed[id], obj.yspeed[id] = euc_speed(dir_, sp_)
						end
					end
						
				elseif obj.var2[id] == 2 then --is beam mode engaged?
					obj.var1[id] = obj.var1[id] - 0.08
					if obj.var1[id] <= 0 then --energy expended
						obj.clock[id] = 0
						obj.var2[id] = 0
						obj.target[id] = 0
					end
					
				elseif obj.clock[id] == 70 then --engage shield if unguarded for a while
					obj.var2[id] = 1
					obj.var1[id] = 0.08
					local o=object_create(ox, oy, 8, img_en08, enemylist, 0)
					obj.var1[o] = id --var1 for the shield is its host
					obj.hp[o] = 9999
				end
				
			elseif t== 8 then --shield
				local hid = obj.var1[id]
				local hx = obj.x[hid]
				local hy = obj.y[hid]
				if hx == nil or obj.var2[hid]==2 then --host doesn't exist or has engaged beam
					object_destroy(enemylist, id)
				else
					local ep = obj.var1[hid]
					if obj.hp[id]<9999 then --charge hosts' power if shield has been hit
						obj.var1[hid]=ep+1
						obj.hp[id]=9999
					end
					obj.x[id] = hx
					obj.y[id] = hy
					local xoff = math.max(0,math.min(2,math.floor(ep*0.1)))
					Graphics_drawPartialImage(math.floor(ox-15),math.floor(oy-15), xoff*31,0, 31,31, img_en08, themedb.bullet[theme])
				end	
				
			elseif t == 201 then --boss 01
				local bhp = obj.hp[id]
				stage_boss_hp = bhp
				if obj.target[id] > 0 then
					obj.y[id] = oy + obj.yspeed[id]
					obj.x[id] = ox + obj.xspeed[id]
					obj.target[id] = obj.target[id] - 0.25
					if obj.target[id] < 0.25 then
						obj.hp[id] = stage_boss_hp_max --invincibile until stopped moving
					end
				else
					obj.clock[id] = obj.clock[id] + 1 --clock doesn't tick when boss isn't onscreen
				end
				
				Graphics_drawImage(ox-29, oy-16, img_boss01, themedb.enemy[theme])
				if bhp > 0.66*stage_boss_hp_max then
					if obj.phase[id]==0 then obj.phase[id]=1; spellcard_name = '"Offensive Matrix: Scattershot"' end
					if obj.clock[id] == 35 then
						local targ_ = angle(ox,oy,player_x,player_y)
						bullet01_create(ox, oy, targ_, 1.5)
						bullet01_create(ox, oy, targ_+(25 - difficulty), 1.5)
						bullet01_create(ox, oy, targ_-(25 - difficulty), 1.5)
						bullet01_create(ox, oy, targ_+2*(25 - difficulty), 1.5)
						bullet01_create(ox, oy, targ_-2*(25 - difficulty), 1.5)
						if difficulty > 5 then
							bullet01_create(ox, oy, targ_+3*(25 - difficulty), 1.5)
							bullet01_create(ox, oy, targ_-3*(25 - difficulty), 1.5)
						end
						if difficulty > 10 then
							bullet01_create(ox, oy, targ_+4*(25 - difficulty), 1.5)
							bullet01_create(ox, oy, targ_-4*(25 - difficulty), 1.5)
						end
					elseif obj.clock[id] == 70 then
						local targ_ = angle(ox,oy,player_x,player_y)
						bullet01_create(ox, oy, targ_+0.5*(25 - difficulty), 1.5)
						bullet01_create(ox, oy, targ_-0.5*(25 - difficulty), 1.5)
						bullet01_create(ox, oy, targ_+1.5*(25 - difficulty), 1.5)
						bullet01_create(ox, oy, targ_-1.5*(25 - difficulty), 1.5)
						if difficulty > 5 then --need to make this more linear
							bullet01_create(ox, oy, targ_+2.5*(25 - difficulty), 1.5)
							bullet01_create(ox, oy, targ_-2.5*(25 - difficulty), 1.5)
						end
						if difficulty > 10 then
							bullet01_create(ox, oy, targ_+3.5*(25 - difficulty), 1.5)
							bullet01_create(ox, oy, targ_-3.5*(25 - difficulty), 1.5)
						end
					elseif obj.clock[id] > 70 then
						obj.clock[id] = 1
					end
					
				elseif bhp > 0.33*stage_boss_hp_max then
					if obj.phase[id]==1 then obj.phase[id]=2; spellcard_name = '"Defensive Matrix: Shield"'; kill_bullets() end
					if obj.clock[id] == 50 then
						local o=0
						local i=-8
						local targ_ = angle(ox,oy,player_x,player_y)
						while i<7 do
							bullet01_create(ox, oy, targ_+i*(22 - difficulty), 1.5, -0.3)
							i=i+2
						end
						if difficulty > 3 then
							bullet02_create(ox-18, oy, 1)
						end
					elseif obj.clock[id] ==100 then
						local o=0
						local i=-6
						local targ_ = angle(ox,oy,player_x,player_y)
						while i<9 do
							bullet01_create(ox, oy, targ_+i*(22 - difficulty), 1.5, 0.3)
							i=i+2
						end
						if difficulty > 3 then
							bullet02_create(ox+18, oy, 1)
						end
					elseif obj.clock[id] >100 then
						obj.clock[id] = 1
					end
					
				else 
					if obj.phase[id]==2 then obj.phase[id]=3; spellcard_name = '"Self Destruct Matrix"'; kill_bullets() end
					if DEBUG==true then
						if timer%10==0 then
							local i=timer%10
							while i<360 do
								bullet01_create(ox, oy, i, 2)
								i=i+10
							end
						end	
					end
					local cl = obj.clock[id]
					local sw = 45+difficulty*3 --point at which the rotation direction "switches"
					local ang = 0.1+(difficulty>>7) --this apparently means divided by 16
					if ang*cl < sw then
						if cl % (15 - math.floor(difficulty*0.2)) == 0 then
							bullet01_create(ox, oy, ang*cl, 2)
							bullet01_create(ox, oy, ang*cl+ 60, 2)
							bullet01_create(ox, oy, ang*cl+120, 2)
							bullet01_create(ox, oy, ang*cl+180, 2)
							bullet01_create(ox, oy, ang*cl+240, 2)
							bullet01_create(ox, oy, ang*cl+300, 2)
						end
					else
						if cl % (15 - math.floor(difficulty*0.2)) == 0 then
							bullet01_create(ox, oy, 2*sw - ang*cl+  0, 2)
							bullet01_create(ox, oy, 2*sw - ang*cl+ 60, 2)
							bullet01_create(ox, oy, 2*sw - ang*cl+120, 2)
							bullet01_create(ox, oy, 2*sw - ang*cl+180, 2)
							bullet01_create(ox, oy, 2*sw - ang*cl+240, 2)
							bullet01_create(ox, oy, 2*sw - ang*cl+300, 2)
						end
						if ang*cl >= 2*sw then
							obj.clock[id] = 0
						end
					end
				end
				
			elseif t == 202 then
				local bhp = obj.hp[id]
				stage_boss_hp = bhp
				if obj.target[id] > 0 then
					obj.y[id] = oy + obj.yspeed[id]
					obj.x[id] = ox + obj.xspeed[id]
					obj.target[id] = obj.target[id] - 0.25
					if obj.target[id] < 0.25 then
						obj.hp[id] = stage_boss_hp_max --invincibile until stopped moving
					end
				else
					obj.clock[id] = obj.clock[id] + 1 --clock doesn't tick when boss isn't onscreen
				end
				local cl = obj.clock[id]
				Graphics_drawImage(ox-19, oy-17, img_boss02, themedb.enemy[theme])
				
				if bhp > 0.66*stage_boss_hp_max then
					if obj.phase[id]==0 then obj.phase[id]=1; spellcard_name= '"Shield Cannon"'; kill_bullets() end
					if cl == 87 then
						local targ_ = angle(ox,oy,player_x,player_y)
						bullet07_create(ox+ 0, oy-24, targ_, 1.5, 90, -0.6)
						bullet07_create(ox+15, oy-15, targ_, 1.5, 45, -0.6)
						bullet07_create(ox+24, oy+ 0, targ_, 1.5,  0, -0.6)
						bullet07_create(ox+15, oy+15, targ_, 1.5,315, -0.6)
						bullet07_create(ox+ 0, oy+24, targ_, 1.5,270, -0.6)
						bullet07_create(ox-15, oy+15, targ_, 1.5,225, -0.6)
						bullet07_create(ox-24, oy+ 0, targ_, 1.5,180, -0.6)
						bullet07_create(ox-15, oy-15, targ_, 1.5,135, -0.6)
						obj.clock[id] = 0
					end
					
					if cl == 20 then
						local targ_ = angle(ox,oy,player_x,player_y)
						local i=0
						while i<difficulty/2 do
							bullet01_create(ox, oy, targ_+i*(20-(0.5*difficulty)), 1)
							bullet01_create(ox, oy, targ_-i*(20-(0.5*difficulty)), 1)
							i=i+1
						end
					end
						
				elseif bhp > 0.33*stage_boss_hp_max then
					if obj.phase[id]==1 then obj.phase[id]=2; spellcard_name = '"Tidal Flux"'; kill_bullets() end
					if cl > 82 then
						local i = timer%(41-math.floor(difficulty))-3 --gives some variation to prevent cheesing
						while i<401 do
							bullet04_create( i, -3, 1, 160, 6, 0)
							i=i+(41-math.floor(difficulty))
						end
						obj.clock[id] = 0
						obj.var1[id] = player_x
						obj.var2[id] = player_y
					end
				
				else
					if obj.phase[id]==2 then obj.phase[id]=3; spellcard_name = '"Cross Cannon"'; kill_bullets() end
					if cl%(30-difficulty) == 1 and cl%(10*(30-difficulty))~=1 then
						bullet05_create(50, -3, 45, 2)
						bullet05_create(350, -3, 315, 2)
						
						bullet01_create(ox-5, oy+10, angle(ox-5,oy+10,obj.var1[id],obj.var2[id]), 1)
						bullet01_create(ox+5, oy+10, angle(ox+5,oy+10,obj.var1[id],obj.var2[id]), 1)
					
					elseif cl % (82-difficulty) == 1 then
						obj.var1[id] = player_x
						obj.var2[id] = player_y
						bullet02_create(player_x, -3, 1)
					end
				end
				
			elseif t == 203 then --odin 'bo03'
				local bhp = obj.hp[id]
				stage_boss_hp = bhp
				obj.clock[id] = obj.clock[id] + 1 --clock doesn't tick when boss isn't onscreen
				local cl = obj.clock[id]
				local bid = obj.var1[id]
				
				if cl%650==200 then
					local i=0
					while i<4 do
						local o = object_create(50+i*100, -30, 1, img_en01, enemylist, 0)
						obj.hp[o] = 18
						obj.target[o] = 40
						obj.xspeed[o], obj.yspeed[o] = euc_speed(0,2)
						i=i+1
					end
				end
				
				if bhp > 0.66*stage_boss_hp_max then
					if obj.phase[id]==0 then
						obj.phase[id]=1
						spellcard_name= '"Alpha Squad Test"'
						kill_bullets();
						obj.x[id]=600
						local o = object_create(200, -30, 107, img_en07, enemylist, 0) --creation of odin, fleet commander
						obj.hp[o] = stage_boss_hp_max
						obj.target[o] = 70
						obj.xspeed[o], obj.yspeed[o] = euc_speed(0,1)
						obj.var1[id] = o
						bid = o
					end
					obj.hp[id] = obj.hp[bid]
				
				elseif bhp > 0.33*stage_boss_hp_max then
					if obj.phase[id]==1 then obj.phase[id]=2; spellcard_name= '"Beta Squad Test"'; kill_bullets(); kill_enemies();
						obj.var2[bid]=0; --reset mode to unshielded
						obj.var1[bid]=0; --reset energy to zero
						obj.clock[bid]=0;
						obj.clock[id]=0
						obj.xspeed[id], obj.yspeed[id] = euc_speed(0,0)
					end
					obj.hp[id] = obj.hp[bid]
					
					if cl%600==1 then
						local i=0
						while i<3 do
							local o = object_create(100+i*100, -30, 5, img_en05, enemylist, 0)
							obj.hp[o] = 90
							obj.target[o] = 150
							obj.xspeed[o], obj.yspeed[o] = euc_speed(0,0.5)
							i=i+1
						end
					end
					
				else
					if obj.phase[id]==2 then obj.phase[id]=3; spellcard_name= '"Gamma Squad Test"'; kill_bullets(); kill_enemies();
						obj.var2[bid]=0; --reset mode to unshielded
						obj.var1[bid]=0; --reset energy to zero
						obj.clock[bid]=0;
						obj.clock[id]=0
						obj.xspeed[id], obj.yspeed[id] = euc_speed(0,0)
					end
					obj.hp[id] = obj.hp[bid]
					if obj.hp[id] == nil then
						kill_enemies()
						object_destroy(enemylist, id)
						cl=0
					end
					
					if cl%900==1 then
						local i=0
						while i<2 do
							local o = object_create(75+i*250, -30, 4, img_en04, enemylist, 0)
							obj.hp[o] = 100
							obj.target[o] = 60
							obj.xspeed[o], obj.yspeed[o] = euc_speed(0,1)
							i=i+1
						end
					end
				end
					
			end
			
			i = i+1
		end
		
		--ENEMY BULLETS\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
		local i = 0
		while i<bulletlist.size do
			local id = ds_list_find_value(bulletlist, i)
			local t = obj.type[id]
			local ox = obj.x[id]
			local oy = obj.y[id]
			if t == 1 then
				if onscreen(ox,oy)==false then
					object_destroy(bulletlist, id)
				else
					if obj.var1[id] == 0 or timer%2 ~= 0 then
						obj.x[id] = ox + obj.xspeed[id]
						obj.y[id] = oy + obj.yspeed[id]
					else
						obj.dir[id] = obj.dir[id] + obj.var1[id]*2 --b01 bullets can have a "spin" applied to them. Multiplied by 2 because it's only altered every 2 frames
						obj.xspeed[id], obj.yspeed[id] = euc_speed(obj.dir[id], obj.var2[id]) --var1 is rotation speed, var2 is initial speed
					end
					Graphics_drawImage(obj.x[id]-3, obj.y[id]-3, img_bullet01, themedb.bullet[theme])
					--Graphics_drawImage(obj.x[id], obj.y[id], img_r)
				end
			elseif t == 2 then --payload 'b02'
				if onscreen(ox,oy)==false then
					object_destroy(bulletlist, id)
				else
					obj.y[id] = oy + obj.yspeed[id]
					Graphics_drawImage(obj.x[id]-1, obj.y[id]-5, img_bullet02, themedb.bullet[theme])
					--also, make this bullet explode into more)
				end
			elseif t == 3 then --II shot 'b03'
				if onscreen(ox,oy)==false then
					object_destroy(bulletlist, id)
				else
					obj.y[id] = oy + obj.yspeed[id]
					Graphics_drawImage(math.floor(obj.x[id]-4), math.floor(obj.y[id]-3), img_bullet03, themedb.bullet[theme])
				end
			elseif t == 4 then --swaying bullets
				if onscreen(ox,oy)==false then
					object_destroy(bulletlist, id)
				else
					obj.clock[id] = obj.clock[id] + 1
					obj.x[id] = ox + obj.xspeed[id]
					obj.y[id] = oy + obj.yspeed[id]
					Graphics_drawImage(ox-3, oy-3, img_bullet04, themedb.bullet[theme])
					if obj.clock[id]<=(obj.var1[id]*0.5) then --var1 is the frequency of the wave (in ticks)
						obj.xspeed[id] = obj.xspeed[id] + (obj.var2[id]/obj.var1[id]) --var2 is the magnitude of the wave (in arbitrary measurement)
					else
						obj.xspeed[id] = obj.xspeed[id] - (obj.var2[id]/obj.var1[id])
						if obj.clock[id] == (obj.var1[id]) then
							obj.clock[id] = 0
						end
					end
				end
			elseif t == 5 then --diagonal shots
				if onscreen(ox,oy)==false then
					object_destroy(bulletlist, id)
				else
					obj.x[id] = ox + obj.xspeed[id]
					obj.y[id] = oy + obj.yspeed[id]
					Graphics_drawImage(ox-2, oy-2, obj.graphic[id], themedb.bullet[theme]) --error?
					obj.dir[id] = obj.dir[id] + obj.hp[id]
				end
				
			elseif t == 7 then --rotating bullets
				if onscreen(ox,oy)==false then
					object_destroy(bulletlist, id)
				else
					obj.x[id] = ox + obj.xspeed[id]
					obj.y[id] = oy + obj.yspeed[id]
					if timer%2==0 then
						obj.y[id] = obj.y[id] + (math.cos(math.rad(obj.dir[id]))*1)
						obj.x[id] = obj.x[id] + (math.sin(math.rad(obj.dir[id]))*1)
					end
					Graphics_drawImage(ox-2, oy-2, img_bullet07, themedb.bullet[theme])
					obj.dir[id] = obj.dir[id] + obj.hp[id]
				end
				
			elseif t== 8 then --beam
				local hid = obj.var1[id] --var1 is host, var2 is final power
				local pow = obj.var2[id]
				local cl = obj.clock[id]
				local hx = obj.x[hid]
				local hy = obj.y[hid]
				local xoff = 0
				local hitx = 0
				obj.clock[id] = cl + 1
				if hx == nil or obj.var2[hid]==0 then  --host doesn't exist or has exhausted energy
					object_destroy(bulletlist, id)
				else
					obj.x[id] = hx
					obj.y[id] = hy+10
					 --progression of the different beam animations
					if pow==1 then
						if cl<20 then xoff = 0
						elseif cl<40 then xoff = 1
						elseif cl<60 then xoff = 2
						else xoff = 3; hitx = 4 end
					elseif pow==2 then
						if cl<18 then xoff = 0
						elseif cl<36 then xoff = 1
						elseif cl<64 then xoff = 2
						elseif cl<72 then xoff = 3; hitx = 4
						else xoff = 4; hitx = 5 end
					elseif pow>=3 then
						if cl<16 then xoff = 0
						elseif cl<32 then xoff = 1
						elseif cl<48 then xoff = 2
						elseif cl<60 then xoff = 3; hitx = 4
						elseif cl<72 then xoff = 4; hitx = 5 --3.5 + 1.5
						else xoff = 5; hitx = 6 end
					end
					if not (timer%3>0 and xoff<2) then
						Graphics_drawPartialImage(ox-7,oy, xoff*15,0, 15,240, img_bullet08, themedb.bullet[theme])
					end
				end
			end
			i = i+1
		end
		
		--friendly bullets
		local i = 0
		while i<shotlist.size do 
			local id = ds_list_find_value(shotlist, i)
			local t = obj.type[id]
			local shotw = shot_lib.width[t]
			local shoth = shot_lib.height[t]
			local speed = shot_lib.speed[t]
			local graph = shot_lib.graphic[t]
			
			if t==2 then
				obj.yspeed[id] = obj.yspeed[id]-.125;
			elseif t==4 then
				obj.x[id] = player_x
				obj.y[id] = player_y - 10
			elseif t==5 and timer%2==1 then
				obj.xspeed[id], obj.yspeed[id] = euc_speed(obj.dir[id], shot_lib.speed[5])
			end
			
			obj.x[id] = obj.x[id] + obj.xspeed[id]
			obj.y[id] = obj.y[id] + obj.yspeed[id]
			local ox = obj.x[id]
			local oy = obj.y[id]
			
			if onscreen(ox,oy)==false then
				object_destroy(shotlist, id)
			else
				--collision check
				local j=0
				local range=400; local targ_=-1; --tracer variables
				while j<enemylist.size do
					local idc = ds_list_find_value(enemylist, j)
					local typ = obj.type[idc]
					local ex=obj.x[idc]
					local ey=obj.y[idc]
					local er=nil --enemy_lib_radius[typ] --this doesn't really work with hitboxes too well
					if t==5 then --tracer calculations
						local nr = math.sqrt((ex-ox)^2 + (ey-oy)^2)
						if nr < range then
							range = nr
							targ_ = idc
						end
					end
					--this is where you need to take out the generalised code nad use the local tables I just added above containing all the different enemy widths
					--Check if an enemy has a radius measurement first, and if it does, use that.
					local hit=false
					if er ~= nil then
						if math.sqrt((ex-ox)^2 + (ey-oy)^2) < er then
							hit=true
						end
					else
						local ew = enemy_lib_width[typ]
						local eh = enemy_lib_height[typ]
						if ox<ex+(ew+shotw)*0.5 and ox>ex-(ew+shotw)*0.5 and oy<ey+(eh+shoth)*0.5 and oy>ey-(eh+shoth)*0.5 then
							hit = true
						end
					end
					if hit==true then
						obj.hp[idc] = obj.hp[idc] - shot_lib.power[t]
						if obj.hp[idc] < 1 then
							local dty = obj.type[idc]
							if dty == 1 then score=score+2*difficulty; effect_create(ex, ey, 'end')
							elseif dty == 2 then score=math.ceil(score+4*(1+difficulty*.125)); effect_create(ex, ey, 'end')
							elseif dty == 3 then score=math.ceil(score+4*(1+difficulty*.125)); effect_create(ex, ey, 'end')
							elseif dty == 4 then score=math.ceil(score+10*(1+difficulty*.125)); effect_create(ex, ey, 'end')
							elseif dty == 5 then score=math.ceil(score+ 6*(1+difficulty*.125)); effect_create(ex, ey, 'end')
							elseif dty == 6 then score=math.ceil(score+10*(1+difficulty*.125)); effect_create(ex, ey, 'end')
							elseif dty == 107 then score=math.ceil(score+14*(1+difficulty*.125)); effect_create(ex, ey, 'end')
							elseif dty == 201 then score=math.ceil(score+50*(1+difficulty*.125)); effect_create(ex, ey, 'bod')
							elseif dty == 202 then score=math.ceil(score+65*(1+difficulty*.125)); effect_create(ex, ey, 'bod')
							end
							object_destroy(enemylist, idc)
						end
						if t~=4 then --beam continues to hit, so we don't delete it yet unlike other bullets
							object_destroy(shotlist, id)
							targ_ = -1
							j=enemylist.size
						end
					end
					j=j+1
				end
				if timer%2==0 and targ_>0 and range<100 then --turning to face a close target
					local ang = angle(ox,oy, obj.x[targ_], obj.y[targ_])
					local fac = obj.dir[id]
					local off = ((ang-fac+180)%360)-180
					obj.dir[id]= obj.dir[id]+math.min(10,400/range)*(off/math.abs(off))
				end
					
				Graphics_drawImage(math.floor(ox-math.floor(shotw*0.5)), math.floor(oy-math.floor(shoth*0.5)), graph, themedb.null[theme])
				--end collision check
			end
			i = i+1
		end
		
		--effects handling
		local i = 0
		while i<fxlist.size do 
			local id = ds_list_find_value(fxlist, i)
			local g = obj.graphic[id]
			local t = obj.type[id]
			local ox = obj.x[id]
			local oy = obj.y[id]
			local cl = obj.clock[id]
			local life = 0
			local fxw = 0
			local fyh = 0
			local th = 0
			if t== 'end' then fxw = 11; fyh = 11; life = 3; th = themedb.ship[theme]
			elseif t=='bod' then fxw=49; fyh= 19; life = 5; th = themedb.ship[theme]
			elseif t=='bud' then fxw=5; fyh=5; life = 3; th = themedb.null[theme] --experimental
			elseif t=='pld' then fxw=31; fyh=31; life=4; th = themedb.ship[theme] end
			
			Graphics_drawPartialImage(math.floor(ox-fxw*0.5), math.floor(oy-fyh*0.5), math.floor(cl)*fxw, 0, fxw,fyh, g, th) --ox is nill on destruction of kamikaze
			if cl>=life then
				object_destroy(fxlist, id)
			else
				obj.clock[id] = cl + 0.125
			end
			i=i+1
		end
		
		if warning_flash > 0 then
			warning_flash = warning_flash + 1
			if warning_flash % 40 == 2 then
				Sound.play(wav_warning,NO_LOOP)
			end
			if warning_flash % 30 > 8 then
				Graphics_drawImage(174, 115, img_warning, themedb.null[theme])
			end
			if warning_flash > 120 then
				warning_flash = 0
				local o = object_create(200, -70, stage_boss, -1, enemylist, 0)
				obj.hp[o] = 9999
				obj.target[o] = 120
				obj.xspeed[o], obj.yspeed[o] = euc_speed(0, 0.25)
			end
		end
		
		if stage_clear == 0 then
			if enemylist.size < 1 and warning_flash == 0 then
				stage_clear = 1
			end
		elseif stage_clear > 0 then
			Graphics_drawImage(161, 112, img_clear, themedb.null[theme])
			stage_clear = stage_clear + 1
			if stage_clear > 200 then
				menu_init()
			end
		end
		
		Graphics_termBlend()
		
		--PLAYER COLLISION AND DEATH\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
		if player_alive == true then
			local hit=false
			local px=player_x
			local py=player_y
			local col={}
			col[1]=Screen.getPixel(px, py-1);
			col[2]=Screen.getPixel(px, py+1); 
			col[3]=Screen.getPixel(px-1, py); 
			col[4]=Screen.getPixel(px+1, py);
			local i=1
			while i<5 do
				local c = Color.getB(col[i])
				if c==themedb.hit1[theme] or c==themedb.hit2[theme] then --enemy and bullet textures. Consider pulling these from a theme-specific database
					player_alive = false
					Sound.play(wav_ship_death,NO_LOOP)
					i=5
				else i=i+1
				end
			end
		end
		
		--GUI DRAW PHASE \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
		Graphics_initBlend()
		gpu_drawtext(48,5, tostring(score), themedb.bullet[theme])
		Graphics_drawImage(8, 8, img_score, themedb.bullet[theme])
		fps_draw()
		if stage_boss_hp_max > 0 then
			Graphics_drawPartialImage(155,3, 0,0, 162,16, img_boss_hp_bar, themedb.bg[theme])
			Graphics_drawPartialImage(155,3, 0,16, 38+ 121*math.min(1,stage_boss_hp/stage_boss_hp_max),16, img_boss_hp_bar, themedb.bullet[theme])
		end
		--gpu_drawtext(5,30, spellcard_name) --to add this function, you'll first need to initialize the alphabet
		if DEBUG then
			gpu_drawtext(150,30, tostring(debugval1))
			Graphics_fillRect(150, 250, 70, 100, debugval1)
			--gpu_drawtext(150,55, tostring(c_light))
			--gpu_drawtext(150,80, tostring(c_bg))
			--gpu_drawtext(150,105, tostring(c_ship))
		end
		Graphics_termBlend()
		
		if v_record == true and timer%3==1 then
			System.takeScreenshot(scrdir.."/f"..v_frame..".jpg",true)
			v_frame=v_frame+1
		end
		
		Screen_flip()
		
		--PLAY SOUNDS \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
		if playwav.b01 then
			Sound.play(wav_b01,NO_LOOP)
			playwav.b01 = false
		end
		if playwav.b02 then
			Sound.play(wav_b02,NO_LOOP)
			playwav.b02 = false
		end
		if playwav.b03 then
			Sound.play(wav_b03,NO_LOOP)
			playwav.b03 = false
		end
		if playwav.b04 then
			Sound.play(wav_b04,NO_LOOP)
			playwav.b04 = false
		end
		if playwav.b07 then
			Sound.play(wav_b07,NO_LOOP)
			playwav.b07 = false
		end
		
		--SPAWN NEW ENEMIES \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
		local morespawn = true
		while morespawn == true do
			if larray.time[spawnindex] == nil then
				morespawn = false
				if stage_clear == -1 then
					stage_clear = 0
				end
			elseif (larray.time[spawnindex] < timer) then
				local ty = larray.enid[spawnindex]
				local D = larray.dir[spawnindex]
				local P = larray.pix[spawnindex]
				
				local nx =0
				local ny =0
				local dmov=0
				
				if D == "T" then
					nx = P
					ny = -30
					dmov = 0
				else
					ny = P
					if D == "L" then
						nx = -30
						dmov = 90
					else
						nx = 430
						dmov = 270
					end
				end
				
				local img_ = -1
				local hp_ = -1
				local targ_ = -1
				local spawn_ = -1
				local sp_ = 0
				
				if ty == 'en01' then
					img_ = img_en01
					hp_ = 6
					targ_ = 60
					spawn_ = 1
					sp_ = 2
					ty = 1
				elseif ty == 'en02' then
					img_ = img_en02
					hp_ = 14
					targ_ = 60
					spawn_ = 1
					sp_ = 2
					ty = 2
				elseif ty == 'en03' then
					img_ = img_en03
					hp_ = 10
					targ_ = 60
					spawn_ = 1
					sp_ = 0.5
					ty = 3
				elseif ty == 'en04' then
					img_ = img_en04
					hp_ = 60
					targ_ = 60
					spawn_ = 1
					sp_ = 1
					ty = 4
				elseif ty == 'en05' then
					img_ = img_en05
					hp_ = 30
					targ_ = 150
					spawn_ = 1
					sp_ = 0.5
					ty = 5
				elseif ty == 'en06' then
					img_ = timer%3
					hp_ = 100
					targ_ = 30
					spawn_ = 1
					sp_ = 0.5
					dmov = dmov + ((timer%26)-13)
					ty = 6
				elseif ty == 'en07' then
					img_ = img_en07
					hp_ = 100
					targ_ = 60
					spawn_ = 1
					sp_ = 1
					ty = 107 --elite mob
				elseif ty == 'bo01' then
					stage_boss = 201
					stage_boss_hp_max = 1200
					warning_flash = 1
				elseif ty == 'bo02' then
					stage_boss = 202
					stage_boss_hp_max = 1200
					warning_flash = 1
				elseif ty == 'bo03' then
					stage_boss = 203
					stage_boss_hp_max = 500
					warning_flash = 1
				end
				
				if spawn_ == 1 then
					local o = object_create(nx, ny, ty, img_, enemylist, dmov)
					obj.hp[o] = hp_
					obj.target[o] = targ_
					obj.xspeed[o], obj.yspeed[o] = euc_speed(dmov,sp_)
				end
				
				spawnindex = spawnindex + 1
			else
				morespawn = false
			end
		end
		
		timer = timer + 1
		
		
		if (Controls_check(pad,KEY_START)) and not (Controls_check(oldpad,KEY_START)) then
			menu_init()
		end
	end
	oldpad = pad
end