require("luci.sys")
require("luci.util")
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

local apply = luci.http.formvalue("cbi.apply")
 if apply then
     io.popen("/etc/init.d/MosDNS reload")
end

return mp
