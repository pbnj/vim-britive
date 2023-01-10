# vim-britive

> A Vim integration plugin for Britive

## Table of Contents

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [vim-britive](#vim-britive)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Overview

[Britive](https://www.britive.com/) is a multi-cloud privilege & identity
access management platform.

This is an unofficial vim plugin to provide a seamless integration with
[`britive-cli`](https://www.npmjs.com/package/britive-cli).

## Install

With [vim-plug](https://github.com/junegunn/vim-plug):

```vim
Plug 'https://github.com/pbnj/vim-britive'
```

## Dependencies

[`britive-cli`](https://www.npmjs.com/package/britive-cli)

## Usage

Run Britive commands from vim:

```vim
:Britive <args...>
```

Tab completion on `:Britive` command returns possible Britive sub-commands,
like `checkin`, `checkout`, ...etc.

For example, to check out a profile called `foo` and display credentials as
environment variables:

```vim
:Britive checkout foo --displaymode=env
```

Since checking out Britive Profiles for programmatic access (i.e. generating
API keys) are very common operations, a dedicated command is provided:

```vim
:BritiveCheckout <profile>
```

This is equivalent to checking out **Programmatic Access** via the Britive web
UI.

Tab completion is supported on `:BritiveCheckout` command, which returns
possible profile names.

You may also check out Britive Profiles for console access (i.e. launching a
browser tab):

```vim
:BritiveConsole <profile>
```

This will produce a URL for the configured Cloud Service Provider, equivalent
to checking out **Console Access** via the Britive web UI.

Tab completion is supported on `:BritiveCheckout` command, which returns
possible profile names.

## License

MIT
