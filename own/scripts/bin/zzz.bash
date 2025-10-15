#!/usr/bin/env nix-shell
#!nix-shell -i bash -p joystickwake swayidle

pids=()
joystickwake --loglevel warning --cooldown 60 &
pids+=($!)
swayidle -d timeout 900 'systemctl hibernate' &
pids+=($!)
(while true; do sleep 1s; loginctl unlock-session; done) &
pids+=($!)
echo "got PIDs ${pids[@]}"
kde-inhibit --screenSaver --notifications --power moe.launcher.sleepy-launcher --just-run-game
for pid in "${pids[@]}"; do
    echo "terminating $pid"
    kill -TERM $pid
    if ! waitpid -t 10 -e $pid; then
        echo "WARN $pid did not terminate, killing"
        kill -KILL $pid
    fi
done