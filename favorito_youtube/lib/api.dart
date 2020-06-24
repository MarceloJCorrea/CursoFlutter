import 'dart:convert';
import 'package:http/http.dart' as http;

import 'models/video.dart'; //as http para saber que é uma resposta de uma url que está esperando

const API_KEY = 'AIzaSyDGQYyugX57groa4QOOvrng_GsOZ0Jf9qA';

class Api{

  search(String search) async {
    http.Response response = await http.get(
        "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=$API_KEY&maxResults=10" //10 para carregar 10 videos por vez, se mudar o search e a key dá pra ver os dados recebidos pelo api
    );

    decode(response);
  }

  List<Video> decode (http.Response response){
    if(response.statusCode == 200){//200 é o retorno que conseguiu carregar os dados do api

      var decoded = json.decode(response.body);//response.body é o json que recebemos do link

      List<Video> videos = decoded['items'].map<Video>(//dentro de items tem vários maps, pega cada um dos maps e transforma num objeto video
          (map){
            return Video.fromJason(map);//pegou os dados do mapa e transformou num objeto video
          }
      ).toList();//transforma numa lista de videos

      return videos;

    } else {
      throw Exception("Falha ao carregar os vídeos");
    }

  }
}