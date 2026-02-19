# Quick Reference: Updating Screens for Localization

## Quick Start Pattern

For ANY Dart file with hardcoded UI text, follow these 3 steps:

### Step 1: Add Import
```dart
import '../l10n/app_localizations.dart';  // Adjust path as needed
```

### Step 2: Add l10n Instance
In the `build()` method, add this as the FIRST line:
```dart
@override
Widget build(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  // ... rest of code
}
```

### Step 3: Replace Hardcoded Strings
Search for all `Text('...')` and replace with `Text(l10n.key)`

## Common Replacements Reference

| Hardcoded Text | Localization Key | Usage |
|----------------|------------------|-------|
| `'Search'` | `l10n.search` | AppBar, buttons |
| `'Notifications'` | `l10n.notifications` | AppBar, nav |
| `'Get Started'` | `l10n.getStarted` | Buttons |
| `'Browse as Guest'` | `l10n.browseAsGuest` | Buttons |
| `'Send Interest'` | `l10n.sendInterest` | Buttons |
| `'Verified'` | `l10n.verified` | Badges |
| `'Premium Member'` | `l10n.premiumMember` | Badges |
| `'Photo Verified'` | `l10n.photoVerified` | Badges |
| `'ID verified'` | `l10n.idVerified` | Badges |
| `'Paid Member'` | `l10n.paidMember` | Badges |
| `'Recently Joined'` | `l10n.recentlyJoined` | Section titles |
| `'View All'` | `l10n.viewAll` | Buttons |
| `'Complete'` | `l10n.completeButton` | Buttons |
| `'Cancel'` | `l10n.cancel` | Dialogs |
| `'Save'` | `l10n.save` | Buttons |
| `'Next'` | `l10n.next` | Navigation |
| `'Previous'` | `l10n.previous` | Navigation |
| `'Subscribe'` | `l10n.subscribePlan` | Buttons |
| `'Active'` | `l10n.active` | Status |
| `'Pending'` | `l10n.pending` | Status |
| `'Submit'` | `l10n.submit` | Forms |
| `'Logout'` | `l10n.logout` | Menu |

## Dynamic Text with Parameters

| Pattern | Localization | Example |
|---------|--------------|---------|
| `'Interest sent to ${name}'` | `l10n.interestSentTo(name)` | `Text(l10n.interestSentTo(profile.name))` |
| `'Login as ${role}'` | `l10n.loginAs(role)` | `Text(l10n.loginAs(userRole))` |
| `'${count} users found'` | `l10n.usersFound(count)` | `Text(l10n.usersFound('25'))` |
| `'Subscribe to ${plan}'` | `l10n.subscribeTo(plan)` | Already in ARB |
| `'Subscribed to ${plan} successfully!'` | `l10n.subscribedSuccess(plan)` | `Text(l10n.subscribedSuccess(planName))` |

## File-by-File Checklist

### Auth Screens (`lib/auth/`)
- [ ] `login_screen.dart` - Login form, validation messages, demo credentials
- [ ] `register_screen.dart` - Registration form, gender options, submit messages
- [ ] `otp_screen.dart` - OTP instructions, verification messages
- [ ] `forgot_password_screen.dart` - Reset instructions, confirmations
- [x] `role_selection_screen.dart` - ✅ DONE
- [ ] `splash_screen.dart` - App branding text, stats

### User Screens (`lib/user/`)
- [x] `home_screen.dart` - ✅ PARTIALLY DONE (needs completion message)
- [x] `profile_screen.dart` - ✅ DONE
- [ ] `subscription_screen.dart` - Plans, payment dialogs
- [ ] `search_screen.dart` - Search UI, filters, empty states
- [ ] `matches_screen.dart` - Match labels, sort options
- [ ] `match_detail_screen.dart` - Profile details, action buttons
- [ ] `interest_management_screen.dart` - Tabs, action buttons
- [ ] `chat_screen.dart` - Message UI, timestamps
- [ ] `chat_list_screen.dart` - Empty states
- [ ] `horoscope_screen.dart` - Horoscope labels, compatibility
- [ ] `notifications_screen.dart` - Notifications UI
- [ ] `profile_creation_screen.dart` - Form steps, labels

### Admin Screens (`lib/admin/`)
- [ ] `admin_dashboard.dart` - Dashboard widgets
- [ ] `user_management_screen.dart` - User list, actions
- [ ] `mediator_management_screen.dart` - Mediator actions
- [ ] `subscription_management_screen.dart` - Plan management
- [ ] `profile_approvals_screen.dart` - Approval actions
- [ ] `banner_management_screen.dart` - Banner CRUD
- [ ] `cms_screen.dart` - CMS operations
- [ ] `commission_settings_screen.dart` - Settings UI
- [ ] `horoscope_settings_screen.dart` - Settings UI
- [ ] `wallet_management_screen.dart` - Wallet operations
- [ ] `notification_broadcast_screen.dart` - Broadcast UI
- [ ] `pay_per_profile_screen.dart` - Bundle management
- [ ] `reports_screen.dart` - Reports UI

### Mediator Screens (`lib/mediator/`)
- [ ] `mediator_dashboard.dart` - Dashboard widgets
- [ ] `create_profile_screen.dart` - Profile creation forms
- [ ] `wallet_screen.dart` - Wallet UI
- [ ] `commission_history_screen.dart` - History list

### Widgets (`lib/widgets/`)
- [ ] `profile_card.dart` - Card labels, buttons
- [ ] `premium_banner.dart` - Banner text
- [ ] `plan_card.dart` - Plan details
- [ ] `verified_badge.dart` - Badge text
- [ ] `filter_bottom_sheet.dart` - Filter labels

## Example: Complete Screen Update

Before (`search_screen.dart`):
```dart
class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Column(
        children: [
          TextButton(child: const Text('Advanced Filters'), onPressed: () {}),
          const Text('No profiles found matching your filters'),
        ],
      ),
    );
  }
}
```

After:
```dart
import '../l10n/app_localizations.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.search),
      ),
      body: Column(
        children: [
          TextButton(child: Text(l10n.advancedFilters), onPressed: () {}),
          Text(l10n.noProfilesFoundFilters),
        ],
      ),
    );
  }
}
```

## Finding Hardcoded Text

Use your IDE's search to find all hardcoded strings in a file:
1. Open file in VS Code
2. Press Ctrl+F (Cmd+F on Mac)
3. Search for: `Text\('`
4. Replace each occurrence with the appropriate l10n key

## Verification

After updating a file:
1. Save the file
2. Check for compile errors
3. Run the app and navigate to that screen
4. Switch language and verify all text changes
5. Test with different data (names, counts, etc.)

## Pro Tips

1. **Don't remove `const`**: If the Text widget was const before, you can't make it const with l10n (dynamic)
   ```dart
   const Text('Search')  →  Text(l10n.search)  // Remove const
   ```

2. **Nested builders**: For nested widgets, you might need to pass `l10n` down or get it again
   ```dart
   ListView.builder(
     itemBuilder: (context, index) {
       final l10n = AppLocalizations.of(context)!;  // Get again in builder
       return Text(l10n.someKey);
     },
   )
   ```

3. **Static widgets**: For widgets defined as static or const outside build method, refactor to be non-static or pass l10n values

4. **Form hints**: Replace all hint text
   ```dart
   hintText: 'Enter email'  →  hintText: l10n.enterEmail
   ```

5. **Validation messages**: Replace all validators
   ```dart
   'Required'  →  l10n.required
   'Invalid email'  →  l10n.invalidEmail
   ```

## Need a New Translation?

If you need a key that doesn't exist:

1. Add to `lib/l10n/app_en.arb`:
   ```json
   "myNewKey": "My New Text"
   ```

2. Add to `lib/l10n/app_hi.arb`:
   ```json
   "myNewKey": "मेरा नया पाठ"
   ```

3. Run regeneration:
   ```bash
   flutter gen-l10n
   ```

4. Use it:
   ```dart
   Text(l10n.myNewKey)
   ```

---

**Start with the easiest files first to build confidence, then tackle the complex ones!**
