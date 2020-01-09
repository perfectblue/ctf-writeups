Let's apply some critical thinking skills for a moment.
This problem was updated about a day after the first release. I saved the original copy and I got the second copy.
They said they added more hints so if we just diff them we instantly find the hints.
Clearly it was updated to make it *easier* so the changed data is probably very relevant to the flag.

```
$ sudo su
# mkdir /mnt/old
# guestmount -a old/box-disk001.vmdk /mnt/old
# mkdir /mnt/new
# guestmount -a new/box-disk001.vmdk /mnt/new
```

We take the md5sum of every file in both vmdks and then we see that these files changed:

<diff.txt>
```
home/ubuntu/.bash_history
home/ubuntu/.viminfo
root/.vim/.netrwhist
root/.bash_history
root/.viminfo
root/client
root/.lesshst
lib/modules/4.4.0-96-generic/modules.dep.bin
lib/modules/4.4.0-96-generic/modules.dep
lib/modules/4.4.0-96-generic/modules.builtin
lib/modules/4.4.0-96-generic/modules.builtin.bin
lib/modules/4.4.0-96-generic/modules.symbols.bin
lib/modules/4.4.0-96-generic/kernel/fs/rtk.ko
var/lib/cloud/instances/iid-be18dcb3189c06c8/boot-finished
var/lib/cloud/instances/iid-be18dcb3189c06c8/vendor-data.txt.i
var/lib/cloud/instances/iid-be18dcb3189c06c8/user-data.txt.i
var/lib/cloud/instances/iid-be18dcb3189c06c8/obj.pkl
var/lib/cloud/data/status.json
var/lib/dhcp/dhclient.enp0s3.leases
var/lib/snapd/state.json
var/lib/systemd/random-seed
var/log/cloud-init-output.log
var/log/auth.log
var/log/lastlog
var/log/cloud-init.log
var/log/wtmp
var/log/syslog
var/log/kern.log
```

Grepping through these files, we find the flag in var/log/syslog and var/log/kern.log.

```
# guestunmount /mnt/new
# guestunmount /mnt/old
# ^D
$
```
