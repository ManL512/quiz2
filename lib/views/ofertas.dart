import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'viewproduct.dart';

class Product {
  final String articulo;
  final String calificaciones;
  final String valoracion;
  final String precio;
  final String descuento;
  final String descripcion;
  final String urlimagen;

  Product(
      {required this.articulo,
      required this.calificaciones,
      required this.valoracion,
      required this.precio,
      required this.descuento,
      required this.descripcion,
      required this.urlimagen});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      articulo: json['articulo'],
      calificaciones: json['calificaciones'],
      valoracion: json['valoracion'],
      precio: json['precio'],
      descuento: json['descuento'],
      descripcion: json['descripcion'],
      urlimagen: json['urlimagen'],
    );
  }
}

class HomePageO extends StatefulWidget {
  const HomePageO({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePageO> {
  List<Product> products = [];
  bool isHorizontalView = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    const url = 'https://api.npoint.io/9d122573b46e2ac7a185';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)["articulos"];
      List<Product> filteredProducts = [];

      for (var item in data) {
        Product product = Product.fromJson(item);
        // Verifica si el producto tiene un descuento diferente de "0"
        if (product.descuento != "0") {
          filteredProducts.add(product);
        }
      }

      setState(() {
        products = filteredProducts;
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  void toggleView() {
    setState(() {
      isHorizontalView = !isHorizontalView;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
        actions: const [],
      ),
      body: isHorizontalView ? _buildHorizontalView() : _buildVerticalView(),
    );
  }

  Widget _buildVerticalView() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.6,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return _buildCard(products[index]);
      },
    );
  }

  Widget _buildHorizontalView() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 2.5,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return _buildCard(products[index]);
      },
    );
  }

  String calculateDiscountedPrice(String precioStr, String descuentoStr) {
    int precio = int.parse(precioStr);
    int descuento = descuentoStr.isNotEmpty ? int.parse(descuentoStr) : 0;
    double precioConDescuento = precio - (precio * descuento / 100);
    return '${precioConDescuento.toStringAsFixed(2)}${descuento != 0 ? ' (${descuento}% OFF)' : ''}';
  }

  Widget _buildCard(Product product) {
    void verPerfil() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetails(
            articulo: product.articulo,
            calificaciones: product.calificaciones,
            valoracion: product.valoracion,
            precio: product.precio,
            descuento: product.descuento,
            descripcion: product.descripcion,
            urlimagen: product.urlimagen,
          ),
        ),
      );
    }

    return SizedBox(
      child: Card(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: isHorizontalView
                  ? Row(
                      children: [
                        Center(
                          child: Image.network(
                            product.urlimagen,
                            width: 100,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.articulo,
                                  style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                    'Precio: ${calculateDiscountedPrice(product.precio, product.descuento)}'),
                                Text('Calificación: ${product.valoracion}'),
                              ],
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: verPerfil,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            backgroundColor:
                                const Color.fromARGB(255, 0, 0, 255),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(0.0),
                            child: Text(
                              "View",
                              style: TextStyle(
                                fontSize: 10.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Image.network(
                              product.urlimagen,
                              width: double.infinity,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            product.articulo,
                            style: const TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8.0),
                          Text('Precio: ${product.precio}'),
                          Text('Calificación: ${product.valoracion}'),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
