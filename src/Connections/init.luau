local ConnectionsT = {}
local ToCleanUp = {}

--[=[
	@class Connections

	This is a class that makes handling connections ([RBXConnections](https://create.roblox.com/docs/reference/engine/datatypes/RBXScriptConnection)) easier!
]=]
local Connections = {}
Connections.__index = Connections
--[=[
	This is the function that creates the connection.

	@param name string -- The name you want to assign to the connection
	@param connectiontype RBXScriptSignal -- The type of connection you want to use
	@param func (any) -> (any) -- The function to run when the connection is fired
	@param AutoConnect boolean? -- If true then the connection will automatically connect to the function
	@return table -- Returns the table so that it's functions can be called
]=]
function Connections.NewConnection(
	name: string,
	connectiontype: RBXScriptSignal,
	func: (any) -> any,
	AutoConnect: boolean?
)
	assert(not ConnectionsT[name], "Name '" .. name .. "' is already in use by another function!")
	local connection = {
		["Name"] = name,
		["ConnectionType"] = connectiontype,
		["Function"] = func,
		["Connection"] = nil,
	}
	ConnectionsT[name] = setmetatable(connection, Connections)
	if AutoConnect == true then
		ConnectionsT[name]:Connect()
	end
	return connection
end
--[=[
	Connects the connection that was made.

	@return RBXScriptConnection -- Returns the newly connected connection
]=]
function Connections:Connect()
	self.Connection = self.ConnectionType:Connect(self.Function)
	return self.Connection
end
--[=[
	Disconnects the connection if it was previously connected.
]=]
function Connections:Disconnect()
	if self.Connection then
		self.Connection:Disconnect()
	end
end
--[=[
	Cleans up/Destroys the connection that is no longer needed.
]=]
function Connections:Destroy()
	self.Connection:Disconnect()
	ConnectionsT[self.Name] = nil
	setmetatable(self, nil)
end
--[=[
	This connection retrieves a connection that was previously created so it makes it possible to run the connections functions via other scripts

	@param Name string -- The name of the connection you want to get
	@return table | nil -- Returns the table so that it's functions can be called or nil, if it isn't found
]=]
function Connections.GetConnection(Name)
	if ConnectionsT[Name] then
		return ConnectionsT[Name]
	else
		return nil
	end
end
--[=[
	This connection adds said connection to a "trash can" so that when the .Clean() function is ran, all the connections in the "trash can" would be destroyed

]=]
function Connections:AddToClean()
	local Name = self.Name
	if ConnectionsT[Name] then
		table.insert(ToCleanUp, Name)
	end
end
--[=[
	This function allows you to force run the connection's given function with any arguments

	@param ... any -- any arguments
	@return any -- Returns the function data
]=]
function Connections:ForceRun(...: any?)
	return self.Function(...)
end
--[=[
	This function updates the connection's previous function to the newly set one.

	@param newfunc (any) -> any -- the function you want it to update to
]=]
function Connections:ChangeFunction(newfunc: (any) -> any)
	ConnectionsT[self.Name].Function = newfunc
end
--[=[
	This function cleans up any connections that are in the "trash can", to add connections to the trash can you need to use the :AddToClean() function
]=]
function Connections.Clean()
	for _, connection in ToCleanUp do
		if ConnectionsT[connection] then
			ConnectionsT[connection]:Destroy()
		end
	end
	ToCleanUp = {}
end

return Connections
