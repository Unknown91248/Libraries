local Connections = {}
local ToCleanUp = {}
local Main = {}
Main.__index = Main
function Main.NewConnection(name: string, connectiontype: RBXScriptSignal, func: () -> (), AutoConnect: boolean?)
	assert(not Connections[name], "Name '" .. name .. "' is already in use by another function!")
	local connection = {
		["Name"] = name,
		["ConnectionType"] = connectiontype,
		["Function"] = func,
		["Connection"] = nil,
	}
	Connections[name] = setmetatable(connection, Main)
	if AutoConnect == true then
		Connections[name]:Connect()
	end
	return connection
end

function Main:Connect()
	self.Connection = self.ConnectionType:Connect(self.Function)
	return self.Connection
end

function Main:Disconnect()
	if self.Connection then
		self.Connection:Disconnect()
	end
end

function Main:Destroy()
	self.Connection:Disconnect()
	Connections[self.Name] = nil
	setmetatable(self, nil)
end

function Main.GetConnection(Name)
	return Connections[Name]
end

function Main:AddToClean()
	local Name = self.Name
	if Connections[Name] then
		table.insert(ToCleanUp, Name)
		return Connections[Name]
	end
end

function Main:ForceRun(...: any?)
	self.Function(...)
end

function Main:ChangeFunction(newfunc: () -> ())
	Connections[self.Name].Function = newfunc
end

function Main.Clean()
	for _, connection in ToCleanUp do
		if Connections[connection] then
			Connections[connection]:Destroy()
		end
	end
	ToCleanUp = {}
end

return Main
