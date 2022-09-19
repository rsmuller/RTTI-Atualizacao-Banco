# RTTI-Atualizacao-Banco
Exemplo de como executar atualizações no banco de dados a partir de um novo exe

Este projeto tem como objetivo, realizar mudanças na base de dados (Base de exemplo em Firebird 2.5) a partir do executável. Utilizando RTTI a classe de atualização irá ler todos os metodos da classe de versões. Então para criar uma mudança nova, basta adicionar uma nova procedure na classe de versões. O exemplo conta com uma criação de tabela, uma adição de campo e uma remoção de campo.

Scrip para criar a tabela, generator e trigger da base

`CREATE GENERATOR VERSAO_BANCO;`

`CREATE TABLE VERSAO_BANCO (
	ID INTEGER NOT NULL,
	VERSAO VARCHAR(20),
	CONSTRAINT PK_VERSAOBANCO PRIMARY KEY (ID)
);`

`CREATE TRIGGER TR_GEN_VERSAOBANCO FOR VERSAO_BANCO BEFORE INSERT
AS
BEGIN
    if (new.ID is null) then
    new.ID = gen_id(VERSAO_BANCO, 1);
END;`
