import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceModal extends StatelessWidget {

  ImageSourceModal(this.onImageSelected);//construtor para que possa ser utilizado a imagem selecionada no modal do images_field

  final Function(File) onImageSelected;

  @override
  Widget build(BuildContext context) {
    if(Platform.isAndroid){//se for Android monta a caixa de diálogo desta forma
      return BottomSheet(
        onClosing: (){},//função que chama quando estou fechando esse modal
        builder: (_) => Column(//builder recebe o context mas não vai  usar pra nada
          mainAxisSize: MainAxisSize.min,//ocupa o menos de espaço possível
          crossAxisAlignment: CrossAxisAlignment.stretch,//botões vão ocupar o máximo de espaço possível
          children: <Widget>[
            FlatButton(
              child: const Text('Camera'),
              onPressed: getFromCamera,//espera uma função que não retorna nada
            ),
            FlatButton(
              child: const Text('Galeria'),
              onPressed: getFromGallery,//espera uma função que não retorna nada
            ),
          ],
        ),
      );
    } else {//se for IOS monta a caixa de diálogo desta forma
      return CupertinoActionSheet(
        title: const Text('Selecionar foto para anúncio'),//título da caixa de diálogo
        message: const Text('Escolha a origem da foto'),//mensagem da caixa de diálogo
        cancelButton: CupertinoActionSheetAction(//caixa de diálogo que cancela a seleção da camera ou galeria
          child: Text('Cancelar', style: TextStyle(color: Colors.red),),
          onPressed: (){
            Navigator.of(context).pop();//fecha a tela ao optar por cancelar
          },
        ),
        actions: <Widget>[
          CupertinoActionSheetAction(//caixa de diálogo pra buscar da camera
            child: const Text('Camera'),
            onPressed: getFromCamera,//espera uma função que não retorna nada
          ),
          CupertinoActionSheetAction(//caixa de diálogo para buscar da galeria
            child: const Text('Galeria'),
            onPressed: getFromGallery,//espera uma função que não retorna nada
          ),
        ],
      );
    }

  }

  Future<void> getFromCamera() async {//função não retorna nada, vai carregar os dados da camera
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
    if(pickedFile == null) return;
    final image = File(pickedFile.path);//caminho do arquivo, já tenho o arquivo da imagem
    imageSelected(image);//busca a imagem selecionada
  }

  Future<void> getFromGallery() async {//função não retorna nada, vai carregar os dados da galeria
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    if(pickedFile == null) return;
    final image = File(pickedFile.path);//caminho do arquivo, já tenho o arquivo da imagem
    imageSelected(image);//busca a imagem selecionada
  }

  void imageSelected(File image) async{//função que carrega o arquivo de imagem selecionado
     final croppedFile = await ImageCropper.cropImage(//corta a imagem
         sourcePath: image.path,//pega o caminho da imagem a ser cortada
         aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),//imagem vai ser sempre no formato quadrado
         androidUiSettings: AndroidUiSettings(//formatação para cortar imagem no android
           toolbarTitle: "Editar Imagem",
           toolbarColor: Colors.purple,
           toolbarWidgetColor: Colors.white
           ),
         iosUiSettings: IOSUiSettings(//formatação para cortar imagem no IOS
           title: "Editar Imagem",
           cancelButtonTitle: "Canelar",
           doneButtonTitle: "Concluir",
         )
     );
     if(croppedFile != null)//só vai passar a imagem cortada para o onimageselected se a imagem foi cortada realmente, se cancelar não
       onImageSelected(croppedFile);//seleciona a imagem já cortada, essa função fica dentro de images_field
  }

}
