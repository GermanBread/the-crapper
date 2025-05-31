#!/bin/sh
( curl 'https://api.ipify.org'; echo ) &
( curl 'https://api6.ipify.org'; echo ) &
wait