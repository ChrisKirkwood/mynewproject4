import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

class Utils {
  static final Logger logger = Logger();

  /// Handle Google sign-in and return the GoogleSignInAccount object.
  static Future<GoogleSignInAccount?> handleSignIn() async {
    try {
      return await GoogleSignIn().signIn();
    } catch (error) {
      logger.e('Error signing in with Google: $error');
      return null;
    }
  }
}
