# [Bookstore](https://console.firebase.google.com/u/0/project/bookstore-636f3/hosting/sites/bookstore-636f3)

API de Gerenciamento de livrarias! Esta API foi desenvolvida utilizando Spring Boot e oferece funcionalidades para gerenciar os livros da loja e adicionar funcionários que podem fazer login na loja para ajudar no controle de estoque.

- Apesar do projeto ser mobile, você consegue acessar a versão web pela url [bookstore web](https://console.firebase.google.com/u/0/project/bookstore-636f3/hosting/sites/bookstore-636f3)

## Funcionalidades

### Autenticação e Autorização
- **Cadastro de Usuários**: Os usuários podem se cadastrar fornecendo informações básicas como nome de usuário, nome, senha e informações da loja (que incluem banner, nome da loja, slogan, etc).
- **Login**: Autenticação segura utilizando Spring Security e JWT (JSON Web Tokens) pelos administradores da loja ou pelo seus funcionários.

### Gerenciamento de Perfil
- **Atualizar Perfil**: Os usuários podem alterar o nome
- **Atualizar Senha**: Os usuários pode trocar de senha

### Gerenciamento de Livros
- Administradores da loja podem cadastrar, editar ou excluir livros da livraria.

### Gerenciamento de Funcionários
- Administradores podem cadastrar novos funcionários na loja. Esses funcionários tem um login próprio e poodem visulizar os livros e controler o estoque.

### Documentação com Swagger
- **Swagger UI**: A API está documentada utilizando Swagger, permitindo uma fácil visualização e teste dos endpoints diretamente no navegador.

### Acesso baseado em Roles
- Todas as operações são são seguras e exigem autenticação do usuário, validação da role atribuída ao usuário, bem como se ele possui relação com a loja que está operando.

<div style="display: flex; flex-wrap: wrap; gap: 10px;">
  <img src="/assets/image1.png" alt="login" width="45%">
  <img src="/assets/image2.png" alt="home" width="45%">
  <img src="/assets/image3.png" alt="enter project" width="45%">
  <img src="/assets/image4.png" alt="tasks" width="45%">
  <img src="/assets/image5.png" alt="new task" width="45%">
  <img src="/assets/image6.png" alt="project info" width="45%">
</div>

## Tecnologias e Ferramentas Utilizadas

- **Flutter**: Framework desenvolvido pelo Google para construção de aplicativos mobile híbridos (saiba mais em [Flutter](https://flutter.dev/))
- **Dio**: Para comunicação eficiente com a API e uso de interceptors (saiba mais em [Dio](https://pub.dev/packages/dio))
- **BLoC**: Para gerenciamento eficiente dos estados da aplicação (saiba mais em [BLoC](https://pub.dev/packages/flutter_bloc))
- **GetIt**: Para injeção de dependência (saiba mais em [GetIt](https://pub.dev/packages/get_it))
- **Cached network image**: Para otimização de imagens web (saiba mais em [Cached network image](https://pub.dev/packages/cached_network_image))
- **Image picker**: Para tratar imagens selecionadas pelo usuário (saiba mais em [Image picker](https://pub.dev/packages/image_picker))

## Doc
![image](https://github.com/user-attachments/assets/c532349b-b33c-45ec-a83e-8dfa1d07fed7)
![image](https://github.com/user-attachments/assets/5f4d7ae0-4819-4302-a859-719762601161)
![image](https://github.com/user-attachments/assets/73d9e983-76ff-48ab-b81f-4ab3a5eccd35)

## Como Executar o Projeto

### Pré-requisitos

- Flutter SDK 3.29.2

### Instalação e Execução

1. **Clone o repositório**:

   ```bash
   git clone git@github.com:karoldm/bookstore.git
   cd bookstore
   ```
   
2. **Verificar instalação do flutter**:

  ```bash
     flutter doctor
     ```

3. **Instale as dependências**:

   ```bash
   flutter pub get
   ```

4. **Inicie o projeto**:
   
   ```bash
   flutter run
   ```
   - O frontend estará disponível em http://localhost:3000 (se estiver rodando na web)


## Deploy

Projeto hospedado no [Firebase Hosting](https://firebase.google.com/docs/hosting?hl=pt-br)

## Contribuição

Contribuições são bem-vindas! Sinta-se à vontade para abrir issues e pull requests ❤️
