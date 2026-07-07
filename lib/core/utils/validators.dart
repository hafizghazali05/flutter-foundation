/// Pure form validators. Each returns `null` when valid, otherwise an error
/// string suitable for a [TextFormField.validator].
class Validators {
  Validators._();

  static String? email(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Email is required';
    final regex = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');
    if (!regex.hasMatch(v)) return 'Enter a valid email';
    return null;
  }

  static String? required(String? value, {String field = 'This field'}) {
    if (value == null || value.trim().isEmpty) return '$field is required';
    return null;
  }

  static String? password(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Password is required';
    if (v.length < 6) return 'Minimum 6 characters';
    return null;
  }

  static String? otp(String? value) {
    final v = value?.trim() ?? '';
    if (v.length != 6) return 'Enter the 6-digit code';
    if (int.tryParse(v) == null) return 'Digits only';
    return null;
  }
}
