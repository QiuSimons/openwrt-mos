module("luci.controller.MosDNS",package.seeall)
function index()
if not nixio.fs.access("/etc/config/MosDNS")then
return
end
	entry({"admin","services","MosDNS"},cbi("MosDNS"),_("MosDNS"),30).dependent=true
    entry({"admin","services","MosDNS","status"},call("act_status")).leaf=true
end 

function act_status()
  local e={}
  e.running=luci.sys.call("pgrep -f mosdns >/dev/null")==0
  luci.http.prepare_content("application/json")
  luci.http.write_json(e)
end
