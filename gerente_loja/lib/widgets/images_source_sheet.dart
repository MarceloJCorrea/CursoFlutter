import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceSheet extends StatelessWidget {

  final Function(File) onImageSelected;

  ImageSourceSheet({this.onImageSelected});

  void imageSelected(File image) async{
    if(image != null){
     File _croppedImage =  await ImageCropper.cropImage(//imagem cortada salva no cropeedImage
       sourcePath: image.path,
       aspectRatioPresets: [
         CropAspectRatioPreset.square,
         CropAspectRatioPreset.ratio3x2,
         CropAspectRatioPreset.original,
         CropAspectRatioPreset.ratio4x3,
         CropAspectRatioPreset.ratio16x9
       ],
     );
     onImageSelected(_croppedImage);//chama a função passando o cropeedImage
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: (){},//fechar a telinha da imagem não vai fazer nada
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FlatButton(
            child: Text('Câmera'),
            onPressed: () async{
              File image = await ImagePicker.pickImage(source: ImageSource.camera);//abre a camera e salva em um arquivo
              imageSelected(image);
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('Galeria'),
            onPressed: () async{
              File image = await ImagePicker.pickImage(source: ImageSource.gallery);//abre a galeria e salva em um arquivo
              imageSelected(image);
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }
}
