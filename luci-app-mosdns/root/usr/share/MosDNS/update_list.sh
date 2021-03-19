#!/bin/bash
PATH="/usr/sbin:/usr/bin:/sbin:/bin"
IP4_URL="https://raw.githubusercontent.com/QiuSimons/Chnroute/master/dist/chnroute/chnroute.txt"
IP6_URL="https://raw.githubusercontent.com/QiuSimons/Chnroute/master/dist/chnroute/chnroute-v6.txt"
DOMAIN_URL="https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/accelerated-domains.china.conf"
GFWDOMAIN_URL="https://raw.githubusercontent.com/Loyalsoldier/cn-blocked-domain/release/domains.txt"
WORKDIR=$(uci get MosDNS.MosDNS.workdir 2>/dev/null)
TEMPDIR="/tmp/MosDNSupdatelist"

# IP/MASK
update_ip_list(){
    echo "Updating ip list"
    local tmpip4file="$TEMPDIR/ip4_data"
    local tmpip6file="$TEMPDIR/ip6_data"
    local tmpfile="$TEMPDIR/temp_chn.list"
    curl $IP4_URL -o $tmpip4file 2>/dev/null
    if [ "$(awk 'NR==1 {print}' $tmpip4file 2>/dev/null)" = "" ]; then
        echo "received ipv4 empty body"
        EXIT 2
    fi
    curl $IP6_URL -o $tmpip6file 2>/dev/null
    if [ "$(awk 'NR==1 {print}' $tmpip6file 2>/dev/null)" = "" ]; then
        echo "received ipv6 empty body"
        EXIT 2
    fi
    cat $tmpip4file > $tmpfile 2>/dev/null
    cat $tmpip6file >> $tmpfile 2>/dev/null
    if [ ! -d "$WORKDIR" ]; then
        echo $WORKDIR" is missing"
        EXIT 1
    fi
    mv -f $tmpfile "$WORKDIR/chn_ip.list"
    echo "Updating ip finished"
}

# DOMAIN
update_domain_list(){
    echo "Updating domain list"
    local tmpdomainfile="$TEMPDIR/domain_data"
    local tmpgfwdomainfile="$TEMPDIR/gfwdomain_data"
    local tmpfile="$TEMPDIR/temp_chn_domain.list"
    local tmpgfwfile="$TEMPDIR/temp_gfw_domain.list"
    curl -L -k $DOMAIN_URL -o $tmpdomainfile 2>/dev/null
    curl -L -k $GFWDOMAIN_URL -o $tmpgfwdomainfile 2>/dev/null
    if [ "$(awk 'NR==1 {print}' $tmpdomainfile 2>/dev/null)" = "" ]; then
        echo "received domain empty body"
        EXIT 3
    fi
    cat $tmpdomainfile | awk -F '/' '{print $2}' > $tmpfile 2>/dev/null
    mv -f $tmpfile "$WORKDIR/chn_domain.list"
    cat $tmpgfwdomainfile > $tmpgfwfile 2>/dev/null
    mv -f $tmpgfwfile "$WORKDIR/non_chn_domain.list"
    echo "Updating domain finished"
}
EXIT(){
    rm /var/run/update_list 2>/dev/null
    rm -rf $TEMPDIR 2>/dev/null
    [ "$1" != "0" ] && touch /var/run/update_list_error && echo $1 > /var/run/update_list_error
    exit $1
}

main(){
    touch /var/run/update_list
    rm -rf $TEMPDIR 2>/dev/null
    rm /var/run/update_list_error 2>/dev/null
    mkdir $TEMPDIR
    update_ip_list
    update_domain_list
    EXIT 0
}

main
