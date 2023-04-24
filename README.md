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

Run Britive commands from vim.

```vim
:Britive <args...>
```

A basic example is checking out Britive Profiles:

```vim
:Britive checkout <APPLICATION>/<ENVIRONMENT>/<PROFILE>
```

Tab completion on `:Britive` command completes Britive sub-commands,
like `checkin`, `checkout`, ...etc.

### Profile Checkouts

#### Checkout Programmatic Access

Since checking out Britive Profiles for programmatic access (i.e. generating
API keys) are very common operations, there is a convenient command for it:

```vim
:BritiveCheckout <APPLICATION>/<ENVIRONMENT>/<PROFILE>
```

This is equivalent to checking out **Programmatic Access** via the Britive web
UI.

Tab completion is supported on `:BritiveCheckout` command, which completes
profile names.

You may pass any `britive checkout` flags to this command. For example, if you
would like to check out programmatic access and display the API
keys/credentials in "environment variable" format:

```vim
:BritiveCheckout <APPLICATION>/<ENVIRONMENT>/<PROFILE> --mode=env
```

#### Checkout Console Access

You may check out console access for Britive Profiles:

```vim
:BritiveConsole <APPLICATION>/<ENVIRONMENT>/<PROFILE>
```

This will produce a URL for the configured Cloud Service Provider, equivalent
to checking out **Console Access** via the Britive web UI.

Tab completion is supported on `:BritiveConsole` command, which completes
possible profile names.

To automatically open Britive console URLs without manually copying/pasting, on
macOS:

```vim
:BritiveConsole <APPLICATION>/<ENVIRONMENT>/<PROFILE> | xargs open
```

On Linux/Ubuntu:

```vim
:BritiveConsole <APPLICATION>/<ENVIRONMENT>/<PROFILE> | xargs xdg-open
```

### Britive API

`pybritive` exposes the `api` subcommand to query Britive APIs beyond the
available commands.

For example, you may run an environment scan like so:

```sh
pybritive api scans.scan --application_id <app_id> --environment_id <env_id>
```

This plugin provides the vim command `:BritiveAPI` with tab-completion
suggestions, which allows you to do the same in vim:

```vim
:BritiveAPI scans.scan --application_id <app_id> --environment_id <env_id>
```

The results will be displayed in a vim terminal buffer. This allows you to
leverage the full capabilities and functionality of vim to query and interact
with the data as you please.

## TODO

- [ ] Windows OS testing

## License

MIT
