description
---
"sshpicker.sh" read the host list from "hosts.conf" by default, or from a specified filename via parameter1. After the user selects a host, it establishes an SSH connection. This program aims to facilitate system administrators by allowing them to make a quick ssh connection without needing to memorize hostnames or IPs.


examle for hosts.conf
---
```
# hostname/aliasname ; ip
localhost             # If there's name resolution, you can just set the hostname
my-local ; 127.0.0.1  # if not, separate the hostname with a semicolon and provide the IP information afterward.
```

note for hosts.conf
---
- Information after the "#" symbol is ignored and treated as a comment.
- The hostname and host IP are separated by a semicolon.
- Whitespace characters and blank lines will be ignored.