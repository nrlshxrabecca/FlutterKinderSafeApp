import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// Gets the currently signed-in user, or `null` if no user is signed in.
  User? get currentUser => _firebaseAuth.currentUser;

  /// Stream that emits authentication state changes (e.g., sign-in, sign-out).
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Signs in a user with the given [email] and [password].
  /// Returns the authenticated [User], or throws a [FirebaseAuthException] on failure.
  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      print('Attempting to log in with email: $email');
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('Login successful for user: ${userCredential.user?.email}');
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // Specific Firebase exceptions (e.g., user-not-found, wrong-password)
      print('FirebaseAuthException: ${e.code} - ${e.message}');
      throw e;
    } catch (e) {
      // General exceptions
      print('Error during login: $e');
      rethrow;
    }
  }

  /// Registers a new user with the given [email] and [password].
  /// Returns the created [User], or throws a [FirebaseAuthException] on failure.
  Future<User?> createWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      print('Attempting to register user with email: $email');
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('Registration successful for user: ${userCredential.user?.email}');
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // Specific Firebase exceptions (e.g., email-already-in-use)
      print('FirebaseAuthException: ${e.code} - ${e.message}');
      throw e;
    } catch (e) {
      // General exceptions
      print('Error during registration: $e');
      rethrow;
    }
  }

  /// Signs out the currently authenticated user.
  /// Throws an error if the sign-out process fails.
  Future<void> signOut() async {
    try {
      print('Signing out current user: ${currentUser?.email}');
      await _firebaseAuth.signOut();
      print('User signed out successfully');
    } catch (e) {
      print('Error during sign-out: $e');
      throw e;
    }
  }
}
