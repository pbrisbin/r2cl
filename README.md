# R2CL

Fetch releases from GitHub and format a full CHANGELOG from their notes.

## Installation

TODO

## Usage

```console
% r2cl --help
Usage: r2cl --repo OWNER/NAME [--default-branch ARG] [--after vX.Y.Z]
            [-u|--update PATH]

Available options:
  --repo OWNER/NAME        Repository to fetch releases for
  --default-branch ARG     Branch to use in Unreleased section (default: "main")
  --after vX.Y.Z           Only generate with versions down to the given version
  -u,--update PATH         Update PATH in place
  -h,--help                Show this help text
```

`$GITHUB_TOKEN` must be set token a token with `read:content` on the repository.

## Examples

Replacing a full `CHANGELOG.md`:

```console
GITHUB_TOKEN=... r2cl --repo foo/bar >CHANGELOG.md
```

## `--update`

If you pass `--update PATH` the content will be written into that file. Where
it's written depends on the presence of pragmas.

If both `<!-- r2cl BEGIN -->` and `<!-- r2cl END -->` are present, the lines
between them are *replaced* with the content. If only `BEGIN` present, the lines
are *inserted* after it. If neither are present, the lines are *inserted* at the
top of the file. No how it started, after this operation, both `BEGIN` and `END`
pragmas will be present.

## `--after`

If `--after vX.Y.Z` is given, only releases down to that version (exclusive,
beginning with latest) are included. This allows you to main content for older
versions manually, while automatically writing in content for newer versions
(presumably when more details and/or consistent release notes began).

---

[CHANGELOG](./CHANGELOG.md) | [LICENSE](./LICENSE)
