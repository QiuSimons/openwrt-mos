require("luci.sys")
require("luci.util")
require("luci.http")
require("luci.dispatcher")
require("nixio.fs")
local fs=require"nixio.fs"
local port=require"luci.model.uci".cursor()
local port=port:get("MosDNS","MosDNS","port")

mp = Map("MosDNS", translate("MosDNS"))
mp.description = translate("一个插件化的 DNS 转发/分流器，默认监听6052端口（配置文件: /etc/mosdns/config.yaml）")
mp:section(SimpleSection).template  = "MosDNS/MosDNS_status"

s = mp:section(TypedSection, "MosDNS")
s.anonymous=true
s.addremove=false

enabled = s:option(Flag, "enabled", translate("启用MosDNS"))
enabled.default = 0
enabled.rmempty = false

-- manual-config
addr = s:option(Value, "manual-config", translate("手动配置"))

addr.template = "cbi/tvalue"
addr.rows = 20

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
