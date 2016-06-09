#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/un.h>

//#define UDS_READ_PATH "/tmp/pd-local.sock"
#define UDS_READ_PATH "/tmp/pd-local-read.sock"

int main()
{
  int sock;
  struct sockaddr_un addr;
  char buf[2048];
  int n;

  unlink(UDS_READ_PATH);
  sock = socket(AF_UNIX, SOCK_DGRAM, 0);

  addr.sun_family = AF_UNIX;
  strcpy(addr.sun_path, UDS_READ_PATH);
  
  bind(sock, (struct sockaddr *)&addr, sizeof(addr));
  fprintf(stdout, "[Server] Socket bind done. path[%s]\n", UDS_READ_PATH);  

  memset(buf, 0, sizeof(buf));
  
  while (1) {
//    memset(buf, 0, sizeof(buf));

    n = recv(sock, buf, sizeof(buf) - 1, 0);
    printf("recvd: [%s]\n", buf);
  }

  close(sock);
  unlink(UDS_READ_PATH);
  
  return 0;
}

