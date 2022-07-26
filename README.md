# This is a fork of <https://github.com/variadico/noti>

# noti

![Go](https://github.com/subvillion/noti/workflows/Go/badge.svg)

Monitor a process and trigger a notification.

Never sit and wait for some long-running process to finish. Noti can alert you
when it's done. You can receive messages on your computer or phone.

![macOS Banner Notification]

## Services

Noti can send notifications on a number of services.

```txt
           | macOS | Linux | Windows
--------------------------------------
Banner     |   ✔   |   ✔   |    ✔
Speech     |   ✔   |   ✔   |    ✔
BearyChat  |   ✔   |   ✔   |    ✔
Keybase    |   ✔   |   ✔   |    ✔
Mattermost |   ✔   |   ✔   |    ✔
Pushbullet |   ✔   |   ✔   |    ✔
Pushover   |   ✔   |   ✔   |    ✔
Pushsafer  |   ✔   |   ✔   |    ✔
Simplepush |   ✔   |   ✔   |    ✔
Slack      |   ✔   |   ✔   |    ✔
Telegram   |   ✔   |   ✔   |    ✔
Zulip      |   ✔   |   ✔   |    ✔
Twilio     |   ✔   |   ✔   |    ✔
Gotify     |   ✔   |   ✔   |    ✔
ntfy       |   ✘   |   ✘   |    ✘
```

Checkout the [screenshots] directory to see what the notifications look like on
different platforms.

## Installation

The `master` branch always contains the latest tagged release.

```bash
# Install the latest version on macOS.
brew install noti

# Install latest version, if you have Go installed.
go get github.com/subvillion/noti/cmd/noti
```

If you don't want to build from source or install anything extra, just download
the latest binary.

```bash
# macOS
curl -L $(curl -s https://api.github.com/repos/variadico/noti/releases/latest | awk '/browser_download_url/ { print $2 }' | grep 'darwin-amd64' | sed 's/"//g') | tar -xz

# Linux
curl -L $(curl -s https://api.github.com/repos/variadico/noti/releases/latest | awk '/browser_download_url/ { print $2 }' | grep 'linux-amd64' | sed 's/"//g') | tar -xz
```

Or download with your browser from the [latest release] page.

### From source

If you want to build from source, then build like this.

```bash
# build binary
make build
# build binary and move to Go bin dir
make install
```

## Examples

Just put `noti` at the beginning or end of your regular commands. For more
details, checkout the [docs].

Display a notification when `tar` finishes compressing files.

```bash
noti tar -cjf music.tar.bz2 Music/
```

Add `noti` after a command, in case you forgot at the beginning.

```bash
clang foo.c -Wall -lm -L/usr/X11R6/lib -lX11 -o bizz; noti
```

If you already started a command, but forgot to use `noti`, then you can do
this to get notified when that process' PID disappears.

```bash
noti --pwatch 1234
```

You can also press `ctrl+z` after you started a process. This will temporarily
suspend the process, but you can resume it with `noti`.

```bash
$ dd if=/dev/zero of=foo bs=1M count=2000
^Z
zsh: suspended  dd if=/dev/zero of=foo bs=1M count=2000
$ fg; noti
[1]  + continued  dd if=/dev/zero of=foo bs=1M count=2000
2000+0 records in
2000+0 records out
2097152000 bytes (2.1 GB, 2.0 GiB) copied, 12 s, 175 MB/s
```

Additionally, `noti` can send a message piped from stdin with `-`.

```bash
$ make test 2>&1 | tail --lines 5 | noti -t "Test Results" -m -
```

[CircleCI]: https://circleci.com/gh/variadico/noti/tree/master.svg?style=svg
[AppVeyor]: https://ci.appveyor.com/api/projects/status/qc2fgc164786jws6/branch/master?svg=true
[Codecov]: https://codecov.io/gh/variadico/noti/branch/master/graph/badge.svg
[macOS Banner Notification]: https://raw.githubusercontent.com/variadico/noti/master/docs/screenshots/macos_banner.png
[screenshots]: https://github.com/subvillion/noti/tree/master/docs/screenshots
[latest release]: https://github.com/subvillion/noti/releases/latest
[docs]: https://github.com/subvillion/noti/blob/master/docs/noti.md
