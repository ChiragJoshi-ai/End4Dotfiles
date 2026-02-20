#!/bin/bash
wlsunset -t 4000 &
pkill wlsunset && wlsunset -t 4000 &
