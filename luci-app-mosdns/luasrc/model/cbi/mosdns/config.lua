m = Map("mosdns")

s = m:section(TypedSection, "mosdns")
s.addremove = false
s.anonymous = true

config = s:option(TextValue, "manual-config")
config.description = translate("<font color=\"ff0000\"><strong>View the Custom YAML Configuration file used by this MosDNS. You can edit it as you own need.")
config.template = "cbi/tvalue"
config.rows = 25

function config.cfgvalue(self, section)
  return nixio.fs.readfile("/etc/mosdns/cus_config.yaml")
end

function config.write(self, section, value)
  value = value:gsub("\r\n?", "\n")
  nixio.fs.writefile("/etc/mosdns/cus_config.yaml", value)
end

return m
