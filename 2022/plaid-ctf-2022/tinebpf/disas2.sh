set -e
rm -f tmp.bin
make generate
./generate | xxd -p | tr -d '\n'
