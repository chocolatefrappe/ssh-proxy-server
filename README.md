> [!WARNING]
> This project is for personal use only. **Use at your own risk!**

# About
A SSH Server tuned for proxying traffic, to be uses with [ssh-proxy-client](https://github.com/chocolatefrappe/ssh-proxy-client).

### SSH Tunneling Explained

**Exposing service running in localhost of a server behind NAT to the internet**

Consider the scenario below. The client runs a web server on port 3000 but cannot expose this web server to the public internet as the client 
machine is behind NAT. The remote server, on the other hand, can be reachable via the internet. The client can SSH into this remote server. In this situation, how can the client expose the webserver on port `3000` to the internet? Via reverse SSH tunnel!

![diagram](https://github.com/chocolatefrappe/ssh-proxy-client/assets/4363857/4340e986-3e27-420d-a373-41e78c3053ba)

**Example**
1. Run a web server on client localhost port `3000`. 
2. Configure reverse tunnel with command.

   ```bash
   $ ssh -R 80:127.0.0.1:3000 user@<remote_server_ip>
   ```

3. Now, when users from distant internet visit port `80` of the remote server as `http://<remote_server_ip>`, the request is redirected back to the client's local server (port `3000`) via SSH tunnel where the local server handles the request and response.

By default, the remote port forwarding tunnel will bind to the `localhost` of the remote server. To enable it to listen on the public interface (for a scenario like above), set the SSH configuration `GatewayPorts yes` in `sshd_config`.

**Further reading**:
- https://www.ssh.com/ssh/tunneling/example
- https://goteleport.com/blog/ssh-tunneling-explained


> WIP
