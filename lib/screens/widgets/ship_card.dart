import 'package:correios_frete/correios_frete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_correios/flutter_correios.dart';
import 'package:flutter_correios/model/resultado_cep.dart';

class ShipCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ExpansionTile(
        title: Text(
          "Calcular Frete",
          textAlign: TextAlign.start,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        leading: Icon(Icons.location_on),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8),
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "CEP",
              ),
              initialValue: "",
              onFieldSubmitted: (text) async {
                if (text.length == 8) {
                  /*
                  FlutterCorreios fc = FlutterCorreios();
                  ResultadoCEP resultado = await fc.consultarCEP(cep: text);

                  print("bairro: ${resultado.bairro}");
                  print("cidade: ${resultado.cidade}");
                  print("estado: ${resultado.estado}");
                  print("logradouro: ${resultado.logradouro}");
                  print("   Estado Km2: ${resultado.estadoInfo.areaKm2}");
                  print("   Estado IBGE: ${resultado.estadoInfo.codigoIBGE}");
                  print("   Estado Nome: ${resultado.estadoInfo.nome}");
                  print("   Cidade Km2: ${resultado.cidadeInfo.areaKm2}");
                  print("   Cidade IBGE: ${resultado.cidadeInfo.codigoIBGE}");

                  

                  Result result = await CalcPriceTerm(
                    "",
                    "",
                    "04014",
                    "58814000",
                    text,
                    "10",
                    "1",
                    '20',
                    "20",
                    "20",
                    "${20 * 20 * 20}",
                    "N",
                    "0",
                    "N",
                    "xml",
                    "3",
                  );

                  print("\n\n\nPreço do frete: R\$ ${result.valor}\n\n");*/
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
