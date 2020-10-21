import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerenteloja/blocs/products_bloc.dart';
import 'package:gerenteloja/validator/product_validator.dart';
import 'package:gerenteloja/widgets/images_widget.dart';
import 'package:gerenteloja/widgets/products_sizes.dart';

class ProductScreen extends StatefulWidget {

  //category e produto não tão servido para nada somente para enviar esses dados para o bloc
  final String categoryId;
  final DocumentSnapshot product;


  ProductScreen({this.categoryId, this.product});

  @override
  _ProductScreenState createState() => _ProductScreenState(categoryId, product);
}

class _ProductScreenState extends State<ProductScreen> with ProductValidator{

  final ProductBloc _productBloc;

  _ProductScreenState(String categoryId, DocumentSnapshot product) :
        _productBloc = ProductBloc(categoryId: categoryId, product: product);

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();//para utiliar o scaffold na função saverProduct


  @override
  Widget build(BuildContext context) {

    InputDecoration _buildDecoration(String label){//função que retorna a decoração e é possível alterar o label do texto
      return InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey)
      );
    }

    final _fieldStyle = TextStyle(
      color: Colors.white, fontSize: 16
    );


    return Scaffold(
      key: _scaffoldKey,//como o scaffold está na propria tela, não cosnegue utilizar o scaffold.ofcontext na função saveProduct
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        elevation: 0,
        title: StreamBuilder<bool>(
          stream: _productBloc.outCreated,//strem do productBloc que habilita o botão exclui ou não, se o produto já estiver craido
          initialData: false,//valor inicial é de produto não criado
          builder: (context, snapshot) {
            return Text(snapshot.data ? "Editar Produto" : 'Criar Produto');//se o produto está criado aparece editar produto
          }
        ),
        actions: <Widget>[
         StreamBuilder<bool>(//mostra ou não o botão se o botão está criado ou não
           stream: _productBloc.outCreated,
           initialData: false,
           builder: (context, snapshot){
             if(snapshot.data) {
               return StreamBuilder<bool>(
                 builder: (context, snapshot) {
                   return StreamBuilder<bool>( //desabilita o botaõ se está carregando ou não
                       stream: _productBloc.outLoading,//para que o botão só fique ativo quando terminar de salvar
                       initialData: false,
                       //não estou carregando
                       builder: (context, snapshot) {
                         return IconButton(
                           icon: Icon(Icons.remove),
                           onPressed: snapshot.data ? null : () { //se está carregando coloca null como função, botão fica desabilitado, caso contrário libera o botão e usa a função salvar
                             _productBloc.deleteProduct();
                             Navigator.of(context).pop(); //depois que exclui o produto sai da tela
                           },
                         );
                       }
                   );
                 },
               );
             } else return Container();
           },
         ),
          StreamBuilder<bool>(
            stream: _productBloc.outLoading,//para que o botão só fique ativo quando terminar de salvar
              initialData: false,//não estou carregando
            builder: (context, snapshot) {
              return IconButton(
                icon: Icon(Icons.save),
                onPressed: snapshot.data ? null : saveProduct,//se está carregando coloca null como função, botão fica desabilitado, caso contrário libera o botão e usa a função salvar
              );
            }
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Form(
            key: _formKey,
            child: StreamBuilder<Map>(
              stream: _productBloc.outData,
              builder: (context, snapshot) {
                if(!snapshot.hasData) return Container();
                return ListView(//listView para que possa rolar a tela para cima e para baixo e ver o conteúdo
                  padding: EdgeInsets.all(16),
                  children: <Widget>[
                    Text('Imagens', style: TextStyle(color: Colors.grey, fontSize: 12),),
                    ImagesWidget(
                      context: context,
                      initialValue: snapshot.data['images'],//pegando do bloc
                      onSaved: _productBloc.saveImages,//chama a função no bloc que salva a imagem
                      validator: validateImages,//chama a classe validator para validar o campo
                    ),
                    TextFormField(
                      initialValue: snapshot.data['title'],
                      style: _fieldStyle,
                      decoration: _buildDecoration('Título'),
                      onSaved: _productBloc.saveTitle,
                      validator: validateTitle,
                    ),
                    TextFormField(
                      initialValue: snapshot.data['description'],
                      style: _fieldStyle,
                      maxLines: 6,
                      decoration: _buildDecoration('Descrição'),
                      onSaved: _productBloc.saveDescription,
                      validator: validateDescription,
                    ),
                    TextFormField(
                      initialValue: snapshot.data['price']?.toStringAsFixed(2),//? é para que caso não tenha nem dado retorna nulo e nem converte a string em 2 casas decimais
                      style: _fieldStyle,
                      decoration: _buildDecoration('Preço'),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),//color o campo com formato de número
                      onSaved: _productBloc.savePrice,
                      validator: validatePrice,
                    ),
                    SizedBox(height: 16,),
                    Text(
                      'Tamanhos', style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    ProductSizes(
                      context: context,
                      initialValue: snapshot.data['sizes'],
                      onSaved: _productBloc.saveSizes,
                      validator: (s){
                        if(s.isEmpty) return '';//se tiver erro apresenta uma string sem nada e o campo com borda vermelha que está no product_sizes
                        return null;//senão tiver erro retorna null
                      },
                    )
                  ],
                );
              }
            ),
          ),
          StreamBuilder<bool>(//vai ter uma tela que fica transparente por cima da tela "Cria produto", porém quando eu for carregar vai colocar na cor black54 e acionar o ignore pointer, tudo que clicar no meio será ignorado
              stream: _productBloc.outLoading,//para que o botão só fique ativo quando terminar de salvar
              initialData: false,//não estou carregando
              builder: (context, snapshot) {
                return IgnorePointer(
                  ignoring: !snapshot.data,//se estiver carregando não vai ignorar o ponteiro, se estiver carregando vai ignorar o ponteiro
                  child: Container(
                    color: snapshot.data ? Colors.black54 : Colors.transparent,//deixa a tela ofuscada se estiver carregando, caso contrário, fica transparente
                  ),
                );
              }
          )
        ],
      ),
    );
  }

  void saveProduct() async{
      if (_formKey.currentState.validate())//se o validator passar por todas validações vai retornar true e vai chamar o onsaved de todos os campos
        _formKey.currentState.save();

      _scaffoldKey.currentState.showSnackBar(//mensagem abaixo informando que o produto está sendo salvo
        SnackBar(content: Text('Salvando o produto...', style: TextStyle(color: Colors.white),),
          duration: Duration(minutes: 1),
          backgroundColor: Colors.pinkAccent,
        )
      );

      bool _success = await _productBloc.saveProduct();//função do bloc que salva o produto

      _scaffoldKey.currentState.removeCurrentSnackBar();//remove a snack bar que foi setada antes

      _scaffoldKey.currentState.showSnackBar(//mensagem abaixo informando que o produto está sendo salvo
          SnackBar(content: Text(_success ? 'Produto Salvo' : "Erro ao salvar produto", //se o salvamento der certo mostra msg de que o produto foi salvo senão erro ao salvar produto.
            style: TextStyle(color: Colors.white),),
            backgroundColor: Colors.pinkAccent,
          )

      );
      Navigator.of(context).pop();
    }

}
