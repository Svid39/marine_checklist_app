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

Below is a step-by-step plan for the architectural refactoring and evolution of the app.

### Step 1: Visuals & State Management (Themes + Riverpod)
Implementing a theme switcher (Light, Standard, Dark) is the perfect opportunity to introduce **Riverpod**. Theme switching is an excellent, straightforward task to test-drive a new state manager.
* Create beautiful marine-inspired color palettes.
* Develop a settings provider that fetches the theme preference from the `userProfileBox` and instantly updates the UI without workarounds.

### Step 2: Clean Architecture (Repository Layer)
Currently, screens (e.g., `DashboardScreen` or `DeficiencyListScreen`) interact directly with `Hive.box` to add or delete records. This logic needs to be decoupled from the UI.
* Create `ChecklistRepository` and `DeficiencyRepository` classes.
* Screens will become "dumb": they will simply send commands (e.g., "delete deficiency number 5"), and the repository will handle the database operations along with the deletion of attached photos. This will significantly simplify the screen code.

### Step 3: Memory Optimization & UX (Garbage Collector & Search)
The app actively generates PDF documents and saves photos, making device file system management crucial.
* Write a service (Garbage Collector) that quietly cleans up the temporary PDF report folder (cache) upon app startup to prevent the app from bloating.
* Add a search bar to the Dashboard to quickly find the necessary check by vessel name or port.

### Step 4 (Long-term): Backend & Synchronization
This step will be implemented when the app goes into production and there is a need to set up a server.
* Add an API layer to our Repositories (from Step 2). The UI won't need to change at all since all logic will be securely encapsulated by then.
