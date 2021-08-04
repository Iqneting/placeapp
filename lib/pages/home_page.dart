//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:places_app/components/afiliados_slider.dart';
import 'package:places_app/components/noticias_slider.dart';
import 'package:places_app/components/search_address_map.dart';
import 'package:places_app/components/web_view.dart';

import 'package:places_app/menu.dart';
import 'package:places_app/models/anuncio.model.dart';
import 'package:places_app/shared/user_preferences.dart';
import 'package:places_app/storage/App.dart';
import 'package:provider/provider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class HomePage extends StatefulWidget {
  static final String routeName = '/';

  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Anuncio> anuncios = [];
  bool isLoading = true;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  Size _size;
  UserPreferences preferences = new UserPreferences();

  AppState appState = new AppState();

  @override
  void initState() {
    super.initState();
    this.initData();
  }

  void initData() async {
    this.anuncios = await Anuncio.fetchData();
    print(anuncios);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    appState = Provider.of<AppState>(context);
    _size = MediaQuery.of(context).size;
    final arg = ModalRoute.of(context).settings.arguments;

    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    print('Mensaje recibido desde notificacion $arg');

    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      drawer: MenuBar(),
      body: _stack(),
    );
  }

  Widget _stack() {
    return Stack(
      children: <Widget>[
        _body(),
        Positioned(
          left: 10,
          top: 25,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(200.0),
            ),
            child: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => scaffoldKey.currentState.openDrawer(),
             /* onPressed: () => showMaterialModalBottomSheet(
  context: context,
  builder: (context) => SearchAddressMap(),
)*/
              
             
            ),
          ),
        ),
      ],
    );
  }

  Widget _body() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 25.0),
            _publicidad(),
            SizedBox(height: 25.0),
            _title("Servicios"),
            AfiliadosCarousel(),
            SizedBox(height: 5.0),
            _title("Contenido"),
            NoticiasSlider(),
          ],
        ),
      ),
    );
  }

  Widget _title(String title) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 10.0),
      child: Text(
        title,
        textAlign: TextAlign.left,
        style: TextStyle(
          color: Colors.grey.shade800,
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.3,
        ),
      ),
      margin: EdgeInsets.only(
        bottom: 20.0,
      ),
    );
  }

  Widget _publicidad() {
    return Container(
      margin: EdgeInsets.only(top: 30.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      height: _size.height < 100 ? _size.height * 0.25 : 250.0,
      child: new Swiper(
        itemBuilder: (BuildContext context, int index) {
          return Stack(
            children: [
              new Image.network(
                anuncios[index].imagen,
                fit: BoxFit.fill,
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: Container()),
                      Padding(
                        padding: const EdgeInsets.only(right: 20, top: 20),
                        child: Center(
                          child: RaisedButton(
                            color: Colors.white60,
                            shape:  Border.all(
                              color: Colors.red,
                              width: 1.0,
                            ),
                            child: Row(
                              children: [
                                Text('Ver')
                              // })
                              ],
                            ),
                            onPressed:(){
                              if (anuncios[index].link.isNotEmpty) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            WebViewComponent(
                                                anuncios[index].link)),
                                  );
                                }
                            }
                          
                              //                         child: IconButton(
                              // icon: Icon(Icons.add,size: 20,color: Colors.redAccent,),
                              // onPressed: () {
                              //   if (anuncios[index].link.isNotEmpty) {
                              //     Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //           builder: (context) =>
                              //               WebViewComponent(
                              //                   anuncios[index].link)),
                              //     );
                              //   }
                              // }),
                        )),
                      )
                    ],
                  ),
                ],
              )
            ],
          );
        },
        autoplay: true,
        itemCount: anuncios.length,
        pagination: new SwiperPagination(),
      ),
    );
  }
}
