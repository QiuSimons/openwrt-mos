mp = Map("MosDNS", translate("MosDNS"))
mp.title = translate("MosDNS")
mp.description = translate("MosDNS is a 'programmable' DNS forwarder.")
mp:section(SimpleSection).template = "MosDNS/MosDNS_status"

s = mp:section(TypedSection, "MosDNS")
s.addremove = false
s.anonymous = true

s:tab("basic", translate("Basic Setting"))
enable = s:taboption("basic",Flag, "enabled", translate("Enable"))
enable.rmempty = false


s:tab("manual-config", translate("Manual Configuration"))
config = s:taboption("manual-config", Value, "manual-config", translate("Manual Configuration"), translate("This file is /etc/mosdns/config.yaml."), "")
config.template = "cbi/tvalue"
config.rows = 25

function config.cfgvalue(self, section)
	return nixio.fs.readfile("/etc/mosdns/config.yaml")
end

function config.write(self, section, value)
	value = value:gsub("\r\n?", "\n")
	nixio.fs.writefile("/etc/mosdns/config.yaml", value)
end

return mp
