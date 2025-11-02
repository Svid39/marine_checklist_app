# Changelog

All notable changes to this project will be documented in this file.


## [1.1.0] - 2025-09-21

### Added 🚀

-   Full localization support for English and Russian throughout the entire user interface.
-   Added an in-app language switcher in the settings screen to change the language on the fly.
-   Implemented a system to dynamically load checklists from external JSON files located in the `assets` folder.

### Changed ✨

-   Refactored checklist data storage from a single, hardcoded Dart file to individual, manageable JSON files.
-   Added the `shipName` field to the `Deficiency` model to provide better context, especially for manually created deficiencies.
-   Improved code quality and maintainability by adding DartDoc comments to all major models, screens, and services.
-   Removed all debug print statements from the codebase.

### Fixed 🛠️

-   Resolved all `use_build_context_synchronously` linter warnings by adding `mounted` checks, preventing potential crashes after async operations.
-   Fixed an issue on Android where app data would persist after reinstallation by disabling the Auto Backup feature in the `AndroidManifest.xml`.
-   Resolved various build conflicts related to the localization system setup and conflicting linter rules.

## [1.0.0] - 2025-09-12

-   Initial release of the application.
-   Core functionality including checklist execution, deficiency tracking, and PDF report generation.