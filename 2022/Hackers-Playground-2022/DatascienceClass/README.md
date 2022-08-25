Vulnerable to `https://github.com/advisories/GHSA-hwvq-6gjx-j797` allowing xss, which can then:

- Load an iframe at `hub/token`
- Click the `Request new API token` button
- Exfiltrate the token

This token can then be used to authenticate as the admin and read the flag via a call to `/user/admin/api/contents/flag?content=1`
