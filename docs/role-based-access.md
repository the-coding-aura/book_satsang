# Role-Based Access

## Purpose

This document records the status of role-based UI rules in the application and outlines how to implement them when backend support is ready.

Training deliverable: role-based UI with admin and core role checks. At handover this is not implemented.

## Current State

No conditional UI based on user role, admin flag, or permission level exists in the app.

Evidence:

- RegisterMemberRequestModel always sends isAdmin: 0
- No role field read from profile or login response for UI decisions
- Drawer menu is identical for all logged-in users
- Home tabs are identical for all users
- Core Team page role labels are static display text, not user permissions

Designation dropdown on profile and registration is member designation (job title in the organization), not application role.

## What Was Planned in Training

Typical rules discussed during training:

| Role | Expected behavior |
|------|-------------------|
| Standard member | Full read access, limited admin actions hidden |
| Core team | Access to additional drawer or tab items |
| Admin | Member management, content moderation, or config screens |

Exact rules depend on backend contract which was not finalized at handover.

## Suggested Implementation Approach

### Step 1: Define role model

1. Confirm API fields on login or profile response (for example isAdmin, roleId, roleName)
2. Add role fields to AuthData or a separate UserSession model
3. Persist role in secure storage alongside token if needed after login

### Step 2: Expose role to UI

1. Add getter on AuthService or a SessionService
2. Or store role in a UserProvider registered at home route level
3. Extension method context.userRole for widgets

### Step 3: Apply UI rules

Examples:

- Hide Members tab admin actions unless role is admin
- Show extra drawer item for core team only
- Disable edit on certain profile fields for non-admin

Use conditional widgets:

```
if (context.watch<UserProvider>().isAdmin)
  AdminOnlyWidget()
```

Or filter drawer ListTile list from a config list with requiredRole field.

### Step 4: Backend enforcement

UI hiding is not security. API must reject unauthorized actions. Client role checks are for UX only.

## Tests and Checks (When Implemented)

| Check | Expected |
|-------|----------|
| Login as standard member | Admin menus hidden |
| Login as admin | Admin menus visible |
| Login as core role | Core-specific items visible |
| API call without permission | Error message from server |

Until implemented, all checks are N/A.

## Common Issues (Anticipated)

**Role stale after profile update**

Refetch profile or refresh role on home init.

**Role only on profile not login**

Store role at first profile fetch if not in login response.

**Hardcoded isAdmin: 0 on register**

New users always non-admin until backend assigns role.

## Notes for Future Developers

- Coordinate with backend team on role enum values before building UI branches.
- Document role matrix in this file once rules are confirmed.
- Core Team static page content is unrelated to user role permissions. Do not confuse the two.

See authentication.md for registration payload and profile-module.md for profile data fields available from API.
