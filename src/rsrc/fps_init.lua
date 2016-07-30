fps_tmr = Timer.new() -- Create a new timer
fps = 0 -- This will be the framerate var
fps_counter = 0 -- Internal var to calculate fps

function fps_draw()
	-- Increase internal val by 1
	fps_counter = fps_counter + 1

	-- If a second has passed, reset timer and save fps val
	if Timer.getTime(fps_tmr) > 1000 then
		Timer.reset(fps_tmr)
		fps = fps_counter
		fps_counter = 0
	end
	
	gpu_drawtext(160, 220, fps)
	--gpu_drawtext(370, 7, math.ceil((fl1[1]+fl1[2]+fl1[3]+fl1[4]+fl1[5])/5))
	--gpu_drawtext(370, 13, "FR2: "..tostring(math.ceil((fl2[1]+fl2[2]+fl2[3]+fl2[4]+fl2[5])/5)), red)
	--gpu_drawtext(370, 19, "FR3: "..tostring(math.ceil((fl3[1]+fl3[2]+fl3[3]+fl3[4]+fl3[5])/5)), red)
	--gpu_drawtext(370, 25, "FR4: "..tostring(math.ceil((fl4[1]+fl4[2]+fl4[3]+fl4[4]+fl4[5])/5)), red)
	--fl_c = fl_c + 1; if fl_c>4 then fl_c=1 end
end

--[[
fl_c = 1

fl1={0,0,0,0,0}
fl2={0,0,0,0,0}
fl3={0,0,0,0,0}
fl4={0,0,0,0,0}

fl_tmr = {}
fl_tmr[fl1] = Timer.new()
fl_tmr[fl2] = Timer.new()
fl_tmr[fl3] = Timer.new()
fl_tmr[fl4] = Timer.new()

n1=1
n2=2
n3=3
n4=4
n5=5

function fl_start(n)
	Timer.reset(fl_tmr[n])
end

function fl_end(n)
	n[fl_c] = Timer.getTime(fl_tmr[n])
end
]]--