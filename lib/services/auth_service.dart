import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:diaryapp/helpers/constants.dart';

class AuthService {
  static final AuthService instance = AuthService._internal();
  factory AuthService() => instance;

  Auth0 auth0 = Auth0(auth0Domain, auth0ClientId);
  UserProfile? profile;

  AuthService._internal();

  Future<UserProfile?> login() async {
    final credentials = await auth0.webAuthentication(scheme: 'diaryapp').login();
    profile = credentials.user;
    return profile;
  }

 Future logout() async {
  await auth0.webAuthentication(scheme: "diaryapp").logout();
 }
}