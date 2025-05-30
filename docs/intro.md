# Zak's Libraries
---

## 📥 Installation

All modules are installable via [Wally](https://wally.run).

---

## ⚙️ Wally Setup

First, ensure Wally is installed. Then follow these steps:

1. Initialize Wally in your project: `wally init`

2. Add the package you would like to install to your `wally.toml` file:

Example:
```toml
[dependencies] 
connections = "unknown91248/connections@0.0.2"
```
3. Install dependencies by running `wally install` in your project's terminal

4. Wally will then create a `/Packages` folder which is where you will be requiring your scripts from.
---

## 🚀 Usage Example (Connections module)

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Connections = require(ReplicatedStorage.Packages.connections)

-- Create a new named connection
local conn = Connections.NewConnection("TouchEvent", workspace.Part.Touched, function(hit)
	print("Touched by:", hit.Name)
end)

-- Start listening to the event
conn:Connect()

task.wait(5)

-- Cleanup when done
conn:Disconnect()
conn:Destroy()
```
---
