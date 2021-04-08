require("luci.sys")
require("luci.util")
require("luci.http")
require("luci.dispatcher")
require("nixio.fs")
local fs=require"nixio.fs"
local port=require"luci.model.uci".cursor()
local port=port:get("MosDNS","MosDNS","port")

mp = Map("MosDNS", translate("MosDNS"))
mp.description = translate("MosDNS is a 'programmable' DNS forwarder.")
mp:section(SimpleSection).template  = "MosDNS/MosDNS_status"

s = mp:section(TypedSection, "MosDNS")
s.anonymous=true
s.addremove=false

enabled = s:option(Flag, "enabled", translate("Enable"))
enabled.default = 0
enabled.rmempty = false

-- manual-config
addr = s:option(Value, "manual-config", translate("Manual Configuration"),
translate("------------------------------------------------------------------------------------------------------------"))

addr.template = "cbi/tvalue"
addr.rows = 25

function addr.cfgvalue(self, section)
	return nixio.fs.readfile("/etc/mosdns/config.yaml")
end

function addr.write(self, section, value)
	value = value:gsub("\r\n?", "\n")
	nixio.fs.writefile("/etc/mosdns/config.yaml", value)
end

local apply = luci.http.formvalue("cbi.apply")
 if apply then
     io.popen("/etc/init.d/MosDNS reload")
end

io.popen("/etc/init.d/MosDNS reload")

return mp
