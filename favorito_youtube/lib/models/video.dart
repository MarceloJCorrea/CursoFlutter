class Video{

  //final pois uma vez atribuído, não muda mais o valor do atributo.
  final String id;//id do video
  final String title;//titulo do video
  final String thumb; //resolução do video
  final String channel;//canal que postou o video

   Video({this.id, this.title, this.thumb, this.channel});

  //String é o tipo, dynamic é o nosso valor, que pode ser qualquer um
  factory Video.fromJason(Map<String, dynamic> json){//pega o json e retorna um objeto que contém os dados do seu json

    return Video(//vai retornar os dados do json e passar os parâmetros para as variaveis
      id: json['id']['videoId'],
      title: json['snippet']['title'],
      thumb: json['snippet']['thumbnails']['higt']['url'],
      channel: json['snippet']['channelTitle']
    );

  }

}