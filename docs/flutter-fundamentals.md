# Flutter Fundamentals

## Purpose

This document records the Flutter basics covered during the training phase before feature work began. It serves as a reference for candidates joining the project mid-stream.

Training deliverable: Flutter basics done, state updates working in a simple UI.

## Concepts Covered

### StatelessWidget vs StatefulWidget

| Type | When to use | State location |
|------|-------------|----------------|
| StatelessWidget | UI that only depends on constructor parameters | None. Rebuilds when parent rebuilds |
| StatefulWidget | UI that changes over time (input, timers, toggles) | State object via createState |

Rule used in this project: screens that call APIs or hold form state use StatefulWidget or a ChangeNotifier provider. Pure display widgets use StatelessWidget.

### Basic UI Building Blocks Used

- Scaffold for page structure
- AppBar for top bar titles
- Column and Row for layout
- SingleChildScrollView for scrollable forms
- TextFormField and TextField for input
- ElevatedButton for primary actions
- SizedBox and Padding for spacing
- StreamBuilder and Selector for reactive UI (introduced later with Provider)

## Training Exercise Flow

These steps were done before the main app features.

### Step 1: Create a simple stateless screen

1. Create a StatelessWidget with a Text widget
2. Wrap in Scaffold with an AppBar
3. Run on emulator and confirm layout

### Step 2: Add a stateful counter or toggle

1. Convert to StatefulWidget
2. Add a button that calls setState
3. Confirm the label or counter updates on tap

Expected check: tapping the button updates the displayed value without restarting the app.

### Step 3: Build a login-style form (UI only)

1. Add a TextFormField for mobile number
2. Add keyboardType TextInputType.phone
3. Add a submit ElevatedButton
4. Validate input length before enabling the button

This exercise directly led into the Login Page UI milestone documented in authentication.md.

## How This Applies to the Current Project

The production login screen (lib/modules/login/pages/login_page.dart) uses StatelessWidget for the page shell because form state lives in LoginProvider, not in the widget itself.

OTP timer state lives in OtpProvider with a Timer and notifyListeners.

Bottom navigation index lives in HomePageProvider with a PageController.

Pattern in this codebase: keep widgets thin, push state and API calls into providers.

## Dependencies

No extra packages required for the fundamentals exercise. The main app later added provider and rxdart for state and validation streams.

## Common Issues

**setState called after dispose**

Cancel timers and async work in dispose. OtpProvider cancels its timer in dispose.

**Hot reload does not reset provider state**

Use hot restart (Shift+F5 in VS Code) or re-run the app when testing auth flows.

**Keyboard covers input fields**

Wrap form content in SingleChildScrollView and add bottom padding.

## Notes for Future Developers

When adding a new screen, decide early whether it needs local widget state or a provider. Follow the existing module pattern: page widget in pages/, logic in providers/, reusable pieces in widgets/.

See project-structure.md for the full folder convention.
