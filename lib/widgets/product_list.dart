import 'dart:convert';
import 'dart:io';
import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/products.dart';
import 'login_page.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key, required this.title});

  final String title;

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  late Future<Products?> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = getProducts();
  }

  void handleClick(String value) {
    switch (value) {
      case 'Logout':
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) => const LoginPage(title: 'Sign In',)
            )
        );
        break;
      default:
        break;
    }
  }

  Future<Products?> getProducts() async{
    try {
      SharedPreferences userPrefs = await SharedPreferences.getInstance();
      String? token = userPrefs.getString("token");
      String? _token;

      if(token != null) {
        _token = token;
      } else {
        return null;
      }

      Response res = await get(Uri.parse("https://test.renecv.com/products?contactId=523452355"),
      headers : {
        HttpHeaders.authorizationHeader: _token
      });
      if (res.statusCode == 200 || res.statusCode == 201) {
        final body = json.decode(res.body);
        Products products = Products.fromJson(body);
        return products;
      }
    } catch(e) {
      return null;
    }
    return null;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child:
        Text('Welcome iOS TEST',
          style: TextStyle(color: Colors.white),
        ),
        ),
        backgroundColor: const Color(0xff0c7cc0),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            color: Colors.white,
            tooltip: 'Speak',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Not yet implemented')));
            },
          ),
          PopupMenuButton<String>(
            color: Colors.white,
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'My Settings', 'Help', 'Report Technical Issue', 'Terms and Conditions', 'About', 'Logout'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),

        ],
      ),
      body: Stack(

        children: [

          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              alignment: Alignment.topLeft,
              child: Image.asset("icons/product_bg2.jpg"),
            ),
          ),
          Column(
            children: [
              const SizedBox(height:200),
              Expanded(
                child: FutureBuilder (
                  future: _productsFuture,

                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasData) {
                      final products = snapshot.data!;
                      return buildProducts(products, context);
                    } else {
                      return const Text("No data available");
                    }
                  }
        ),
              ),
            ],
          )]
      ),
    );
  }

  Widget buildProducts(Products products, BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 200, minHeight: 56.0),
      child: ListView.builder(
        itemCount: products.resultList?.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final product = products.resultList?[index];
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            width: double.maxFinite,
              decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(20))
              ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child:
                        (ResultList.productTitle[product!.accountType.toString()].split(" ").length > 1 ||
                            ResultList.productTitle[product.accountType.toString()].split("™").length > 1 ||
                            ResultList.productTitle[product.accountType.toString()].split("Ⓡ").length > 1) ?
                        Row(
                          children:
                            getRichText(ResultList.productTitle[product.accountType.toString()])
                          ,
                        ):
                        Text(
                            ResultList.productTitle[product.accountType.toString()],
                            style: const TextStyle(fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,)
                        ),
                      ),
                      const SizedBox(width: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(ResultList.productDescription[product.accountType.toString()],
                          style: const TextStyle(fontSize: 16,

                            color: Colors.white,),
                        ),
                      )
                    ]
                  ),
                ),
                Expanded(
                flex: 1,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(15.0),
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: (product.signedUp != null && product.signedUp == true) ? const Color(0xff3FAE29): const Color(0xff0c7cc0))
                        ),
                        child: Text(
                            (product.accountType.toString() == "SECURUSDEBIT") ? "FUND NOW" : (product.signedUp != null && product.signedUp == true) ? "LAUNCH": "SIGNUP",
                          style: TextStyle(color: (product.accountType.toString() == "SMC")? const Color(0xff3FAE29): (product.signedUp != null && product.signedUp == true) ? const Color(0xff3FAE29): const Color(0xff0c7cc0))
                        ),
                      ),
                    ]
                  ),
                )

              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> getRichText(productTitle) {
    List<String> titleParts = productTitle.split(" ");
    if (titleParts.length == 1 && productTitle.contains("™")) {
      titleParts[1] = "™";
    }
    if (titleParts.length == 1 && productTitle.contains("®")) {
      titleParts[1] = "®";
    }
    if (titleParts.length > 2) {
      titleParts[1] = titleParts.sublist(1).join(' ');
    }
    List<Widget> result =
    [
        Text(
          titleParts[0],
          style: const TextStyle(fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,)
      ),
      const SizedBox(width:5),
      EasyRichText(
        titleParts[1],
        defaultStyle: const TextStyle(fontSize: 20,
          color: Colors.white,),
        patternList: [
          titleParts[1].contains("™")?
          EasyRichTextPattern(
            targetString: '™',
            superScript: true,
            matchWordBoundaries: true,
            style: const TextStyle(fontSize: 12,
              color: Colors.white,
            ),
          ):
          EasyRichTextPattern(
            targetString: '®',
            superScript: true,
            matchWordBoundaries: true,
            style: const TextStyle(fontSize: 12,
              color: Colors.white,
            ),
          ),
        ]
      ),
      (productTitle.contains("TEXT CONNECT")?
      EasyRichText(
          "Limited Availability",
          defaultStyle: const TextStyle(fontSize: 10,
            color: Colors.white,),
          patternList: [
            EasyRichTextPattern(
              targetString: 'Limited Availability',
              superScript: true,
              matchWordBoundaries: true,
              style: const TextStyle(fontSize: 12,
                color: Color(0xffc0392b),
              ),
            )
          ]
      )
      :Container())
    ];
    return result;
  }

}

