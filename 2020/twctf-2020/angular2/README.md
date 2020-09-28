# Angular 2

- For the 2nd part, a http request was being sent to /api/answer
- Base URI was taken from Host header for some reason, so a fake server to redirect to '/api/true-answer' returned the flag
