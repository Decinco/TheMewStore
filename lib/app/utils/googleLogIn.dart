import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GoogleLoginUtils {
  static Future<void> nativeGoogleSignIn(SupabaseClient supabase) async {
    /// Web Client ID that you registered with Google Cloud.
    const webClientId = '100431781632-vprn2pm4qq5p3mtl1hoiddaevv5at006.apps.googleusercontent.com';
    const clientId = '100431781632-fbmaumu4eiv075lin6oqjkvih0hpjknb.apps.googleusercontent.com';

    final GoogleSignIn googleSignIn = GoogleSignIn(
      serverClientId: webClientId,
      clientId: clientId
    );
    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) {
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }

    await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );

    await googleSignIn.signOut();
  }

  static Future<void> webGoogleLogIn(SupabaseClient supabase) async {
    await supabase.auth.signInWithOAuth(
      OAuthProvider.google,
      authScreenLaunchMode:
      kIsWeb ? LaunchMode.platformDefault : LaunchMode.externalApplication, // Launch the auth screen in a new webview on mobile.
    );
  }
}