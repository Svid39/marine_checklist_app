# Marine Checklist Pro ⚓

This project is a powerful tool for seafarers, superintendents, and inspectors, turning a mobile phone into a comprehensive assistant for preparing for and passing vessel inspections.

The application is designed to systematize checks before crucial audits such as **PSC (Port State Control), ISM, DNV,** and others. Forget paperwork — create checklists, document non-conformities, attach photo evidence, and generate professional PDF reports right from your device.

## ✨ Features

* **🗂️ Dynamic Checklists:** Create and manage detailed checklists tailored for various types of inspections.
* **📸 Photo Evidence:** Attach photos directly to checklist items or non-conformity reports for clear, visual proof.
* **📄 PDF Report Generation:** Automatically create professional PDF reports based on inspection results, ready to be shared.
* **❗ Non-Conformity Reports:** Specialized functionality to quickly document, describe, and report any deviations from standards.
* **📧 Export & Share:** Easily send generated reports via email or other applications directly from your phone.
* **📱 Offline First:** Conduct inspections and fill out checklists even without an internet connection in the middle of the ocean. All data is saved locally.

## 🗺 Roadmap

The application has successfully completed its core stabilization phase, including dynamic visually-appealing themes, Riverpod state management, and a robust offline database. Below is the development backlog for the next iterations of the project:

### Block 1: Ideal File System & Garbage Collector (Completed ✅)
* **StorageManager:** Centralized architecture preventing hardcoded paths.
* **Database Migration:** Isolated local databases moved specifically into internal `database/` directors to prevent accidental cache clears.
* **Smart Media Handling:** Compressing and copying photos via `image_picker` directly into local `reports/checklist_ID/photos/` folders using relative paths.
* **Garbage Collector:** Replaced O(N) database item deletions with an O(1) unlinked directory swipe, mitigating storage leaks seamlessly in 1 click.

### Block 2: Dashboard (Main Screen) & Navigation (In Progress)
* **Search Checklists:** Add a search bar to filter by vessel name, port, captain name, or IMO number as the number of inspections grows over 50-100 items.
* **Sorting & Filters:** Filter lists by status (In Progress / Completed) and creation date.
* **Safe Navigation Architecture:** Audit codebase to replace arbitrary `Navigator.push` post-async executions with secure context capturers minimizing layout crashes.

### Block 3: Memory Optimization (Media & PDF)
* **On-the-fly Image Compression:** Expanding the `flutter_image_compress` utility to scale down large 5-10MB camera captures down to 500KB - 1MB before saving, preventing PDF generator bottlenecks.
* **PDF Generator Security:** Protect against Out-Of-Memory exceptions during the generation of reports containing large amounts of non-conformities and photography.
* **Asynchronous Loading Spinners:** Implement beautiful loading screens (spinners) during heavy operations seamlessly demonstrating background task activity.

### Block 4: UI/UX Improvements
* **Permissions Handling:** Utilize `permission_handler` for elegant camera/storage access prompts on first app launch.
* **Checklist Exit Protection:** Prompt warning dialogue models upon trying to exit a checklist while unsaved data relies on the current state.
* **Backend & Synchronization (Long-term):** Add an API layer to the repository structures for cloud cross-crew synchronization.
