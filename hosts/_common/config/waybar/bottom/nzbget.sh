paused=$(curl \
    -s \
    https://view:viewtimefarduck@usenet.milogert.com/nzbget/jsonrpc/status \
    | \
    jq \
    -r \
    '.result.DownloadPaused')
if [ "$paused" != "true" ]; then
    paused_text="▶️"
else
    paused_text="⏸️"
fi

speed=$(curl \
    -s \
    https://view:viewtimefarduck@usenet.milogert.com/nzbget/jsonrpc/status \
    | \
    jq \
    -r \
    '.result.DownloadRate')
modified_speed=$((speed / 1024))

echo "nzbget: $modified_speed KB/s ($paused_text)"
