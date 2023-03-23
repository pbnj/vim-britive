# vim-britive

> An unofficial Vim plugin for Britive

## Table of Contents

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Overview](#overview)
- [Install](#install)
- [Dependencies](#dependencies)
- [Usage](#usage)
- [License](#license)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Overview

[Britive](https://www.britive.com/) is a multi-cloud privilege & identity
access management platform.

This is an unofficial vim plugin to provide a seamless integration with
[`pybritive`](https://github.com/britive/python-cli).

## Install

With [vim-plug](https://github.com/junegunn/vim-plug):

```vim
Plug 'https://github.com/pbnj/vim-britive'
```

## Dependencies

- [`pybritive`](https://github.com/britive/python-cli)

## Usage

### Basic

Run Britive commands from vim:

```vim
:Britive <args...>
```

Tab completion on `:Britive` command returns possible Britive sub-commands,
like `checkin`, `checkout`, ...etc.

For example, to check out a profile called `foo` and display credentials as
environment variables:

```vim
:Britive checkout <APPLICATION>/<ENVIRONMENT>/<PROFILE>
```

### Checkout Programmatic Access

Since checking out Britive Profiles for programmatic access (i.e. generating
API keys) are very common operations, there is a convenient command for it:

```vim
:BritiveCheckout <APPLICATION>/<ENVIRONMENT>/<PROFILE>
```

This is equivalent to checking out **Programmatic Access** via the Britive web
UI.

Tab completion is supported on `:BritiveCheckout` command, which returns
possible profile names.

You may pass any `britive checkout` flags to this command. For example, if you
would like to check out programmatic access and display the API
keys/credentials in "environment variable" format:

```vim
:BritiveCheckout <APPLICATION>/<ENVIRONMENT>/<PROFILE> --mode=env
```

### Checkout Console Access

You may check out console access for Britive Profiles:

```vim
:BritiveConsole <APPLICATION>/<ENVIRONMENT>/<PROFILE>
```

This will produce a URL for the configured Cloud Service Provider, equivalent
to checking out **Console Access** via the Britive web UI.

Tab completion is supported on `:BritiveConsole` command, which returns
possible profile names.

To automatically open Britive console URLs without manually copying/pasting, on macOS:

```vim
:BritiveConsole <APPLICATION>/<ENVIRONMENT>/<PROFILE> | xargs open
```

On Linux/Ubuntu:

```vim
:BritiveConsole <APPLICATION>/<ENVIRONMENT>/<PROFILE> | xargs xdg-open
```

### FZF Integration

If [vim-fzf](https://github.com/junegunn/fzf.vim) plugin is installed, the
following commands become available:

```vim
:BritiveCheckoutFZF
:BritiveConsoleFZF
```

This allows you to fuzzy search through your Britive Profiles and the selections
will be passed to the respective Britive vim commands.

Multiple selections are supported.

`ctrl-r` fzf binding is configured to reload Britive Profiles in the Fuzzy
Finder window.

## TODO

- [ ] Windows OS testing

## License

MIT
