import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

void main() {
  runApp(MyApp());
}

/// The main application widget.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Consulta de CNPJ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CNPJConsulta(),
    );
  }
}

/// The widget for CNPJ consultation.
class CNPJConsulta extends StatefulWidget {
  @override
  _CNPJConsultaState createState() => _CNPJConsultaState();
}

class _CNPJConsultaState extends State<CNPJConsulta> {
  final MaskedTextController _controller =
      MaskedTextController(mask: '00.000.000/0000-00');
  late Map<String, dynamic>? _dadosCNPJ;

  @override
  void initState() {
    super.initState();
    _dadosCNPJ = null;
  }

  /// Removes formatting from the CNPJ string.
  String _removeFormatting(String cnpj) {
    return cnpj.replaceAll(RegExp(r'\D'), '');
  }

  /// Consults the CNPJ using the provided CNPJ string.
  Future<void> _consultarCNPJ(String cnpj) async {
    final formattedCNPJ = _removeFormatting(cnpj);
    final response = await http
        .get(Uri.parse('https://publica.cnpj.ws/cnpj/$formattedCNPJ'));
    if (response.statusCode == 200) {
      setState(() {
        _dadosCNPJ = json.decode(response.body);
      });
    } else {
      setState(() {
        _dadosCNPJ = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erro ao consultar CNPJ'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consulta de CNPJ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Digite o CNPJ',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _consultarCNPJ(_controller.text);
              },
              child: Text('Consultar'),
            ),
            SizedBox(height: 16),
            _dadosCNPJ != null ? _buildDadosCNPJ() : Container(),
          ],
        ),
      ),
    );
  }

  /// Builds the widget to display the CNPJ data.
  Widget _buildDadosCNPJ() {
    return Expanded(
      child: ListView(
        children: [
          ListTile(
            title: Text('Razão Social'),
            subtitle: Text(_dadosCNPJ?['razao_social'] ?? 'N/A'),
          ),
          ListTile(
            title: Text('Nome Fantasia'),
            subtitle:
                Text(_dadosCNPJ?['estabelecimento']['nome_fantasia'] ?? 'N/A'),
          ),
          ListTile(
            title: Text('Situação Cadastral'),
            subtitle: Text(
                _dadosCNPJ?['estabelecimento']['situacao_cadastral'] ?? 'N/A'),
          ),
          ListTile(
            title: Text('Capital Social'),
            subtitle: Text(_dadosCNPJ?['capital_social'] ?? 'N/A'),
          ),
          ListTile(
            title: Text('Atividade Principal'),
            subtitle: Text(_dadosCNPJ?['estabelecimento']['atividade_principal']
                    ['descricao'] ??
                'N/A'),
          ),
          ListTile(
            title: Text('Porte'),
            subtitle: Text(_dadosCNPJ?['porte']['descricao'] ?? 'N/A'),
          ),
          ListTile(
            title: Text('Natureza Jurídica'),
            subtitle:
                Text(_dadosCNPJ?['natureza_juridica']['descricao'] ?? 'N/A'),
          ),
          ListTile(
            title: Text('Qualificação do Responsável'),
            subtitle: Text(_dadosCNPJ?['qualificacao_do_responsavel']
                    ['descricao'] ??
                'N/A'),
          ),
          ListTile(
            title: Text('Logradouro'),
            subtitle:
                Text(_dadosCNPJ?['estabelecimento']['logradouro'] ?? 'N/A'),
          ),
          ListTile(
            title: Text('Número'),
            subtitle: Text(_dadosCNPJ?['estabelecimento']['numero'] ?? 'N/A'),
          ),
          ListTile(
            title: Text('Bairro'),
            subtitle: Text(_dadosCNPJ?['estabelecimento']['bairro'] ?? 'N/A'),
          ),
          ListTile(
            title: Text('CEP'),
            subtitle: Text(_dadosCNPJ?['estabelecimento']['cep'] ?? 'N/A'),
          ),
          ListTile(
            title: Text('Cidade'),
            subtitle:
                Text(_dadosCNPJ?['estabelecimento']['cidade']['nome'] ?? 'N/A'),
          ),
          ListTile(
            title: Text('Estado'),
            subtitle:
                Text(_dadosCNPJ?['estabelecimento']['estado']['nome'] ?? 'N/A'),
          ),
          ListTile(
            title: Text('Telefone'),
            subtitle: Text(
                '${_dadosCNPJ?['estabelecimento']['ddd1'] ?? ''} ${_dadosCNPJ?['estabelecimento']['telefone1'] ?? ''}'),
          ),
          ListTile(
            title: Text('Fax'),
            subtitle: Text(
                '${_dadosCNPJ?['estabelecimento']['ddd_fax'] ?? ''} ${_dadosCNPJ?['estabelecimento']['fax'] ?? ''}'),
          ),
          ListTile(
            title: Text('Email'),
            subtitle: Text(_dadosCNPJ?['estabelecimento']['email'] ?? 'N/A'),
          ),
          ListTile(
            title: Text('Situação Especial'),
            subtitle: Text(
                _dadosCNPJ?['estabelecimento']['situacao_especial'] ?? 'N/A'),
          ),
          ListTile(
            title: Text('Data da Situação Especial'),
            subtitle: Text(_dadosCNPJ?['estabelecimento']
                    ['data_situacao_especial'] ??
                'N/A'),
          ),
          ListTile(
            title: Text('Data de Início da Atividade'),
            subtitle: Text(_dadosCNPJ?['estabelecimento']
                    ['data_inicio_atividade'] ??
                'N/A'),
          ),
          ListTile(
            title: Text('Atividades Secundárias'),
            subtitle: Column(
              children: (_dadosCNPJ?['estabelecimento']
                      ['atividades_secundarias'] as List)
                  .map((atividade) {
                return ListTile(
                  title: Text(atividade['descricao'] ?? 'N/A'),
                );
              }).toList(),
            ),
          ),
          ListTile(
            title: Text('Inscrições Estaduais'),
            subtitle: Column(
              children: (_dadosCNPJ?['estabelecimento']['inscricoes_estaduais']
                      as List)
                  .map((inscricao) {
                return ListTile(
                  title: Text(inscricao['inscricao_estadual'] ?? 'N/A'),
                  subtitle: Text(inscricao['estado']['nome'] ?? 'N/A'),
                );
              }).toList(),
            ),
          ),
          ListTile(
            title: Text('Sócios'),
            subtitle: Column(
              children: (_dadosCNPJ?['socios'] as List).map((socio) {
                return ListTile(
                  title: Text(socio['nome'] ?? 'N/A'),
                  subtitle:
                      Text(socio['qualificacao_socio']['descricao'] ?? 'N/A'),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
