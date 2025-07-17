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
--[=[
	@class Date

	Simple util that helps with managing dates and helps with getting certain days,months etc...
]=]
local Date = {}
--[=[
	This function returns the current date in the format of mm/dd/yy

	@return string -- Returns the formatted string
]=]
function Date.GetTodayInFormat(): string
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
	return month .. "/" .. day .. "/" .. year
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
function Date.GetStringDate(filler, ...: string): string
	local Data = { ... }
	local fullstring = ""
	for i, val in Data do
		if i == 1 then
			fullstring = val
		else
			fullstring = fullstring .. filler .. val
		end
	end
	return os.date(fullstring)
end
--[=[
	Basic function that switchs a month's name to its number
	Example: June -> 6

	@param month string -- Month that you would like to be switched to a number.
	@return number -- The month number
]=]
function Date.MonthTextToNumber(month: string): number
	for i, Month in Months do
		if Month:lower() == month:lower() then
			return i
		end
	end
end
--[=[
	Basic function that switchs a month's number to its name
	Example: 12 -> December

	@param month number -- Month number that you would like to be switched to a name.
	@return string -- The month name
]=]
function Date.MonthNumberToText(month: number): string
	for i, Month in Months do
		if i == month then
			return Month
		end
	end
end
--[=[
	A function that returns the month after the specified month

	@param month string | number -- Month name or number
	@return ({string, number}) -- The next month's name and number
]=]
function Date.GetNextMonth(month: string | number): ({string, number})
	if typeof(month) == "string" then
		month = Date.MonthTextToNumber(month)
	end
	local nextmonth = month + 1
	if nextmonth >= 13 then
		nextmonth = 1
	end
	return { Months[nextmonth], nextmonth }
end
--[=[
	A function that returns the month before the specified month

	@param month string | number -- Month name or number
	@return (string, number) -- The previous month's name and number
]=]
function Date.GetPrevMonth(month: string | number): ({string, number})
	if typeof(month) == "string" then
		month = Date.MonthTextToNumber(month)
	end
	local prevmonth = month - 1
	if prevmonth <= 0 then
		prevmonth = 12
	end
	return { Months[prevmonth], prevmonth }
end
--[=[
	A function that returns a boolean on if the specified year is a leap year

	@param year number -- The year you want to check
	@return boolean -- The boolean on if the year is a leap year
]=]
function Date.IsLeapYear(year: number): boolean
	return year % 4 == 0 and year % 100 ~= 0
end
--[=[
	A function that returns the amount of days that is in the specified month and year
	Example: `February 2024` would return `29`
	@param month string| number -- The month you want to get the days from
	@param year number -- The year (to check if it is a leap year)
	@return number -- Amount of days in specified month
]=]
function Date.GetDaysInMonth(month: string | number, year: number): number
	if typeof(month) == "string" then
		month = Date.MonthTextToNumber(month)
	end
	local days = 31

	if month == 2 then
		if Date.IsLeapYear(year) then
			days = 29
		else
			days = 28
		end
	elseif month == 4 or month == 6 or month == 9 or month == 11 then
		days = 30
	end

	return days
end

return Date
