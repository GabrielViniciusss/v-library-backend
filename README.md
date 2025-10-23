# Desafio Backend Rails - Sistema de Biblioteca Digital (v-library-backend)

Esta é uma API RESTful desenvolvida em Ruby on Rails para gerenciar uma plataforma de biblioteca digital, como parte de um desafio backend. Usuários autenticados podem cadastrar, buscar e gerenciar materiais (livros, artigos, vídeos) associados a autores (pessoas ou instituições).

## Funcionalidades Principais

* **Autenticação:** Via e-mail/senha usando Tokens JWT.
* **Gerenciamento de Materiais:** CRUD completo para Livros, Artigos e Vídeos, com campos genéricos e específicos.
* **Gerenciamento de Autores:** CRUD para Autores do tipo Pessoa ou Instituição.
* **Associações:** Materiais associados a um criador (usuário) e um autor (pessoa/instituição).
* **Permissões:** Apenas o usuário criador pode alterar ou remover seus materiais. A visualização é pública.
* **Status de Material:** Materiais possuem status (rascunho, publicado, arquivado).
* **API Externa:** Integração com OpenLibrary para buscar dados de livros via ISBN durante o cadastro.
* **Busca:** Endpoint para buscar materiais por título, descrição ou nome do autor.
* **Paginação:** Resultados das listagens e busca são paginados.
* **Documentação Interativa:** Interface Swagger UI disponível para explorar e testar a API.

## Tecnologias Utilizadas

* **Ruby:** Versão 3.x.x (Verificar `Gemfile`)
* **Rails:** Versão 7.1.x (API-only mode)
* **Banco de Dados:** PostgreSQL
* **Autenticação:** Devise + Devise-JWT
* **Autorização:** Pundit
* **Paginação:** Kaminari
* **Cliente HTTP:** Faraday
* **Serialização JSON:** jsonapi-serializer
* **Testes/Documentação:** RSpec, Rswag (Swagger)

## Configuração do Ambiente (Setup)

**Pré-requisitos:**

* Ruby (versão definida no `Gemfile`)
* Bundler (`gem install bundler`)
* PostgreSQL (servidor rodando)
* Git

**Passos:**

1.  **Clone o repositório:**
    ```bash
    git clone <URL_DO_SEU_REPOSITORIO>
    cd v-library-backend
    ```

2.  **Instale as dependências:**
    ```bash
    bundle install
    ```

3.  **Configure as Credenciais:**
    A aplicação usa a chave secreta do JWT armazenada nas credenciais criptografadas do Rails. Execute o comando abaixo e adicione a chave (se ainda não o fez):
    ```bash
    EDITOR="code --wait" rails credentials:edit
    ```
    Adicione a seguinte chave ao arquivo (substitua `<SUA_CHAVE_SECRETA_JWT>` por uma chave gerada com `bundle exec rails secret`):
    ```yaml
    devise_jwt_secret: '<SUA_CHAVE_SECRETA_JWT>'
    ```
    Salve e feche o editor.

4.  **Configure o Banco de Dados:**
    * Certifique-se que seu servidor PostgreSQL está rodando.
    * Verifique/edite as credenciais (usuário/senha) no arquivo `config/database.yml` para corresponder à sua configuração local do Postgres.
    * Crie os bancos de dados de desenvolvimento e teste:
        ```bash
        rails db:create
        ```
    * Execute as migrações para criar as tabelas:
        ```bash
        rails db:migrate
        ```
    * (Opcional, mas recomendado para testes Rswag) Prepare o banco de dados de teste:
        ```bash
        rails db:migrate RAILS_ENV=test
        ```

## Rodando a Aplicação

Para iniciar o servidor Rails (geralmente na porta 3000):

```bash
bundle exec rails s
```

A API estará acessível em http://localhost:3000.

## Documentação e Testes

### Documentação Interativa (Swagger)

Com o servidor rodando, acesse a interface do Swagger UI em:
[http://localhost:3000/api-docs](http://localhost:3000/api-docs)

A documentação do Swagger (`swagger.yaml`) é gerada automaticamente ao rodar os testes RSpec com sucesso. Se precisar forçar a geração manualmente:
```bash
bundle exec rspec
```

### Rodando os Testes (RSpec)

Para executar a suíte de testes (que também gera/atualiza a documentação `swagger.yaml` se os testes passarem):
```bash
bundle exec rspec
```

## Autenticação (JWT)

### Registro
Faça uma requisição `POST` para `/api/signup` com o seguinte corpo JSON:
```json
{
  "user": {
    "email": "user@example.com",
    "password": "password123",
    "password_confirmation": "password123"
  }
}
```

### Login
Faça uma requisição `POST` para `/api/login` com o corpo:
```json
{
  "user": {
    "email": "user@example.com",
    "password": "password123"
  }
}
```
A resposta bem-sucedida incluirá o Token JWT no cabeçalho `Authorization`. Ex: `Authorization: Bearer eyJhbGciOiJIUzI1NiJ9...`

### Requisições Autenticadas
Para acessar endpoints protegidos (como criar/atualizar/deletar materiais ou autores), inclua o token JWT no cabeçalho `Authorization` de cada requisição:
```
Authorization: Bearer <SEU_TOKEN_JWT>
```
Você pode usar o botão "Authorize" na interface do Swagger para configurar isso globalmente para testes na UI.

### Logout
Faça uma requisição `DELETE` para `/api/logout` (enviando o token no header `Authorization`).

## Principais Endpoints da API

*   **Autenticação:**
    *   `POST /api/signup`
    *   `POST /api/login`
    *   `DELETE /api/logout`
*   **Autores (Pessoas):** CRUD em `/api/people`
*   **Autores (Instituições):** CRUD em `/api/institutions`
*   **Materiais (Livros):** CRUD em `/api/books`
*   **Materiais (Artigos):** CRUD em `/api/articles`
*   **Materiais (Vídeos):** CRUD em `/api/videos`
*   **Busca:** `GET /api/search?q=<termo>`

## GraphQL

Além dos endpoints REST, a API expõe um endpoint GraphQL:

* Endpoint: `POST /graphql`

### Consultas disponíveis (iniciais)

1) Listar materiais com paginação

Query:

```
query($page: Int, $perPage: Int) {
  materials(page: $page, perPage: $perPage) {
    id
    title
    status
    type
  }
}
```

Variáveis (JSON):

```
{ "page": 1, "perPage": 10 }
```

2) Buscar um material por ID

```
query($id: ID!) {
  material(id: $id) {
    id
    title
    type
  }
}
```

Variáveis:

```
{ "id": 123 }
```

3) Listar autores

```
{
  people { id name }
  institutions { id name city }
}
```

Observações:

* As variáveis podem ser enviadas como JSON (recomendado) definindo `Content-Type: application/json`.
* Os nomes dos argumentos seguem o padrão camelCase na API (ex: `perPage`).
* Em desenvolvimento, você pode usar clientes como Insomnia, Postman ou o app GraphiQL para testar queries.

Para detalhes completos sobre parâmetros, schemas e respostas, consulte a **documentação interativa do Swagger**.

## Regras de Negócio Implementadas

*   Apenas usuários autenticados podem criar, atualizar ou deletar autores e materiais.
*   Um material só pode ser atualizado ou deletado pelo usuário que o criou.
*   Materiais e Autores públicos podem ser listados e visualizados por qualquer pessoa.
*   ISBN (para livros) e DOI (para artigos) devem ser únicos.
*   Um material deve sempre estar associado a um usuário criador e a um autor existente.
*   Um material tem apenas um autor, mas um autor pode ter vários materiais.
*   O status de um material deve ser um dos valores válidos (`rascunho`, `publicado`, `arquivado`).
*   Campos obrigatórios (como título, email, senha, etc.) possuem validações e retornam erro 422 (ou apropriado) se ausentes/inválidos.
