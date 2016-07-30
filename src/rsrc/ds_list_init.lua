function ds_list_create(lname) --creates a list from an existing table
	lname.size = 0
end

function ds_list_add(lname, value)
	lname[lname.size] = value
	lname.size = lname.size + 1
end

function ds_list_delete(lname, index)
	local i = index
	lname[i] = nil
	while i < lname.size-1 do
		lname[i] = lname[i+1]
		lname[i+1] = nil
		i = i+1
	end
	lname.size = lname.size - 1
end

function ds_list_destroy(lname)
	lname = nil
end

function ds_list_find_value(lname, index)
	return lname[index]
end

function ds_list_find_index(lname, value)
	local i=0
	local index = nil
	while i<lname.size do
		if tostring(lname[i]) == tostring(value) then
			index = i
			i = lname.size
		end
	i = i+1
	end
	
	return index --returns nil if value not found
end