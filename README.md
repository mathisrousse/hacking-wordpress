# bruteforce_xmlrpc.sh

Bash script that brute-forces a WordPress account through the `xmlrpc.php` endpoint, using the `wp.getUsersBlogs` method. It is a manual alternative to `wpscan --password-attack xmlrpc`.

This endpoint is a known brute-force vector on WordPress sites that haven't disabled XML-RPC, since it bypasses standard login lockout/rate-limiting plugins that only watch `wp-login.php`.

## Usage

```bash
chmod +x bruteforce_xmlrpc.sh
./bruteforce_xmlrpc.sh -u admin -w passwords.txt -U http://example.com/xmlrpc.php
```

## Output

For each password that returns a successful response, the script prints the matching line:

```
Mot : S3cr3t! | Ligne : <member><name>isAdmin</name>...
```

## Limitations

- No delay between requests: a WAF or fail2ban-style protection may block the source IP on a real target.
- No XML escaping: usernames or passwords containing `<`, `>` or `&` can break the request body.
- Sequential only, no concurrency — slower than tools like WPScan's built-in password attack mode.

