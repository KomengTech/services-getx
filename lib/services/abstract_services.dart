abstract class AbstractServices {
  void init({required String baseUrl});

  Future<void> signUpEmail({
    required String name,
    required String email,
    required String password,
  });

  Future<void> loginEmail({required String email, required String password});

  Future<void> getUserDetails();

  Future<void> logout();
}
