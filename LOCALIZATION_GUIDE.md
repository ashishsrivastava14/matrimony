# Localization Guide - AP Matrimony

This app supports multiple languages: **English**, **Hindi (हिंदी)**, **Tamil (தமிழ்)**, and **Telugu (తెలుగు)**.

## How to Use Translations in Your Screens

### 1. Import the localization package

```dart
import '../l10n/app_localizations.dart';
```

### 2. Get the localization instance in your build method

```dart
@override
Widget build(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  
  return Scaffold(
    appBar: AppBar(
      title: Text(l10n.myProfile), // Uses translated text
    ),
    // ... rest of your widget
  );
}
```

### 3. Use translations for any text

```dart
Text(l10n.home)           // Home
Text(l10n.matches)        // Matches
Text(l10n.profile)        // Profile
Text(l10n.notifications)  // Notifications
Text(l10n.settings)       // Settings
```

## Available Translation Keys

### Common Actions
- `save`, `cancel`, `edit`, `delete`, `confirm`
- `yes`, `no`, `ok`, `submit`, `next`, `back`, `skip`, `done`, `close`
- `send`, `accept`, `reject`, `apply`, `filter`, `sort`, `clear`
- `viewAll`, `viewDetails`, `login`, `logout`, `register`

### Navigation
- `home`, `search`, `matches`, `chat`, `chats`, `profile`
- `notifications`, `settings`, `dashboard`

### User Profile
- `myProfile`, `editProfile`, `viewProfile`, `createProfile`
- `name`, `email`, `mobile`, `phoneNumber`, `age`, `height`, `weight`
- `religion`, `caste`, `education`, `occupation`, `income`
- `location`, `city`, `state`, `country`, `dateOfBirth`
- `maritalStatus`, `motherTongue`, `aboutMe`
- `partnerPreferences`, `familyDetails`, `horoscope`, `photos`

### Interests & Matching
- `sendInterest`, `interestSent`, `interestReceived`, `interestAccepted`
- `myInterests`, `myMatches`, `matchPercentage`
- `shortlist`, `shortlisted`, `removeShortlist`

### Subscription
- `subscription`, `subscriptions`, `mySubscription`
- `subscribeTo`, `premium`, `upgradeNow`
- `unlockContact`, `contactDetails`, `unlocked`

### Status
- `verified`, `notVerified`, `active`, `inactive`
- `online`, `offline`, `lastSeen`, `typing`
- `pending`, `approved`, `rejected`

### Admin & Management
- `userManagement`, `mediatorManagement`, `subscriptionManagement`
- `profileApprovals`, `bannerManagement`, `cmsManagement`
- `commissionSettings`, `horoscopeSettings`, `walletManagement`
- `notificationBroadcast`, `payPerProfile`

### Financial
- `wallet`, `balance`, `commission`, `commissionHistory`
- `earning`, `earnings`, `withdraw`, `deposit`
- `transaction`, `transactions`, `revenue`

### Messages
- `noMessages`, `noNotifications`, `noMatches`, `noResults`
- `loading`, `error`, `success`, `warning`, `info`

## Adding New Translations

When you need to add new translatable text:

### 1. Add to English file (`lib/l10n/app_en.arb`)

```json
{
  "myNewKey": "My New Text",
  "@myNewKey": {
    "description": "Description of what this text is for"
  }
}
```

### 2. Add to Hindi file (`lib/l10n/app_hi.arb`)

```json
{
  "myNewKey": "मेरा नया पाठ"
}
```

### 3. Add to Tamil file (`lib/l10n/app_ta.arb`)

```json
{
  "myNewKey": "எனது புதிய உரை"
}
```

### 4. Add to Telugu file (`lib/l10n/app_te.arb`)

```json
{
  "myNewKey": "నా కొత్త టెక్స్ట్"
}
```

### 5. Rebuild the app

```bash
flutter clean
flutter pub get
flutter build web --debug  # or run the app
```

The localization files will be automatically generated in `lib/l10n/`.

## Using Placeholders

For dynamic text with variables:

### 1. In ARB files:

```json
{
  "greeting": "Hello {name}!",
  "@greeting": {
    "placeholders": {
      "name": {
        "type": "String"
      }
    }
  }
}
```

### 2. In Dart code:

```dart
Text(l10n.greeting('John'))  // Output: Hello John!
```

## Changing Language at Runtime

Users can select their preferred language from the login screen. The selection is:
- Saved in SharedPreferences
- Automatically loaded on app restart
- Applied to the entire app immediately

## Examples from the App

### Login Screen
```dart
Text(l10n.welcomeBack)        // Welcome Back! 👋
Text(l10n.signInToContinue)   // Sign in to continue
TextFormField(labelText: l10n.email)
TextFormField(labelText: l10n.password)
ElevatedButton(child: Text(l10n.login))
```

### Bottom Navigation
```dart
BottomNavigationBarItem(
  label: l10n.home,
  icon: Icon(Icons.home),
)
```

### Profile Screen
```dart
AppBar(title: Text(l10n.myProfile))
Text(l10n.verified)
Text(l10n.notVerified)
```

## Best Practices

1. **Always use translations** - Never hardcode user-visible text
2. **Keep keys descriptive** - Use clear, semantic key names
3. **Add descriptions** - Use the `@key` format to document translations
4. **Test all languages** - Verify text displays correctly in all languages
5. **Consider text length** - Some languages require more space than others
6. **Use proper capitalization** - Follow language-specific capitalization rules

## File Locations

- Translation files: `lib/l10n/*.arb`
- Generated files: `lib/l10n/*.dart` (auto-generated, don't edit)
- Language provider: `lib/providers/language_provider.dart`
- Language preferences: `lib/services/language_preferences.dart`
- Configuration: `l10n.yaml`
