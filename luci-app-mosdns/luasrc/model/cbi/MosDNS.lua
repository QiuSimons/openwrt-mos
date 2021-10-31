mp = Map("MosDNS")
mp.title = translate("MosDNS")
mp.description = translate("MosDNS is a 'programmable' DNS forwarder.")
mp:section(SimpleSection).template = "MosDNS/MosDNS_status"

s = mp:section(TypedSection, "MosDNS")
s.addremove = false
s.anonymous = true

s:tab("basic", translate("Basic Setting"))
enable = s:taboption("basic", Flag, "enabled", translate("Enable"))
enable.rmempty = false

redirect = s:taboption("basic", Flag, "redirect", translate("Enable DNS Redirect"))
redirect.rmempty = false

autoconf = s:taboption("basic", Flag, "autoconf", translate("Enable AutoConfiguration"))
autoconf.description = translate("Turning it on will make the necessary adjustments to other plug-in settings.")
autoconf.rmempty = false

s:tab("geo_update", translate("Geodata Update"))
enable = s:taboption("geo_update", Flag, "geo_auto_update", translate("Enable Auto Database Update"))
enable.rmempty = false

o = s:taboption("geo_update", ListValue, "geo_update_week_time", translate("Update Cycle"))
o:value("*", translate("Every Day"))
o:value("1", translate("Every Monday"))
o:value("2", translate("Every Tuesday"))
o:value("3", translate("Every Wednesday"))
o:value("4", translate("Every Thursday"))
o:value("5", translate("Every Friday"))
o:value("6", translate("Every Saturday"))
o:value("0", translate("Every Sunday"))
o.default = 1

update_time = s:taboption("geo_update", ListValue, "geo_update_day_time", translate("Update Time (Every Day)"))
for t = 0, 23 do
  update_time:value(t, t..":00")
end
update_time.default = 0

data_update = s:taboption("geo_update", Button, "geo_update_database", translate("Database Update"))
data_update.inputtitle = translate("Check And Update")
data_update.inputstyle = "reload"
data_update.write = function()
  luci.sys.exec("/etc/mosdns/mosupdater.sh >/dev/null 2>&1 &")
end

s:tab("manual-config", translate("Manual Configuration"))
config = s:taboption("manual-config", Value, "manual-config", translate("Manual Configuration"))
config.description = translate("View the YAML Configuration file used by this MosDNS. You can edit it as you own need; Beware the listening port 5335 was hardcoded into the init script, do not change that.")
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
