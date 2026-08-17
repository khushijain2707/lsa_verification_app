# LSA Verification & Data Lineage Integration

A Flutter mobile application developed for the **HabotConnect Flutter Mobile Developer Hiring Assignment**.

The application implements an LSA onboarding verification gate with data lineage validation, secure request headers, fail-closed compliance handling, UI friction logging, and automated tests.

---

## Project Overview

The application provides a single-screen **LSA Onboarding Gate** where a user enters a Parent Consent Code and submits it for compliance verification.

The application follows a fail-closed approach:

- Valid verification → Success
- Invalid lineage → Quarantined
- API failure / HTTP 500 → Quarantined
- Timeout / malformed response → Quarantined
- Sensitive consent data is cleared on failure

The main screen is implemented as a `StatelessWidget` and uses `ValueNotifier` and `ValueListenableBuilder` for reactive state updates.

---

## 🎥 Demo Video

[▶️ Watch Project Demo](https://drive.google.com/file/d/1MNnRxb6zQrjuVEUtsjUXbm10AB2ZZ8dF/view?usp=drive_link)

## 🎨 Figma Design

[🔗 View Figma Design](https://www.figma.com/design/yef4biugqpCrAiyqOH15Mn/LSA-Verification?node-id=21-133&t=Hd7S1vQJg6P2tinv-1)

## Features

- LSA ID displayed as read-only
- Parent Consent Code input
- Hidden system-controlled Predecessor ID
- Verify & Submit action
- Four verification states:
  - Idle
  - Processing
  - Success
  - Quarantined
- Data lineage validation before network communication
- UUID v4 `x-trace-id`
- SHA-256 `x-logic-hash`
- JSON HTTP POST request
- Fail-closed error handling
- Sensitive consent code clearing on failure
- 5-second UI friction logging
- Consent code value is never written to friction logs
- Automated widget/unit tests
- Figma-to-Flutter implementation

---

## Screen Flow

```text
Idle
  |
  v
Enter Parent Consent Code
  |
  v
Verify & Submit
  |
  v
Processing
  |
  +---- Valid response ----> Verification Successful
  |
  +---- Invalid / 500 / Timeout / Malformed
                              |
                              v
                    Data Quarantined
 ```
---
## API Integration

### Endpoint

POST `https://api.habotconnect.com/v1/compliance/verify`

### Request Body

```json
{
  "predecessor_id": "PRED-9982-XYZ",
  "lsa_id": "LSA-7049",
  "parent_consent_code": "<user input>",
  "timestamp_utc": "<UTC timestamp>"
}
```

### Required Headers

```text
Content-Type: application/json
x-trace-id: UUID v4
x-logic-hash: SHA-256 hash
```
The `x-logic-hash` is generated from the JSON request body.

---

## Data Lineage Validation

The application validates the predecessor ID before any network request.

The system-controlled predecessor ID is:

`PRED-9982-XYZ`

The predecessor ID is not displayed in the user interface.

If lineage validation fails, the application immediately enters the Quarantined state and does not make a network request.

---

## Fail-Closed Behavior
- Valid response → Verification Successful
- Invalid lineage → Data Quarantined
- HTTP 500 → Data Quarantined
- Timeout → Data Quarantined
- Malformed response → Data Quarantined
- Consent code is cleared on failure

---

## Demo Mode

### Success

Input:

`PCC-2026-9901`

Result:

`Verification Successful`

### API 500

Input:

`TEST-500`

Result:

`Data Quarantined - Compliance Failure`

The consent code is cleared after failure.

---

## UI Friction Logging

If the Parent Consent Code field remains inactive for more than 5 seconds, a friction log is generated.

The consent code value is never included in the log.

---

## Testing

Run:

```bash
flutter analyze
flutter test
```

Result:

```text
No issues found!
+3: All tests passed!

The three tests cover:

1. Valid submission
2. Invalid lineage
3. API 500 failure
```
---

## Project Structure

```text
lib/
├── main.dart
├── screens/
├── widgets/
├── models/
├── services/
├── controllers/
└── utils/
```
## Author

Khushi Jain

Flutter / Mobile Application Developer 
