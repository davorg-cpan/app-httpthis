# Bonjour / mDNS / ZeroConf support in App::HTTPThis

App::HTTPThis can advertise your local web server on your network so other
devices can find it without you having to tell them an IP address and port.

This document explains the *what*, the *how*, and the *how do I check it’s
working?*

---

## 1) What is Bonjour / Rendezvous / mDNS / ZeroConf / Avahi?

### The 30‑second version

* **mDNS** (*multicast DNS*) is the core technology: DNS‑like name lookups
  performed on the local network using multicast rather than a central DNS
  server.
* **DNS‑SD** (*DNS Service Discovery*) is the convention layered on top that
  says *how* a service advertises itself (service type, name, port, and
  optional metadata).
* **Bonjour** is Apple’s implementation/branding of mDNS + DNS‑SD.
* **Rendezvous** was Apple’s earlier name for the same thing.
* **ZeroConf** is a broader term (“zero configuration networking”) that
  includes mDNS + DNS‑SD and related ideas.
* **Avahi** is the common Linux implementation of mDNS + DNS‑SD.

So when people say “Bonjour” (or “Rendezvous”, “mDNS”, “ZeroConf”, “Avahi”),
they’re usually talking about the same family of technologies: *advertise a
service on the local network and let clients discover it automatically*.

### What it does for App::HTTPThis

When you start `http_this` with a name, it can publish a service of type:

    $ http_this --name MyService .

* `_http._tcp` on the `local` domain

That means other machines on the same network that speak mDNS/DNS‑SD can
discover something like:

* **Service name**: `MyService`
* **Service type**: `_http._tcp`
* **Address/port**: e.g. `172.24.198.3:7007`

(Exact details depend on your network and how many interfaces you have.)

---

## 2) How do I use it with `http_this`?

### Basic usage

Start the server and publish it via mDNS/DNS‑SD:

```bash
http_this --name MyService
```

* `--name` is the *service instance name* that other devices will see.
* If you omit `--name`, the server will still run, but it will not advertise
  itself over mDNS.

### What Perl modules do I need?

Publishing is implemented via **Net::Rendezvous::Publish**.

You will also need an appropriate backend module for your platform, typically:

* `Net::Rendezvous::Publish::Backend::Avahi` (common on Linux)

In other words:

* **Publishing** (what `http_this` does): `Net::Rendezvous::Publish` + a
  `Net::Rendezvous::Publish::Backend::*`.

### Notes and gotchas

* **“Bonjour” is just the ecosystem name**. App::HTTPThis does not require
  Apple libraries; it publishes an mDNS/DNS‑SD service that any Bonjour/mDNS
  client can discover.
* **Multiple interfaces are normal.** On machines with Docker, WSL2, VPNs,
  etc., your service may appear once per interface.
* **The advertised name is not a hostname.** It’s a *service instance* label
  shown in service browsers.

---

## 3) How do I see my advertised service?

### Option A: Avahi tools (Linux)

If you’re on Linux with Avahi installed, you can browse all advertised
services:

```bash
avahi-browse -at
```

You should see entries like:

* Service name (e.g. `MyService`)
* Service type (`_http._tcp`)
* Domain (`local`)

To filter to HTTP services only:

```bash
avahi-browse -rt _http._tcp
```

### Option B: A graphical browser

On many platforms there are “Bonjour browser” apps that show advertised
services. These are handy for a quick sanity check.

(Any mDNS/DNS‑SD browser should work — you’re just looking for `_http._tcp`
with the instance name you chose.)

### Option C: Discover from Perl

To discover services from Perl, use **Net::Bonjour**.

Net::Bonjour can browse and resolve services to host/port information.

A minimal example (adapted from the Net::Bonjour documentation):

```perl
use strict;
use warnings;

use Net::Bonjour;

my $browser = Net::Bonjour->new('http');
$browser->discover;

for my $service ($browser->services) {
  $service->resolve;
  next unless $service->name; # defensive
  printf "%s %s:%s\n",
    $service->name,
    ($service->addresses)[0] // 'unknown',
    $service->port // 'unknown';
}
```

If you started:

```bash
http_this --name MyService
```

…you should see output that includes something like:

```text
MyService 172.24.198.3:7007
```

### Interpreting what you see

* Seeing `MyService` means the advertisement is happening.
* Seeing an address/port means the client successfully resolved the service.
* If you see multiple `MyService` entries, you’re likely seeing multiple
  network interfaces.

---

## Troubleshooting

* **I don’t see anything in my browser**

  * Ensure you started with `--name`.
  * Ensure the publish modules are installed (`Net::Rendezvous::Publish` +
    backend).
  * Ensure mDNS isn’t blocked by firewall rules on your machine or network.

* **It shows up, but I can’t connect**

  * Confirm which address/port was advertised.
  * Confirm your server is listening on the interface reachable from the client.
  * Check if you’re in an environment with tricky networking (WSL2, Docker
    bridges, VPNs).

* **What should I tell users to connect to?**

  * Many service browsers will let you click through.
  * Otherwise, tell them the resolved `http://<address>:<port>/`.

---

## Further reading

* App::HTTPThis repository issues:
  [https://github.com/davorg-cpan/app-httpthis/issues](https://github.com/davorg-cpan/app-httpthis/issues)

(If you find anything unclear or you have platform-specific notes to add,
please open an issue or PR.)

