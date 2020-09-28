import 'package:flutter/material.dart';

import 'package:form_validation/src/models/producto_model.dart';
import 'package:form_validation/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:form_validation/src/providers/producto_provider.dart';
// import 'package:form_validation/src/bloc/provider.dart';

class HomePage extends StatelessWidget {

  final productosProvider = new ProductoProvider();
  static final String routeName = 'home';
  final prefs = new PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {

    // final bloc = Provider.of(context);
    prefs.ultimaPagina = HomePage.routeName;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Home')
      ),
      body: _obtenerListaProductos(),

      floatingActionButton: _crearBoton(context),
    );
  }

  Widget _obtenerListaProductos(){

    return FutureBuilder(
      future: productosProvider.obtenerProductos(),
      builder: (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {
        
        if(snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) => _crearItem(context, snapshot.data[index]),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _crearItem(BuildContext context, ProductoModel producto) {

    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red
      ),
      onDismissed: (direccion) => productosProvider.borrarProducto(producto.id),

      child: Card(
        child: Column(
          children: <Widget>[

            ( producto.imgUrl == null )
              ? Image(image: AssetImage('assets/no-image.png'))
              : FadeInImage(
                  image: NetworkImage( producto.imgUrl ),
                  placeholder: AssetImage('assets/jar-loading.gif'),
                  height: 300.0,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              
              ListTile(
                title: Text('${ producto.titulo } - ${ producto.valor }'),
                subtitle: Text(producto.id),
                onTap: () => Navigator.pushNamed(context, 'producto', arguments: producto),
              ),

          ]
        ),
      ),
    );
  }

  _crearBoton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.deepPurple,
      onPressed: ()=> Navigator.pushNamed(context, 'producto'),
    );
  }

}