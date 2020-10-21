import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerenteloja/blocs/user_bloc.dart';

class OrderHeader extends StatelessWidget {

  final DocumentSnapshot order;

  OrderHeader(this.order);

  @override
  Widget build(BuildContext context) {
    
    final _userBloc = BlocProvider.of<UserBloc>(context);

    final _user = _userBloc.getUser(order.data['clienteId']);
    
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, //alinhamento no início
            children: <Widget>[
              Text('Nome: ${_user['name']}', style: TextStyle(fontWeight: FontWeight.w500),),
              Text('Endereço: ${_user['addrees']}', style: TextStyle(fontWeight: FontWeight.w500),),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end, //alinhamento no final
          children: <Widget>[
            Text('Produtos: R\$ ${order.data['productsPrice'].toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.w500),),
            Text('Total: R\$ ${order.data['totalPrice'].toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.w500),),
          ],
        )
      ],
    );
  }
}
