--if you merge this script into index.lua, you can have the obj table as a local variable, saving a shitload of fps

obj = {}

current_id = 0
obj.type = {}
obj.graphic = {}
obj.dir = {}
obj.x = {}
obj.y = {}
obj.count = 0

obj.xspeed = {}
obj.yspeed = {}

obj.target = {}
obj.hp = {}
obj.clock = {}

obj.var1 = {}
obj.var2 = {}

obj.phase = {}

bulletlist = {}
enemylist = {}
shotlist = {}
fxlist = {}
ds_list_create(bulletlist)
ds_list_create(enemylist)
ds_list_create(shotlist)
ds_list_create(fxlist)

function object_create(ox, oy, otype, ographic, olist, odir)
	local i = current_id
	ds_list_add(olist, i)
	current_id = current_id +1
	
	obj.x[i] = ox
	obj.y[i] = oy
	obj.type[i] = otype
	obj.graphic[i] = ographic
	
	obj.dir[i] = odir
	obj.xspeed[i] = 0
	obj.yspeed[i] = 0
	
	obj.target[i] = 0
	obj.hp[i] = 0
	obj.clock[i] = 0
	
	obj.var1[i] = 0
	obj.var2[i] = 0
	
	obj.phase[i] = 0
	
	obj.count = obj.count + 1
	return i
end

function object_destroy(list, id)
	obj.type[id] = nil
	obj.graphic[id] = nil
	obj.x[id] = nil
	obj.y[id] = nil
	
	obj.dir[id] = nil
	obj.xspeed[id] = nil
	obj.yspeed[id] = nil
	
	obj.target[id] = nil
	obj.hp[id] = nil
	obj.clock[id] = nil
	
	obj.var1[id] = nil
	obj.var2[id] = nil
	
	obj.phase[id] = nil
	
	obj.count = obj.count - 1
	local ind = ds_list_find_index(list, id)
	ds_list_delete(list, ind)
end