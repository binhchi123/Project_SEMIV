import 'package:flutter/material.dart';
import 'package:project_4/models/category.dart';
import 'package:project_4/models/product.dart';
import 'package:project_4/screens/cart_screen.dart';
import 'package:project_4/screens/category_screen.dart';
import 'package:project_4/screens/details_screen.dart';
import 'package:project_4/screens/login_screen.dart';
import 'package:project_4/screens/product_screen.dart';
import 'package:project_4/screens/profile_screen.dart';
import 'package:project_4/screens/register_screen.dart';
import 'package:project_4/screens/search_screen.dart';
import 'package:project_4/services/account_service.dart';
import 'package:project_4/services/category_service.dart';
import 'package:project_4/services/product_service.dart';
class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Category>> categories;
  late Future<List<Product>> products;
  final AccountService _accountService = AccountService();
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
                    // ListTile(
                    //   leading: Icon(Icons.list, color: Colors.blueGrey[700]),
                    //   title: Text('Đơn hàng'),
                    //   onTap: () {
                    //     Navigator.of(context).push(
                    //       MaterialPageRoute(builder: (context) => OrderPage()),
                    //     );
                    //   },
                    // ),
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
                      child: Stack(
                        children: <Widget>[
                          Image.asset('assets/images/img_1.jpg'),
                          Positioned(
                            top: 150,
                            left: 140,
                            child: Text(
                              'BURBERRY\n\t\tLONDON\n\tENGLAND',
                              style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                              ),
                            ),
                          ),
                          // Positioned(
                          //   bottom: 100,
                          //   left: 160,
                          //   child: Text(
                          //     'MUA NGAY',
                          //     style: TextStyle(
                          //       fontSize: 20,
                          //       color: Colors.white,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    SizedBox(height: 25,),
                    Align(
                      alignment: Alignment.center,
                      child: Stack(
                        children: <Widget>[
                          Image.asset('assets/images/img_2.jpg'),
                          Positioned(
                            top: 170,
                            left: 140,
                            child: Text(
                              'GUCCI',
                              style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                              ),
                            ),
                          ),
                          // Positioned(
                          //   bottom: 150,
                          //   left: 130,
                          //   child: Text(
                          //     'MUA NGAY',
                          //     style: TextStyle(
                          //       fontSize: 20,
                          //       color: Colors.white,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    SizedBox(height: 25,),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: TextButton(onPressed: (){},
                            child: Text(
                              'SẢN PHẨM',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                              ),
                            ),)
                      ),
                    ),
                    SizedBox(height: 25,),
                    FutureBuilder(
                      future: products,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Center(child: Text("Error occurred: ${snapshot.error}"));
                        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                          final data = snapshot.data!;
                          return LayoutBuilder(
                            builder: (context, constraints) {
                              return GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10.0,
                                  mainAxisSpacing: 20.0,
                                ),
                                itemCount: data.length < 8 ? data.length : 8,
                                itemBuilder: (context, index) {
                                  final product = data[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DetailPage(productId: product.productID),
                                        ),
                                      );
                                    },
                                    child: _buildImageWithDetails(
                                      imagePath: 'http://art.somee.com/images/${product.imageUrl}',
                                      name: product.productName,
                                      price: '${product.price.toString()} đ',
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
                    SizedBox(height: 25,),
                    OutlinedButton(onPressed: () => {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => ProductPage()),
                        ),
                      },
                      style: OutlinedButton.styleFrom( 
                        padding: EdgeInsets.fromLTRB(50, 15, 50, 15)
                      ),
                      child: Text('Xem tất cả', style: TextStyle(color: Colors.black),)
                    ),
                    SizedBox(height: 25,),
                    Align(
                      alignment: Alignment.center,
                      child: Stack(
                        children: <Widget>[
                          Image.asset('assets/images/img_3.jpg'),
                          Positioned(
                            top: 170,
                            left: 100,
                            child: Text(
                              'BALENCIAGA',
                              style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                              ),
                            ),
                          ),
                          // Positioned(
                          //   bottom: 150,
                          //   left: 140,
                          //   child: Text(
                          //     'MUA NGAY',
                          //     style: TextStyle(
                          //       fontSize: 20,
                          //       color: Colors.white,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    SizedBox(height: 25,),
                    Align(
                      alignment: Alignment.center,
                      child: Stack(
                        children: <Widget>[
                          Image.asset('assets/images/img_4.jpg'),
                          Positioned(
                            top: 170,
                            left: 90,
                            child: Text(
                              'ACME DE LA VIE',
                              style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                              ),
                            ),
                          ),
                          // Positioned(
                          //   bottom: 150,
                          //   left: 140,
                          //   child: Text(
                          //     'MUA NGAY',
                          //     style: TextStyle(
                          //       fontSize: 20,
                          //       color: Colors.white,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
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