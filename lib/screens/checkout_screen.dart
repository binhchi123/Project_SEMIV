// import 'package:flutter/material.dart';
// import 'package:project_4/models/category.dart';
// import 'package:project_4/screens/cart_screen.dart';
// import 'package:project_4/screens/category_screen.dart';
// import 'package:project_4/screens/home_screen.dart';
// import 'package:project_4/screens/login_screen.dart';
// import 'package:project_4/screens/profile_screen.dart';
// import 'package:project_4/screens/register_screen.dart';
// import 'package:project_4/screens/search_screen.dart';
// import 'package:project_4/services/account_service.dart';
// import 'package:project_4/services/category_service.dart';
// import 'package:project_4/services/order_service.dart';

// class CheckoutPage extends StatefulWidget {
//   final List<dynamic> cartItems;

//   CheckoutPage({required this.cartItems});

//   @override
//   State<StatefulWidget> createState() => _CheckoutPageState();
// }

// class _CheckoutPageState extends State<CheckoutPage> {
//   late Future<List<Category>> categories;
//   late Future<Map<String, dynamic>> userInfo;
//   final AccountService _accountService = AccountService();
//   final OrderService _orderService = OrderService();
//   bool _isLoggedIn = false;
  
//   @override
//   void initState() {
//     super.initState();
//     categories = CategoryService.getAll();
//     userInfo = _fetchUserInfo();
//   }

//   Future<Map<String, dynamic>> _fetchUserInfo() async {
//     _isLoggedIn = true;
//     return await _accountService.getMe();
//   }

//   Future<void> _logout() async {
//     if (_isLoggedIn) {
//       try {
//         await _accountService.logout(); 
//         setState(() {
//           _isLoggedIn = false;
//         });
//       } catch (e) {
//         print('Error logging out: $e');
//       }
//     } else {
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (context) => LoginPage()),
//       );
//     }
//   }


//   // Future<void> _placeOrder(BuildContext context) async {
//   //   try {
//   //     bool success = await _orderService.placeOrder(widget.cartIds);
//   //     if (success) {
//   //       // Thông báo đặt hàng thành công
//   //       ScaffoldMessenger.of(context).showSnackBar(
//   //         SnackBar(content: Text('Đặt hàng thành công!')),
//   //       );
//   //       // Có thể quay về trang chính hoặc giỏ hàng
//   //       Navigator.pop(context);
//   //     }
//   //   } catch (e) {
//   //     // Thông báo lỗi
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackBar(content: Text('Đặt hàng thất bại: $e')),
//   //     );
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     final selectedProducts = widget.cartItems.where((item) => item['isChecked'] == true).toList();
//     return SafeArea(
//         child: Scaffold(
//             appBar: AppBar(
//               title: Align(
//                 alignment: Alignment.center,
//                 child: GestureDetector(
//                   onTap: () {
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(builder: (context) => HomePage()),
//                     );
//                   },
//                   child: Image.asset('assets/images/logo.png'),
//                 ),
//               ),
//               backgroundColor: Colors.black,
//               automaticallyImplyLeading: true,
//               actions: <Widget>[
//                 IconButton(
//                   icon: Icon(Icons.search),
//                   onPressed: () {
//                     showSearch(context: context, delegate: CustomSearchDelegate());
//                   },
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.card_travel),
//                   onPressed: () => {
//                     Navigator.of(context).pushReplacement(
//                       MaterialPageRoute(builder: (context) => CartPage()),
//                     )
//                   },
//                 ),
//               ],
//             ),
//             drawer: Drawer(
//               child: Column(
//                 children: <Widget>[
//                   DrawerHeader(
//                     decoration: BoxDecoration(
//                       color: Color(0xFF2C3848),
//                     ),
//                     child: Align(
//                       alignment: Alignment.center,
//                       child: Text(
//                         'Menu',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                   if (_isLoggedIn) ...[
//                     ListTile(
//                       leading: Icon(Icons.person, color: Colors.blueGrey[700]),
//                       title: Text('Hồ sơ'),
//                       onTap: () {
//                         Navigator.of(context).push(
//                           MaterialPageRoute(builder: (context) => ProfilePage()),
//                         );
//                       },
//                     ),
//                   ],
//                   ListTile(
//                     leading: Icon(Icons.home, color: Colors.blueGrey[700]),
//                     title: Text('Trang chủ'),
//                     onTap: () {
//                       Navigator.of(context).pushReplacement(
//                         MaterialPageRoute(builder: (context) => HomePage()),
//                       );
//                     },
//                   ),
//                   Expanded(
//                     child: FutureBuilder(
//                       future: categories,
//                       builder: (context, snapshot) {
//                         if (snapshot.connectionState == ConnectionState.waiting) {
//                           return Center(
//                             child: CircularProgressIndicator(),
//                           );
//                         } else if (snapshot.hasError) {
//                           return Center(child: Text("Error occurred: ${snapshot.error}"));
//                         } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
//                           final data = snapshot.data!;
//                           return ListView.separated(
//                             itemCount: data.length,
//                             separatorBuilder: (context, index) => SizedBox(height: 10),
//                             itemBuilder: (context, index) {
//                               final category = data[index];
//                               return ListTile(
//                                 leading: Icon(Icons.category, color: Colors.blueGrey[700]),
//                                 title: Text(category.categoryName),
//                                 onTap: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => CategoryPage(categoryId: category.categoryID),
//                                     ),
//                                   );
//                                 },
//                               );
//                             },
//                           );
//                         } else {
//                           return Center(child: Text("No data available"));
//                         }
//                       },
//                     ),
//                   ),
//                   ListTile(
//                     leading: Icon(Icons.login, color: Colors.blueGrey[700]),
//                     title: Text(_isLoggedIn ? 'Đăng xuất' : 'Đăng nhập'),
//                     onTap: _logout,
//                   ),          
//                   if (!_isLoggedIn)
//                   ListTile(
//                     leading: Icon(Icons.person_add, color: Colors.blueGrey[700]),
//                     title: Text('Đăng ký'),
//                     onTap: () {
//                       Navigator.of(context).pushReplacement(
//                         MaterialPageRoute(builder: (context) => RegisterPage()),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             body: SingleChildScrollView(
//               padding: EdgeInsets.all(5),
//               child: Container(
//                 child: Column(                  
//                   children: [
//                     Expanded(
//                       child: 
//                       FutureBuilder<Map<String, dynamic>>(
//                       future: userInfo,
//                       builder: (context, snapshot) {
//                         if (snapshot.connectionState == ConnectionState.waiting) {
//                           return Center(child: CircularProgressIndicator());
//                         } else if (snapshot.hasError) {
//                           return Center(child: Text('Lỗi: ${snapshot.error}'));
//                         } else {
//                           final userInfo = snapshot.data!;
//                           return Padding(
//                             padding: EdgeInsets.all(16.0),
//                             child: Column(
//                               children: [
//                                 Text('Thông tin đơn hàng', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//           ListView.builder(
//             shrinkWrap: true,
//             physics: NeverScrollableScrollPhysics(),
//               itemCount: selectedProducts.length,
//               itemBuilder: (context, index) {
//                 final item = selectedProducts[index];
//                 final product = item['product'];
//                 return ListTile(
//                   title: Text(product['productName']),
//                   subtitle: Text('${product['price']}đ'),
//                   trailing: Text('Số lượng: ${item['quantity']}'),
//                 );
//               },
//             ),


//                                  Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       'Tổng cộng:',
//                                       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                                     ),
//                                     // Text(
//                                     //   '${widget.selectedProducts.fold(0.0, (sum, product) {
//                                     //     return sum + (product['price'] is int
//                                     //         ? (product['price'] as int).toDouble()
//                                     //         : product['price'] ?? 0.0);
//                                     //   }).toStringAsFixed(0)}đ',
//                                     //   style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
//                                     // ),
//                                   ],
//                                 ),
//                                 SizedBox(height: 20),
//                                 Text('Thông tin giao hàng', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//                                 SizedBox(height: 20),
//                                 TextFormField(
//                                   initialValue: userInfo['userName'],
//                                   decoration: InputDecoration(labelText: 'Họ và tên', border: OutlineInputBorder()),
//                                 ),
//                                 SizedBox(height: 10),
//                                 TextFormField(
//                                   initialValue: userInfo['email'],
//                                   decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
//                                 ),
//                                 SizedBox(height: 10),
//                                 TextFormField(
//                                   initialValue: userInfo['phoneNumber'],
//                                   decoration: InputDecoration(labelText: 'Điện thoại', border: OutlineInputBorder()),
//                                 ),
//                                 SizedBox(height: 10),
//                                 TextFormField(
//                                   initialValue: userInfo['address'],
//                                   decoration: InputDecoration(labelText: 'Địa chỉ', border: OutlineInputBorder()),
//                                 ),                                  
//                               ],
//                             ),
//                           );
//                         }
//                       },
//                     ),     
//                     ),           
//                         SizedBox(height: 20,),
//                                 Text('Phương thức vận chuyển',
//                                   style: TextStyle(
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 18
//                                   ),
//                                 ),
//                                 Row(
//                                   children: [
//                                     Icon(
//                                       Icons.local_shipping,
//                                       color: Colors.blue,
//                                       size: 40.0,
//                                     ),
//                                     SizedBox(width: 10),
//                                     Text(
//                                       'Giao hàng tận nơi (2-4 ngày)',
//                                       style: TextStyle(fontSize: 18),
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(height: 20,),
//                                 Text('Phương thức thanh toán',
//                                   style: TextStyle(
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 18
//                                   ),
//                                 ),
//                                 Row(
//                                   children: [
//                                     Icon(
//                                       Icons.payment,
//                                         color: Colors.blue,
//                                         size: 40.0,
//                                       ),
//                                       SizedBox(width: 10),
//                                       Text(
//                                       'Thanh toán khi giao hàng (COD)',
//                                       style: TextStyle(fontSize: 18),
//                                     ),
//                                   ],
//                                 ),       
//                     SizedBox(height: 20,),
//                     ElevatedButton(
//                       onPressed: (){},
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Color(0xFF338dbc),
//                           padding: EdgeInsets.fromLTRB(60, 20, 60, 20)
//                         ),
//                       child: Text('Hoàn tất đơn hàng'),
//                     ),    
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         IconButton(onPressed: (){
//                           Navigator.of(context).pushReplacement(
//                             MaterialPageRoute(builder: (context) => CartPage()),
//                           );
//                         },
//                             icon: Icon(Icons.keyboard_backspace)
//                         ),
//                         TextButton(onPressed: (){
//                           Navigator.of(context).pushReplacement(
//                             MaterialPageRoute(builder: (context) => CartPage()),
//                           );
//                         },
//                             child: Text('Quay lại giỏ hàng', style: TextStyle(color: Colors.black),)
//                         )
//                       ],
//                     ),
//                     SizedBox(height: 20,),
//                     Text('ĐĂNG KÝ NHẬN TIN',
//                       style: TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     TextField(
//                       decoration: InputDecoration(
//                         labelText: 'Nhập EmaiL',
//                         border: OutlineInputBorder(),
//                         labelStyle: TextStyle(color: Colors.black),
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     ElevatedButton(
//                       onPressed: () {},
//                       style: ElevatedButton.styleFrom(
//                           backgroundColor: Color(0xFF86590d),
//                           padding: EdgeInsets.fromLTRB(30, 15, 30, 15)
//                       ),
//                       child: Text('ĐĂNG KÍ'),
//                     ),
//                     SizedBox(height: 20),
//                     Align(
//                       alignment: Alignment.centerLeft,
//                       child: Container(
//                           color: Colors.black,
//                           padding: EdgeInsets.all(20),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Align(
//                                 alignment: Alignment.topLeft,
//                                 child: Image.asset('assets/images/logo.png', width: 200,),
//                               ),
//                               SizedBox(height: 25,),
//                               Row(
//                                 children: [
//                                   IconButton(onPressed: (){}, icon: Icon(Icons.location_on, color: Colors.white,)
//                                   ),
//                                   Text('Địa chỉ: Quận 7, TP.HCM', style: TextStyle(color: Colors.white),)
//                                 ],
//                               ),
//                               SizedBox(height: 10,),
//                               Row(
//                                 children: [
//                                   IconButton(onPressed: (){}, icon: Icon(Icons.phone, color: Colors.white,)
//                                   ),
//                                   Text('Điện thoại: 0888883200', style: TextStyle(color: Colors.white),)
//                                 ],
//                               ),
//                               SizedBox(height: 10,),
//                               Row(
//                                 children: [
//                                   IconButton(onPressed: (){}, icon: Icon(Icons.mail, color: Colors.white,)
//                                   ),
//                                   Text('Email: hunganhparis@gmail.com', style: TextStyle(color: Colors.white),)
//                                 ],
//                               ),
//                               SizedBox(height: 20),
//                               Center(
//                                 child: Text(
//                                   'Copyright © 2024 Deal Hub',
//                                   style: TextStyle(
//                                     color: Color(0xFFACACAC),
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                               )
//                             ],
//                           )
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             )
//         )
//     );
//   }

// }

// class CustomSearchDelegate extends SearchDelegate {
//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       IconButton(
//         icon: Icon(Icons.clear),
//         onPressed: () {
//           query = '';
//         },
//       ),
//     ];
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//       icon: Icon(Icons.arrow_back),
//       onPressed: () {
//         close(context, null);
//       },
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     // Sử dụng callback sau khi khung hình để điều hướng
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (query.isNotEmpty) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => SearchResultsPage(name: query),
//           ),
//         );
//       } else {
//         // Xử lý trường hợp query rỗng
//         print('Query is empty');
//       }
//     });

//     // Trả về một container trống vì chúng ta đang điều hướng đi
//     return Container();
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     final suggestions = [
//       'Gucci',
//       'Balenciaga',
//       'Acme De La Vie'
//     ];

//     return ListView.builder(
//       itemCount: suggestions.length,
//       itemBuilder: (context, index) {
//         return ListTile(
//           title: Text(suggestions[index]),
//           onTap: () {
//             query = suggestions[index];
//             showResults(context);
//           },
//         );
//       },
//     );
//   }
// }