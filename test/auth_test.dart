import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

void main() async {
  test("No authentified user", () {
    final auth = MockFirebaseAuth();
    final user = auth.currentUser;
    expect(user, isNull);
  });

  test("Sign user up", () async {
    String email = "email@email.com";
    final auth = MockFirebaseAuth(mockUser: MockUser(uid: 'testoID'));
    final result = await auth.createUserWithEmailAndPassword(
        email: email, password: "password");
    final user = result.user!;
    expect(user.email, email);
  });

  test("Sign user in", () async {
    String email = "email@email.com";
    final auth = MockFirebaseAuth(mockUser: MockUser(uid: 'testoID'));
    await auth.createUserWithEmailAndPassword(
        email: email, password: "password");
    final result = await auth.signInWithEmailAndPassword(
        email: email, password: "password");
    final user = result.user!;
    expect(user.email, email);
  });

  test("User sign out", () async {
    final auth = MockFirebaseAuth(mockUser: MockUser(uid: 'testoID'));

    await auth.signOut();
    expect(auth.currentUser, isNull);
  });
}
