local function resolvePath(base, relative, ending)
	local path = base .. "/" .. relative .. (ending or "")
	if love.filesystem.getInfo(path) then
		return path
	else
		return nil
	end
end

return resolvePath
