# just one time listening.
#exec socat unix-recvfrom:/tmp/pd-local.sock stdout

# keep listening after receive.
exec socat unix-recv:/tmp/pd-local.sock stdout
