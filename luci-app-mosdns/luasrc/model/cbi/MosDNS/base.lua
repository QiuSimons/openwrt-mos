require("luci.sys")
require("luci.util")
require("io")
local m,s,o,o1
local fs=require"nixio.fs"
local uci=require"luci.model.uci".cursor()
local configpath=uci:get("MosDNS","MosDNS","configpath") or "/etc/config/MosDNS.yaml"
local binpath=uci:get("MosDNS","MosDNS","binpath") or "/usr/bin/MosDNS/MosDNS"
httpport=uci:get("MosDNS","MosDNS","httpport") or "3000"
m = Map("MosDNS", "Mos DNS")
m.description = translate("Free and open source, powerful network-wide ads & trackers blocking DNS server.")
m:section(SimpleSection).template  = "MosDNS/MosDNS_status"

s = m:section(TypedSection, "MosDNS")
s.anonymous=true
s.addremove=false
---- enable
o = s:option(Flag, "enabled", translate("Enable"))
o.default = 0
o.optional = false
---- httpport
-- o =s:option(Value,"httpport",translate("Browser management port"))
-- o.placeholder=3000
-- o.default=3000
-- o.datatype="port"
-- o.optional = false
-- o.description = translate("<input type=\"button\" style=\"width:210px;border-color:Teal; text-align:center;font-weight:bold;color:Green;\" value=\"MosDNS Web:"..httpport.."\" onclick=\"window.open('http://'+window.location.hostname+':"..httpport.."/')\"/>")
---- update warning not safe
local binmtime=uci:get("MosDNS","MosDNS","binmtime") or "0"
local e=""
if not fs.access(configpath) then
	e=e.." "..translate("no config")
end
if not fs.access(binpath) then
	e=e.." "..translate("no core")
else
	local version=uci:get("MosDNS","MosDNS","version")
	local testtime=fs.stat(binpath,"mtime")
	if testtime~=tonumber(binmtime) or version==nil or version=="read ver error" then
		-- local tmp=luci.sys.exec(binpath.." -v 2>&1 | grep -m 1 -E 'v[0-9.]+-\\w+' -o")
		-- version=string.sub(tmp, 1, -9)
		version=luci.sys.exec(binpath.." -v 2>&1 | grep -m 1 -E 'v[0-9.]+-\\w+' -o")
		if version=="" then version="read ver error" end
		uci:set("MosDNS","MosDNS","version",version)
		uci:set("MosDNS","MosDNS","binmtime",testtime)
		uci:save("MosDNS")
	end
	e=version..e
end
o=s:option(Button,"restart",translate("Update"))
o.inputtitle=translate("Update core version")
o.template = "MosDNS/MosDNS_check"
o.showfastconfig=(not fs.access(configpath))
o.description=string.format(translate("core version:").."<strong><font id=\"updateversion\" color=\"green\">%s </font></strong>",e)
---- port warning not safe
-- 2020-08-20 remove iptables redirect, config now support multiple port binding, define one address to bind
local port=luci.sys.exec("awk -F: '$1 ~ /# addr/{gsub(/[ \t]+/,\"\",$3);print substr($3,1,length($3)-1);exit;}' "..configpath.." 2>nul")
if (port=="") then port="?" end
---- Update local list
o=s:option(Button,"updatelist",translate("Update list"))
o.inputtitle=translate("Update list")
o.template = "MosDNS/MosDNS_updatelist"
---- Redirect
o = s:option(ListValue, "redirect", port..translate("Redirect"), translate("MosDNS redirect mode"))
o.placeholder = "none"
o:value("none", translate("none"))
o:value("dnsmasq-upstream", translate("Run as dnsmasq upstream server"))
o:value("redirect", translate("Redirect 53 port to MosDNS"))
o:value("exchange", translate("Use port 53 replace dnsmasq"))
o.default     = "none"
o.optional = true
---- bin path
o = s:option(Value, "binpath", translate("Bin Path"), translate("MosDNS Bin path if no bin will auto download"))
o.default     = "/usr/bin/MosDNS/MosDNS"
o.datatype    = "string"
o.optional = false
o.rmempty=false
o.validate=function(self, value)
if value=="" then return nil end
if fs.stat(value,"type")=="dir" then
	fs.rmdir(value)
end
if fs.stat(value,"type")=="dir" then
	if (m.message) then
	m.message =m.message.."\nerror!bin path is a dir"
	else
	m.message ="error!bin path is a dir"
	end
	return nil
end 
return value
end
--- upx
o = s:option(ListValue, "upxflag", translate("use upx to compress bin after download"))
o:value("", translate("none"))
o:value("-1", translate("compress faster"))
o:value("-9", translate("compress better"))
o:value("--best", translate("compress best(can be slow for big files)"))
o:value("--brute", translate("try all available compression methods & filters [slow]"))
o:value("--ultra-brute", translate("try even more compression variants [very slow]"))
o.default     = ""
o.description=translate("bin use less space,but may have compatibility issues")
o.rmempty = true
---- config path
o = s:option(Value, "configpath", translate("Config Path"), translate("MosDNS config path"))
o.default     = "/etc/config/MosDNS.yaml"
o.datatype    = "string"
o.optional = false
o.rmempty=false
o.validate=function(self, value)
if value==nil then return nil end
if fs.stat(value,"type")=="dir" then
	fs.rmdir(value)
end
if fs.stat(value,"type")=="dir" then
	if m.message then
	m.message =m.message.."\nerror!config path is a dir"
	else
	m.message ="error!config path is a dir"
	end
	return nil
end 
return value
end
---- work dir
o = s:option(Value, "workdir", translate("Work dir"), translate("MosDNS work dir include rules,audit log and database"))
o.default     = "/usr/bin/MosDNS"
o.datatype    = "string"
o.optional = false
o.rmempty=false
o.validate=function(self, value)
if value=="" then return nil end
if fs.stat(value,"type")=="reg" then
	if m.message then
	m.message =m.message.."\nerror!work dir is a file"
	else
	m.message ="error!work dir is a file"
	end
	return nil
end 
if string.sub(value, -1)=="/" then
	return string.sub(value, 1, -2)
else
	return value
end
end
---- log file
o = s:option(Value, "logfile", translate("Runtime log file"), translate("MosDNS runtime Log file if 'syslog': write to system log;if empty no log"))
o.datatype    = "string"
o.rmempty = true
o.validate=function(self, value)
if fs.stat(value,"type")=="dir" then
	fs.rmdir(value)
end
if fs.stat(value,"type")=="dir" then
	if m.message then
	m.message =m.message.."\nerror!log file is a dir"
	else
	m.message ="error!log file is a dir"
	end
	return nil
end 
return value
end
---- debug
o = s:option(Flag, "verbose", translate("Verbose log"))
o.default = 0
o.optional = true
---- gfwlist 
local a=luci.sys.call("grep -m 1 -q programadd "..configpath)
if (a==0) then
a="Added"
else
a="Not added"
end
o=s:option(Button,"gfwdel",translate("Del gfwlist"),translate(a))
o.optional = true
o.inputtitle=translate("Del")
o.write=function()
	luci.sys.exec("sh /usr/share/MosDNS/gfw2adg.sh del 2>&1")
	luci.http.redirect(luci.dispatcher.build_url("admin","services","MosDNS"))
end
o=s:option(Button,"gfwadd",translate("Add gfwlist"),translate(a))
o.optional = true
o.inputtitle=translate("Add")
o.write=function()
	luci.sys.exec("sh /usr/share/MosDNS/gfw2adg.sh 2>&1")
	luci.http.redirect(luci.dispatcher.build_url("admin","services","MosDNS"))
end
o = s:option(Value, "gfwupstream", translate("Gfwlist upstream dns server"), translate("Gfwlist domain upstream dns service")..translate(a))
o.default     = "tcp://208.67.220.220:5353"
o.datatype    = "string"
o.optional = true
---- chpass
o = s:option(Value, "hashpass", translate("Change browser management password"), translate("Press load culculate model and culculate finally save/apply"))
o.default     = ""
o.datatype    = "string"
o.template = "MosDNS/MosDNS_chpass"
o.optional = true
---- upgrade protect
o = s:option(MultiValue, "upprotect", translate("Keep files when system upgrade"))
o:value("$binpath",translate("core bin"))
o:value("$configpath",translate("config file"))
o:value("$logfile",translate("log file"))
o:value("$workdir/data/sessions.db",translate("sessions.db"))
o:value("$workdir/data/stats.db",translate("stats.db"))
o:value("$workdir/data/querylog.json",translate("querylog.json"))
o:value("$workdir/data/filters",translate("filters"))
o.widget = "checkbox"
o.default = nil
o.optional=true
---- wait net on boot
o = s:option(Flag, "waitonboot", translate("On boot when network ok restart"))
o.default = 1
o.optional = true
---- backup workdir on shutdown
local workdir=uci:get("MosDNS","MosDNS","workdir") or "/usr/bin/MosDNS"
o = s:option(MultiValue, "backupfile", translate("Backup workdir files when shutdown"))
o1 = s:option(Value, "backupwdpath", translate("Backup workdir path"))
local name
o:value("filters","filters")
o:value("stats.db","stats.db")
o:value("querylog.json","querylog.json")
o:value("sessions.db","sessions.db")
o1:depends ("backupfile", "filters")
o1:depends ("backupfile", "stats.db")
o1:depends ("backupfile", "querylog.json")
o1:depends ("backupfile", "sessions.db")
for name in fs.glob(workdir.."/data/*")
do
	name=fs.basename (name)
	if name~="filters" and name~="stats.db" and name~="querylog.json" and name~="sessions.db" then
		o:value(name,name)
		o1:depends ("backupfile", name)
	end
end
o.widget = "checkbox"
o.default = nil
o.optional=false
o.description=translate("Will be restore when workdir/data is empty")
----backup workdir path

o1.default     = "/usr/bin/MosDNS"
o1.datatype    = "string"
o1.optional = false
o1.validate=function(self, value)
if fs.stat(value,"type")=="reg" then
	if m.message then
	m.message =m.message.."\nerror!backup dir is a file"
	else
	m.message ="error!backup dir is a file"
	end
	return nil
end 
if string.sub(value,-1)=="/" then
	return string.sub(value, 1, -2)
else
	return value
end
end

----Crontab
o = s:option(MultiValue, "crontab", translate("Crontab task"),translate("Please change time and args in crontab"))
o:value("autoupdate",translate("Auto update core"))
o:value("cutquerylog",translate("Auto tail querylog"))
o:value("cutruntimelog",translate("Auto tail runtime log"))
o:value("autohost",translate("Auto update ipv6 hosts and restart adh"))
o:value("autogfw",translate("Auto update gfwlist and restart adh"))
o.widget = "checkbox"
o.default = nil
o.optional=true

----downloadpath
o = s:option(TextValue, "downloadlinks",translate("Download links for update"))
o.optional = false
o.rows = 4
o.wrap = "soft"
o.cfgvalue = function(self, section)
	return fs.readfile("/usr/share/MosDNS/links.txt")
end
o.write = function(self, section, value)
	fs.writefile("/usr/share/MosDNS/links.txt", value:gsub("\r\n", "\n"))
end
fs.writefile("/var/run/lucilogpos","0")
function m.on_commit(map)
	if (fs.access("/var/run/MCDserverdis")) then
		io.popen("/etc/init.d/MosDNS reload &")
		return
	end
	local ucitracktest=uci:get("MosDNS","MosDNS","ucitracktest")
	if ucitracktest=="1" then
		return
	elseif ucitracktest=="0" then
		io.popen("/etc/init.d/MosDNS reload &")
	else
		if (fs.access("/var/run/AdGlucitest")) then
			uci:set("MosDNS","MosDNS","ucitracktest","0")
			io.popen("/etc/init.d/MosDNS reload &")
		else
			fs.writefile("/var/run/AdGlucitest","")
			if (ucitracktest=="2") then
				uci:set("MosDNS","MosDNS","ucitracktest","1")
			else
				uci:set("MosDNS","MosDNS","ucitracktest","2")
			end
		end
		uci:save("MosDNS")
	end
end
return m