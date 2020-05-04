# Contrived-Web

### TL;DR

- SSRF in the /api/image to ftp server
- CRLF injection in the username to inject ftp commands
- Upload file into the ftp server using profile picture upload
- Use PORT ftp command to SSRF to rabbitmq http API (use REST to discard the png header from the uploaded file)
- Inject in rabbitmq email queue with an "attachment" parameter to get it to email us the flag


