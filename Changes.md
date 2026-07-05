# Changes for App-HTTPThis

All notable changes to this project will be documented in this file.

The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project (since version 0.11.0) adheres to
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

- Rewrote Changes to Changes.md (using KeepAChangeLog format)

### Fixed

- Replace generated README with a useful README.md

### Added

- Add --version to print the installed App::HTTPThis version
- Add Bonjour.md to the distribution

## [1.0.1] - 2026-07-03

### Added

- Add --wsl and config wsl=1 to bind to the WSL IP address for access from Windows browsers

### Fixed

- Ensure --config selects the config file before it is loaded

## [1.0.0] - 2026-07-01

### Fixed

- Default to binding to 127.0.0.1 when no host is set in the CLI or config

### Added

- Add --all (alias --promiscuous) and config all=1 to restore the previous all-interfaces behaviour

## [0.11.2] - 2026-07-01

### Fixed

- Be honest about the default being to bind to all network interfaces
- Add back missing '=head1 NAME' section (went missing in de-dzillification)

## [0.11.1] - 2026-03-16

### Fixed

- Bump required version of Plack::App::DirectoryIndex

## [0.11.0] - 2026-03-13

### Fixed

- Switch to semantic versioning
- Command-line args take precedence over config file
- Ensure $dir_index is undef if autoindex is turned off
- Don't look for config file in $ENV{HOME} if that's undef
- Strip out Dist::Zilla :-)

## [0.010] 2025-12-04

### Added

- Add --host option

## [0.009] 2023-06-21

### Added

- Add missing prereq

## [0.008] 2023-06-21

### Added

- Add support for a config file

## [0.007] 2023-06-05

### Added

- Add --pretty option for nicer directory listings

## [0.006] 2023-05-25

### Added

- Add bugtracker URL

## [0.005] 2023-05-25

### Fixed

- Various admin fixes

## [0.004] 2023-5-15

### Fixed

- Fix prereqs

## [0.003] 2023-05-15

### Added

- Handle default pages (like index.html)

## [0.002] 2010-07-29

### Changed

- Use Plack::Runner higher-level interface instead of Plack::Handler::Standalone directly

### Fixed

- Deal with port-already-in-use better, with prettier messages

### Added

- Added --name option to announce the server over Bonjour

## [0.001] Wed Jul 28 15:52:36 UTC 2010-07-28

### Added

- Initial release
