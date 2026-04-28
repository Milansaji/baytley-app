# Signup Feature Documentation

## Overview

A complete signup feature has been implemented using the BLoC (Business Logic Component) pattern in the Baytley Flutter application. This feature allows new users to create accounts with validation, error handling, and state management.

## File Structure

```
lib/features/auth/
├── bloc/
│   ├── auth_bloc.dart          (Existing - handles both sign in & sign up)
│   ├── auth_event.dart         (Existing)
│   ├── auth_state.dart         (Existing)
│   ├── signup_bloc.dart        (NEW - dedicated signup logic)
│   ├── signup_event.dart       (NEW - signup-specific events)
│   └── signup_state.dart       (NEW - signup-specific states)
├── screens/
│   ├── auth_screen.dart        (Updated - now navigates to signup)
│   └── signup_screen.dart      (NEW - dedicated signup UI)
├── models/
│   └── user_model.dart         (Existing)
└── data/
    └── repositories/
        └── auth_repository.dart (Existing)
```

## Features

### SignupScreen
A dedicated signup screen with:
- **Full Name Input** - Required, minimum 3 characters
- **Email Input** - Required, valid email format validation
- **Password Input** - Required, minimum 6 characters with visibility toggle
- **Confirm Password Input** - Matches password field
- **Form Validation** - Real-time validation with error messages
- **Loading State** - Shows spinner during signup
- **Error Handling** - Displays Firebase auth errors
- **Navigation** - Link back to sign in screen
- **Localization** - Supports English and Arabic

### SignupBloc
Handles signup business logic:
- **SignupRequested** - Initiates signup with name, email, and password
- **SignupFormReset** - Clears the signup form state
- **Validation** - Email format, password length, name length
- **Firebase Integration** - Uses existing AuthRepository
- **State Management** - Loading, success, error, and validation error states

## Usage

### Basic Integration
The signup feature is already integrated into the auth flow. Users can:

1. **From Login Screen**: Click "Don't have an account? Sign Up" to navigate to the signup screen
2. **Direct Navigation**: 
   ```dart
   Navigator.push(
     context,
     MaterialPageRoute(builder: (context) => const SignupScreen()),
   );
   ```

### Using SignupBloc in a Widget
```dart
// Access the SignupBloc
final signupBloc = context.read<SignupBloc>();

// Trigger signup
signupBloc.add(
  SignupRequested(
    name: 'John Doe',
    email: 'john@example.com',
    password: 'password123',
  ),
);

// Listen to state changes
BlocListener<SignupBloc, SignupState>(
  listener: (context, state) {
    if (state is SignupSuccess) {
      // User created successfully
    } else if (state is SignupError) {
      // Handle error
    }
  },
)
```

## Validation Rules

### Full Name
- Required field
- Minimum 3 characters
- Error: "Name must be at least 3 characters"

### Email
- Required field
- Must contain @ and .
- Error: "Enter a valid email address"

### Password
- Required field
- Minimum 6 characters
- Error: "Password must be at least 6 characters"

### Confirm Password
- Must match password field
- Error: "Passwords do not match"

## States

### SignupState Hierarchy
- `SignupInitial` - Initial state
- `SignupLoading` - During signup process
- `SignupSuccess(UserModel)` - Signup successful with user data
- `SignupError(String)` - Signup failed with error message
- `SignupValidationError(Map<String, String>)` - Validation failed with field errors

## Error Handling

The signup feature handles:
- **Firebase Auth Errors** - Displays firebase_auth error messages
- **Validation Errors** - Field-specific validation feedback
- **Network Errors** - General error messages
- **User Feedback** - SnackBar messages for all errors

## Localization

All signup screen text is localized:
- **English** (en)
- **Arabic** (ar)

Localization keys are automatically handled through the `app_locale.dart` extension.

## Integration with Existing Auth

The signup feature integrates seamlessly with the existing auth system:
- Uses the same `AuthRepository`
- Follows the same authentication flow
- Integrates with Firebase Auth
- Uses the existing `UserModel`

After successful signup, users are authenticated and can access the main app screen.

## State Flow Diagram

```
SignupInitial
    ↓
SignupRequested (user submits form)
    ↓
SignupLoading
    ├→ SignupSuccess (if successful)
    │   └→ User authenticated, app navigates to MainScreen
    └→ SignupError (if failed)
        └→ SignupInitial (ready for retry)
```

## Testing

To test the signup feature:

1. Start the app and go to the login screen
2. Click "Don't have an account? Sign Up"
3. Fill in the signup form with valid data
4. Click "Create Account"
5. The signup should succeed and navigate to the main app

### Test Cases
- **Valid signup**: All fields filled correctly
- **Invalid email**: Email without @ or .
- **Password mismatch**: Confirm password doesn't match
- **Short name**: Name less than 3 characters
- **Short password**: Password less than 6 characters
- **Duplicate email**: Try signing up with existing email (Firebase error)

## Future Enhancements

Possible improvements:
- Email verification step
- Password strength indicator
- Social login integration
- Terms and conditions acceptance
- Email uniqueness check before signup
- Phone number field
- Address information
