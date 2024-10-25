import 'package:flutter/material.dart';
import 'package:project_4/models/category.dart';
import 'package:project_4/models/product.dart';
import 'package:project_4/screens/cart_screen.dart';
import 'package:project_4/screens/category_screen.dart';
import 'package:project_4/screens/home_screen.dart';
import 'package:project_4/screens/login_screen.dart';
import 'package:project_4/screens/profile_screen.dart';
import 'package:project_4/screens/register_screen.dart';
import 'package:project_4/screens/search_screen.dart';
import 'package:project_4/services/account_service.dart';
import 'package:project_4/services/category_service.dart';
import 'package:project_4/services/order_service.dart';
import 'package:project_4/services/product_service.dart';
class OrderPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List<dynamic> _orderItems = [];
  late Future<List<Category>> categories;
  late Future<List<Product>> products;
  final AccountService _accountService = AccountService();
  final OrderService _orderService = OrderService();
  String? _userName;
  bool _isLoggedIn = false;
  @override
  void initState() {
    super.initState();
    categories = CategoryService.getAll();
    products = ProductService.getAll();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    try {
      final userInfo = await _accountService.getMe(); 
      setState(() {
        _userName = userInfo['userName']; 
        _isLoggedIn = true;
      });
    } catch (e) {
      print('Error fetching user info: $e');
    }
  }

  // Tải order từ API
  void _loadOrder() async {
    try {
      List<dynamic> items = await _orderService.getOrdersByAccount();
      if (mounted) {
        setState(() {
          _orderItems = items; // Cập nhật danh sách sản phẩm
        });
        print(_orderItems);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  Future<void> _logout() async {
    if (_isLoggedIn) {
      try {
        await _accountService.logout(); 
        setState(() {
          _isLoggedIn = false;
          _userName = null;
        });
      } catch (e) {
        print('Error logging out: $e');
      }
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginPage()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                  child: Image.asset('assets/images/logo.png'),
                ),
              ),
              backgroundColor: Colors.black,
              automaticallyImplyLeading: true,
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    showSearch(context: context, delegate: CustomSearchDelegate());
                  },
                ),
                IconButton(
                  icon: Icon(Icons.card_travel),
                  onPressed: () => {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => CartPage()),
                    )
                  },
                ),
              ],
            ),
            drawer: Drawer(
              child: Column(
                children: <Widget>[
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Color(0xFF2C3848),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        _userName != null ? 'Hello $_userName' : 'Menu',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  if (_isLoggedIn) ...[
                    ListTile(
                      leading: Icon(Icons.person, color: Colors.blueGrey[700]),
                      title: Text('Hồ sơ'),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => ProfilePage()),
                        );
                      },
                    ),
                  ],
                  ListTile(
                    leading: Icon(Icons.home, color: Colors.blueGrey[700]),
                    title: Text('Trang chủ'),
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    },
                  ),
                  Expanded(
                    child: FutureBuilder(
                      future: categories,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Center(child: Text("Error occurred: ${snapshot.error}"));
                        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                          final data = snapshot.data!;
                          return ListView.separated(
                            itemCount: data.length,
                            separatorBuilder: (context, index) => SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final category = data[index];
                              return ListTile(
                                leading: Icon(Icons.category, color: Colors.blueGrey[700]),
                                title: Text(category.categoryName),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CategoryPage(categoryId: category.categoryID),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        } else {
                          return Center(child: Text("No data available"));
                        }
                      },
                    ),
                  ),    
                  ListTile(
                    leading: Icon(Icons.login, color: Colors.blueGrey[700]),
                    title: Text(_isLoggedIn ? 'Đăng xuất' : 'Đăng nhập'),
                    onTap: _logout,
                  ),          
                  if (!_isLoggedIn)
                  ListTile(
                    leading: Icon(Icons.person_add, color: Colors.blueGrey[700]),
                    title: Text('Đăng ký'),
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(5),
              child: Container(
                child: Column(
                  children: [           
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: TextButton(onPressed: (){},
                            child: Text(
                              'Đơn hàng',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                              ),
                            ),)
                      ),
                    ),
                    SizedBox(height: 25,),
                       ListView.builder(
                            shrinkWrap: true,
                            itemCount: _orderItems.length,
                            itemBuilder: (context, index) {
                              final item = _orderItems[index];
                              final product = item['product'];
                              String imageUrl = product != null ? 'http://art.somee.com/images/${product['imageUrl']}' : '';
                              String productName = product != null ? product['productName'] : 'Tên sản phẩm không có';
                              double price = product != null ? (product['price'] is int
                                  ? (product['price'] as int).toDouble()
                                  : product['price'] ?? 0.0)
                                  : 0.0;
                              return         Padding(
                      padding: const EdgeInsets.all(0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.favorite, color: Colors.red),
                              Spacer(),
                              Text('Hoàn thành', style: TextStyle(color: Colors.green)),
                            ],
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Image.network(imageUrl, width: 80, height: 80, fit: BoxFit.cover),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(productName, style: TextStyle(fontSize: 16)),
                                  SizedBox(width: 16),
                                  Text('${price .toStringAsFixed(0)}đ', style: TextStyle(fontWeight: FontWeight.bold)),
                                ],
                              ),            
                            ],
                          ),       
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Spacer(), 
                              Align(
                                alignment: Alignment.centerRight,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end, 
                                  children: [
                                    Text('Tổng số tiền: 232,200', 
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                    SizedBox(height: 16),
                                    Row(
                                      mainAxisSize: MainAxisSize.min, 
                                      children: [
                                        OutlinedButton(
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.black,
                                            padding: EdgeInsets.fromLTRB(30, 15, 30, 15)
                                          ),
                                          child: Text('Trả hàng/Hoàn tiền'),
                                        ),
                                        SizedBox(width: 15,),
                                        OutlinedButton(
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.red,
                                            padding: EdgeInsets.fromLTRB(30, 15, 30, 15)
                                          ),
                                          child: Text('Đánh giá'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                            },
                          ),              
                    SizedBox(height: 25,),
                    Text('ĐĂNG KÝ NHẬN TIN',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Nhập EmaiL',
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF86590d),
                        padding: EdgeInsets.fromLTRB(30, 15, 30, 15)
                      ),
                      child: Text('ĐĂNG KÍ'),
                    ),
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                          color: Colors.black,
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Image.asset('assets/images/logo.png', width: 200,),
                              ),
                              SizedBox(height: 25,),
                              Row(
                                children: [
                                  IconButton(onPressed: (){}, icon: Icon(Icons.location_on, color: Colors.white,)
                                  ),
                                  Text('Địa chỉ: Quận 7, TP.HCM', style: TextStyle(color: Colors.white),)
                                ],
                              ),
                              SizedBox(height: 10,),
                              Row(
                                children: [
                                  IconButton(onPressed: (){}, icon: Icon(Icons.phone, color: Colors.white,)
                                  ),
                                  Text('Điện thoại: 0888883200', style: TextStyle(color: Colors.white),)
                                ],
                              ),
                              SizedBox(height: 10,),
                              Row(
                                children: [
                                  IconButton(onPressed: (){}, icon: Icon(Icons.mail, color: Colors.white,)
                                  ),
                                  Text('Email: hunganhparis@gmail.com', style: TextStyle(color: Colors.white),)
                                ],
                              ),
                              SizedBox(height: 20),
                              Center(
                                child: Text(
                                  'Copyright © 2024 Deal Hub',
                                  style: TextStyle(
                                    color: Color(0xFFACACAC),
                                    fontSize: 16,
                                  ),
                                ),
                              )
                            ],
                          )
                      ),
                    ),
                  ],
                ),
              ),
            )
        )
    );
  }
}

Widget _buildImageWithDetails({required String imagePath, required String name, required String price}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Image.network(imagePath, width: 125,),
      SizedBox(height: 8),
      Text(name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      SizedBox(height: 4),
      Text(price, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF417505))),
    ],
  );
}

class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Sử dụng callback sau khi khung hình để điều hướng
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (query.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SearchResultsPage(name: query),
          ),
        );
      } else {
        // Hiển thị thông báo không tìm thấy
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Not Found'),
            content: Text('Không tìm thấy kết quả cho "$query".'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }
    });

    // Trả về một container trống vì chúng ta đang điều hướng đi
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = [
      'Gucci',
      'Balenciaga',
      'Acme De La Vie'
    ];

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestions[index]),
          onTap: () {
            query = suggestions[index];
            showResults(context);
          },
        );
      },
    );
  }
}