import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:product_list/widgets/product_list.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  late String _token;
  String _errorMessage = "";
  bool _isSuccess = false;
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  Future<bool> login(String email, String password) async{
    try {
      Response res = await post(Uri.parse("https://test.renecv.com/authenticate"),
      body: {
        'user': email,
        'password': password
      });
      if (res.statusCode == 200 || res.statusCode == 201) {
        _token = res.headers['authorization'] as String;
        SharedPreferences userPrefs = await SharedPreferences.getInstance();
        userPrefs.setString("token", _token);
        setState(() {
          _isSuccess = true;
        });
        return true;
      }
    } catch(e) {
      setState((){
        _errorMessage="Invalid credentials. Please try againflutter";
      });
      return false;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(

        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage("icons/login_bg1.jpg"))
              )
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(

              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    hintText: 'Email Address',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder()
                  ),
                    onChanged: (text) {
                      setState(() {
                        _errorMessage = "";
                      }
                      );
                    }
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _pwdController,
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      hintText: 'Password',
                        filled: true,
                        fillColor: Colors.white,
                        border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                            _passwordVisible ? Icons.visibility: Icons.visibility_off
                        ), onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });

                      },
                      )
                    ),

                ),
                const SizedBox(height: 20),
                Text(_errorMessage, style: const TextStyle(color: Colors.white)),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () async {
                    if(!EmailValidator.validate(_emailController.text.toString())) {
                      setState((){
                        _errorMessage = "Invalid email format";
                      });
                      return;
                    }
                    try {
                      Future<bool> _ = (await login(_emailController.text
                          .toString(),
                          _pwdController.text.toString())) as Future<bool>;
                    }catch (e) {
                      setState((){
                        _errorMessage = "Invalid credentials";
                      });
                    }

                    if (_isSuccess) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const ProductListPage(title: 'Product List',)
                        )
                      );
                    }
                  },
                  child: Container(
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xff0c7cc0),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: const Center(
                      child: Text("Sign in",
                      style: TextStyle(color: Colors.white, fontSize: 12)
                      )
                    )


                  )
                )

              ],
          ),
            ),
          ],

        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
