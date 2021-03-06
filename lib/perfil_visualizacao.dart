import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import './custom_widgets/oiaWidgets.dart';
import './infrastructure/constants.dart';
import 'custom_widgets/oiaWidgets.dart';
import './infrastructure/imageProvider.dart';
import 'infrastructure/database_integration.dart';
import 'infrastructure/imageProvider.dart';

class WorkerProfile extends StatefulWidget {
  @override
  _WorkerProfileState createState() => _WorkerProfileState();
}

class _WorkerProfileState extends State<WorkerProfile> {
  String _uid, _tag, nomeUsuario, _descricao;
  num _valorMedio;

  final imageProvider = OiaImageProvider();
  final cartaServicosController = CartaServicosController();

  Future<List> _imagens;
  List _imagensURL;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;

    setState(() {
      _uid = args['uid'];
      _tag = args['tag'];
      nomeUsuario = args['nome'];

      cartaServicosController.get(_uid).then((value) {
        Map cartaServicos = value.cartaServicos;
        _descricao = cartaServicos[_tag]['descricao'];
        _valorMedio = cartaServicos[_tag]['valorMedio'];
      });

      _imagens = Future.delayed(
        Duration(seconds: 4),
        () => imageProvider.getAllImagesOfAService(_uid, _tag),
      );
    });

    return OiaScaffold(
      showBottomBar: true,
      appBarTitle: nomeUsuario,
      body: FutureBuilder(
          future: _imagens,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                _imagensURL = snapshot.data ?? [];
                return _buildBody();
                break;
              case ConnectionState.none:
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Não foi possível recuperar as imagens...")));
                return Container();
                break;
              default:
                return Center(
                  child: CircularProgressIndicator(),
                );
                break;
            }
          }),
    );
  }

  _buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Constants.SMALL_HEIGHT_BOX,
          _buildCarousel(_imagensURL),
          Constants.LARGE_HEIGHT_BOX,
          Container(
            decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10)),
            padding: EdgeInsets.all(Constants.smallSpace),
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Descrição",
                  style: TextStyle(
                      fontSize: Constants.mediumFontSize,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                Constants.SMALL_HEIGHT_BOX,
                Text(
                  _descricao ?? "",
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: Constants.regularFontSize),
                ),
              ],
            ),
          ),
          Constants.MEDIUM_HEIGHT_BOX,
          Container(
            decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10)),
            padding: EdgeInsets.all(Constants.smallSpace),
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Valor Médio",
                  style: TextStyle(
                      fontSize: Constants.mediumFontSize,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                Constants.SMALL_HEIGHT_BOX,
                Text(
                  _valorMedio == 0 || _valorMedio == null
                      ? "Sem preço definido"
                      : "R\$ $_valorMedio",
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: Constants.regularFontSize),
                ),
              ],
            ),
          ),
          Constants.LARGE_HEIGHT_BOX,
          OiaLargeButton(
            title: "Encontrar no mapa",
            onPressed: () {
              Navigator.pushNamed(context, '/map', arguments: _uid);
            },
          ),
          // TODO: Implementar tela de salvar contato
          OiaLargeButton(
            title: "Salvar contato",
            onPressed: () {},
          ),
          Constants.MEDIUM_HEIGHT_BOX,
        ],
      ),
    );
  }

  _buildCarousel(List imagens) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.35,
      width: MediaQuery.of(context).size.width * 0.8,
      child: Carousel(
        images: imagens.map((e) => Image.network(e)).toList(),
        borderRadius: true,
        autoplay: false,
        animationDuration: Duration(milliseconds: 600),
      ),
    );
  }
}
