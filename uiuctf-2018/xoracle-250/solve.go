package main

import "fmt"
import "net"
import "errors"
import "os"
import "sync"
import "encoding/base64"

func check(err error) {
	if err != nil {
		panic(err)
	}
}

var wg = sync.WaitGroup{}
var sem = make(chan struct{}, 200) //semen
var work = make(chan int)

func succ() error {
	wg.Add(1)
	sem <- struct{}{}
	defer func() {
		<-sem
		wg.Done()
	}()
	conn, err := net.Dial("tcp", "34.213.162.78:6464")
	if err != nil {
		return err
	}
	recvBuf := make([]byte, 20000)
	n, err := conn.Read(recvBuf)
	buf := make([]byte, 2050)
	if recvBuf[n-1] != 0x0A {
		return errors.New("bad read")
	}
	recvBuf = recvBuf[:n-1]
	n, err = base64.StdEncoding.Decode(buf, recvBuf)
	check(err)
	if n != 2039 {
		return errors.New(fmt.Sprintf("bad read length %d", n))
	}
	buf = buf[:n]

	i := <- work
	f, err := os.Create(fmt.Sprintf("ciphers/%d",i))
	check(err)
	f.Write(buf)
	f.Close()
	fmt.Printf("%d ", i)
	return nil
}

func makeWork() {
	i := 0
	for {
		work <- i
		i++
	}
}

func main() {
	wg.Add(1)
	go makeWork()
	for i := 0; i < 10000; i++ {
		go succ()
	}
	wg.Done()
	wg.Wait()
	fmt.Println()
}
