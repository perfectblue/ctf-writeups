import subprocess

dat = open("sources/img2_new.jpg", "rb").read()
dat = list(dat)

for i in range(len(dat)):
    print(i)
    for b in range(0, 8):
        dat[i] ^= (1 << b)
        with open("sources/img2_new2.jpg", "wb") as f:
            f.write(bytes(dat))
        try:
            output = subprocess.check_output(["sources/target/debug/i_c_u", "sources/img2_new.jpg", "sources/img2_new2.jpg"], stderr=subprocess.DEVNULL)
            print(output.split(b"\n")[2])
            if b"pwned2" in output:
                print("SICE")
                exit()
        except subprocess.CalledProcessError:
            pass
        dat[i] ^= (1 << b)