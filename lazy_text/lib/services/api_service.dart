import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  Future<Map<String, String>> getHeaders() async {
  final prefs = await SharedPreferences.getInstance();

  final token = prefs.getString("token");

  print("TOKEN FROM STORAGE:");
  print(token);

  return {
    "Authorization": "Bearer $token",
  };
}
  static const String baseUrl =
      "http://10.0.2.2:5001/api";

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        "Content-Type": "application/json",
      },
    ),
  );

  // SIGNUP
  Future<Response> signup({
    required String fullname,
    required String email,
    required String password,
  }) async {
    return await dio.post(
      "/auth/signup",
      data: {
        "fullname": fullname,
        "email": email,
        "password": password,
      },
    );
  }

  // LOGIN
  Future<Response> login({
    required String email,
    required String password,
  }) async {
    return await dio.post(
      "/auth/login",
      data: {
        "email": email,
        "password": password,
      },
    );
  }

  // GET USERS
  Future<Response> getUsers() async {
  return await dio.get(
    "/message/users",
    options: Options(
      headers: await getHeaders(),
    ),
  );
}

  // GET MESSAGES
  Future<Response> getMessages(
  String userId,
) async {
  return await dio.get(
    "/message/$userId",
    options: Options(
      headers: await getHeaders(),
    ),
  );
}

  // SEND MESSAGE
  Future<Response> sendMessage({
  required String receiverId,
  required String text,
}) async {
  return await dio.post(
    "/message/send/$receiverId",
    data: {
      "text": text,
    },
    options: Options(
      headers: await getHeaders(),
    ),
  );
}
}