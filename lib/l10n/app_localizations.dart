import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('ta'),
    Locale('te'),
  ];

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'AP Matrimony'**
  String get appTitle;

  /// App name
  ///
  /// In en, this message translates to:
  /// **'AP Matrimony'**
  String get appName;

  /// App tagline
  ///
  /// In en, this message translates to:
  /// **'Biggest Matrimony Service for AP'**
  String get tagline;

  /// Years of service text
  ///
  /// In en, this message translates to:
  /// **'10 Years of Successful Matchmaking'**
  String get yearsOfService;

  /// Customers count text
  ///
  /// In en, this message translates to:
  /// **'1 Crore+ Customers Served'**
  String get customersServed;

  /// Powered by text
  ///
  /// In en, this message translates to:
  /// **'Powered by QuickPrepAI'**
  String get poweredBy;

  /// Welcome message on login screen
  ///
  /// In en, this message translates to:
  /// **'Welcome Back! 👋'**
  String get welcomeBack;

  /// Login as specific role
  ///
  /// In en, this message translates to:
  /// **'Login as {role}'**
  String loginAs(String role);

  /// Sign in subtitle
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get signInToContinue;

  /// Language selection label
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// Language label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Email label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Mobile label
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get mobile;

  /// Email address label
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// Mobile number label
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumber;

  /// Email hint text
  ///
  /// In en, this message translates to:
  /// **'Enter email'**
  String get enterEmail;

  /// Mobile hint text
  ///
  /// In en, this message translates to:
  /// **'Enter mobile'**
  String get enterMobile;

  /// Password label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Password hint text
  ///
  /// In en, this message translates to:
  /// **'Enter password'**
  String get enterPassword;

  /// Forgot password text
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// Login button text
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// OR divider text
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// Don't have account text
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// Register button text
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// Required field validation
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// User role
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// Mediator role
  ///
  /// In en, this message translates to:
  /// **'Mediator'**
  String get mediator;

  /// Admin role
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// Home navigation
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Matches navigation
  ///
  /// In en, this message translates to:
  /// **'Matches'**
  String get matches;

  /// Shortlisted navigation
  ///
  /// In en, this message translates to:
  /// **'Shortlisted'**
  String get shortlisted;

  /// Interests navigation
  ///
  /// In en, this message translates to:
  /// **'Interests'**
  String get interests;

  /// Profile navigation
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @sort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sort;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @approved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approved;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @religion.
  ///
  /// In en, this message translates to:
  /// **'Religion'**
  String get religion;

  /// No description provided for @caste.
  ///
  /// In en, this message translates to:
  /// **'Caste'**
  String get caste;

  /// No description provided for @education.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get education;

  /// No description provided for @occupation.
  ///
  /// In en, this message translates to:
  /// **'Occupation'**
  String get occupation;

  /// No description provided for @income.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get income;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @state.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get state;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @maritalStatus.
  ///
  /// In en, this message translates to:
  /// **'Marital Status'**
  String get maritalStatus;

  /// No description provided for @motherTongue.
  ///
  /// In en, this message translates to:
  /// **'Mother Tongue'**
  String get motherTongue;

  /// No description provided for @aboutMe.
  ///
  /// In en, this message translates to:
  /// **'About Me'**
  String get aboutMe;

  /// No description provided for @partnerPreferences.
  ///
  /// In en, this message translates to:
  /// **'Partner Preferences'**
  String get partnerPreferences;

  /// No description provided for @familyDetails.
  ///
  /// In en, this message translates to:
  /// **'Family Details'**
  String get familyDetails;

  /// No description provided for @horoscope.
  ///
  /// In en, this message translates to:
  /// **'Horoscope'**
  String get horoscope;

  /// No description provided for @photos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get photos;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @chats.
  ///
  /// In en, this message translates to:
  /// **'Chats'**
  String get chats;

  /// No description provided for @sendInterest.
  ///
  /// In en, this message translates to:
  /// **'Send Interest'**
  String get sendInterest;

  /// No description provided for @interestSent.
  ///
  /// In en, this message translates to:
  /// **'Interest Sent'**
  String get interestSent;

  /// No description provided for @interestReceived.
  ///
  /// In en, this message translates to:
  /// **'Interest Received'**
  String get interestReceived;

  /// No description provided for @interestAccepted.
  ///
  /// In en, this message translates to:
  /// **'Interest Accepted'**
  String get interestAccepted;

  /// No description provided for @shortlist.
  ///
  /// In en, this message translates to:
  /// **'Shortlist'**
  String get shortlist;

  /// No description provided for @removeShortlist.
  ///
  /// In en, this message translates to:
  /// **'Remove from Shortlist'**
  String get removeShortlist;

  /// No description provided for @blockUser.
  ///
  /// In en, this message translates to:
  /// **'Block User'**
  String get blockUser;

  /// No description provided for @reportUser.
  ///
  /// In en, this message translates to:
  /// **'Report User'**
  String get reportUser;

  /// No description provided for @matchPercentage.
  ///
  /// In en, this message translates to:
  /// **'Match Percentage'**
  String get matchPercentage;

  /// No description provided for @premium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premium;

  /// No description provided for @subscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get subscription;

  /// No description provided for @subscriptions.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions'**
  String get subscriptions;

  /// No description provided for @subscribeTo.
  ///
  /// In en, this message translates to:
  /// **'Subscribe to {plan}'**
  String subscribeTo(String plan);

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @users.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get users;

  /// No description provided for @mediators.
  ///
  /// In en, this message translates to:
  /// **'Mediators'**
  String get mediators;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @revenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get revenue;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @management.
  ///
  /// In en, this message translates to:
  /// **'Management'**
  String get management;

  /// No description provided for @userManagement.
  ///
  /// In en, this message translates to:
  /// **'User Management'**
  String get userManagement;

  /// No description provided for @mediatorManagement.
  ///
  /// In en, this message translates to:
  /// **'Mediator Management'**
  String get mediatorManagement;

  /// No description provided for @subscriptionManagement.
  ///
  /// In en, this message translates to:
  /// **'Subscription Management'**
  String get subscriptionManagement;

  /// No description provided for @profileApprovals.
  ///
  /// In en, this message translates to:
  /// **'Profile Approvals'**
  String get profileApprovals;

  /// No description provided for @bannerManagement.
  ///
  /// In en, this message translates to:
  /// **'Banner Management'**
  String get bannerManagement;

  /// No description provided for @cmsManagement.
  ///
  /// In en, this message translates to:
  /// **'CMS Management'**
  String get cmsManagement;

  /// No description provided for @commissionSettings.
  ///
  /// In en, this message translates to:
  /// **'Commission Settings'**
  String get commissionSettings;

  /// No description provided for @horoscopeSettings.
  ///
  /// In en, this message translates to:
  /// **'Horoscope Settings'**
  String get horoscopeSettings;

  /// No description provided for @walletManagement.
  ///
  /// In en, this message translates to:
  /// **'Wallet Management'**
  String get walletManagement;

  /// No description provided for @notificationBroadcast.
  ///
  /// In en, this message translates to:
  /// **'Notification Broadcast'**
  String get notificationBroadcast;

  /// No description provided for @payPerProfile.
  ///
  /// In en, this message translates to:
  /// **'Pay Per Profile'**
  String get payPerProfile;

  /// No description provided for @wallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get wallet;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @commission.
  ///
  /// In en, this message translates to:
  /// **'Commission'**
  String get commission;

  /// No description provided for @commissionHistory.
  ///
  /// In en, this message translates to:
  /// **'Commission History'**
  String get commissionHistory;

  /// No description provided for @earning.
  ///
  /// In en, this message translates to:
  /// **'Earning'**
  String get earning;

  /// No description provided for @earnings.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get earnings;

  /// No description provided for @withdraw.
  ///
  /// In en, this message translates to:
  /// **'Withdraw'**
  String get withdraw;

  /// No description provided for @deposit.
  ///
  /// In en, this message translates to:
  /// **'Deposit'**
  String get deposit;

  /// No description provided for @transaction.
  ///
  /// In en, this message translates to:
  /// **'Transaction'**
  String get transaction;

  /// No description provided for @transactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// No description provided for @createProfile.
  ///
  /// In en, this message translates to:
  /// **'Create Profile'**
  String get createProfile;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @viewProfile.
  ///
  /// In en, this message translates to:
  /// **'View Profile'**
  String get viewProfile;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @myMatches.
  ///
  /// In en, this message translates to:
  /// **'My Matches'**
  String get myMatches;

  /// No description provided for @myInterests.
  ///
  /// In en, this message translates to:
  /// **'My Interests'**
  String get myInterests;

  /// No description provided for @mySubscription.
  ///
  /// In en, this message translates to:
  /// **'My Subscription'**
  String get mySubscription;

  /// No description provided for @upgradeNow.
  ///
  /// In en, this message translates to:
  /// **'Upgrade Now'**
  String get upgradeNow;

  /// No description provided for @contactDetails.
  ///
  /// In en, this message translates to:
  /// **'Contact Details'**
  String get contactDetails;

  /// No description provided for @unlockContact.
  ///
  /// In en, this message translates to:
  /// **'Unlock Contact'**
  String get unlockContact;

  /// No description provided for @unlocked.
  ///
  /// In en, this message translates to:
  /// **'Unlocked'**
  String get unlocked;

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// No description provided for @notVerified.
  ///
  /// In en, this message translates to:
  /// **'Not Verified'**
  String get notVerified;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @lastSeen.
  ///
  /// In en, this message translates to:
  /// **'Last seen'**
  String get lastSeen;

  /// No description provided for @typing.
  ///
  /// In en, this message translates to:
  /// **'Typing...'**
  String get typing;

  /// No description provided for @noMessages.
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get noMessages;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get noNotifications;

  /// No description provided for @noMatches.
  ///
  /// In en, this message translates to:
  /// **'No matches found'**
  String get noMatches;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResults;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @selectRole.
  ///
  /// In en, this message translates to:
  /// **'Select Your Role'**
  String get selectRole;

  /// No description provided for @continueAs.
  ///
  /// In en, this message translates to:
  /// **'Continue as {role}'**
  String continueAs(String role);

  /// No description provided for @enterOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP'**
  String get enterOtp;

  /// No description provided for @otpSentTo.
  ///
  /// In en, this message translates to:
  /// **'OTP sent to {contact}'**
  String otpSentTo(String contact);

  /// No description provided for @resendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resendOtp;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @passwordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordMismatch;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get invalidEmail;

  /// No description provided for @invalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number'**
  String get invalidPhone;

  /// No description provided for @guest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guest;

  /// No description provided for @registeredUser.
  ///
  /// In en, this message translates to:
  /// **'Registered User'**
  String get registeredUser;

  /// No description provided for @paidMember.
  ///
  /// In en, this message translates to:
  /// **'Paid Member'**
  String get paidMember;

  /// No description provided for @mediatorBroker.
  ///
  /// In en, this message translates to:
  /// **'Mediator / Broker'**
  String get mediatorBroker;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @browseAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Browse as Guest'**
  String get browseAsGuest;

  /// No description provided for @otherRoles.
  ///
  /// In en, this message translates to:
  /// **'Other roles'**
  String get otherRoles;

  /// No description provided for @manageAndEarn.
  ///
  /// In en, this message translates to:
  /// **'Manage & earn'**
  String get manageAndEarn;

  /// No description provided for @platformAccess.
  ///
  /// In en, this message translates to:
  /// **'Platform access'**
  String get platformAccess;

  /// No description provided for @tenYears.
  ///
  /// In en, this message translates to:
  /// **'10 Years'**
  String get tenYears;

  /// No description provided for @successfulMatchmaking.
  ///
  /// In en, this message translates to:
  /// **'Successful Matchmaking'**
  String get successfulMatchmaking;

  /// No description provided for @oneCrorePlus.
  ///
  /// In en, this message translates to:
  /// **'1 Crore+'**
  String get oneCrorePlus;

  /// No description provided for @checkYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Check Your Email'**
  String get checkYourEmail;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPasswordTitle;

  /// No description provided for @passwordResetSent.
  ///
  /// In en, this message translates to:
  /// **'We have sent a password reset link to your email address.'**
  String get passwordResetSent;

  /// No description provided for @passwordResetInstructions.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we\'ll send you a link to reset your password.'**
  String get passwordResetInstructions;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get backToLogin;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @joinAppMatrimony.
  ///
  /// In en, this message translates to:
  /// **'Join AP Matrimony'**
  String get joinAppMatrimony;

  /// No description provided for @createProfileFindMatch.
  ///
  /// In en, this message translates to:
  /// **'Create your profile and find your perfect match'**
  String get createProfileFindMatch;

  /// No description provided for @lookingFor.
  ///
  /// In en, this message translates to:
  /// **'I am looking for a'**
  String get lookingFor;

  /// No description provided for @bride.
  ///
  /// In en, this message translates to:
  /// **'Bride'**
  String get bride;

  /// No description provided for @groom.
  ///
  /// In en, this message translates to:
  /// **'Groom'**
  String get groom;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @phonePlus91.
  ///
  /// In en, this message translates to:
  /// **'+91 '**
  String get phonePlus91;

  /// No description provided for @datePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'DD/MM/YYYY'**
  String get datePlaceholder;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @registrationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registration successful! Redirecting to OTP...'**
  String get registrationSuccess;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @verificationCode.
  ///
  /// In en, this message translates to:
  /// **'Verification Code'**
  String get verificationCode;

  /// No description provided for @enterOtpInstructions.
  ///
  /// In en, this message translates to:
  /// **'Enter the 4-digit code sent to your\nregistered mobile number'**
  String get enterOtpInstructions;

  /// No description provided for @useOtp.
  ///
  /// In en, this message translates to:
  /// **'Use OTP: 1234'**
  String get useOtp;

  /// No description provided for @invalidOtpMessage.
  ///
  /// In en, this message translates to:
  /// **'Invalid OTP. Use 1234'**
  String get invalidOtpMessage;

  /// No description provided for @verifyOtp.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verifyOtp;

  /// No description provided for @didntReceiveCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive code? '**
  String get didntReceiveCode;

  /// No description provided for @otpResent.
  ///
  /// In en, this message translates to:
  /// **'OTP Resent: 1234'**
  String get otpResent;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// No description provided for @demoCredentials.
  ///
  /// In en, this message translates to:
  /// **'Demo credentials'**
  String get demoCredentials;

  /// No description provided for @userPaidMember.
  ///
  /// In en, this message translates to:
  /// **'User / Paid Member'**
  String get userPaidMember;

  /// No description provided for @closeDemoCredentials.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeDemoCredentials;

  /// No description provided for @viewDemoCredentials.
  ///
  /// In en, this message translates to:
  /// **'View Demo Credentials'**
  String get viewDemoCredentials;

  /// No description provided for @yourProfileIs.
  ///
  /// In en, this message translates to:
  /// **'Your profile is'**
  String get yourProfileIs;

  /// No description provided for @complete.
  ///
  /// In en, this message translates to:
  /// **'complete'**
  String get complete;

  /// No description provided for @completeButton.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get completeButton;

  /// No description provided for @recentlyJoined.
  ///
  /// In en, this message translates to:
  /// **'Recently Joined'**
  String get recentlyJoined;

  /// No description provided for @newProfilesOnPlatform.
  ///
  /// In en, this message translates to:
  /// **'New profiles on the platform'**
  String get newProfilesOnPlatform;

  /// No description provided for @noMatchesYet.
  ///
  /// In en, this message translates to:
  /// **'No matches yet'**
  String get noMatchesYet;

  /// No description provided for @photoVerified.
  ///
  /// In en, this message translates to:
  /// **'Photo Verified'**
  String get photoVerified;

  /// No description provided for @idVerified.
  ///
  /// In en, this message translates to:
  /// **'ID verified'**
  String get idVerified;

  /// No description provided for @typeYourMessage.
  ///
  /// In en, this message translates to:
  /// **'Type your message...'**
  String get typeYourMessage;

  /// No description provided for @you.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get you;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @nearbyProfiles.
  ///
  /// In en, this message translates to:
  /// **'Nearby Profiles'**
  String get nearbyProfiles;

  /// No description provided for @matchesNearYourLocation.
  ///
  /// In en, this message translates to:
  /// **'Matches near your location'**
  String get matchesNearYourLocation;

  /// No description provided for @advancedFilters.
  ///
  /// In en, this message translates to:
  /// **'Advanced Filters'**
  String get advancedFilters;

  /// No description provided for @noProfilesFoundFilters.
  ///
  /// In en, this message translates to:
  /// **'No profiles found matching your filters'**
  String get noProfilesFoundFilters;

  /// No description provided for @viewMore.
  ///
  /// In en, this message translates to:
  /// **'View More'**
  String get viewMore;

  /// No description provided for @basicFilters.
  ///
  /// In en, this message translates to:
  /// **'Basic Filters'**
  String get basicFilters;

  /// No description provided for @ageRange.
  ///
  /// In en, this message translates to:
  /// **'Age Range'**
  String get ageRange;

  /// No description provided for @searching.
  ///
  /// In en, this message translates to:
  /// **'Searching...'**
  String get searching;

  /// No description provided for @religionCasteLocation.
  ///
  /// In en, this message translates to:
  /// **'Religion, Caste, Location, etc.'**
  String get religionCasteLocation;

  /// No description provided for @subscriptionPlans.
  ///
  /// In en, this message translates to:
  /// **'Subscription Plans'**
  String get subscriptionPlans;

  /// No description provided for @currentPlan.
  ///
  /// In en, this message translates to:
  /// **'Current Plan'**
  String get currentPlan;

  /// No description provided for @freePlanMessage.
  ///
  /// In en, this message translates to:
  /// **'You are currently on the Free plan. Upgrade to unlock premium features!'**
  String get freePlanMessage;

  /// No description provided for @availableUnlocks.
  ///
  /// In en, this message translates to:
  /// **'Available Unlocks'**
  String get availableUnlocks;

  /// No description provided for @unlockIndividualProfiles.
  ///
  /// In en, this message translates to:
  /// **'Unlock individual profiles without a subscription'**
  String get unlockIndividualProfiles;

  /// No description provided for @buy.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get buy;

  /// No description provided for @featureComparison.
  ///
  /// In en, this message translates to:
  /// **'Feature Comparison'**
  String get featureComparison;

  /// No description provided for @feature.
  ///
  /// In en, this message translates to:
  /// **'Feature'**
  String get feature;

  /// No description provided for @silver.
  ///
  /// In en, this message translates to:
  /// **'Silver'**
  String get silver;

  /// No description provided for @gold.
  ///
  /// In en, this message translates to:
  /// **'Gold'**
  String get gold;

  /// No description provided for @diamond.
  ///
  /// In en, this message translates to:
  /// **'Diamond'**
  String get diamond;

  /// No description provided for @selectPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Select Payment Method:'**
  String get selectPaymentMethod;

  /// No description provided for @payNow.
  ///
  /// In en, this message translates to:
  /// **'Pay Now'**
  String get payNow;

  /// No description provided for @subscribedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Subscribed to {plan} successfully!'**
  String subscribedSuccess(String plan);

  /// No description provided for @buyUnlocks.
  ///
  /// In en, this message translates to:
  /// **'Buy {count} Unlocks'**
  String buyUnlocks(String count);

  /// No description provided for @payForUnlocks.
  ///
  /// In en, this message translates to:
  /// **'Pay ₹{price} to get {count} profile unlocks.'**
  String payForUnlocks(String price, String count);

  /// No description provided for @unlocksPurchased.
  ///
  /// In en, this message translates to:
  /// **'{count} unlocks purchased!'**
  String unlocksPurchased(String count);

  /// No description provided for @stepIndicator.
  ///
  /// In en, this message translates to:
  /// **'Step {current}: {title}'**
  String stepIndicator(String current, String title);

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @profileSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile saved successfully!'**
  String get profileSavedSuccess;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @basicDetails.
  ///
  /// In en, this message translates to:
  /// **'Basic Details'**
  String get basicDetails;

  /// No description provided for @tellUsAboutYourself.
  ///
  /// In en, this message translates to:
  /// **'Tell us about yourself'**
  String get tellUsAboutYourself;

  /// No description provided for @photoPickerMock.
  ///
  /// In en, this message translates to:
  /// **'Photo picker (mock)'**
  String get photoPickerMock;

  /// No description provided for @addPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add Photo'**
  String get addPhoto;

  /// No description provided for @educationCareer.
  ///
  /// In en, this message translates to:
  /// **'Education & Career'**
  String get educationCareer;

  /// No description provided for @premiumMember.
  ///
  /// In en, this message translates to:
  /// **'Premium Member'**
  String get premiumMember;

  /// No description provided for @freeMember.
  ///
  /// In en, this message translates to:
  /// **'Free Member'**
  String get freeMember;

  /// No description provided for @upgradeToPremium.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium'**
  String get upgradeToPremium;

  /// No description provided for @markAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get markAllRead;

  /// No description provided for @noNotificationsYet.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get noNotificationsYet;

  /// No description provided for @yourDailyMatches.
  ///
  /// In en, this message translates to:
  /// **'Your Daily Matches'**
  String get yourDailyMatches;

  /// No description provided for @prime.
  ///
  /// In en, this message translates to:
  /// **'PRIME'**
  String get prime;

  /// No description provided for @newBadge.
  ///
  /// In en, this message translates to:
  /// **'NEW'**
  String get newBadge;

  /// No description provided for @viewAllMatches.
  ///
  /// In en, this message translates to:
  /// **'View All Matches'**
  String get viewAllMatches;

  /// No description provided for @interestSentTo.
  ///
  /// In en, this message translates to:
  /// **'Interest sent to {name}'**
  String interestSentTo(String name);

  /// No description provided for @noMatchesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No matches available at the moment'**
  String get noMatchesAvailable;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get sortBy;

  /// No description provided for @viewHoroscope.
  ///
  /// In en, this message translates to:
  /// **'View Horoscope'**
  String get viewHoroscope;

  /// No description provided for @dontShow.
  ///
  /// In en, this message translates to:
  /// **'Don\'t Show'**
  String get dontShow;

  /// No description provided for @interestSentSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Interest sent successfully!'**
  String get interestSentSuccessfully;

  /// No description provided for @contactUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Contact unlocked!'**
  String get contactUnlocked;

  /// No description provided for @checkHoroscopeCompatibility.
  ///
  /// In en, this message translates to:
  /// **'Check Horoscope Compatibility'**
  String get checkHoroscopeCompatibility;

  /// No description provided for @profileReported.
  ///
  /// In en, this message translates to:
  /// **'Profile reported.'**
  String get profileReported;

  /// No description provided for @reportThisProfile.
  ///
  /// In en, this message translates to:
  /// **'Report this Profile'**
  String get reportThisProfile;

  /// No description provided for @upgradeToView.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to View'**
  String get upgradeToView;

  /// No description provided for @unlockOne.
  ///
  /// In en, this message translates to:
  /// **'Unlock (1)'**
  String get unlockOne;

  /// No description provided for @interestManagement.
  ///
  /// In en, this message translates to:
  /// **'Interest Management'**
  String get interestManagement;

  /// No description provided for @noInterestsFound.
  ///
  /// In en, this message translates to:
  /// **'No interests found'**
  String get noInterestsFound;

  /// No description provided for @acceptInterest.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get acceptInterest;

  /// No description provided for @declineInterest.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get declineInterest;

  /// No description provided for @noConversationsYet.
  ///
  /// In en, this message translates to:
  /// **'No Conversations Yet'**
  String get noConversationsYet;

  /// No description provided for @startChattingMatches.
  ///
  /// In en, this message translates to:
  /// **'Start chatting with your matches'**
  String get startChattingMatches;

  /// No description provided for @horoscopeMatching.
  ///
  /// In en, this message translates to:
  /// **'Horoscope Matching'**
  String get horoscopeMatching;

  /// No description provided for @checkCompatibility.
  ///
  /// In en, this message translates to:
  /// **'Check Compatibility'**
  String get checkCompatibility;

  /// No description provided for @compatibilityScore.
  ///
  /// In en, this message translates to:
  /// **'Compatibility Score'**
  String get compatibilityScore;

  /// No description provided for @excellentMatch.
  ///
  /// In en, this message translates to:
  /// **'Excellent Match!'**
  String get excellentMatch;

  /// No description provided for @tenPoruthamDetails.
  ///
  /// In en, this message translates to:
  /// **'10 Porutham Details'**
  String get tenPoruthamDetails;

  /// No description provided for @summary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summary;

  /// No description provided for @checkAnother.
  ///
  /// In en, this message translates to:
  /// **'Check Another'**
  String get checkAnother;

  /// No description provided for @reportDownloaded.
  ///
  /// In en, this message translates to:
  /// **'Report downloaded (mock)'**
  String get reportDownloaded;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @logoutMenuItem.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutMenuItem;

  /// No description provided for @matrimonyAdmin.
  ///
  /// In en, this message translates to:
  /// **'Matrimony Admin'**
  String get matrimonyAdmin;

  /// No description provided for @pendingWithdrawalRequests.
  ///
  /// In en, this message translates to:
  /// **'Pending Withdrawal Requests'**
  String get pendingWithdrawalRequests;

  /// No description provided for @requestApproved.
  ///
  /// In en, this message translates to:
  /// **'Request approved for {name}'**
  String requestApproved(String name);

  /// No description provided for @requestRejected.
  ///
  /// In en, this message translates to:
  /// **'Request rejected'**
  String get requestRejected;

  /// No description provided for @recentPayouts.
  ///
  /// In en, this message translates to:
  /// **'Recent Payouts'**
  String get recentPayouts;

  /// No description provided for @usersFound.
  ///
  /// In en, this message translates to:
  /// **'{count} users found'**
  String usersFound(String count);

  /// No description provided for @activePlans.
  ///
  /// In en, this message translates to:
  /// **'Active Plans'**
  String get activePlans;

  /// No description provided for @popular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get popular;

  /// No description provided for @usersCount.
  ///
  /// In en, this message translates to:
  /// **'{count} users'**
  String usersCount(String count);

  /// No description provided for @recentSubscriptions.
  ///
  /// In en, this message translates to:
  /// **'Recent Subscriptions'**
  String get recentSubscriptions;

  /// No description provided for @editPlan.
  ///
  /// In en, this message translates to:
  /// **'Edit {plan} Plan'**
  String editPlan(String plan);

  /// No description provided for @planUpdated.
  ///
  /// In en, this message translates to:
  /// **'{plan} plan updated!'**
  String planUpdated(String plan);

  /// No description provided for @reportsAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Reports & Analytics'**
  String get reportsAnalytics;

  /// No description provided for @userRegistrations.
  ///
  /// In en, this message translates to:
  /// **'User Registrations'**
  String get userRegistrations;

  /// No description provided for @topLocations.
  ///
  /// In en, this message translates to:
  /// **'Top Locations'**
  String get topLocations;

  /// No description provided for @downloadReports.
  ///
  /// In en, this message translates to:
  /// **'Download Reports'**
  String get downloadReports;

  /// No description provided for @genderDistribution.
  ///
  /// In en, this message translates to:
  /// **'Gender Distribution'**
  String get genderDistribution;

  /// No description provided for @ageDistribution.
  ///
  /// In en, this message translates to:
  /// **'Age Distribution'**
  String get ageDistribution;

  /// No description provided for @reviewApproveProfiles.
  ///
  /// In en, this message translates to:
  /// **'Review and approve new profiles'**
  String get reviewApproveProfiles;

  /// No description provided for @noRejectedProfiles.
  ///
  /// In en, this message translates to:
  /// **'No rejected profiles'**
  String get noRejectedProfiles;

  /// No description provided for @profileRejected.
  ///
  /// In en, this message translates to:
  /// **'{name} rejected'**
  String profileRejected(String name);

  /// No description provided for @rejectButton.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get rejectButton;

  /// No description provided for @profileApproved.
  ///
  /// In en, this message translates to:
  /// **'{name} approved!'**
  String profileApproved(String name);

  /// No description provided for @approveButton.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approveButton;

  /// No description provided for @payPerProfileSettings.
  ///
  /// In en, this message translates to:
  /// **'Pay Per Profile Settings'**
  String get payPerProfileSettings;

  /// No description provided for @addBundle.
  ///
  /// In en, this message translates to:
  /// **'Add Bundle'**
  String get addBundle;

  /// No description provided for @activeBundles.
  ///
  /// In en, this message translates to:
  /// **'Active Bundles'**
  String get activeBundles;

  /// No description provided for @editMenuItem.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editMenuItem;

  /// No description provided for @deleteMenuItem.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteMenuItem;

  /// No description provided for @recentPurchases.
  ///
  /// In en, this message translates to:
  /// **'Recent Purchases'**
  String get recentPurchases;

  /// No description provided for @addNewBundle.
  ///
  /// In en, this message translates to:
  /// **'Add New Bundle'**
  String get addNewBundle;

  /// No description provided for @bundleAdded.
  ///
  /// In en, this message translates to:
  /// **'Bundle added!'**
  String get bundleAdded;

  /// No description provided for @addButton.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addButton;

  /// No description provided for @addMediator.
  ///
  /// In en, this message translates to:
  /// **'Add Mediator'**
  String get addMediator;

  /// No description provided for @toggleStatus.
  ///
  /// In en, this message translates to:
  /// **'Toggle Status'**
  String get toggleStatus;

  /// No description provided for @addNewMediator.
  ///
  /// In en, this message translates to:
  /// **'Add New Mediator'**
  String get addNewMediator;

  /// No description provided for @mediatorAdded.
  ///
  /// In en, this message translates to:
  /// **'Mediator added!'**
  String get mediatorAdded;

  /// No description provided for @composeNotification.
  ///
  /// In en, this message translates to:
  /// **'Compose Notification'**
  String get composeNotification;

  /// No description provided for @targetAudience.
  ///
  /// In en, this message translates to:
  /// **'Target Audience'**
  String get targetAudience;

  /// No description provided for @allUsers.
  ///
  /// In en, this message translates to:
  /// **'All Users'**
  String get allUsers;

  /// No description provided for @premiumUsers.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premiumUsers;

  /// No description provided for @freeUsers.
  ///
  /// In en, this message translates to:
  /// **'Free Users'**
  String get freeUsers;

  /// No description provided for @mediatorsAudience.
  ///
  /// In en, this message translates to:
  /// **'Mediators'**
  String get mediatorsAudience;

  /// No description provided for @notificationType.
  ///
  /// In en, this message translates to:
  /// **'Notification Type'**
  String get notificationType;

  /// No description provided for @push.
  ///
  /// In en, this message translates to:
  /// **'Push'**
  String get push;

  /// No description provided for @inApp.
  ///
  /// In en, this message translates to:
  /// **'In-App'**
  String get inApp;

  /// No description provided for @emailType.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailType;

  /// No description provided for @sms.
  ///
  /// In en, this message translates to:
  /// **'SMS'**
  String get sms;

  /// No description provided for @scheduledForLater.
  ///
  /// In en, this message translates to:
  /// **'Scheduled for later'**
  String get scheduledForLater;

  /// No description provided for @schedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule;

  /// No description provided for @notificationSent.
  ///
  /// In en, this message translates to:
  /// **'Notification sent to all users!'**
  String get notificationSent;

  /// No description provided for @sendNow.
  ///
  /// In en, this message translates to:
  /// **'Send Now'**
  String get sendNow;

  /// No description provided for @recentBroadcasts.
  ///
  /// In en, this message translates to:
  /// **'Recent Broadcasts'**
  String get recentBroadcasts;

  /// No description provided for @sent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get sent;

  /// No description provided for @featureConfiguration.
  ///
  /// In en, this message translates to:
  /// **'Feature Configuration'**
  String get featureConfiguration;

  /// No description provided for @enableHoroscopeMatching.
  ///
  /// In en, this message translates to:
  /// **'Enable Horoscope Matching'**
  String get enableHoroscopeMatching;

  /// No description provided for @allowHoroscopeCompatibility.
  ///
  /// In en, this message translates to:
  /// **'Allow users to check horoscope compatibility'**
  String get allowHoroscopeCompatibility;

  /// No description provided for @autoHoroscopeMatching.
  ///
  /// In en, this message translates to:
  /// **'Auto Horoscope Matching'**
  String get autoHoroscopeMatching;

  /// No description provided for @autoCalculateScores.
  ///
  /// In en, this message translates to:
  /// **'Automatically calculate compatibility scores'**
  String get autoCalculateScores;

  /// No description provided for @showDosham.
  ///
  /// In en, this message translates to:
  /// **'Show Dosham Warning'**
  String get showDosham;

  /// No description provided for @displayDoshamStatus.
  ///
  /// In en, this message translates to:
  /// **'Display dosham status on profiles'**
  String get displayDoshamStatus;

  /// No description provided for @minimumPoruthamScore.
  ///
  /// In en, this message translates to:
  /// **'Minimum Porutham Score'**
  String get minimumPoruthamScore;

  /// No description provided for @minimumScoreRequired.
  ///
  /// In en, this message translates to:
  /// **'Minimum score required for good match'**
  String get minimumScoreRequired;

  /// No description provided for @compatibilityLabels.
  ///
  /// In en, this message translates to:
  /// **'Compatibility Labels'**
  String get compatibilityLabels;

  /// No description provided for @poruthamConfiguration.
  ///
  /// In en, this message translates to:
  /// **'10 Porutham Configuration'**
  String get poruthamConfiguration;

  /// No description provided for @horoscopeSettingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Horoscope settings saved!'**
  String get horoscopeSettingsSaved;

  /// No description provided for @saveSettings.
  ///
  /// In en, this message translates to:
  /// **'Save Settings'**
  String get saveSettings;

  /// No description provided for @defaultCommissionRate.
  ///
  /// In en, this message translates to:
  /// **'Default Commission Rate'**
  String get defaultCommissionRate;

  /// No description provided for @appliedToAllStandard.
  ///
  /// In en, this message translates to:
  /// **'Applied to all standard mediator accounts'**
  String get appliedToAllStandard;

  /// No description provided for @premiumMediatorRate.
  ///
  /// In en, this message translates to:
  /// **'Premium Mediator Rate'**
  String get premiumMediatorRate;

  /// No description provided for @higherRateTopPerforming.
  ///
  /// In en, this message translates to:
  /// **'Higher rate for top-performing mediators'**
  String get higherRateTopPerforming;

  /// No description provided for @minimumPayoutAmount.
  ///
  /// In en, this message translates to:
  /// **'Minimum Payout Amount'**
  String get minimumPayoutAmount;

  /// No description provided for @commissionStructure.
  ///
  /// In en, this message translates to:
  /// **'Commission Structure'**
  String get commissionStructure;

  /// No description provided for @settingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Settings saved!'**
  String get settingsSaved;

  /// No description provided for @contentManagement.
  ///
  /// In en, this message translates to:
  /// **'Content Management'**
  String get contentManagement;

  /// No description provided for @addPage.
  ///
  /// In en, this message translates to:
  /// **'Add Page'**
  String get addPage;

  /// No description provided for @addNewPage.
  ///
  /// In en, this message translates to:
  /// **'Add New Page'**
  String get addNewPage;

  /// No description provided for @pageCreated.
  ///
  /// In en, this message translates to:
  /// **'Page created!'**
  String get pageCreated;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @addBanner.
  ///
  /// In en, this message translates to:
  /// **'Add Banner'**
  String get addBanner;

  /// No description provided for @addNewBanner.
  ///
  /// In en, this message translates to:
  /// **'Add New Banner'**
  String get addNewBanner;

  /// No description provided for @uploadImage.
  ///
  /// In en, this message translates to:
  /// **'Upload Image'**
  String get uploadImage;

  /// No description provided for @bannerAdded.
  ///
  /// In en, this message translates to:
  /// **'Banner added!'**
  String get bannerAdded;

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboardTitle;

  /// No description provided for @welcomeBackAdmin.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, Admin'**
  String get welcomeBackAdmin;

  /// No description provided for @revenueOverview.
  ///
  /// In en, this message translates to:
  /// **'Revenue Overview'**
  String get revenueOverview;

  /// No description provided for @successStories.
  ///
  /// In en, this message translates to:
  /// **'Success Stories'**
  String get successStories;

  /// No description provided for @recentWeddingCelebrations.
  ///
  /// In en, this message translates to:
  /// **'Recent wedding celebrations'**
  String get recentWeddingCelebrations;

  /// No description provided for @walletTitle.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get walletTitle;

  /// No description provided for @walletBalance.
  ///
  /// In en, this message translates to:
  /// **'Wallet Balance'**
  String get walletBalance;

  /// No description provided for @availableForWithdrawal.
  ///
  /// In en, this message translates to:
  /// **'Available for withdrawal'**
  String get availableForWithdrawal;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @recentTransactions.
  ///
  /// In en, this message translates to:
  /// **'Recent Transactions'**
  String get recentTransactions;

  /// No description provided for @withdrawFunds.
  ///
  /// In en, this message translates to:
  /// **'Withdraw Funds'**
  String get withdrawFunds;

  /// No description provided for @availableBalance.
  ///
  /// In en, this message translates to:
  /// **'Available: ₹8,500'**
  String get availableBalance;

  /// No description provided for @withdrawalSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal request submitted successfully!'**
  String get withdrawalSubmitted;

  /// No description provided for @mediatorDashboard.
  ///
  /// In en, this message translates to:
  /// **'Mediator Dashboard'**
  String get mediatorDashboard;

  /// No description provided for @performanceOverview.
  ///
  /// In en, this message translates to:
  /// **'Performance Overview'**
  String get performanceOverview;

  /// No description provided for @recentProfiles.
  ///
  /// In en, this message translates to:
  /// **'Recent Profiles'**
  String get recentProfiles;

  /// No description provided for @recentSuccessfulMatches.
  ///
  /// In en, this message translates to:
  /// **'Recent Successful Matches'**
  String get recentSuccessfulMatches;

  /// No description provided for @createClientProfile.
  ///
  /// In en, this message translates to:
  /// **'Create Client Profile'**
  String get createClientProfile;

  /// No description provided for @draftSaved.
  ///
  /// In en, this message translates to:
  /// **'Draft saved'**
  String get draftSaved;

  /// No description provided for @saveDraft.
  ///
  /// In en, this message translates to:
  /// **'Save Draft'**
  String get saveDraft;

  /// No description provided for @profileSubmittedApproval.
  ///
  /// In en, this message translates to:
  /// **'Profile submitted for approval!'**
  String get profileSubmittedApproval;

  /// No description provided for @clientPhotos.
  ///
  /// In en, this message translates to:
  /// **'Client Photos'**
  String get clientPhotos;

  /// No description provided for @contactDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact Details'**
  String get contactDetailsTitle;

  /// No description provided for @noRecordsFound.
  ///
  /// In en, this message translates to:
  /// **'No records found'**
  String get noRecordsFound;

  /// No description provided for @upgradeToPremiumBanner.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium'**
  String get upgradeToPremiumBanner;

  /// No description provided for @unlimitedMessagingDescription.
  ///
  /// In en, this message translates to:
  /// **'Unlock unlimited messaging, advanced filters, and priority support'**
  String get unlimitedMessagingDescription;

  /// No description provided for @viewPlans.
  ///
  /// In en, this message translates to:
  /// **'View Plans'**
  String get viewPlans;

  /// No description provided for @mostPopular.
  ///
  /// In en, this message translates to:
  /// **'MOST POPULAR'**
  String get mostPopular;

  /// No description provided for @subscribePlan.
  ///
  /// In en, this message translates to:
  /// **'Subscribe'**
  String get subscribePlan;

  /// About this person section title
  ///
  /// In en, this message translates to:
  /// **'About {name}'**
  String aboutProfile(String name);

  /// No description provided for @noDescriptionProvided.
  ///
  /// In en, this message translates to:
  /// **'No description provided.'**
  String get noDescriptionProvided;

  /// No description provided for @educationAndCareer.
  ///
  /// In en, this message translates to:
  /// **'Education & Career'**
  String get educationAndCareer;

  /// No description provided for @familyDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Family Details'**
  String get familyDetailsTitle;

  /// No description provided for @locationTitle.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get locationTitle;

  /// No description provided for @horoscopeTitle.
  ///
  /// In en, this message translates to:
  /// **'Horoscope'**
  String get horoscopeTitle;

  /// No description provided for @partnerPreferencesTitle.
  ///
  /// In en, this message translates to:
  /// **'Partner Preferences'**
  String get partnerPreferencesTitle;

  /// No description provided for @ageYears.
  ///
  /// In en, this message translates to:
  /// **'{age} years'**
  String ageYears(String age);

  /// No description provided for @suggestedMatches.
  ///
  /// In en, this message translates to:
  /// **'Suggested Matches'**
  String get suggestedMatches;

  /// No description provided for @matchesBasedOnPreferences.
  ///
  /// In en, this message translates to:
  /// **'{count} matches based on your preferences'**
  String matchesBasedOnPreferences(String count);

  /// No description provided for @regular.
  ///
  /// In en, this message translates to:
  /// **'Regular'**
  String get regular;

  /// No description provided for @totalMatchesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Matches based on your'**
  String totalMatchesCount(String count);

  /// No description provided for @star.
  ///
  /// In en, this message translates to:
  /// **'Star'**
  String get star;

  /// No description provided for @rasi.
  ///
  /// In en, this message translates to:
  /// **'Rasi'**
  String get rasi;

  /// No description provided for @dosham.
  ///
  /// In en, this message translates to:
  /// **'Dosham'**
  String get dosham;

  /// No description provided for @familyType.
  ///
  /// In en, this message translates to:
  /// **'Family Type'**
  String get familyType;

  /// No description provided for @familyStatus.
  ///
  /// In en, this message translates to:
  /// **'Family Status'**
  String get familyStatus;

  /// No description provided for @brothers.
  ///
  /// In en, this message translates to:
  /// **'Brothers'**
  String get brothers;

  /// No description provided for @sisters.
  ///
  /// In en, this message translates to:
  /// **'Sisters'**
  String get sisters;

  /// No description provided for @annualIncome.
  ///
  /// In en, this message translates to:
  /// **'Annual Income'**
  String get annualIncome;

  /// No description provided for @employedIn.
  ///
  /// In en, this message translates to:
  /// **'Employed In'**
  String get employedIn;

  /// No description provided for @diet.
  ///
  /// In en, this message translates to:
  /// **'Diet'**
  String get diet;

  /// No description provided for @applyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get applyFilters;

  /// No description provided for @splashHeadlinePart1.
  ///
  /// In en, this message translates to:
  /// **'\"Find Someone Who'**
  String get splashHeadlinePart1;

  /// No description provided for @splashHeadlineHighlight.
  ///
  /// In en, this message translates to:
  /// **'TRULY'**
  String get splashHeadlineHighlight;

  /// No description provided for @splashHeadlinePart2.
  ///
  /// In en, this message translates to:
  /// **'Gets You\"'**
  String get splashHeadlinePart2;

  /// No description provided for @oneCrorePlusHappyCustomers.
  ///
  /// In en, this message translates to:
  /// **'1 Crore+ Happy Customers'**
  String get oneCrorePlusHappyCustomers;

  /// No description provided for @choosePlan.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Plan'**
  String get choosePlan;

  /// No description provided for @upgradeToUnlockFeatures.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to unlock more features'**
  String get upgradeToUnlockFeatures;

  /// No description provided for @buyProfileUnlocks.
  ///
  /// In en, this message translates to:
  /// **'Buy Profile Unlocks'**
  String get buyProfileUnlocks;

  /// No description provided for @viewContactDetailsDescription.
  ///
  /// In en, this message translates to:
  /// **'View contact details of profiles you are interested in'**
  String get viewContactDetailsDescription;

  /// No description provided for @profileUnlocksCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} Profile Unlocks'**
  String profileUnlocksCountLabel(String count);

  /// No description provided for @pricePerProfile.
  ///
  /// In en, this message translates to:
  /// **'₹{price} per profile'**
  String pricePerProfile(String price);

  /// No description provided for @planActiveDetails.
  ///
  /// In en, this message translates to:
  /// **'{contactViews} contact views remaining · {durationMonths} month duration'**
  String planActiveDetails(String contactViews, String durationMonths);

  /// No description provided for @viewContactDetails.
  ///
  /// In en, this message translates to:
  /// **'View Contact Details'**
  String get viewContactDetails;

  /// No description provided for @chatWithMatches.
  ///
  /// In en, this message translates to:
  /// **'Chat with Matches'**
  String get chatWithMatches;

  /// No description provided for @profileHighlight.
  ///
  /// In en, this message translates to:
  /// **'Profile Highlight'**
  String get profileHighlight;

  /// No description provided for @prioritySupport.
  ///
  /// In en, this message translates to:
  /// **'Priority Support'**
  String get prioritySupport;

  /// No description provided for @profileBoost.
  ///
  /// In en, this message translates to:
  /// **'Profile Boost'**
  String get profileBoost;

  /// No description provided for @planPriceDescription.
  ///
  /// In en, this message translates to:
  /// **'₹{price} for {months} months'**
  String planPriceDescription(String price, String months);

  /// No description provided for @upi.
  ///
  /// In en, this message translates to:
  /// **'UPI'**
  String get upi;

  /// No description provided for @creditDebitCard.
  ///
  /// In en, this message translates to:
  /// **'Credit / Debit Card'**
  String get creditDebitCard;

  /// No description provided for @netBanking.
  ///
  /// In en, this message translates to:
  /// **'Net Banking'**
  String get netBanking;

  /// No description provided for @byCriteria.
  ///
  /// In en, this message translates to:
  /// **'By Criteria'**
  String get byCriteria;

  /// No description provided for @byProfileId.
  ///
  /// In en, this message translates to:
  /// **'By Profile ID'**
  String get byProfileId;

  /// No description provided for @savedSearch.
  ///
  /// In en, this message translates to:
  /// **'Saved Search'**
  String get savedSearch;

  /// No description provided for @searchByProfileId.
  ///
  /// In en, this message translates to:
  /// **'Search by Profile ID'**
  String get searchByProfileId;

  /// No description provided for @enterMemberIdHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the member ID to find a specific profile'**
  String get enterMemberIdHint;

  /// No description provided for @profileId.
  ///
  /// In en, this message translates to:
  /// **'Profile ID'**
  String get profileId;

  /// No description provided for @profileIdHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., M1234567'**
  String get profileIdHint;

  /// No description provided for @noSavedSearches.
  ///
  /// In en, this message translates to:
  /// **'No Saved Searches'**
  String get noSavedSearches;

  /// No description provided for @saveSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Save your search criteria for quick access'**
  String get saveSearchHint;

  /// No description provided for @activeNow.
  ///
  /// In en, this message translates to:
  /// **'Active now'**
  String get activeNow;

  /// No description provided for @activeTwoHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'Active 2h ago'**
  String get activeTwoHoursAgo;

  /// No description provided for @contactDetailsMasked.
  ///
  /// In en, this message translates to:
  /// **'Contact details are masked. Upgrade to Premium to view.'**
  String get contactDetailsMasked;

  /// No description provided for @messageHint.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get messageHint;

  /// No description provided for @enterProfileDetailsHint.
  ///
  /// In en, this message translates to:
  /// **'Enter both profiles\' details to get matching score'**
  String get enterProfileDetailsHint;

  /// No description provided for @yourDetails.
  ///
  /// In en, this message translates to:
  /// **'Your Details'**
  String get yourDetails;

  /// No description provided for @partnersDetails.
  ///
  /// In en, this message translates to:
  /// **'Partner\'s Details'**
  String get partnersDetails;

  /// No description provided for @timeOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Time of Birth'**
  String get timeOfBirth;

  /// No description provided for @placeOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Place of Birth'**
  String get placeOfBirth;

  /// No description provided for @starNakshatram.
  ///
  /// In en, this message translates to:
  /// **'Star (Nakshatram)'**
  String get starNakshatram;

  /// No description provided for @horoscopeSummaryText.
  ///
  /// In en, this message translates to:
  /// **'This is an excellent match with 7.5 out of 10 poruthams matching. The couple is highly compatible for marriage based on horoscope analysis. Both nakshatras complement each other well.'**
  String get horoscopeSummaryText;

  /// No description provided for @matchLabel.
  ///
  /// In en, this message translates to:
  /// **'Match'**
  String get matchLabel;

  /// No description provided for @noMatchLabel.
  ///
  /// In en, this message translates to:
  /// **'No Match'**
  String get noMatchLabel;

  /// No description provided for @poruthamDina.
  ///
  /// In en, this message translates to:
  /// **'Dina Porutham'**
  String get poruthamDina;

  /// No description provided for @poruthamDinaDesc.
  ///
  /// In en, this message translates to:
  /// **'Star compatibility'**
  String get poruthamDinaDesc;

  /// No description provided for @poruthamGana.
  ///
  /// In en, this message translates to:
  /// **'Gana Porutham'**
  String get poruthamGana;

  /// No description provided for @poruthamGanaDesc.
  ///
  /// In en, this message translates to:
  /// **'Temperament matching'**
  String get poruthamGanaDesc;

  /// No description provided for @poruthamMahendra.
  ///
  /// In en, this message translates to:
  /// **'Mahendra Porutham'**
  String get poruthamMahendra;

  /// No description provided for @poruthamMahendraDesc.
  ///
  /// In en, this message translates to:
  /// **'Prosperity & well-being'**
  String get poruthamMahendraDesc;

  /// No description provided for @poruthamStreeDeergha.
  ///
  /// In en, this message translates to:
  /// **'Stree Deergha'**
  String get poruthamStreeDeergha;

  /// No description provided for @poruthamStreeDeerghaDesc.
  ///
  /// In en, this message translates to:
  /// **'Long married life'**
  String get poruthamStreeDeerghaDesc;

  /// No description provided for @poruthamYoni.
  ///
  /// In en, this message translates to:
  /// **'Yoni Porutham'**
  String get poruthamYoni;

  /// No description provided for @poruthamYoniDesc.
  ///
  /// In en, this message translates to:
  /// **'Physical compatibility'**
  String get poruthamYoniDesc;

  /// No description provided for @poruthamRasi.
  ///
  /// In en, this message translates to:
  /// **'Rasi Porutham'**
  String get poruthamRasi;

  /// No description provided for @poruthamRasiDesc.
  ///
  /// In en, this message translates to:
  /// **'Emotional compatibility'**
  String get poruthamRasiDesc;

  /// No description provided for @poruthamRasiyathipathi.
  ///
  /// In en, this message translates to:
  /// **'Rasiyathipathi'**
  String get poruthamRasiyathipathi;

  /// No description provided for @poruthamRasiyathipathiDesc.
  ///
  /// In en, this message translates to:
  /// **'Ruling planet harmony'**
  String get poruthamRasiyathipathiDesc;

  /// No description provided for @poruthamVasya.
  ///
  /// In en, this message translates to:
  /// **'Vasya Porutham'**
  String get poruthamVasya;

  /// No description provided for @poruthamVasyaDesc.
  ///
  /// In en, this message translates to:
  /// **'Mutual attraction'**
  String get poruthamVasyaDesc;

  /// No description provided for @poruthamRajju.
  ///
  /// In en, this message translates to:
  /// **'Rajju Porutham'**
  String get poruthamRajju;

  /// No description provided for @poruthamRajjuDesc.
  ///
  /// In en, this message translates to:
  /// **'Longevity of spouse'**
  String get poruthamRajjuDesc;

  /// No description provided for @poruthamVedha.
  ///
  /// In en, this message translates to:
  /// **'Vedha Porutham'**
  String get poruthamVedha;

  /// No description provided for @poruthamVedhaDesc.
  ///
  /// In en, this message translates to:
  /// **'Obstacle analysis'**
  String get poruthamVedhaDesc;

  /// No description provided for @stepBasicInfo.
  ///
  /// In en, this message translates to:
  /// **'Basic Info'**
  String get stepBasicInfo;

  /// No description provided for @stepReligionCaste.
  ///
  /// In en, this message translates to:
  /// **'Religion / Caste'**
  String get stepReligionCaste;

  /// No description provided for @stepEducationOccupation.
  ///
  /// In en, this message translates to:
  /// **'Study / Job'**
  String get stepEducationOccupation;

  /// No description provided for @stepFamilyDetails.
  ///
  /// In en, this message translates to:
  /// **'Family Details'**
  String get stepFamilyDetails;

  /// No description provided for @stepHoroscopeDetails.
  ///
  /// In en, this message translates to:
  /// **'Horoscope Details'**
  String get stepHoroscopeDetails;

  /// No description provided for @stepLifestyle.
  ///
  /// In en, this message translates to:
  /// **'Lifestyle'**
  String get stepLifestyle;

  /// No description provided for @stepPartnerPreferences.
  ///
  /// In en, this message translates to:
  /// **'Partner Preferences'**
  String get stepPartnerPreferences;

  /// No description provided for @stepPhotoUpload.
  ///
  /// In en, this message translates to:
  /// **'Photo Upload'**
  String get stepPhotoUpload;

  /// No description provided for @stepPrivacySettings.
  ///
  /// In en, this message translates to:
  /// **'Privacy Settings'**
  String get stepPrivacySettings;

  /// No description provided for @subCaste.
  ///
  /// In en, this message translates to:
  /// **'Sub Caste'**
  String get subCaste;

  /// No description provided for @highestEducation.
  ///
  /// In en, this message translates to:
  /// **'Highest Education'**
  String get highestEducation;

  /// No description provided for @fathersName.
  ///
  /// In en, this message translates to:
  /// **'Father\'s Name'**
  String get fathersName;

  /// No description provided for @fathersOccupation.
  ///
  /// In en, this message translates to:
  /// **'Father\'s Occupation'**
  String get fathersOccupation;

  /// No description provided for @mothersName.
  ///
  /// In en, this message translates to:
  /// **'Mother\'s Name'**
  String get mothersName;

  /// No description provided for @mothersOccupation.
  ///
  /// In en, this message translates to:
  /// **'Mother\'s Occupation'**
  String get mothersOccupation;

  /// No description provided for @smoking.
  ///
  /// In en, this message translates to:
  /// **'Smoking'**
  String get smoking;

  /// No description provided for @drinking.
  ///
  /// In en, this message translates to:
  /// **'Drinking'**
  String get drinking;

  /// No description provided for @heightRange.
  ///
  /// In en, this message translates to:
  /// **'Height Range'**
  String get heightRange;

  /// No description provided for @preferredEducation.
  ///
  /// In en, this message translates to:
  /// **'Preferred Education'**
  String get preferredEducation;

  /// No description provided for @preferredOccupation.
  ///
  /// In en, this message translates to:
  /// **'Preferred Occupation'**
  String get preferredOccupation;

  /// No description provided for @preferredLocation.
  ///
  /// In en, this message translates to:
  /// **'Preferred Location'**
  String get preferredLocation;

  /// No description provided for @preferredReligion.
  ///
  /// In en, this message translates to:
  /// **'Preferred Religion'**
  String get preferredReligion;

  /// No description provided for @uploadPhotos.
  ///
  /// In en, this message translates to:
  /// **'Upload Photos'**
  String get uploadPhotos;

  /// No description provided for @addPhotosDescription.
  ///
  /// In en, this message translates to:
  /// **'Add up to 10 photos to your profile. Clear, recent photos get more responses.'**
  String get addPhotosDescription;

  /// No description provided for @showProfileToAll.
  ///
  /// In en, this message translates to:
  /// **'Show profile to all members'**
  String get showProfileToAll;

  /// No description provided for @profileVisibleToAll.
  ///
  /// In en, this message translates to:
  /// **'Your profile will be visible to everyone'**
  String get profileVisibleToAll;

  /// No description provided for @showPhotosToPremiumOnly.
  ///
  /// In en, this message translates to:
  /// **'Show photos to premium members only'**
  String get showPhotosToPremiumOnly;

  /// No description provided for @paidMembersCanSeePhotos.
  ///
  /// In en, this message translates to:
  /// **'Only paid members can see your photos'**
  String get paidMembersCanSeePhotos;

  /// No description provided for @showHoroscopeDetails.
  ///
  /// In en, this message translates to:
  /// **'Show horoscope details'**
  String get showHoroscopeDetails;

  /// No description provided for @displayHoroscopeOnProfile.
  ///
  /// In en, this message translates to:
  /// **'Display horoscope information on profile'**
  String get displayHoroscopeOnProfile;

  /// No description provided for @allowContactMessages.
  ///
  /// In en, this message translates to:
  /// **'Allow contact messages'**
  String get allowContactMessages;

  /// No description provided for @receiveMessagesFromInterested.
  ///
  /// In en, this message translates to:
  /// **'Receive messages from interested profiles'**
  String get receiveMessagesFromInterested;

  /// No description provided for @hidePhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Hide phone number'**
  String get hidePhoneNumber;

  /// No description provided for @phoneNumberHiddenDefault.
  ///
  /// In en, this message translates to:
  /// **'Phone number will not be shown by default'**
  String get phoneNumberHiddenDefault;

  /// No description provided for @hiName.
  ///
  /// In en, this message translates to:
  /// **'Hi {name}!'**
  String hiName(String name);

  /// No description provided for @completeProfileForMatches.
  ///
  /// In en, this message translates to:
  /// **'Complete your profile to get more matches'**
  String get completeProfileForMatches;

  /// No description provided for @profileLookingGreat.
  ///
  /// In en, this message translates to:
  /// **'Your profile is looking great!'**
  String get profileLookingGreat;

  /// No description provided for @adminDashboard.
  ///
  /// In en, this message translates to:
  /// **'Admin Dashboard'**
  String get adminDashboard;

  /// No description provided for @welcomeBackMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome back! Here\'s what\'s happening today.'**
  String get welcomeBackMessage;

  /// No description provided for @totalUsers.
  ///
  /// In en, this message translates to:
  /// **'Total Users'**
  String get totalUsers;

  /// No description provided for @activeProfiles.
  ///
  /// In en, this message translates to:
  /// **'Active Profiles'**
  String get activeProfiles;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @thisYear.
  ///
  /// In en, this message translates to:
  /// **'This Year'**
  String get thisYear;

  /// No description provided for @recentRegistrations.
  ///
  /// In en, this message translates to:
  /// **'Recent Registrations'**
  String get recentRegistrations;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// No description provided for @banners.
  ///
  /// In en, this message translates to:
  /// **'Banners'**
  String get banners;

  /// No description provided for @broadcast.
  ///
  /// In en, this message translates to:
  /// **'Broadcast'**
  String get broadcast;

  /// No description provided for @cms.
  ///
  /// In en, this message translates to:
  /// **'CMS'**
  String get cms;

  /// No description provided for @bannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Banner Title'**
  String get bannerTitle;

  /// No description provided for @position.
  ///
  /// In en, this message translates to:
  /// **'Position'**
  String get position;

  /// No description provided for @linkUrl.
  ///
  /// In en, this message translates to:
  /// **'Link URL'**
  String get linkUrl;

  /// No description provided for @pages.
  ///
  /// In en, this message translates to:
  /// **'Pages'**
  String get pages;

  /// No description provided for @faqs.
  ///
  /// In en, this message translates to:
  /// **'FAQs'**
  String get faqs;

  /// No description provided for @testimonials.
  ///
  /// In en, this message translates to:
  /// **'Testimonials'**
  String get testimonials;

  /// No description provided for @pageTitle.
  ///
  /// In en, this message translates to:
  /// **'Page Title'**
  String get pageTitle;

  /// No description provided for @appliedToAllMediators.
  ///
  /// In en, this message translates to:
  /// **'Applied to all standard mediator accounts'**
  String get appliedToAllMediators;

  /// No description provided for @higherRateForTopMediators.
  ///
  /// In en, this message translates to:
  /// **'Higher rate for top-performing mediators'**
  String get higherRateForTopMediators;

  /// No description provided for @perSuccessfulMatch.
  ///
  /// In en, this message translates to:
  /// **'Per Successful Match'**
  String get perSuccessfulMatch;

  /// No description provided for @perProfileRegistration.
  ///
  /// In en, this message translates to:
  /// **'Per Profile Registration'**
  String get perProfileRegistration;

  /// No description provided for @subscriptionReferral.
  ///
  /// In en, this message translates to:
  /// **'Subscription Referral'**
  String get subscriptionReferral;

  /// No description provided for @bonusMatchesPerMonth.
  ///
  /// In en, this message translates to:
  /// **'Bonus (10+ matches/month)'**
  String get bonusMatchesPerMonth;

  /// No description provided for @allowUsersHoroscopeCheck.
  ///
  /// In en, this message translates to:
  /// **'Allow users to check horoscope compatibility'**
  String get allowUsersHoroscopeCheck;

  /// No description provided for @autoShowCompatibility.
  ///
  /// In en, this message translates to:
  /// **'Automatically show compatibility on profile view'**
  String get autoShowCompatibility;

  /// No description provided for @minimumPoruthamDesc.
  ///
  /// In en, this message translates to:
  /// **'Minimum poruthams needed for \"Good Match\" label'**
  String get minimumPoruthamDesc;

  /// No description provided for @tenPoruthamConfiguration.
  ///
  /// In en, this message translates to:
  /// **'10 Porutham Configuration'**
  String get tenPoruthamConfiguration;

  /// No description provided for @excellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get excellent;

  /// No description provided for @good.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get good;

  /// No description provided for @average.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get average;

  /// No description provided for @poor.
  ///
  /// In en, this message translates to:
  /// **'Poor'**
  String get poor;

  /// No description provided for @searchMediators.
  ///
  /// In en, this message translates to:
  /// **'Search mediators...'**
  String get searchMediators;

  /// No description provided for @totalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get totalLabel;

  /// No description provided for @avgCommission.
  ///
  /// In en, this message translates to:
  /// **'Avg Commission'**
  String get avgCommission;

  /// No description provided for @profiles.
  ///
  /// In en, this message translates to:
  /// **'Profiles'**
  String get profiles;

  /// No description provided for @commissionRate.
  ///
  /// In en, this message translates to:
  /// **'Commission Rate (%)'**
  String get commissionRate;

  /// No description provided for @district.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get district;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phoneLabel;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @editItem.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editItem;

  /// No description provided for @deleteItem.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteItem;

  /// No description provided for @notificationSentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Notification sent to all users!'**
  String get notificationSentSuccess;

  /// No description provided for @sentStatus.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get sentStatus;

  /// No description provided for @approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// No description provided for @searchUsersHint.
  ///
  /// In en, this message translates to:
  /// **'Search users...'**
  String get searchUsersHint;

  /// No description provided for @popularLabel.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get popularLabel;

  /// No description provided for @activeStatus.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get activeStatus;

  /// No description provided for @totalPlatformRevenue.
  ///
  /// In en, this message translates to:
  /// **'Total Platform Revenue'**
  String get totalPlatformRevenue;

  /// No description provided for @pendingPayouts.
  ///
  /// In en, this message translates to:
  /// **'Pending Payouts'**
  String get pendingPayouts;

  /// No description provided for @completedPayouts.
  ///
  /// In en, this message translates to:
  /// **'Completed Payouts'**
  String get completedPayouts;

  /// No description provided for @approveWithdrawal.
  ///
  /// In en, this message translates to:
  /// **'Approved {name}\'s withdrawal'**
  String approveWithdrawal(String name);

  /// No description provided for @rejectWithdrawal.
  ///
  /// In en, this message translates to:
  /// **'Rejected {name}\'s withdrawal'**
  String rejectWithdrawal(String name);

  /// No description provided for @newUsersToday.
  ///
  /// In en, this message translates to:
  /// **'New Users (Today)'**
  String get newUsersToday;

  /// No description provided for @activeSessions.
  ///
  /// In en, this message translates to:
  /// **'Active Sessions'**
  String get activeSessions;

  /// No description provided for @revenueToday.
  ///
  /// In en, this message translates to:
  /// **'Revenue (Today)'**
  String get revenueToday;

  /// No description provided for @interestsSent.
  ///
  /// In en, this message translates to:
  /// **'Interests Sent'**
  String get interestsSent;

  /// No description provided for @last7Days.
  ///
  /// In en, this message translates to:
  /// **'Last 7 Days'**
  String get last7Days;

  /// No description provided for @last30Days.
  ///
  /// In en, this message translates to:
  /// **'Last 30 Days'**
  String get last30Days;

  /// No description provided for @approvedLabel.
  ///
  /// In en, this message translates to:
  /// **'Approved ({count})'**
  String approvedLabel(int count);

  /// No description provided for @pendingLabel.
  ///
  /// In en, this message translates to:
  /// **'Pending ({count})'**
  String pendingLabel(int count);

  /// No description provided for @rejectedLabel.
  ///
  /// In en, this message translates to:
  /// **'Rejected ({count})'**
  String rejectedLabel(int count);

  /// No description provided for @approvedName.
  ///
  /// In en, this message translates to:
  /// **'{name} approved!'**
  String approvedName(String name);

  /// No description provided for @rejectedName.
  ///
  /// In en, this message translates to:
  /// **'{name} rejected'**
  String rejectedName(String name);

  /// No description provided for @totalUnlocksSold.
  ///
  /// In en, this message translates to:
  /// **'Total Unlocks Sold'**
  String get totalUnlocksSold;

  /// No description provided for @avgPerUser.
  ///
  /// In en, this message translates to:
  /// **'Avg Per User'**
  String get avgPerUser;

  /// No description provided for @activeBundlesTitle.
  ///
  /// In en, this message translates to:
  /// **'Active Bundles'**
  String get activeBundlesTitle;

  /// No description provided for @perProfile.
  ///
  /// In en, this message translates to:
  /// **'per profile'**
  String get perProfile;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @addProfile.
  ///
  /// In en, this message translates to:
  /// **'Add Profile'**
  String get addProfile;

  /// No description provided for @allTab.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allTab;

  /// No description provided for @earnedTab.
  ///
  /// In en, this message translates to:
  /// **'Earned'**
  String get earnedTab;

  /// No description provided for @pendingTab.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pendingTab;

  /// No description provided for @totalEarned.
  ///
  /// In en, this message translates to:
  /// **'Total Earned'**
  String get totalEarned;

  /// No description provided for @transactionHistory.
  ///
  /// In en, this message translates to:
  /// **'Transaction History'**
  String get transactionHistory;

  /// No description provided for @noTransactions.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet'**
  String get noTransactions;

  /// No description provided for @welcomeMediator.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}!'**
  String welcomeMediator(String name);

  /// No description provided for @totalProfiles.
  ///
  /// In en, this message translates to:
  /// **'Total Profiles'**
  String get totalProfiles;

  /// No description provided for @activeMatches.
  ///
  /// In en, this message translates to:
  /// **'Active Matches'**
  String get activeMatches;

  /// No description provided for @successfulMatches.
  ///
  /// In en, this message translates to:
  /// **'Successful Matches'**
  String get successfulMatches;

  /// No description provided for @pendingReviews.
  ///
  /// In en, this message translates to:
  /// **'Pending Reviews'**
  String get pendingReviews;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get processing;

  /// No description provided for @totalIn.
  ///
  /// In en, this message translates to:
  /// **'Total In'**
  String get totalIn;

  /// No description provided for @totalOut.
  ///
  /// In en, this message translates to:
  /// **'Total Out'**
  String get totalOut;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @withdrawTo.
  ///
  /// In en, this message translates to:
  /// **'Withdraw To'**
  String get withdrawTo;

  /// No description provided for @bankTransfer.
  ///
  /// In en, this message translates to:
  /// **'Bank Transfer'**
  String get bankTransfer;

  /// No description provided for @withdrawalSubmittedMsg.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal request submitted successfully!'**
  String get withdrawalSubmittedMsg;

  /// No description provided for @contentLabel.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get contentLabel;

  /// No description provided for @content.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get content;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi', 'ta', 'te'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
    case 'ta':
      return AppLocalizationsTa();
    case 'te':
      return AppLocalizationsTe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
