#[[inotify]]
#!/bin/bash
#inotifywait init script for ubuntu
#

listen=/etc/inotify-listen.txt
cat "/opt" > $listen
option=$1
start() {
        pid=`pgrep inotifywait`
        [ $? -eq 0 ] && echo "inotifywait already running: [pid $pid]" && exit 1
        inotifywait --timefmt "[%Y%m%d %H:%M:%S]" --format "%T %w %e %f" \
        -mrq -e create,modify,delete,attrib,close_write,move \
        --exclude "(.sw[px]|4913|.gz|.log)" \
        --fromfile $listen > /var/log/inotify.log &
}
stop() {
        pkill inotifywait
}
status() {
        pid=`pgrep inotifywait`
        [ $? -eq 0 ] && echo "inotifywait running: [pid $pid]" || echo "inotifywait not running"
}

case $option in
start)
        start
        [ $? -eq 0 ] && status || echo "can't start inotifywait"; exit 1
        ;;
restart)
        stop
        sleep 1
        status
        start
        ;;
stop)
        stop
        [ $? -eq 0 ] && echo "inotifywait killed." || echo "inotifywait already killed"; exit 1
        ;;
status)
        status
        ;;
*)
        echo $"Usage: $0 {start|stop|status|restart}"
        exit 1
esac
