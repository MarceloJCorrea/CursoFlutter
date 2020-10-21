class ProductValidator{

  String validateImages(List images){//retorna string pois é a msg de erro
    if(images.isEmpty) return "Adicione imagens do produto";
    return null;
  }

  String validateTitle(String text){
    if(text.isEmpty) return "Preencha o título do produto";
    return null;
  }

  String validateDescription(String text){
    if(text.isEmpty) return "Preencha a descrição do produto";
    return null;
  }

  String validatePrice(String text){
    double price = double.tryParse(text);//vai tentar transformar o texto em double, se conseguir salva o valor se não conseguir o price vai ser igual a nulo
    if(price != null){
      if(!text.contains('.') || text.split('.')[1].length != 2)//verifica se o preço tem duas casas decimais e se a segunda parte tem dois dígitos apenas
        return "Utilize duas casas decimais";
    } else{
      return 'Preço inválido';
    }
    return null;
  }
}