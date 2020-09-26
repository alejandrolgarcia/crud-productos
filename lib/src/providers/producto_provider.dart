import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:form_validation/src/models/producto_model.dart';

class ProductoProvider {

  final String _url = 'https://flutter-apps-dcb15.firebaseio.com';

  Future<bool> crearProducto(ProductoModel producto) async{

    final url = '$_url/productos.json';

    final resp = await http.post(url, body: productoModelToJson(producto));

    final decodedData = json.decode(resp.body);

    print(decodedData);
    return true;

  }

}