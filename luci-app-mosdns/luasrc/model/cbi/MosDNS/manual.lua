local m, s, o
local fs = require "nixio.fs"
local uci=require"luci.model.uci".cursor()
local sys=require"luci.sys"
require("string")
require("io")
require("table")
function gen_template_config()
	local b
	local d=""
	for cnt in io.lines("/tmp/resolv.conf.auto") do
		b=string.match (cnt,"^[^#]*nameserver%s+([^%s]+)$")
		if (b~=nil) then
			d=d.."  - "..b.."\n"
		end
	end
	local f=io.open("/usr/share/MosDNS/MosDNS_template.yaml", "r+")
	local tbl = {}
	local a=""
	while (1) do
    	a=f:read("*l")
		if (a=="#bootstrap_dns") then
			a=d
		elseif (a=="#upstream_dns") then
			a=d
		elseif (a==nil) then
			break
		end
		table.insert(tbl, a)
	end
	f:close()
	return table.concat(tbl, "\n")
end
m = Map("MosDNS")
local configpath = uci:get("MosDNS","MosDNS","configpath")
local binpath = uci:get("MosDNS","MosDNS","binpath")
s = m:section(TypedSection, "MosDNS")
s.anonymous=true
s.addremove=false
--- config
o = s:option(TextValue, "escconf")
o.rows = 66
o.wrap = "off"
o.rmempty = true
o.cfgvalue = function(self, section)
	return  fs.readfile("/tmp/MosDNStmpconfig.yaml") or fs.readfile(configpath) or gen_template_config() or ""
end
o.validate=function(self, value)
    fs.writefile("/tmp/MosDNStmpconfig.yaml", value:gsub("\r\n", "\n"))
	if fs.access(binpath) then
		-- if (sys.call(binpath.." -c /tmp/MosDNStmpconfig.yaml --check-config 2> /tmp/MosDNStest.log")==0) then
		return value
		-- end
	else
		return value
	end
	luci.http.redirect(luci.dispatcher.build_url("admin","services","MosDNS","manual"))
	return nil
end
o.write = function(self, section, value)
	fs.move("/tmp/MosDNStmpconfig.yaml",configpath)
end
o.remove = function(self, section, value)
	fs.writefile(configpath, "")
end
--- js and reload button
o = s:option(DummyValue, "")
o.anonymous=true
o.template = "MosDNS/yamleditor"
if not fs.access(binpath) then
	o.description=translate("WARNING!!! no bin found apply config will not be test")
end
--- log 
if (fs.access("/tmp/MosDNStmpconfig.yaml")) then
local c=fs.readfile("/tmp/MosDNStest.log")
if (c~="") then
o = s:option(TextValue, "")
o.readonly=true
o.rows = 5
o.rmempty = true
o.name=""
o.cfgvalue = function(self, section)
	return fs.readfile("/tmp/MosDNStest.log")
end
end
end
function m.on_commit(map)
	local ucitracktest=uci:get("MosDNS","MosDNS","ucitracktest")
	if ucitracktest=="1" then
		return
	elseif ucitracktest=="0" then
		io.popen("/etc/init.d/MosDNS reload &")
	else
		fs.writefile("/var/run/AdGlucitest","")
	end
end
return m