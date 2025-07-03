--ALTER TABLE CRIAR CAMPO DE OPERAORA NOS TELEFONRES

ALTER TABLE PESSOA_TELEFONE 
ADD (operadora VARCHAR2(255 CHAR))

--CREATE INDEX ADICIONAR O INDEX EM REALIZACAO DO EXAME PARA A CHAVE DE CPF DO TECNICO
create index idx_realizacaoexame_cpf on REALIZACAO_EXAME (CPF_TECNICO)

--INSERT INTO INSERIR UM ENDEREÇO E UMA PESSOA
INSERT INTO ENDERECO (CEP, Rua, Numero, Bairro, Cidade) VALUES ('50750630', 'Rua Helena de Lemos', '257', 'Ilha do Retiro', 'Recife');
INSERT INTO PESSOA (CPF, Nome, Endereco_CEP, Email, Data_Nascimento, Sexo) VALUES ('13705127403', 'Nicolas Veiga', '50750630', 'nicolasvgbezerra@email.com', TO_DATE('2002-09-16', 'YYYY-MM-DD'), 'M');

--UPDATE ATUALIZAR O CAMPO ANTERIORMENTE NOS TELEFONES CRIADO PARA IGUAL A TIM
update PESSOA_TELEFONE set operadora = 'TIM' WHERE operadora is null 

--DELETE DELETANDO A PESSOA CRIADA ANTERIORMENTE
delete from pessoa where CPF = '13705127403';

--SELECT FROM WHERE SELECIONA OS AGENDAMENTOS QUE ESTÃO AGENDADOS E NÃO SÃO URGENTES
SELECT CODIGO, CPF_PACIENTE, CODIGO_EXAME, DATA_HORA_AGENDADA,PRIORIDADE, STATUS
FROM AGENDAMENTO
WHERE STATUS = 'Agendado' and PRIORIDADE != 'Urgente'

--BETWEEN SELECIONA OS EXAMES REALIZADOS QUE OCORRERAM EM 2026
SELECT CODIGO_LAUDO,CODIGO_AGENDAMENTO,CPF_TECNICO,DATA_HORA_EXECUCAO
FROM REALIZACAO_EXAME
WHERE DATA_HORA_AGENDADA BETWEEN TO_DATE('2026-01-01', 'YYYY-MM-DD') AND TO_DATE('2026-12-31', 'YYYY-MM-DD');

--IN SELECIONA SELECIONA O DIAGNÓSTICO DE 2 MÉDICOS
SELECT DATA_HORA,RESULTADO,STATUS
FROM DIAGNOSTICO
WHERE CPF_MEDICO IN ('11223344556','40450560677')

--LIKE SELECIONA AS PESSOAS QUE O NOME COMEÇAM COM A
SELECT CPF,NOME,SEXO,DATA_NASCIMENTO
FROM PESSOA
WHERE UPPER(NOME) LIKE 'A%'

--is null SELECIONA  PESSOAS QUE NÃO TEM SUPERVISOR
SELECT P.Nome
FROM PESSOA P
inner JOIN FUNCIONARIO F ON P.CPF = F.CPF
WHERE F.CPF_Supervisor IS NULL;

--INNER JOIN TRAZ OS RESULTADOS DOS EXAMES DOS PACINTES
SELECT PP.NOME AS "PACIENTE", L.RESULTADO AS "RESULTADO",E.NOME AS "EXAME"
FROM REALIZACAO_EXAME R
INNER JOIN LAUDO L ON L.CODIGO = R.CODIGO_LAUDO
INNER JOIN AGENDAMENTO A ON A.CODIGO = R.CODIGO_AGENDAMENTO
INNER JOIN PACIENTE P ON P.CPF = A.CPF_PACIENTE
INNER JOIN PESSOA PP ON PP.CPF = P.CPF
INNER JOIN EXAME E ON E.CODIGO = A.CODIGO_EXAME


--MAX, MIN, AVG, COUNT
SELECT
    COUNT(*) AS Total_Agendamentos,
    MIN(Data_Hora_Agendada) AS Primeiro_Agendamento,
    MAX(Data_Hora_Agendada) AS Ultimo_Agendamento
FROM AGENDAMENTO;

select avg(TRUNC(MONTHS_BETWEEN(SYSDATE, p.Data_Nascimento) / 12))
from pessoa p 
inner join paciente pp on pp.cpf = p.cpf

--LEFT JOIN

SELECT P.Nome, M.CRM
FROM PESSOA P
LEFT OUTER JOIN MEDICO M ON P.CPF = M.CPF


--SUBCONSULTA COM OPERADOR RELACIONAL TRAZ O ÚLTIMO AGENDAMENTO DE CADA PACIENTE
select
A.CODIGO,P.NOME,A.DATA_HORA_AGENDADA
FROM AGENDAMENTO A 
INNER JOIN PESSOA P ON P.CPF = A.CPF_PACIENTE
WHERE A.DATA_HORA_AGENDADA = (SELECT MAX(AA.DATA_HORA_AGENDADA) 
                    FROM AGENDAMENTO AA
                    WHERE AA.CPF_PACIENTE = P.CPF)


--SUBCONSULTA COM IN trazer os ultimos 5 agendamentos
select
A.CODIGO,P.NOME,A.DATA_HORA_AGENDADA
FROM AGENDAMENTO A 
INNER JOIN PESSOA P ON P.CPF = A.CPF_PACIENTE
WHERE A.DATA_HORA_AGENDADA IN (SELECT AA.DATA_HORA_AGENDADA 
                                FROM AGENDAMENTO AA
                                ORDER BY AA.DATA_HORA_AGENDADA DESC
                                FETCH FIRST 5 ROWS ONLY )

--SUBSONSULTA COM ANY pegar o médico que tem uma especialidade maior que alguma data de admissao do funcionacio
select distinct
p.nome,p.data_nascimento,p.cpf
from medico m
inner join pessoa p on p.cpf = m.cpf
inner join medico_especialidade me on me.CPF_MEDICO = m.cpf
where me.data_obtencao > any (select f.DATA_ADMISSAO 
                                from funcionario f
                             )


--SUBSONSULTA COM all pegar os funcionarios que foram admitidos antes de algum médico se especializar
select 
p.nome,p.data_nascimento,p.cpf
from funcionario f 
inner join pessoa p on p.cpf = f.cpf
where f.DATA_ADMISSAO < all (select me.data_obtencao 
                                from medico_especialidade me
                             )

--ORDER BY TRAZENDO AS PESSOAS ORDENANDO POR NOME
SELECT CPF,NOME,Sexo
FROM PESSOA
ORDER BY NOME

--COUNT() NUMERO DE AGENDAMENTOS POR PACIENTE
SELECT P.NOME,COUNT(*)
FROM PACIENTE PA 
INNER JOIN PESSOA P ON P.CPF = PA.CPF
INNER JOIN AGENDAMENTO A ON A.CPF_PACIENTE = P.CPF 
GROUP BY P.NOME
ORDER BY 2 

--HAVING TRAZ OS MEDICOS QUE FIZERAM MAIS QUE 2 DIAGNÓSTICOS
SELECT P.NOME,COUNT(*)
FROM DIAGNOSTICO D
INNER JOIN PESSOA P ON P.CPF = D.CPF_MEDICO
GROUP BY P.NOME
HAVING COUNT(*) > 2
ORDER BY 2 

--UNION TRAZER TODOS OS CPF DAS TABELAS ASSOCIADAS A PESSOA
SELECT CPF FROM MEDICO
UNION
SELECT CPF FROM TECNICO
UNION
SELECT CPF FROM FUNCIONARIO
UNION 
SELECT CPF FROM PACIENTE

--CREATE VIEW, CRIAR A VIEW COM AS INFORMAÇÕES JÁ TRAZIDAS ANTERIORMENTE DE REALIZACAO DE EXAME COM SEUS RESULTADOS PARA FACILITAR EXTRAIR DADOS]
CREATE VIEW ResultadoExames_VIEW AS
SELECT PP.NOME AS "PACIENTE", L.RESULTADO AS "RESULTADO",E.NOME AS "EXAME"
FROM REALIZACAO_EXAME R
INNER JOIN LAUDO L ON L.CODIGO = R.CODIGO_LAUDO
INNER JOIN AGENDAMENTO A ON A.CODIGO = R.CODIGO_AGENDAMENTO
INNER JOIN PACIENTE P ON P.CPF = A.CPF_PACIENTE
INNER JOIN PESSOA PP ON PP.CPF = P.CPF
INNER JOIN EXAME E ON E.CODIGO = A.CODIGO_EXAME

--GRANT/REVOKE DANDO E REMOVENDO PERMISSAO DA VIEW CRIADA ANTERIORMENTE PARA O USER

-- Concedendo a permissão
GRANT SELECT ON ResultadoExames_VIEW TO USER;

-- Removendo a permissão
REVOKE SELECT ON ResultadoExames_VIEW FROM USER;


---PARTES DE PL
--IS RECORD

CREATE TYPE rec_paciente_info IS RECORD (
    nome    PESSOA.Nome%TYPE,
    email   PESSOA.Email%TYPE,
    cartao  PACIENTE.Numero_Cartao%TYPE
)

--TABLE
CREATE TYPE tbl_nomes_exames IS TABLE OF EXAME.Nome%TYPE;


--BLOCOS ANONIMOS ATUALIZAR O EMAIL DE UMA PESSOA COM O CPF X
DECLARE
    v_cpf VARCHAR (12) := '11223344556';
BEGIN
    UPDATE PESSOA SET EMAIL = 'ANONIMO@GMAIL.COM' WHERE CPF = v_cpf ;
END;
/

--CREATE PROCEDURE PROCEDIMENTO PARA CANCELAR AGENDAMENTO PASSANDO O CODIGO DELE

CREATE OR REPLACE PROCEDURE prc_cancelar_agendamento (
    p_codigo_agendamento IN AGENDAMENTO.Codigo%TYPE
) IS
BEGIN
    UPDATE AGENDAMENTO
    SET Status = 'Cancelado'
    WHERE Codigo = p_codigo_agendamento;

    COMMIT;
END prc_cancelar_agendamento;
/

--CREATE FUNCTION para retornar a idade de uma pessoa
CREATE OR REPLACE FUNCTION fn_obter_idade_pessoa (
    p_cpf IN PESSOA.CPF%TYPE 
) RETURN NUMBER IS 
    v_data_nascimento PESSOA.Data_Nascimento%TYPE;
    v_idade NUMBER;
BEGIN
    SELECT
        Data_Nascimento
    INTO
        v_data_nascimento
    FROM
        PESSOA
    WHERE
        CPF = p_cpf;

    v_idade := TRUNC(MONTHS_BETWEEN(SYSDATE, v_data_nascimento) / 12);

    RETURN v_idade;

END;
/


--%type e %rowtype

SET SERVEROUTPUT ON;

DECLARE
    v_matricula FUNCIONARIO.Matricula%TYPE := 'F001';
    r_funcionario_info FUNCIONARIO%ROWTYPE; 
    v_nome_funcionario PESSOA.Nome%TYPE; 
BEGIN
    SELECT * INTO r_funcionario_info FROM FUNCIONARIO WHERE Matricula = v_matricula;
    SELECT Nome INTO v_nome_funcionario FROM PESSOA WHERE CPF = r_funcionario_info.CPF;

    DBMS_OUTPUT.PUT_LINE('Dados do Funcionário: ' || v_nome_funcionario);
    DBMS_OUTPUT.PUT_LINE('Matrícula: ' || r_funcionario_info.Matricula);
    DBMS_OUTPUT.PUT_LINE('Data de Admissão: ' || TO_CHAR(r_funcionario_info.Data_Admissao, 'DD/MM/YYYY'));
END;
/


--IF ELSE IF
CREATE OR REPLACE FUNCTION fn_obter_prioridade_pessoa (
    p_cpf IN PESSOA.CPF%TYPE 
) RETURN AGENDAMENTO.Prioridade%TYPE IS 
    v_idade NUMBER;
    v_prioridade AGENDAMENTO.Prioridade%TYPE;
begin 
    v_idade := fn_obter_idade_pessoa(p_cpf);

    IF v_idade > 60 THEN
        v_prioridade := 'Urgente';
    ELSIF v_idade > 50 THEN 
        v_prioridade := 'Emergência';
    ELSE
        v_prioridade := 'Normal';
    END IF;
    RETURN v_prioridade;
END;
/

--case when
select nome
,FN_OBTER_IDADE_PESSOA(cpf)
,case 
    when FN_OBTER_IDADE_PESSOA(cpf) > 60
        then 'Urgente'
    when FN_OBTER_IDADE_PESSOA(cpf) > 50
        then 'Emergência'
    else 'Normal'
end case
from pessoa

--LOOP EXIT WHEN E CURSOR
CREATE OR REPLACE PROCEDURE prc_verificar_fila_agendamento (
    p_meu_agendamento_id IN AGENDAMENTO.Codigo%TYPE
)
IS
    v_contador_na_frente  NUMBER := 0;
    v_codigo_atual        AGENDAMENTO.Codigo%TYPE;

    CURSOR c_fila_de_prioridade IS
        SELECT Codigo
        FROM AGENDAMENTO
        WHERE Status IN ('Agendado', 'Aguardando')
        ORDER BY
            CASE Prioridade
                WHEN 'Emergência' THEN 1
                WHEN 'Urgente'     THEN 2
                WHEN 'Normal'      THEN 3
                ELSE 4
            END ASC,
            Data_Hora_Agendada ASC;
BEGIN
    OPEN c_fila_de_prioridade;

    DBMS_OUTPUT.PUT_LINE('Verificando a posição do agendamento #' || p_meu_agendamento_id || ' na fila de prioridades...');

    LOOP
        FETCH c_fila_de_prioridade INTO v_codigo_atual;
        EXIT WHEN c_fila_de_prioridade%NOTFOUND;
        EXIT WHEN v_codigo_atual = p_meu_agendamento_id;
        
        v_contador_na_frente := v_contador_na_frente + 1;
    END LOOP;

    CLOSE c_fila_de_prioridade;

    IF v_codigo_atual = p_meu_agendamento_id THEN
        DBMS_OUTPUT.PUT_LINE('Resultado: Existem ' || v_contador_na_frente || ' agendamentos na frente do seu.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Atenção: O agendamento #' || p_meu_agendamento_id || ' não está na fila de espera (pode já ter sido realizado ou cancelado).');
    END IF;
END;
/
SET SERVEROUTPUT ON;

BEGIN
    prc_verificar_fila_agendamento(p_meu_agendamento_id => 22);
    
    DBMS_OUTPUT.PUT_LINE('---------------------------------');
    
    prc_verificar_fila_agendamento(p_meu_agendamento_id => 28);
    
    DBMS_OUTPUT.PUT_LINE('---------------------------------');
    
    prc_verificar_fila_agendamento(p_meu_agendamento_id => 1);

END;
/
--FOR IN LOOP
SET SERVEROUTPUT ON;

BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Atendimentos Pendentes ---');

    FOR r_atendimento IN (
        SELECT
            p.nome,TO_CHAR(a.DATA_HORA_AGENDADA, 'DD/MM/YYYY HH24:MI:SS') AS DATA_HORA_FORMATADA,fn_obter_idade_pessoa(cpf) as Idade
        from agendamento a
        inner join pessoa p on p.cpf = a.CPF_PACIENTE
        where a.STATUS in ('Agendado','Aguardando')
        ORDER BY
            CASE Prioridade
                WHEN 'Emergência' THEN 1
                WHEN 'Urgente'     THEN 2
                WHEN 'Normal'      THEN 3
                ELSE 4
            END ASC,
            Data_Hora_Agendada ASC
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE('Nome: ' || r_atendimento.nome || ' | Idade: ' || r_atendimento.Idade || ' | Hora: ' || r_atendimento.DATA_HORA_FORMATADA);
    END LOOP;

END;
/

--WHILE LOP E TABLE
SET SERVEROUTPUT ON;

DECLARE
    TYPE tbl_cpfs IS TABLE OF PESSOA.CPF%TYPE INDEX BY BINARY_INTEGER;
    
    v_lista_tecnicos tbl_cpfs;
    v_indice         BINARY_INTEGER;
    v_nome_tecnico   PESSOA.Nome%TYPE;

BEGIN
    SELECT CPF BULK COLLECT INTO v_lista_tecnicos FROM TECNICO;

    DBMS_OUTPUT.PUT_LINE('--- Processando Técnicos em Lote ---');
    
    v_indice := v_lista_tecnicos.FIRST;

    WHILE v_indice IS NOT NULL LOOP
    
        SELECT Nome INTO v_nome_tecnico FROM PESSOA WHERE CPF = v_lista_tecnicos(v_indice);
        
        DBMS_OUTPUT.PUT_LINE('Processando técnico: ' || v_nome_tecnico);
        
        v_indice := v_lista_tecnicos.NEXT(v_indice);
        
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('--- Fim do Processamento ---');

END;
/


--SELECT INTO
SET SERVEROUTPUT ON;
DECLARE
    v_nome PESSOA.Email%TYPE;
    v_email PESSOA.email %TYPE;
BEGIN
    select nome, EMAIL
    into v_nome, v_email 
    from pessoa 
    where CPF = '33344455566';

    DBMS_OUTPUT.PUT_LINE('Nome: ' || v_nome);
    DBMS_OUTPUT.PUT_LINE('email: ' || v_email );
end;
/
