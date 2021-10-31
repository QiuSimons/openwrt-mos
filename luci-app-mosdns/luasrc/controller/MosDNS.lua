module("luci.controller.MosDNS", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/MosDNS") then
		return
	end

	entry({"admin", "services", "MosDNS"}, alias("admin", "services", "MosDNS", "basic"), _("MosDNS"), 30).dependent = true
	entry({"admin", "services", "MosDNS", "basic"}, cbi("MosDNS/basic"), _("Basic Setting"), 1).leaf = true
	entry({"admin", "services", "MosDNS", "update"}, cbi("MosDNS/update"), _("Geodata Update"), 2).leaf = true
	entry({"admin", "services", "MosDNS", "config"}, cbi("MosDNS/config"), _("Manual Configuration"), 3).leaf = true
	entry({"admin", "services", "MosDNS", "status"}, call("act_status")).leaf = true
end

function act_status()
	local e = {}
	e.running = luci.sys.call("pgrep -f mosdns >/dev/null") == 0
	luci.http.prepare_content("application/json")
	luci.http.write_json(e)
end
