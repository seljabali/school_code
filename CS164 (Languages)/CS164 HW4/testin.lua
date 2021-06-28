Account = {balance = 0 }

function Account:withdraw(v)
	self.balance = self.balance - v
end

function Account:new (o)
	o = o or {}
	setmetatable(o, self)
	self.index = self
	return o
end

a = Account.new{balance = 1000}
