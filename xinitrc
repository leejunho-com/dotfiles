eval $(dbus-launch --sh-syntax --exit-with-session)
systemctl --user daemon-reload
exec i3
