cd root
find . | fakeroot cpio --create --format='newc' > ../test.cpio
