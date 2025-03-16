return {
	PhoneHandler = (function()
		-- note: search for the ByteUtil module in upvalues of every connection to this signal
		local signal = game.Players.LocalPlayer.PlayerGui.Telefonix.UberTaxi.Frame.Accept.Activated
		local ret = {}
		for _, conn in getconnections(signal) do
			if conn.Function then
				-- local source = debug.info(conn.Function, "s")
				for _, upv in debug.getupvalues(conn.Function) do
					if
						type(upv) == "table"
						and type(upv.b) == "function"
						and upv.c
						and type(upv.c.Connect) == "function"
					then
						table.insert(ret, upv)
						break
					end
				end
			end
		end
		if ret[1] then
			if DEBUG then
				print("Succesfully found PhoneHandler ByteUtil module!")
			end
		else
			error("Failed to find ByteUtil module for PhoneHandler")
		end
		return ret[1]
	end)(),
}
