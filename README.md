# Movies2You

Aplicativo iOS desenvolvido em Swift utilizando a arquitetura MVVM para o desafio da Mobile2You.

## Requisitos

Replicar o layout da tela de detalhe dos filmes do app [TodoMovies4](https://apps.apple.com/br/app/todomovies-4/id792499896).

<img alt="Tela App TodoMovies4" src="https://is4-ssl.mzstatic.com/image/thumb/Purple114/v4/97/0e/e2/970ee217-13cf-1674-b016-461aca657663/pr_source.png/460x0w.png" width="300">

1. Usar algum design pattern: MVP, MVVM, MVVM-C, VIPER.
2. As informações do filme devem vir do endpoint getMovieDetails.
3. Usar o vote_count que retorna da API para representar o número de likes.
4. Substituir o "3 of 10 watched" por "<popularity> views", utilizando o valor retornado da API e
mantendo algum ícone ao lado.
5. O ícone de like (coração) deve mudar quando clicado, alternando entre preenchido e vazio.
6. Deve haver uma lista de filmes abaixo dos detalhes.
7. O app deve ser desenvolvido utilizando a linguagem Swift.
8. O projeto deve ser disponibilizado em um repositório aberto no GitHub. Envie a URL assim que
possível.

## Features

- [x] Consumir dados da API The Movie Database
- [x] Mostrar capa e informações do filme principal
- [x] Efeito "stretchy header" ao rolar a tela
- [x] Botão de like para o filme principal com animação
- [x] Lista com os filmes relacionados
- [x] Botões "❤️ Curtir" e "Adicionar às Minhas Listas"
- [ ] Diferenciar a cor do texto com base na cor da imagem principal  —  parcialmente implementada na branch `dev`

## API Key
  
Por motivos de segurança, o arquivo com a API Key não foi adicionado ao repositório. Para rodar o projeto você vai precisar criar uma função da seguinte forma:
  
```swift
func GetAPIKey() -> String {
    "SUA-API-KEY"
}
```

Eu criei essa função em um arquivo na pasta `Helpers`, mas você pode colocar onde achar mais conveniente, desde que possa ser acessada pelo arquivo `MovieAPI.swift`.

## Demonstração da aplicação

A aplicação tem um filme principal onde é mostrada a imagem de capa, o título, a quantidade de likes e view, além de um botão para curtir o filme.

Abaixo temos uma lista com filmes relacionados, recebidos atravez da função `getSimilarMovies` da API, e é mostrado o título do filme, ano de lançamento, os dois primeiros gêneros e um botão a direita para indicar se o filme foi adicionado, assistido ou nenhum destes.

Ao final da tela temos dois botões, um para curtir, que faz a mesma função do botão curtir do início da página, e um para adicionar todos os filmes relacionados.

Os filmes relacionados são clicáveis, ao clicar em um a tela será recarregada e este filme será apresentado como o filme principal. Esse compotamento não faz parte do funcionamento a aplicação TodoMovies4, mas foi implementado para facilitar os testes da aplicação durante o desenvolvimento.

Abaixo, um gif com o funcionamento da aplicação.

<img alt="Demonstração Movies2You" src="Assets/demo.gif" width="300">

## Comentários

A aplicação apesar de simples, apresentou alguns desafios interessantes como o efeito "stretchy header" na imagem principal e a definição da Model a fim de consumir os dados da API de forma mais simples e então disponibilizá-los para a view e até mesmo a animação "flying heart" ao curtir o filme.

Para o efeito "stretchy header" foi utilizada o `GeometryReader` para calcular o deslocamento da tela e adicionar esse deslocamento ao 'offset' da imagem e também à altura, fazendo ela esticar verticalmente. Já para a animação ao curtir o filme foi utilizado o `matchedGeometryEffect` com um segundo icone de coração que alternava a opacidade entre 0 e 1 criando esse efeito.

Já na implementação da Model uma decisão que facilitou bastante o desenvolvimento e consumo de dados da API foi lidar basicamente com a estrutura Movie, que era utilizada tanto para o filme principal, quanto para os filmes relacionados. Assim, todas informações necessárias estavam disponíveis, tanto para o filme principal quanto para os filmes relacionados. Isso resolveu o problema que era encontrado ao consumir o endpoint `getSimilarMovies`, pois os nomes dos gêneros não estavam disponíveis, apenas os IDs. Assim, não era necessário carregar uma lista com todos os gêneros disponíveis e então comparar o ID de cada gênero de cada filme relacionado à lista de gêneros, pois todos esses dados estavam na Model Movie.

Outro desafio foi implementar as cores de destaque no texto da aplicação, utilizando como base as cores da imagem principal. Até o momento essa função não foi implementada pois as soluções tentadas não ficaram muito elegantes, em uma delas era feita a conversão de Image para UIImage com o objetivo de utilizar a biblioteca externa `ColorKit` que oferece uma paleta com cores primárias, secundárias e de fundo com base em uma imagem. O resultado visualmente ficou bem legal, porém o código ficou bem poluído e foi decidido não implementar dessa forma. Por isso, essa função ficou como uma tarefa para o futuro. 
  
### Update - 17/01 22h
A função de implementar as cores de destaque foi parcialmente implementada na branch `dev`.
  
A implementação foi feita mais a título de curiosidade para ver como ficaria o resultado visualmente, então foi utilizada uma função diretamente na View que faz o download da UIImagem, analisa sua paleta de cores e a utiliza nos textos e no fundo de tela da aplicação (não foi utilizado o fundo preto pois em alguns filmes a legibilidade ficava ruim).
  
O resultado ficou bem bonito visualmente, mas principalmente devido a cor do fundo de tela variando de acordo com a imagem principal (em vez de permanecer na cor preta) talvez a interface esteja fugindo um pouco da tela do app TodoMovies4. Por esse motivo o desenvolvimento dessa feature ficou apenas nisso por enquanto.
