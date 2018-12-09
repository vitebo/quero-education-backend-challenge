# Challenge integrated admission

O projeto tem como foco criar uma API para gerenciar admissão, matrícula e mensalidades de alunos com o intuito de ser
consumida em um site.

## API documentation

Toda a documentação da API pode ser encontrada aqui:
[documenter.getpostman.com](https://documenter.getpostman.com/view/4286436/RzfiGoXE)

## System dependencies

- Ruby version: 2.5.1
- Yarn
- Node

## Relação das tabelas

Relações do banco de dados

![Data Base](https://raw.githubusercontent.com/vitebo/challenge-integrated-admission/master/app/assets/images/db-tables.png)

## Run project

1. clone o projeto
    ```bash
    $ git@github.com:vitebo/challenge-integrated-admission.git
    $ cd challenge-integrated-admission/
    ```

2. instale as depêndências
    ```bash
    $ gem install bundler
    $ bundler install
    $ yarn install
    ```

3. rode a aplicação
    ```bash
    $ rails db:create
    $ rails db:migrate
    $ rails s
    ```

## Requisitos

Requisitos da aplicação

### Requisitos de produto

- Para o processo de admissão, o aluno deve inserir seus dados (nome, CPF) e sua nota no ENEM.
- Neste desafio, a admissão é aprovada simplesmente se a nota do ENEM for maior que 450 (geralmente o aluno tem que
fazer vestibular e enviar documentos).
- Se a admissão for aprovada, o aluno poderá ativar a cobrança inserindo a quantidade de parcelas (de 1 a 12) e o dia
de pagamento desejado.
- O aluno deve poder consultar as mensalidades e alterar o método de pagamento (boleto ou cartão de crédito) das
próximas.

### Criação de faturas

As faturas devem ser criadas quando a matrícula é criada. Caso o dia de vencimento escolhido pelo aluno seja menor ou
igual ao dia do mês atual, as faturas devem iniciar no próximo mês. Caso contrário, devem iniciar no mês atual. Por
exemplo, se hoje é 29/01 e o dia de vencimento desejado pelo aluno for 15, a data de vencimento da primeira fatura deve
ser em fevereiro.

### Requisitos de engenharia

- Use Ruby On Rails 5.2.x com banco SQLite
- Todo o código, possíveis comentários e entidades devem ser em inglês
- As rotas da API devem responder dados no formato JSON
- Crie testes automatizados para mostrar pelo menos que a funcionalidade mais complexa do projeto funciona como
especificada

### Observações

- Na rematrícula a cada semestre, o valor das mensalidades pode sofrer reajuste
- Inclua um TODO.md na raiz do projeto com coisas que poderiam ser implementadas ou melhoradas em termos de código,
arquitetura, segurança e/ou infra
- Coloque seu projeto em um repositório indicando a versão do teste (2018_11_21) e nos envie o link

