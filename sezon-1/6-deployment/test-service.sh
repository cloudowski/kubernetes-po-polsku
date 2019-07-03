while :;do
    curl -s http://192.168.99.100:32222|grep '^Hostname\|^Version:'|xargs
    sleep .5
done
