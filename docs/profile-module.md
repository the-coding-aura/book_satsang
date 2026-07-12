# Profile Module

## Purpose

This document covers the profile tab: loading member data from the API, editing form fields, and the current gap on save submission.

Training deliverable: update profile UI built. Submit to backend is not fully wired at handover.

## Module Location

| File | Role |
|------|------|
| lib/modules/home/screens/profile_screen.dart | Profile tab UI |
| lib/modules/home/providers/profile_screen_provider.dart | Fetch, form state, upload |
| lib/modules/home/widgets/ | Profile-specific form widgets |
| lib/modules/home/repository/ | HomeApiRepository for profile fetch |

Profile reuses registration validators and widget patterns from lib/modules/registeration/.

## Current Implementation

### What works

1. On tab open, initiateRegPage runs after first frame
2. fetchProfileDetails calls GET /Member/GetMemberByToken
3. Master data loads: designation, taluka, village lists
4. assignProfileData pre-fills first name, last name, DOB, designation, taluka, village, profile image
5. User can change fields and upload a new profile image via FileUploadService
6. Image upload calls POST /FileHandling/UploadFile through MasterApiRepository
7. Upload progress shows CircularProgressIndicator on the image widget

### What does not work yet

1. SubmitProfileButton onPressed is an empty function
2. registerMember or update profile method in ProfileScreenProvider is commented out
3. No update member endpoint in ApiPath enum
4. updateProfileResponse field exists but no active submit flow

At handover, profile is read and edit UI only.

## Form Fields

Same set as registration:

- Profile image
- First name
- Last name
- Date of birth
- Designation dropdown
- Taluka searchable dropdown
- Village searchable dropdown (depends on selected taluka)

Widgets live under lib/modules/home/widgets/ with names matching registration widgets.

Validation uses RegisterFormValidator streams in the provider.

## Step-by-Step: Wire Profile Update (Future Work)

1. Confirm backend endpoint and payload with API doc
2. Add ApiPath entry, for example updateMember
3. Add updateMember method to HomeApiRepository abstract, HTTP, and mock classes
4. Create UpdateMemberRequestModel from form values
5. Implement submitProfile in ProfileScreenProvider:
   - Set ApiResponse.loading
   - Call repository
   - On success show AppFlushbar.success and optionally refetch profile
   - On error show AppFlushbar.error
6. Connect SubmitProfileButton to submitProfile
7. Disable button while loading via Selector on isLoading

## Tests and Checks

| Check | Expected |
|-------|----------|
| Open profile tab after login | Form fills with user data |
| Change taluka | Village list refreshes for new taluka |
| Upload image MOCK | Mock upload returns URL, image preview updates |
| Tap submit at handover | Nothing happens (known gap) |
| After submit wired | Success message and persisted data on refetch |

## Common Issues

**Profile fields empty on DEV**

Token missing or fetch failed. Confirm login stored AuthData and check network response.

**Village dropdown disabled**

Select taluka first. Village fetch requires talukaId.

**Image upload permission denied**

PermissionService handles Android version-specific rules. User may need to grant camera or photos permission in settings.

**Form valid but submit disabled**

SubmitProfileButton uses StreamBuilder on validation stream. Check all required fields including image.

## Notes for Future Developers

- Do not duplicate registration upload logic. FileUploadService is shared.
- ProfileScreenProvider is large. Consider splitting upload and form logic if submit adds more complexity.
- Filename typo profile_screen_rpovider_extension.dart is used in imports. Fix carefully across the codebase if renaming.

See authentication.md for registration API shape as a reference for update payload and network-layer.md for repository pattern.
