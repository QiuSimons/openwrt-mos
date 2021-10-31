m = Map("MosDNS")
m.title = translate("MosDNS")
m.description = translate("MosDNS is a 'programmable' DNS forwarder.")

m:section(SimpleSection).template = "MosDNS/MosDNS_status"

s = m:section(TypedSection, "MosDNS")
s.addremove = false
s.anonymous = true

enable = s:option(Flag, "enabled", translate("Enable"))
enable.rmempty = false

redirect = s:option(Flag, "redirect", translate("Enable DNS Redirect"))
redirect.rmempty = false

autoconf = s:option(Flag, "autoconf", translate("Enable AutoConfiguration"))
autoconf.description = translate("Turning it on will make the necessary adjustments to other plug-in settings.")
autoconf.rmempty = false

return m
