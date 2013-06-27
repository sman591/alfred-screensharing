# Screen Sharing for Alfred

> Connect to a host via Apple's Screen Sharing app.

Hosts with Screen Sharing enabled will **be automatically discovered** and listed within Alfred.

![Screenshot of "Screen Sharing for Alfred"](screenshot.png)

## Installation

First, install `dnssd` to the default OS X ruby gemset.

```bash
# If using rbenv, first run `rbenv global system`
# If using RVM, first run `rvm use system`
# Otherwise, just run:
$ sudo gem install dnssd
```

Afterwards, [download](Screen%20Sharing.alfredworkflow?raw=true) and install the Alfred workflow.
