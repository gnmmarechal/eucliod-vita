--Creates the functions used to access queues
function ds_queue_create(qname) --creates a queue from an existing table
	qname.start = 1
	qname.finish = 1
	qname.size = qname.finish - qname.start
end

function ds_queue_enqueue(qname,a)
	qname[qname.finish] = a
	qname.finish = qname.finish + 1
	qname.size = qname.finish - qname.start
end

function ds_queue_dequeue(qname)
	if qname.size > 0 then
		local a
		a = qname[qname.start]
		qname.start = qname.start + 1
		qname.size = qname.finish - qname.start
		return a
	end
end

function ds_queue_stack(qname, stackname) --stacks the entirety of a table onto the queue
	local i=1
	while stackname[i] ~= nil do
		ds_queue_enqueue(qname, stackname[i])
		i = i+1
	end
end