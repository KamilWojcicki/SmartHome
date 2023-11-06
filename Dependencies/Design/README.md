# Design

A description of this package.

## Regenerating assets

To regenerate code based on assets (icons and fonts) do the following:

- add fonts/icons in the appropriate catalog in `Resources`,
- close Xcode,
- open Terminal and change directory to `Dependencies/Design`,
- use the following command:
```
swift package --allow-writing-to-package-directory run-swiftgen
```
