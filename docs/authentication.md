# Authentication

## Purpose

This document covers the login UI, OTP screen, registration flow, and API integration for user authentication.

Training deliverables:

- Login UI ready with 10-digit validation
- OTP UI ready with 30-second resend timer
- SendOTP integrated
- Verify login and OTP integrated
- Registration UI and API complete

## Module Locations

| Area | Path |
|------|------|
| Login page and widgets | lib/modules/login/ |
| OTP page and widgets | lib/modules/otp/ |
| Registration | lib/modules/registeration/ |
| Splash session check | lib/modules/splash/ |

## Login Page

File: lib/modules/login/pages/login_page.dart

UI components:

- Background image
- LoginHeader
- LoginMobileField -- 10-digit mobile input
- TermLabelButton -- terms and conditions checkbox
- SendOtpButton -- triggers user exist check or send OTP
- Privacy policy link opens PrivacyPolicyDialog

Validation:

- LoginValidator enforces 10-digit mobile via rxdart stream
- Terms must be accepted before submit
- StreamBuilder disables button until form is valid

### Login flow steps

1. User enters mobile number
2. Tap Send OTP
3. LoginProvider.checkUserExist calls POST /Member/MobileExists
4. If status is 1 (user exists): navigate to OTP with VerificationType.login
5. If user does not exist: LoginProvider.sendOTP calls POST /OTP/SendOTP, then navigate to OTP with VerificationType.otp

## OTP Page

File: lib/modules/otp/pages/otp_page.dart

UI components:

- OtpLogoHeader
- OtpTitleSection
- OtpMaskedMobileText
- OtpPinInput using pinput package
- OtpTimerSection -- countdown from AppConstants.otpTimerSeconds (30)
- OtpChangeMobileLink -- navigates back to login

Timer behavior:

- Starts on screen load
- Resend link disabled until timer reaches zero
- Resend API call is currently commented out in OtpProvider. UI still shows timer.

Verification:

- Login path: memberLogin POST /Member/VerifyLogin
- Register path: verifyOtp POST /OTP/VerifyOTP

Mock flavor OTP for login testing: AppConstants.mockOtp = 123456

Note: AppConstants.otpLength is 4 but mock OTP is 6 digits. Confirm with backend which length is correct before QA sign-off.

## Registration Page

File: lib/modules/registeration/pages/registeration_page.dart

Fields:

- Profile image upload
- First name, last name
- Date of birth
- Designation dropdown
- Taluka and village searchable dropdowns
- Submit button

Flow:

1. Receives verified mobile from route arguments after OTP verify
2. Loads designation, taluka, village master data on init
3. registerMember POST /Member/AddMember with isAdmin hardcoded to 0
4. Success navigates to login page

Validators reuse RegisterFormValidator shared with profile screen.

## API Endpoints Used

| Action | Method | Path |
|--------|--------|------|
| Check mobile exists | POST | /Member/MobileExists |
| Send OTP | POST | /OTP/SendOTP |
| Verify OTP | POST | /OTP/VerifyOTP |
| Member login | POST | /Member/VerifyLogin |
| Register member | POST | /Member/AddMember |

Request and response models live under each module models/ folder. Parsing uses fromJson factory constructors.

## Implementation Flow Summary

```
Splash -> token check
  -> Login
    -> MobileExists
      -> existing: OTP (login type) -> VerifyLogin -> Home
      -> new: SendOTP -> OTP (register type) -> VerifyOTP -> Register -> Login
```

## Tests and Checks

| Test | MOCK flavor | Expected |
|------|-------------|----------|
| Invalid mobile | Enter 9 digits | Submit disabled |
| Valid mobile format | Enter 10 digits, accept terms | Submit enabled |
| OTP timer | Open OTP screen | Resend disabled for 30 seconds |
| Login success | Existing user, mock OTP | Home screen |
| Register success | New user flow, complete form | Redirect to login |

## Common Issues

**OTP input length mismatch**

Align pinput length in OtpPinInput with backend and AppConstants.otpLength.

**Terms checkbox blocks submit**

User must check terms before Send OTP is enabled.

**Registration dropdowns empty**

Master data fetch failed. Check MasterApiRepository and network flavor. Taluka must load before village.

**Navigate to OTP without arguments**

OtpProvider expects OtpArguments. Always pass mobile and verification type from login provider.

## Notes for Future Developers

- To enable OTP resend: uncomment resend logic in OtpProvider and OTPHttpApiRepository, wire to POST /Auth/ResendOTP.
- Registration always sends isAdmin: 0. Role-based access is not built yet. See role-based-access.md.
- Token storage after login is handled in OtpProvider via AuthService. See session-storage.md.
