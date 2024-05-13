# R2CL

Fetch release notes from GitHub and format a full CHANGELOG from their notes.

## Installation

TODO

## Usage

```console
% r2cl --help
TODO
```

## Examples

In the context of a git repository, replacing a full `CHANGELOG.md`:

```console
r2cl >CHANGELOG.md
```

Explicitly stating the repository:

```console
r2cl --repo freckle/stackctl >CHANGELOG.md
```

Updating a portion of `CHANGELOG.md` in place:

Assume you have a `CHANGELOG.md` that looks like this:

```md
<!-- BEGIN r2cl -->

## [v3.2.2.0](...)

...
```

You can generate a CHANGELOG for only newer versions with:

```console
r2cl --after v3.2.2.0
```

And you can write this content after the `BEGIN` line with,

```console
r2cl --after v3.2.2.0 --update CHANGELOG.md
```

---

[CHANGELOG](./CHANGELOG.md) | [LICENSE](./LICENSE)
