# bruteforce_xmlrpc.sh

Bash script that brute-forces a WordPress account through the `xmlrpc.php` endpoint, using the `wp.getUsersBlogs` method.

> ⚠️ **Authorized targets only.** Use this script only on systems you have explicit permission to test.

## How it works

For each password in a wordlist, the script sends an XML-RPC `wp.getUsersBlogs` request with the given username and that password. WordPress returns a fault (`faultCode`) on failure, and the user's blog list on success — so filtering out fault responses reveals the valid password.

```bash
curl -s -X POST -d "<methodCall><methodName>wp.getUsersBlogs</methodName>..." "$URL"
```

This endpoint is a known brute-force vector on WordPress sites that haven't disabled XML-RPC, since it bypasses standard login lockout/rate-limiting plugins that only watch `wp-login.php`.

## Usage

```bash
chmod +x bruteforce_xmlrpc.sh
./bruteforce_xmlrpc.sh -u admin -w passwords.txt -U http://example.com/xmlrpc.php
```

| Flag | Description |
|---|---|
| `-u` | Username to test |
| `-w` | Path to a wordlist (one password per line) |
| `-U` | Full URL to the target's `xmlrpc.php` |
| `-h` | Show usage |

All three flags are required. The script exits early if the wordlist file doesn't exist.

## Output

For each password that returns a successful response (not a `faultCode`), the script prints the matching line:

```
Mot : S3cr3t! | Ligne : <member><name>isAdmin</name>...
```

## Limitations

- No delay between requests: a WAF or fail2ban-style protection may block the source IP on a real target.
- No XML escaping: usernames or passwords containing `<`, `>` or `&` can break the request body.
- Sequential only, no concurrency — slower than tools like WPScan's built-in password attack mode.

## Related

Used in my [WordPress hacking notes](wordpress-hacking.md) as a manual alternative to `wpscan --password-attack xmlrpc`.

## Disclaimer

For educational use and authorized security testing only.
