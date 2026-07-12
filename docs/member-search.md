# Member Search

## Purpose

This document covers member search functionality: the planned Members tab screen and the search behavior already present in master data dropdowns.

Training deliverable: search ready. At handover, the dedicated Members screen is not built yet.

## Current State

### Members tab (not implemented)

File: lib/modules/home/screens/member_screen.dart

Shows placeholder text "Members" only.

There is no:

- Member list API in ApiPath
- Search input on the Members tab
- Navigation to member detail

This was a training milestone target but remains for the next developer.

### Search in dropdowns (implemented)

Search works today in registration and profile forms for geographic master data.

Package: dropdown_search

Used in:

- lib/modules/registeration/widgets/taluka_drop_widget.dart
- lib/modules/registeration/widgets/village_drop_widget.dart
- lib/modules/home/widgets/taluka_drop_widget.dart
- lib/modules/home/widgets/village_drop_widget.dart

Flow:

1. User types in dropdown search box
2. Provider calls fetchTalukaList(searchText) or fetchVillageList(searchText, talukaId)
3. GET master data endpoints return filtered results
4. User selects an item

Taluka search: /MasterData/GetTalukaMasterData with search parameter.

Village search: /MasterData/GetVillageMasterData with search text and taluka id.

## Planned Members Search Screen

When implementing the Members tab, suggested approach based on existing patterns:

1. Add member list and search API paths to ApiPath
2. Create MemberListRequestModel and MemberListResponseModel
3. Add methods to HomeApiRepository or a new MemberApiRepository
4. Create MemberScreenProvider with:
   - TextEditingController for search input
   - Debounced search call (optional, not used elsewhere yet)
   - ApiResponse list state
5. Replace MemberScreen placeholder with:
   - Search TextField
   - ListView of results
   - Empty and error states
6. Register repository in locator.dart if new

## Step-by-Step: Test Existing Dropdown Search

1. Run MOCK or DEV flavor
2. Navigate to registration or profile tab
3. Open taluka dropdown
4. Type partial name in search field
5. Confirm list filters
6. Select taluka, open village dropdown, repeat

## Tests and Checks

| Check | Status at handover |
|-------|-------------------|
| Members tab shows list | Not implemented |
| Members tab search | Not implemented |
| Taluka dropdown search | Works |
| Village dropdown search | Works after taluka selected |

## Common Issues

**Village search returns empty**

Taluka must be selected first. Village API requires talukaId.

**Dropdown does not filter on MOCK**

Check RegisterMockApiRepository or MasterMockApiRepository mock data includes searchable names.

**Keyboard covers dropdown**

dropdown_search handles overlay internally. Test on small screen emulator.

## Notes for Future Developers

- Reuse ApiResponse and AppFlushbar patterns from SatsangScreenProvider for member list loading and errors.
- Consider pagination if member count is large. Satsang list already uses pageNumber and pageSize as a reference.
- Member search UI may need role-based filtering later. See role-based-access.md.

See home-module.md for tab structure and network-layer.md for adding new API endpoints.
