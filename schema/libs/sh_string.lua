fo.string = fo.string or {}


local strSub = string.sub
local strLen = string.len
local mathCeil = math.ceil
local tblInsert = table.insert
local tblConcat = table.concat


-- Explode a string with multiple separators
function fo.string.Explode( seperators, str )
	local p = "[^"..tblConcat(seperators).."]+"

	local words = {}
	for w in str:gmatch(p) do
		tblInsert(words, w)
	end

	return words
end