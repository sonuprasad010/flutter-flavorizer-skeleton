
import 'package:flutter_flavorizer_skeleton/features/login/data/model/user.dart';

class AuthRemoteDataSource {
  
  Future<User> login(String email, String password) async {
    await Future.delayed(Duration(seconds: 1));
    if (email == 'test@test.com' && password == 'password') {
      return User(email: email, password: password);
    } else {
      throw Exception('Invalid credentials');
    }
  }
}
