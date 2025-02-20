
# filter out device ids and mount paths
t_filter_fs()
{
	sed -e 's@mnt/test\.[0-9]*@mnt/test@g' \
	    -e 's@Device: [a-fA-F0-9]*h/[0-9]*d@Device: 0h/0d@g'
}

#
# Filter out expected messages.  Putting messages here implies that
# tests aren't relying on messages to discover failures.. they're
# directly testing the result of whatever it is that's generating the
# message.
#
t_filter_dmesg()
{
	local re

	# the kernel can just be noisy
	re=" used greatest stack depth: "
	re="$re|sched: RT throttling activated"

	# mkfs/mount checks partition tables
	re="$re|unknown partition table"

	# dm swizzling
	re="$re|device doesn't appear to be in the dev hash table"
	re="$re|device-mapper:.*uevent:.*version"
	re="$re|device-mapper:.*ioctl:.*initialised"

	# some tests try invalid devices
	re="$re|scoutfs .* error reading super block"
	re="$re| EXT4-fs (.*): get root inode failed"
	re="$re| EXT4-fs (.*): mount failed"
	re="$re| EXT4-fs (.*): no journal found"
	re="$re| EXT4-fs (.*): VFS: Can't find ext4 filesystem"

	# dropping caches is fine
	re="$re| drop_caches: "

	# mount and unmount spew a bunch
	re="$re|scoutfs.*client connected"
	re="$re|scoutfs.*client disconnected"
	re="$re|scoutfs.*server starting"
	re="$re|scoutfs.*server ready"
	re="$re|scoutfs.*server accepted"
	re="$re|scoutfs.*server closing"
	re="$re|scoutfs.*server shutting down"
	re="$re|scoutfs.*server stopped"

	# xfstests records test execution in desg
	re="$re| run fstests "

	# tests that drop unmount io triggers fencing
	re="$re|scoutfs .* error: fencing "
	re="$re|scoutfs .*: waiting for .* clients"
	re="$re|scoutfs .*: all clients recovered"
	re="$re|scoutfs .* error: client rid.*lock recovery timed out"

	# we test bad devices and options
	re="$re|scoutfs .* error: Required mount option \"metadev_path\" not found"
	re="$re|scoutfs .* error: meta_super META flag not set"
	re="$re|scoutfs .* error: could not open metadev:.*"
	re="$re|scoutfs .* error: Unknown or malformed option,.*"
	re="$re|scoutfs .* error: invalid quorum_heartbeat_timeout_ms value"

	# in debugging kernels we can slow things down a bit
	re="$re|hrtimer: interrupt took .*"

	# fencing tests force unmounts and trigger timeouts
	re="$re|scoutfs .* forcing unmount"
	re="$re|scoutfs .* reconnect timed out"
	re="$re|scoutfs .* recovery timeout expired"
	re="$re|scoutfs .* fencing previous leader"
	re="$re|scoutfs .* reclaimed resources"
	re="$re|scoutfs .* quorum .* error"
	re="$re|scoutfs .* error reading quorum block"
	re="$re|scoutfs .* error .* writing quorum block"
	re="$re|scoutfs .* error .* while checking to delete inode"
	re="$re|scoutfs .* error .*writing btree blocks.*"
	re="$re|scoutfs .* error .*writing super block.*"
	re="$re|scoutfs .* error .* freeing merged btree blocks.*.looping commit del.*upd freeing item"
	re="$re|scoutfs .* error .* freeing merged btree blocks.*.final commit del.upd freeing item"
	re="$re|scoutfs .* error .*reading quorum block.*to update event.*"
	re="$re|scoutfs .* error.*server failed to bind to.*"
	re="$re|scoutfs .* critical transaction commit failure.*"

	# change-devices causes loop device resizing
	re="$re|loop[0-9].* detected capacity change from.*"

	# ignore systemd-journal rotating
	re="$re|systemd-journald.*"

	egrep -v "($re)" 
}
