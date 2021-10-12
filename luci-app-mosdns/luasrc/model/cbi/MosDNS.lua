mp = Map("MosDNS", translate("MosDNS"))
mp.title = translate("MosDNS")
mp.description = translate("MosDNS is a 'programmable' DNS forwarder.")
mp:section(SimpleSection).template = "MosDNS/MosDNS_status"

s = mp:section(TypedSection, "MosDNS")
s.addremove = false
s.anonymous = true

s:tab("basic", translate("Basic Setting"))
enable = s:taboption("basic", Flag, "enabled", translate("Enable"))
enable.rmempty = false
enable = s:taboption("basic", Flag, "redirect", translate("Enable Redirect"))
enable.rmempty = false

s:tab("geo_update", translate("GEODATA Update"))
enable = s:taboption("geo_update", Flag, "geo_auto_update", translate("Enable GEODATA Update"))
o = s:taboption("geo_update", ListValue, "geo_update_week_time", translate("Update Time (Every Week)"))
o:value("*", translate("Every Day"))
o:value("1", translate("Every Monday"))
o:value("2", translate("Every Tuesday"))
o:value("3", translate("Every Wednesday"))
o:value("4", translate("Every Thursday"))
o:value("5", translate("Every Friday"))
o:value("6", translate("Every Saturday"))
o:value("0", translate("Every Sunday"))
o.default = 1

o = s:taboption("geo_update", ListValue, "geo_update_day_time", translate("Update time (every day)"))
for t = 0, 23 do
  o:value(t, t..":00")
end
o.default = 0

o = s:taboption("geo_update", Button, translate("GEODATA Update"))
o.title = translate("GEODATA Update")
o.inputtitle = translate("Check And Update")
o.inputstyle = "reload"
o.write = function()
  luci.sys.exec("/etc/mosdns/mosupdater.sh >/dev/null 2>&1 &")
end

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
