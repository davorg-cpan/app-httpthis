# App::HTTPThis

`http_this` is a tiny command-line web server for the directory you are
standing in.

It is the sort of tool you reach for when you want to answer one simple
question: "Can I see these files in a browser right now?" It starts a local
HTTP server, serves the current directory, prints the URL, and stays out of
your way.

```bash
http_this
```

By default, that serves the current directory on:

```text
http://127.0.0.1:7007/
```

You can also serve a different directory:

```bash
http_this ~/Downloads
```

For more background on why this exists and why it is handy, see Dave Cross's
write-up: [App::HTTPThis: The tiny web server I keep reaching for](https://perlhacks.com/2026/01/apphttpthis-the-tiny-web-server-i-keep-reaching-for/).

## Why Use This?

There are plenty of ways to start a quick web server. `http_this` is useful
because it is deliberately small and boring:

- it serves static files from a directory
- it gives you directory listings
- it can serve `index.html` files when you want that behavior
- it is built on PSGI/Plack
- it has safe localhost-only defaults
- it has escape hatches for WSL and LAN sharing

It is useful for previewing static HTML, sharing generated files with a local
browser, checking exported documentation, or quickly browsing a directory tree
without setting up a larger web server.

## Installation

Install from CPAN:

```bash
cpanm App::HTTPThis
```

or with the standard CPAN client:

```bash
cpan App::HTTPThis
```

## Quick Start

Serve the current directory:

```bash
http_this
```

Serve another directory:

```bash
http_this path/to/files
```

Use a different port:

```bash
http_this --port 9001
```

Use prettier directory listings:

```bash
http_this --pretty
```

Serve `index.html` for directory requests when present:

```bash
http_this --autoindex
```

Print the installed version:

```bash
http_this --version
```

## Network Safety

Since version 1.0.0, `http_this` binds to `127.0.0.1` by default. That means
only this computer can connect to it unless you explicitly choose otherwise.

To bind to a specific address:

```bash
http_this --host 192.168.1.23
```

To deliberately listen on all network interfaces:

```bash
http_this --all
```

`--promiscuous` is also accepted as an alias for `--all`.

Use `--all` only when you really do want other machines on your network to be
able to reach the files you are serving.

## Windows, WSL, And Chrome

If you run `http_this` inside WSL and open the page from a browser running on
Windows, `127.0.0.1` may not be enough. In that setup, WSL has its own network
address.

Use:

```bash
http_this --wsl
```

This binds to the non-loopback IPv4 address selected by the WSL default route
and prints a URL that a Windows browser can open. It is narrower than `--all`
because it binds to one WSL address rather than `0.0.0.0`.

You can make that your default in `.http_thisrc`:

```ini
wsl=1
```

## Configuration

`http_this` looks for configuration in this order:

1. a file passed with `--config`
2. the file named by `HTTP_THIS_CONFIG`
3. `.http_thisrc` in the current directory
4. `.http_thisrc` in your home directory

The file format is simple `key=value` data:

```ini
port=9001
pretty=1
autoindex=1
```

Supported keys are:

- `port`
- `host`
- `name`
- `all`
- `wsl`
- `autoindex`
- `pretty`

Command-line options override configuration values.

## Bonjour / mDNS

`http_this` can advertise itself over Bonjour/mDNS/DNS-SD:

```bash
http_this --name "My shared files"
```

This requires `Net::Rendezvous::Publish` and an appropriate backend for your
platform. See [BONJOUR.md](BONJOUR.md) for more detail.

## Options

```text
--port PORT          listen on a different port
--host HOST          bind to a specific host or IP address
--wsl                bind to the WSL address for Windows browser access
--all                bind to all network interfaces
--promiscuous        alias for --all
--name NAME          publish the server over Bonjour/mDNS
--autoindex          serve index.html for directory requests when present
--pretty             use prettier directory listings
--config FILE        read configuration from FILE
--version            print the installed version
--help               show usage information
--man                show the full manual page
```

## How It Works

`App::HTTPThis` is intentionally thin. The command parses options and config,
then starts a `Plack::Runner` serving a `Plack::App::DirectoryIndex` app.
Plack does the heavy lifting; this distribution provides the convenient CLI
and the small bits of behavior that make it pleasant to use.

## License

This software is free software, licensed under the Artistic License 2.0.
