local Months = {
	[1] = "January",
	[2] = "February",
	[3] = "March",
	[4] = "April",
	[5] = "May",
	[6] = "June",
	[7] = "July",
	[8] = "August",
	[9] = "September",
	[10] = "October",
	[11] = "November",
	[12] = "December",
}

local days30 = { 4, 6, 9, 11 }

--[=[
	@class Date

	Simple util that helps with managing dates and helps with getting certain days,months etc...
]=]
local Date = {}
--[=[
	This function returns the current date in the format of dd/mm/yy

	@return string -- Returns the formatted string
]=]
function Date.todayInFormat(): string
	local date = os.date("!*t")
	local day = date["day"]
	local month = date["month"]
	local year = date["year"]
	if day < 10 then
		day = "0" .. day
	end
	if month < 10 then
		month = "0" .. month
	end
	return day .. "/" .. month .. "/" .. year
end
--[=[
	This function allows you to format a date in any way you want by using [os.date()](https://create.roblox.com/docs/reference/engine/libraries/os#date) specifiers
	Example:
	```lua
	Date.GetStringDate("/","%m","%d","%y") -- Example value would be 06/12/25

	```
	@param filler string -- This is the string that will be inbetween every specifier you put.
	@param ... string -- The specifiers you want to add.
	@return string -- Returns the formatted string
]=]
function Date.stringDate(filler, ...: string): string
	local Data = { ... }
	local fullstring = ""
	for i, val in Data do
		if i == 1 then
			fullstring = val
		else
			fullstring = fullstring .. filler .. val
		end
	end
	return tostring(os.date(fullstring))
end
--[=[
	Basic function that switchs a month's name to its number
	Example: June -> 6

	@param month string -- Month that you want switched to a number.
	@return number -- The month number
]=]
function Date.numericalMonth(month: string): number
	return table.find(Months, month) or 0
end
--[=[
	Basic function that switchs a month's number to its name
	Example: 12 -> December

	@param month number -- Month number to stringify.
	@return string -- Month name
]=]
function Date.stringifyMonth(month: number): string
	return Months[month] or "Invalid Month"
end
--[=[
	A function that returns the month after the specified month

	@param year number -- Year number incase it moves up a year
	@param month number -- Month number
	@return {["year"] : number , ["month"] : number} -- The next month's number and year incase of change.
]=]
function Date.nextMonth(year: number, month: number): { ["year"]: number, ["month"]: number }
	local nextmonth = month + 1
	if nextmonth >= 13 then
		nextmonth = 1
		year += 1
	end
	return { year = year, month = nextmonth }
end
--[=[
	A function that returns the month before the specified month

	@param year number -- Year number incase it moves down a year
	@param month number -- Month number
	@return {["year"] : number , ["month"] : number} -- The previous month's number and year incase of change.
]=]
function Date.GetPrevMonth(year: number, month: number): { ["year"]: number, ["month"]: number }
	local prevmonth = month - 1
	if prevmonth <= 0 then
		prevmonth = 12
		year -= 1
	end
	return { year = year, month = prevmonth }
end
--[=[
	A function that returns a boolean on if the specified year is a leap year

	@param year number -- The year to check
	@return boolean -- The boolean on if the year is a leap year
]=]
function Date.isLeapYear(year: number): boolean
	return year % 4 == 0 and year % 100 ~= 0
end
--[=[
	A function that returns the amount of days that is in the specified month and year
	Example: `February 2024` would return `29`
	@param month string| number -- The month you want to get the days from
	@param year number -- The year (incase of leap year)
	@return number -- Amount of days in specified month
]=]
function Date.daysInMonth(month: string | number, year: number): number
	if typeof(month) == "string" then
		month = Date.numericalMonth(month)
	end

	if month == 2 then
		return Date.isLeapYear(year) and 29 or 28
	end

	return table.find(days30, month) and 30 or 31
end

return Date
