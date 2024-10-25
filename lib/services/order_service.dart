import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';

class OrderService {
  final String _baseUrl = "http://art.somee.com/api";
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<List<dynamic>> getOrdersByAccount() async {
    String? token = await _storage.read(key: 'token');
    if (token == null) {
      throw Exception('User not logged in');
    }
    final response = await Dio().get(
      '$_baseUrl/Orders/ByAccount', 
      options: Options(headers: {
        'Authorization': 'Bearer $token',
      }),
    );
    if (response.statusCode == 200) {
      return response.data;
    } else if (response.statusCode == 401) {
      throw Exception('Token expired or invalid. Please log in again.');
    } else {
      throw Exception('Failed to load orders');
    }
  }


  Future<bool> placeOrder(List<int> cartIds) async {
  String? token = await _storage.read(key: 'token');
  if (token == null) {
    throw Exception('User not logged in');
  }

  try {
    final response = await Dio().post(
      '$_baseUrl/Orders/PlaceOrder',
      options: Options(headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      }),
      data: cartIds, // Gửi danh sách cartId
    );

    if ((response.statusCode ?? 0) >= 200 && (response.statusCode ?? 0) < 210) {
      return true; // Đặt hàng thành công
    } else if (response.statusCode == 401) {
      throw Exception('Token expired or invalid. Please log in again.');
    } else {
      throw Exception('Failed to place order');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Failed to place order: $e');
  }
}


}
