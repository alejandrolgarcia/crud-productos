import 'package:flutter/material.dart';
import 'package:form_validation/src/models/producto_model.dart';
import 'package:form_validation/src/providers/producto_provider.dart';
import 'package:form_validation/src/utils/utils.dart' as utils;

class ProductoPage extends StatefulWidget {

  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {

  final formKey          = GlobalKey<FormState>();
  final scaffoldKey      = GlobalKey<ScaffoldState>();
  final productoProvider = new ProductoProvider();

  ProductoModel producto = ProductoModel();
  bool _guardado = false;


  @override
  Widget build(BuildContext context) {

    final ProductoModel productoData = ModalRoute.of(context).settings.arguments;

    if( productoData != null ) {
      producto = productoData;
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Producto'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.photo_size_select_actual),
            onPressed: (){}
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: (){}
          )
        ],
      ),

      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _crearProducto(),
                _crearPrecio(),
                _crearDisponible(),
                _crearBoton()
              ],
            ),

          )
        ),
      ),
      
    );
  }

  Widget _crearProducto(){
    return TextFormField(
      initialValue: producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Producto'
      ),

      onSaved: (value) => producto.titulo = value,

      validator: (value) {
        if( value.length < 3 ) {
          return 'Ingrese el nombre del producto';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearPrecio(){
    return TextFormField(
      initialValue: producto.valor.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Precio'
      ),

      onSaved: (value) => producto.valor = double.parse(value),

      validator: (value) {
        if(utils.isNumeric(value)) {
          return null;
        } else {
          return 'Solo debe ingresar números';
        }
      }
    );
  }

  Widget _crearBoton(){
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0)
      ),
      color: Colors.deepPurple,
      textColor: Colors.white,
      label: Text('Guardar'),
      icon: Icon(Icons.save),
      onPressed: (_guardado) ? null : _submit,
    );
  }

  Widget _crearDisponible() {

    return SwitchListTile(
      value: producto.disponible,
      title: Text('Disponible'),
      activeColor: Colors.deepPurple,
      onChanged: (value) => setState((){
        producto.disponible = value;
      }),
    );
  }

  void _submit() {
    
    if (!formKey.currentState.validate()) return;

    formKey.currentState.save();

    setState(() {_guardado = true;});

    if(producto.id == null ) {
      productoProvider.crearProducto(producto);
    } else {
      productoProvider.editarProducto(producto);
    }

    mostrarSnackbar('Producto guardado');
    Navigator.pop(context);
  }

  void mostrarSnackbar(String mensaje) {
    
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500),
    );

    scaffoldKey.currentState.showSnackBar(snackbar);

  }
  
}