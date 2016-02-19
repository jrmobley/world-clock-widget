#!/bin/sh
echo "Seattle;`export TZ='America/Los_Angeles';date +'%z';unset TZ`"
echo "NYSE;`export TZ='America/New_York';date +'%z';unset TZ`"
echo "UTC;`export TZ='Etc/UTC';date +'%z';unset TZ`"
echo "Europe;`export TZ='CET';date +'%z';unset TZ`"
echo "UAE;`export TZ='Asia/Qatar';date +'%z';unset TZ`"
echo "Tokyo;`export TZ='Asia/Tokyo';date +'%z';unset TZ`"
