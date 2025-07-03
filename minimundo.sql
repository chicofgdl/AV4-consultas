-- =====================================================================
-- ARQUIVO: minimundo_definitivo_v3_corrigido.sql
-- DESCRIÇÃO: Script único e final para apagar, recriar e popular
--            corretamente o banco de dados com carga massiva.
-- BANCO DE DADOS: Oracle
-- =====================================================================

-- -----------------------------------------------------
-- 1. LIMPEZA E CRIAÇÃO DAS TABELAS
-- -----------------------------------------------------
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE DIAGNOSTICO CASCADE CONSTRAINTS';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE LAUDO CASCADE CONSTRAINTS';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE REALIZACAO_EXAME CASCADE CONSTRAINTS';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE ALOCACAO_EQUIPAMENTO CASCADE CONSTRAINTS';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE AGENDAMENTO CASCADE CONSTRAINTS';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE MEDICO_ESPECIALIDADE CASCADE CONSTRAINTS';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE PESSOA_TELEFONE CASCADE CONSTRAINTS';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE SALA_EXAME CASCADE CONSTRAINTS';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE TECNICO CASCADE CONSTRAINTS';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE MEDICO CASCADE CONSTRAINTS';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE PACIENTE CASCADE CONSTRAINTS';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE FUNCIONARIO CASCADE CONSTRAINTS';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE PESSOA CASCADE CONSTRAINTS';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE ENDERECO CASCADE CONSTRAINTS';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE CLINICA CASCADE CONSTRAINTS';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE ESPECIALIDADE CASCADE CONSTRAINTS';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE EQUIPAMENTO CASCADE CONSTRAINTS';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE EXAME CASCADE CONSTRAINTS';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

-- Recriação das tabelas
CREATE TABLE PESSOA (
    CPF VARCHAR2(11 CHAR) NOT NULL,
    Nome VARCHAR2(255 CHAR) NOT NULL,
    Endereco_CEP VARCHAR2(8 CHAR),
    Email VARCHAR2(255 CHAR),
    Data_Nascimento DATE,
    Sexo VARCHAR2(1 CHAR),
    CONSTRAINT pk_pessoa PRIMARY KEY (CPF),
    CONSTRAINT uq_pessoa_email UNIQUE (Email),
    CONSTRAINT chk_pessoa_sexo CHECK (Sexo IN ('M', 'F', 'O'))
);

CREATE TABLE ENDERECO (
    CEP VARCHAR2(8 CHAR) NOT NULL,
    Rua VARCHAR2(255 CHAR),
    Numero VARCHAR2(10 CHAR),
    Bairro VARCHAR2(100 CHAR),
    Cidade VARCHAR2(100 CHAR),
    CONSTRAINT pk_endereco PRIMARY KEY (CEP)
);

ALTER TABLE PESSOA ADD CONSTRAINT fk_pessoa_endereco FOREIGN KEY (Endereco_CEP) REFERENCES ENDERECO(CEP);

CREATE TABLE PACIENTE (
    CPF VARCHAR2(11 CHAR) NOT NULL,
    Numero_Cartao VARCHAR2(50 CHAR),
    CONSTRAINT pk_paciente PRIMARY KEY (CPF),
    CONSTRAINT uq_paciente_cartao UNIQUE (Numero_Cartao),
    CONSTRAINT fk_paciente_pessoa FOREIGN KEY (CPF) REFERENCES PESSOA(CPF)
);

CREATE TABLE FUNCIONARIO (
    CPF VARCHAR2(11 CHAR) NOT NULL,
    Matricula VARCHAR2(20 CHAR) NOT NULL,
    Data_Admissao DATE NOT NULL,
    CPF_Supervisor VARCHAR2(11 CHAR),
    CONSTRAINT pk_funcionario PRIMARY KEY (CPF),
    CONSTRAINT uq_funcionario_matricula UNIQUE (Matricula),
    CONSTRAINT fk_funcionario_pessoa FOREIGN KEY (CPF) REFERENCES PESSOA(CPF),
    CONSTRAINT fk_funcionario_supervisor FOREIGN KEY (CPF_Supervisor) REFERENCES FUNCIONARIO(CPF)
);

CREATE TABLE MEDICO (
    CPF VARCHAR2(11 CHAR) NOT NULL,
    CRM VARCHAR2(20 CHAR) NOT NULL,
    CONSTRAINT pk_medico PRIMARY KEY (CPF),
    CONSTRAINT uq_medico_crm UNIQUE (CRM),
    CONSTRAINT fk_medico_funcionario FOREIGN KEY (CPF) REFERENCES FUNCIONARIO(CPF)
);

CREATE TABLE TECNICO (
    CPF VARCHAR2(11 CHAR) NOT NULL,
    Registro_Tecnico VARCHAR2(50 CHAR),
    CONSTRAINT pk_tecnico PRIMARY KEY (CPF),
    CONSTRAINT fk_tecnico_funcionario FOREIGN KEY (CPF) REFERENCES FUNCIONARIO(CPF)
);

CREATE TABLE PESSOA_TELEFONE (
    CPF VARCHAR2(11 CHAR) NOT NULL,
    Telefone VARCHAR2(15 CHAR) NOT NULL,
    CONSTRAINT pk_pessoa_telefone PRIMARY KEY (CPF, Telefone),
    CONSTRAINT fk_telefone_pessoa FOREIGN KEY (CPF) REFERENCES PESSOA(CPF)
);

CREATE TABLE ESPECIALIDADE (
    Codigo NUMBER GENERATED BY DEFAULT AS IDENTITY NOT NULL,
    Nome VARCHAR2(100 CHAR) NOT NULL,
    Descricao VARCHAR2(255 CHAR),
    CONSTRAINT pk_especialidade PRIMARY KEY (Codigo),
    CONSTRAINT uq_especialidade_nome UNIQUE (Nome)
);

CREATE TABLE CLINICA (
    Codigo NUMBER GENERATED BY DEFAULT AS IDENTITY NOT NULL,
    Nome VARCHAR2(100 CHAR) NOT NULL,
    Endereco VARCHAR2(255 CHAR),
    CONSTRAINT pk_clinica PRIMARY KEY (Codigo)
);

CREATE TABLE EQUIPAMENTO (
    Numero_Serie VARCHAR2(50 CHAR) NOT NULL,
    Tipo_Equipamento VARCHAR2(100 CHAR) NOT NULL,
    CONSTRAINT pk_equipamento PRIMARY KEY (Numero_Serie)
);

CREATE TABLE EXAME (
    Codigo NUMBER GENERATED BY DEFAULT AS IDENTITY NOT NULL,
    Nome VARCHAR2(50 CHAR) NOT NULL,
    Tipo VARCHAR2(50 CHAR),
    CONSTRAINT pk_exame PRIMARY KEY (Codigo)
);

CREATE TABLE MEDICO_ESPECIALIDADE (
    CPF_Medico VARCHAR2(11 CHAR) NOT NULL,
    Codigo_Especialidade NUMBER NOT NULL,
    Data_Obtencao DATE,
    CONSTRAINT pk_medico_especialidade PRIMARY KEY (CPF_Medico, Codigo_Especialidade),
    CONSTRAINT fk_mesp_medico FOREIGN KEY (CPF_Medico) REFERENCES MEDICO(CPF),
    CONSTRAINT fk_mesp_especialidade FOREIGN KEY (Codigo_Especialidade) REFERENCES ESPECIALIDADE(Codigo)
);

CREATE TABLE SALA_EXAME (
    Codigo_Clinica NUMBER NOT NULL,
    Numero_Sala NUMBER NOT NULL,
    CONSTRAINT pk_sala_exame PRIMARY KEY (Codigo_Clinica, Numero_Sala),
    CONSTRAINT fk_sala_clinica FOREIGN KEY (Codigo_Clinica) REFERENCES CLINICA(Codigo)
);

CREATE TABLE ALOCACAO_EQUIPAMENTO (
    Numero_Serie_Equipamento VARCHAR2(50 CHAR) NOT NULL,
    Codigo_Clinica NUMBER NOT NULL,
    Numero_Sala NUMBER NOT NULL,
    Data_Hora_Inicio TIMESTAMP NOT NULL,
    Data_Hora_Termino TIMESTAMP,
    CONSTRAINT pk_alocacao PRIMARY KEY (Numero_Serie_Equipamento, Codigo_Clinica, Numero_Sala, Data_Hora_Inicio),
    CONSTRAINT fk_alocacao_equipamento FOREIGN KEY (Numero_Serie_Equipamento) REFERENCES EQUIPAMENTO(Numero_Serie),
    CONSTRAINT fk_alocacao_sala FOREIGN KEY (Codigo_Clinica, Numero_Sala) REFERENCES SALA_EXAME(Codigo_Clinica, Numero_Sala)
);

CREATE TABLE AGENDAMENTO (
    Codigo NUMBER GENERATED BY DEFAULT AS IDENTITY NOT NULL,
    CPF_Paciente VARCHAR2(11 CHAR) NOT NULL,
    Codigo_Exame NUMBER NOT NULL,
    Data_Hora_Agendada TIMESTAMP NOT NULL,
    Prioridade VARCHAR2(20 CHAR) DEFAULT 'Normal' NOT NULL,
    Status VARCHAR2(20 CHAR) NOT NULL,
    CONSTRAINT pk_agendamento PRIMARY KEY (Codigo),
    CONSTRAINT fk_agendamento_paciente FOREIGN KEY (CPF_Paciente) REFERENCES PACIENTE(CPF),
    CONSTRAINT fk_agendamento_exame FOREIGN KEY (Codigo_Exame) REFERENCES EXAME(Codigo),
    CONSTRAINT chk_agendamento_prioridade CHECK (Prioridade IN ('Normal', 'Urgente', 'Emergência')),
    CONSTRAINT chk_agendamento_status CHECK (Status IN ('Agendado', 'Realizado', 'Cancelado', 'Aguardando'))
);

CREATE TABLE REALIZACAO_EXAME (
    Codigo_Laudo NUMBER GENERATED BY DEFAULT AS IDENTITY NOT NULL,
    Codigo_Agendamento NUMBER NOT NULL,
    CPF_Tecnico VARCHAR2(11 CHAR) NOT NULL,
    Numero_Serie_Equipamento VARCHAR2(50 CHAR),
    Codigo_Clinica NUMBER NOT NULL,
    Numero_Sala NUMBER NOT NULL,
    Data_Hora_Execucao TIMESTAMP NOT NULL,
    Observacoes CLOB,
    CONSTRAINT pk_realizacao_exame PRIMARY KEY (Codigo_Laudo),
    CONSTRAINT uq_realizacao_agendamento UNIQUE (Codigo_Agendamento),
    CONSTRAINT fk_realizacao_agendamento FOREIGN KEY (Codigo_Agendamento) REFERENCES AGENDAMENTO(Codigo),
    CONSTRAINT fk_realizacao_tecnico FOREIGN KEY (CPF_Tecnico) REFERENCES TECNICO(CPF),
    CONSTRAINT fk_realizacao_equipamento FOREIGN KEY (Numero_Serie_Equipamento) REFERENCES EQUIPAMENTO(Numero_Serie),
    CONSTRAINT fk_realizacao_sala FOREIGN KEY (Codigo_Clinica, Numero_Sala) REFERENCES SALA_EXAME(Codigo_Clinica, Numero_Sala)
);

CREATE TABLE LAUDO (
    Codigo NUMBER NOT NULL,
    Data_Hora TIMESTAMP NOT NULL,
    Resultado CLOB NOT NULL,
    Status VARCHAR2(20 CHAR) NOT NULL,
    CONSTRAINT pk_laudo PRIMARY KEY (Codigo),
    CONSTRAINT fk_laudo_realizacao FOREIGN KEY (Codigo) REFERENCES REALIZACAO_EXAME(Codigo_Laudo),
    CONSTRAINT chk_laudo_status CHECK (Status IN ('Emitido', 'Em análise', 'Revisão pendente'))
);

CREATE TABLE DIAGNOSTICO (
    Codigo NUMBER GENERATED BY DEFAULT AS IDENTITY NOT NULL,
    Codigo_Laudo NUMBER NOT NULL,
    CPF_Medico VARCHAR2(11 CHAR) NOT NULL,
    Data_Hora TIMESTAMP NOT NULL,
    Resultado CLOB NOT NULL,
    Status VARCHAR2(20 CHAR),
    CONSTRAINT pk_diagnostico PRIMARY KEY (Codigo),
    CONSTRAINT uq_diagnostico_laudo UNIQUE (Codigo_Laudo),
    CONSTRAINT fk_diagnostico_laudo FOREIGN KEY (Codigo_Laudo) REFERENCES LAUDO(Codigo),
    CONSTRAINT fk_diagnostico_medico FOREIGN KEY (CPF_Medico) REFERENCES MEDICO(CPF),
    CONSTRAINT chk_diagnostico_status CHECK (Status IN ('Preliminar', 'Final', 'Segunda opinião'))
);

-- -----------------------------------------------------
-- 2. POVOAMENTO DO BANCO DE DADOS (DADOS CONSOLIDADOS)
-- -----------------------------------------------------

-- Endereços
INSERT INTO ENDERECO (CEP, Rua, Numero, Bairro, Cidade) VALUES ('51020000', 'Rua das Flores', '123', 'Boa Viagem', 'Recife');
INSERT INTO ENDERECO (CEP, Rua, Numero, Bairro, Cidade) VALUES ('51030000', 'Avenida Parnamirim', '500', 'Parnamirim', 'Recife');
INSERT INTO ENDERECO (CEP, Rua, Numero, Bairro, Cidade) VALUES ('53030020', 'Avenida Gov. Carlos de Lima Cavalcanti', '2500', 'Casa Caiada', 'Olinda');
INSERT INTO ENDERECO (CEP, Rua, Numero, Bairro, Cidade) VALUES ('52060590', 'Rua Doutor José Maria', '980', 'Casa Forte', 'Recife');
INSERT INTO ENDERECO (CEP, Rua, Numero, Bairro, Cidade) VALUES ('54410010', 'Avenida Bernardo Vieira de Melo', '4500', 'Piedade', 'Jaboatão dos Guararapes');
INSERT INTO ENDERECO (CEP, Rua, Numero, Bairro, Cidade) VALUES ('01311000', 'Avenida Paulista', '1578', 'Bela Vista', 'São Paulo');
INSERT INTO ENDERECO (CEP, Rua, Numero, Bairro, Cidade) VALUES ('40015010', 'Avenida da França', '398', 'Comércio', 'Salvador');
INSERT INTO ENDERECO (CEP, Rua, Numero, Bairro, Cidade) VALUES ('22021000', 'Avenida Atlântica', '1702', 'Copacabana', 'Rio de Janeiro');

-- Pessoas
INSERT INTO PESSOA (CPF, Nome, Endereco_CEP, Email, Data_Nascimento, Sexo) VALUES ('11122233344', 'Carlos Santana', '51020000', 'carlos.santana@email.com', TO_DATE('1985-05-15', 'YYYY-MM-DD'), 'M');
INSERT INTO PESSOA (CPF, Nome, Endereco_CEP, Email, Data_Nascimento, Sexo) VALUES ('55566677788', 'Ana Carolina', '51030000', 'ana.carolina@email.com', TO_DATE('1992-02-20', 'YYYY-MM-DD'), 'F');
INSERT INTO PESSOA (CPF, Nome, Endereco_CEP, Email, Data_Nascimento, Sexo) VALUES ('99988877766', 'Roberto Silva', '51020000', 'roberto.silva@email.com', TO_DATE('1978-11-30', 'YYYY-MM-DD'), 'M');
INSERT INTO PESSOA (CPF, Nome, Endereco_CEP, Email, Data_Nascimento, Sexo) VALUES ('12345678900', 'Fernanda Lima', '51030000', 'fernanda.lima@email.com', TO_DATE('1995-07-25', 'YYYY-MM-DD'), 'F');
INSERT INTO PESSOA (CPF, Nome, Endereco_CEP, Email, Data_Nascimento, Sexo) VALUES ('00987654321', 'Juliano Alves', '51020000', 'juliano.alves@email.com', TO_DATE('1988-09-10', 'YYYY-MM-DD'), 'M');
INSERT INTO PESSOA (CPF, Nome, Endereco_CEP, Email, Data_Nascimento, Sexo) VALUES ('22233344455', 'Pedro Costa', '51020000', 'pedro.costa@email.com', TO_DATE('1975-03-10', 'YYYY-MM-DD'), 'M');
INSERT INTO PESSOA (CPF, Nome, Endereco_CEP, Email, Data_Nascimento, Sexo) VALUES ('33344455566', 'Luana Melo', '51030000', 'luana.melo@email.com', TO_DATE('1980-08-22', 'YYYY-MM-DD'), 'F');
INSERT INTO PESSOA (CPF, Nome, Endereco_CEP, Email, Data_Nascimento, Sexo) VALUES ('44455566677', 'Patricia Souza', '51020000', 'patricia.souza@email.com', TO_DATE('1990-01-05', 'YYYY-MM-DD'), 'F');
INSERT INTO PESSOA (CPF, Nome, Endereco_CEP, Email, Data_Nascimento, Sexo) VALUES ('66677788899', 'Maria Oliveira', '51020000', 'maria.oliveira@email.com', TO_DATE('1960-10-01', 'YYYY-MM-DD'), 'F');
INSERT INTO PESSOA (CPF, Nome, Endereco_CEP, Email, Data_Nascimento, Sexo) VALUES ('77788899900', 'João Pereira', '51030000', 'joao.pereira@email.com', TO_DATE('1998-04-20', 'YYYY-MM-DD'), 'M');
INSERT INTO PESSOA (CPF, Nome, Endereco_CEP, Email, Data_Nascimento, Sexo) VALUES ('88899900011', 'Lívia Andrade', '53030020', 'livia.andrade@email.com', TO_DATE('2001-06-18', 'YYYY-MM-DD'), 'F');
INSERT INTO PESSOA (CPF, Nome, Endereco_CEP, Email, Data_Nascimento, Sexo) VALUES ('11223344556', 'Ricardo Borges', '52060590', 'ricardo.borges@email.com', TO_DATE('1982-03-25', 'YYYY-MM-DD'), 'M');
INSERT INTO PESSOA (CPF, Nome, Endereco_CEP, Email, Data_Nascimento, Sexo) VALUES ('55667788990', 'Marcos Vinicius', '53030020', 'marcos.vinicius@email.com', TO_DATE('1955-12-07', 'YYYY-MM-DD'), 'M');
INSERT INTO PESSOA (CPF, Nome, Endereco_CEP, Email, Data_Nascimento, Sexo) VALUES ('33445566778', 'Sandra Gomes', '51020000', 'sandra.gomes@email.com', TO_DATE('1993-09-02', 'YYYY-MM-DD'), 'F');
INSERT INTO PESSOA (CPF, Nome, Endereco_CEP, Email, Data_Nascimento, Sexo) VALUES ('77889900112', 'Beatriz Costa', '51030000', 'beatriz.costa@email.com', TO_DATE('1989-07-14', 'YYYY-MM-DD'), 'F');
INSERT INTO PESSOA (CPF, Nome, Endereco_CEP, Email, Data_Nascimento, Sexo) VALUES ('10120230344', 'Renata Campos', '54410010', 'renata.campos@email.com', TO_DATE('1979-08-19', 'YYYY-MM-DD'), 'F');
INSERT INTO PESSOA (CPF, Nome, Endereco_CEP, Email, Data_Nascimento, Sexo) VALUES ('20230340455', 'Thiago Barbosa', '01311000', 'thiago.barbosa@email.com', TO_DATE('1991-01-30', 'YYYY-MM-DD'), 'M');
INSERT INTO PESSOA (CPF, Nome, Endereco_CEP, Email, Data_Nascimento, Sexo) VALUES ('30340450566', 'Júlia Nogueira', '52060590', 'julia.nogueira@email.com', TO_DATE('1965-04-12', 'YYYY-MM-DD'), 'F');
INSERT INTO PESSOA (CPF, Nome, Endereco_CEP, Email, Data_Nascimento, Sexo) VALUES ('40450560677', 'Daniela Furtado', '51020000', 'daniela.furtado@email.com', TO_DATE('1980-11-05', 'YYYY-MM-DD'), 'F');
INSERT INTO PESSOA (CPF, Nome, Endereco_CEP, Email, Data_Nascimento, Sexo) VALUES ('50560670788', 'Lucas Martins', '54410010', 'lucas.martins@email.com', TO_DATE('1998-02-15', 'YYYY-MM-DD'), 'M');
INSERT INTO PESSOA (CPF, Nome, Endereco_CEP, Email, Data_Nascimento, Sexo) VALUES ('60670780899', 'Vinícius Moraes', '51030000', 'vinicius.moraes@email.com', TO_DATE('1987-07-27', 'YYYY-MM-DD'), 'M');
INSERT INTO PESSOA (CPF, Nome, Endereco_CEP, Email, Data_Nascimento, Sexo) VALUES ('70780890911', 'Gabriela Rocha', '53030020', 'gabriela.rocha@email.com', TO_DATE('2003-10-01', 'YYYY-MM-DD'), 'F');
INSERT INTO PESSOA (CPF, Nome, Endereco_CEP, Email, Data_Nascimento, Sexo) VALUES ('80890911022', 'Alexandre Pires', '01311000', 'alexandre.pires@email.com', TO_DATE('1972-05-20', 'YYYY-MM-DD'), 'M');
INSERT INTO PESSOA (CPF, Nome, Endereco_CEP, Email, Data_Nascimento, Sexo) VALUES ('90180270363', 'Fabiana Teixeira', '40015010', 'fabiana.tx@email.com', TO_DATE('1983-09-14', 'YYYY-MM-DD'), 'F');
INSERT INTO PESSOA (CPF, Nome, Endereco_CEP, Email, Data_Nascimento, Sexo) VALUES ('80270360454', 'Sérgio Mendes', '22021000', 'sergio.mendes@email.com', TO_DATE('1976-11-21', 'YYYY-MM-DD'), 'M');
INSERT INTO PESSOA (CPF, Nome, Endereco_CEP, Email, Data_Nascimento, Sexo) VALUES ('70360450545', 'Cláudio Andrade', '54410010', 'claudio.andrade@email.com', TO_DATE('1968-06-30', 'YYYY-MM-DD'), 'M');
INSERT INTO PESSOA (CPF, Nome, Endereco_CEP, Email, Data_Nascimento, Sexo) VALUES ('60450540636', 'Bárbara Dias', '51020000', 'barbara.dias@email.com', TO_DATE('1999-03-08', 'YYYY-MM-DD'), 'F');
INSERT INTO PESSOA (CPF, Nome, Endereco_CEP, Email, Data_Nascimento, Sexo) VALUES ('50540630727', 'Isabela Freitas', '01311000', 'isabela.freitas@email.com', TO_DATE('2002-12-12', 'YYYY-MM-DD'), 'F');
INSERT INTO PESSOA (CPF, Nome, Endereco_CEP, Email, Data_Nascimento, Sexo) VALUES ('40630720818', 'Rafael Guimarães', '40015010', 'rafa.guimaraes@email.com', TO_DATE('1995-07-07', 'YYYY-MM-DD'), 'M');
INSERT INTO PESSOA (CPF, Nome, Endereco_CEP, Email, Data_Nascimento, Sexo) VALUES ('30720810909', 'Amanda Correia', '22021000', 'amanda.correia@email.com', TO_DATE('1981-02-28', 'YYYY-MM-DD'), 'F');
INSERT INTO PESSOA (CPF, Nome, Endereco_CEP, Email, Data_Nascimento, Sexo) VALUES ('20810901001', 'Felipe Barros', '52060590', 'felipe.barros@email.com', TO_DATE('1970-01-19', 'YYYY-MM-DD'), 'M');
INSERT INTO PESSOA (CPF, Nome, Endereco_CEP, Email, Data_Nascimento, Sexo) VALUES ('10901001192', 'Vanessa Lima', '51030000', 'vanessa.lima@email.com', TO_DATE('1994-08-23', 'YYYY-MM-DD'), 'F');
INSERT INTO PESSOA (CPF, Nome, Endereco_CEP, Email, Data_Nascimento, Sexo) VALUES ('01001192283', 'Gustavo Ribeiro', '53030020', 'gustavo.ribeiro@email.com', TO_DATE('1988-10-03', 'YYYY-MM-DD'), 'M');

-- Telefones
INSERT INTO PESSOA_TELEFONE(CPF, Telefone) VALUES ('11122233344', '81999887766');
INSERT INTO PESSOA_TELEFONE(CPF, Telefone) VALUES ('55566677788', '11988776655');
INSERT INTO PESSOA_TELEFONE(CPF, Telefone) VALUES ('66677788899', '81999001122');
INSERT INTO PESSOA_TELEFONE(CPF, Telefone) VALUES ('77788899900', '11987654321');
INSERT INTO PESSOA_TELEFONE(CPF, Telefone) VALUES ('88899900011', '81987651234');
INSERT INTO PESSOA_TELEFONE(CPF, Telefone) VALUES ('11223344556', '81991234567');
INSERT INTO PESSOA_TELEFONE(CPF, Telefone) VALUES ('55667788990', '81988889999');
INSERT INTO PESSOA_TELEFONE(CPF, Telefone) VALUES ('10120230344', '81995554433');
INSERT INTO PESSOA_TELEFONE(CPF, Telefone) VALUES ('20230340455', '11988771122');
INSERT INTO PESSOA_TELEFONE(CPF, Telefone) VALUES ('30340450566', '81981112233');
INSERT INTO PESSOA_TELEFONE(CPF, Telefone) VALUES ('40450560677', '81992223344');
INSERT INTO PESSOA_TELEFONE(CPF, Telefone) VALUES ('50560670788', '81993334455');
INSERT INTO PESSOA_TELEFONE(CPF, Telefone) VALUES ('90180270363', '71999887766');
INSERT INTO PESSOA_TELEFONE(CPF, Telefone) VALUES ('80270360454', '21988776655');
INSERT INTO PESSOA_TELEFONE(CPF, Telefone) VALUES ('70360450545', '81977665544');
INSERT INTO PESSOA_TELEFONE(CPF, Telefone) VALUES ('20810901001', '81966554433');
INSERT INTO PESSOA_TELEFONE(CPF, Telefone) VALUES ('01001192283', '81955443322');

-- Clínicas
INSERT INTO CLINICA (Nome, Endereco) VALUES ('Clínica Vida e Saúde', 'Rua das Flores, 123, Boa Viagem, Recife');
INSERT INTO CLINICA (Nome, Endereco) VALUES ('Centro Médico Parnamirim', 'Avenida Parnamirim, 500, Parnamirim, Recife');
INSERT INTO CLINICA (Nome, Endereco) VALUES ('Clínica Litoral Norte', 'Avenida Gov. Carlos de Lima Cavalcanti, 2500, Casa Caiada, Olinda');
INSERT INTO CLINICA (Nome, Endereco) VALUES ('Instituto do Coração de Recife', 'Rua dos Navegantes, 1500, Boa Viagem, Recife');
INSERT INTO CLINICA (Nome, Endereco) VALUES ('Centro de Diagnóstico Feminino', 'Rua da Moeda, 120, Recife Antigo, Recife');
INSERT INTO CLINICA (Nome, Endereco) VALUES ('Unidade de Medicina Esportiva', 'Avenida Boa Viagem, 5500, Boa Viagem, Recife');

-- Salas
INSERT INTO SALA_EXAME(Codigo_Clinica, Numero_Sala) VALUES (1, 101);
INSERT INTO SALA_EXAME(Codigo_Clinica, Numero_Sala) VALUES (1, 102);
INSERT INTO SALA_EXAME(Codigo_Clinica, Numero_Sala) VALUES (2, 201);
INSERT INTO SALA_EXAME(Codigo_Clinica, Numero_Sala) VALUES (3, 301);
INSERT INTO SALA_EXAME(Codigo_Clinica, Numero_Sala) VALUES (3, 302);
INSERT INTO SALA_EXAME(Codigo_Clinica, Numero_Sala) VALUES (4, 401);
INSERT INTO SALA_EXAME(Codigo_Clinica, Numero_Sala) VALUES (4, 402);
INSERT INTO SALA_EXAME(Codigo_Clinica, Numero_Sala) VALUES (5, 501);
INSERT INTO SALA_EXAME(Codigo_Clinica, Numero_Sala) VALUES (6, 601);

-- Funcionários
INSERT INTO FUNCIONARIO(CPF, Matricula, Data_Admissao, CPF_Supervisor) VALUES ('99988877766', 'F001', TO_DATE('2010-01-15', 'YYYY-MM-DD'), NULL);
INSERT INTO FUNCIONARIO(CPF, Matricula, Data_Admissao, CPF_Supervisor) VALUES ('12345678900', 'F002', TO_DATE('2018-03-12', 'YYYY-MM-DD'), NULL);
INSERT INTO FUNCIONARIO(CPF, Matricula, Data_Admissao, CPF_Supervisor) VALUES ('00987654321', 'F003', TO_DATE('2020-08-01', 'YYYY-MM-DD'), '99988877766');
INSERT INTO FUNCIONARIO(CPF, Matricula, Data_Admissao, CPF_Supervisor) VALUES ('22233344455', 'F004', TO_DATE('2005-06-01', 'YYYY-MM-DD'), NULL);
INSERT INTO FUNCIONARIO(CPF, Matricula, Data_Admissao, CPF_Supervisor) VALUES ('33344455566', 'F005', TO_DATE('2015-09-20', 'YYYY-MM-DD'), NULL);
INSERT INTO FUNCIONARIO(CPF, Matricula, Data_Admissao, CPF_Supervisor) VALUES ('44455566677', 'F006', TO_DATE('2019-04-18', 'YYYY-MM-DD'), '12345678900');
INSERT INTO FUNCIONARIO(CPF, Matricula, Data_Admissao, CPF_Supervisor) VALUES ('11223344556', 'F007', TO_DATE('2014-10-09', 'YYYY-MM-DD'), '22233344455');
INSERT INTO FUNCIONARIO(CPF, Matricula, Data_Admissao, CPF_Supervisor) VALUES ('33445566778', 'F008', TO_DATE('2021-02-22', 'YYYY-MM-DD'), '12345678900');
INSERT INTO FUNCIONARIO(CPF, Matricula, Data_Admissao, CPF_Supervisor) VALUES ('40450560677', 'F009', TO_DATE('2019-01-20', 'YYYY-MM-DD'), NULL);
INSERT INTO FUNCIONARIO(CPF, Matricula, Data_Admissao, CPF_Supervisor) VALUES ('50560670788', 'F010', TO_DATE('2023-03-10', 'YYYY-MM-DD'), '00987654321');
INSERT INTO FUNCIONARIO(CPF, Matricula, Data_Admissao, CPF_Supervisor) VALUES ('90180270363', 'F011', TO_DATE('2018-07-22', 'YYYY-MM-DD'), NULL);
INSERT INTO FUNCIONARIO(CPF, Matricula, Data_Admissao, CPF_Supervisor) VALUES ('80270360454', 'F012', TO_DATE('2017-05-15', 'YYYY-MM-DD'), '99988877766');
INSERT INTO FUNCIONARIO(CPF, Matricula, Data_Admissao, CPF_Supervisor) VALUES ('40630720818', 'F013', TO_DATE('2022-11-01', 'YYYY-MM-DD'), '12345678900');
INSERT INTO FUNCIONARIO(CPF, Matricula, Data_Admissao, CPF_Supervisor) VALUES ('30720810909', 'F014', TO_DATE('2020-02-03', 'YYYY-MM-DD'), NULL);

-- Médicos
INSERT INTO MEDICO(CPF, CRM) VALUES ('99988877766', 'CRM-PE 12345');
INSERT INTO MEDICO(CPF, CRM) VALUES ('22233344455', 'CRM-PE 54321');
INSERT INTO MEDICO(CPF, CRM) VALUES ('33344455566', 'CRM-PE 67890');
INSERT INTO MEDICO(CPF, CRM) VALUES ('11223344556', 'CRM-PE 23456');
INSERT INTO MEDICO(CPF, CRM) VALUES ('40450560677', 'CRM-PE 34567');
INSERT INTO MEDICO(CPF, CRM) VALUES ('90180270363', 'CRM-BA 45678');
INSERT INTO MEDICO(CPF, CRM) VALUES ('80270360454', 'CRM-RJ 56789');
INSERT INTO MEDICO(CPF, CRM) VALUES ('30720810909', 'CRM-RJ 67890');

-- Técnicos
INSERT INTO TECNICO(CPF, Registro_Tecnico) VALUES ('12345678900', 'CRTR-PE 6789');
INSERT INTO TECNICO(CPF, Registro_Tecnico) VALUES ('44455566677', 'CRTR-PE 9876');
INSERT INTO TECNICO(CPF, Registro_Tecnico) VALUES ('33445566778', 'CRTR-PE 1122');
INSERT INTO TECNICO(CPF, Registro_Tecnico) VALUES ('50560670788', 'CRTE-PE 3344');
INSERT INTO TECNICO(CPF, Registro_Tecnico) VALUES ('40630720818', 'CRTR-BA 4455');

-- Pacientes
INSERT INTO PACIENTE(CPF, Numero_Cartao) VALUES ('11122233344', 'SUS123456789');
INSERT INTO PACIENTE(CPF, Numero_Cartao) VALUES ('55566677788', 'PLANO987654321');
INSERT INTO PACIENTE(CPF, Numero_Cartao) VALUES ('66677788899', 'UNIMED-XYZ789');
INSERT INTO PACIENTE(CPF, Numero_Cartao) VALUES ('77788899900', 'AMIL-ABC123');
INSERT INTO PACIENTE(CPF, Numero_Cartao) VALUES ('88899900011', 'BRADESCO-SAUDE-001');
INSERT INTO PACIENTE(CPF, Numero_Cartao) VALUES ('55667788990', 'SULAMERICA-PLUS-002');
INSERT INTO PACIENTE(CPF, Numero_Cartao) VALUES ('77889900112', 'HAPVIDA-PREMIUM-003');
INSERT INTO PACIENTE(CPF, Numero_Cartao) VALUES ('10120230344', 'GEAP-102030');
INSERT INTO PACIENTE(CPF, Numero_Cartao) VALUES ('20230340455', 'PORTO-SEGURO-405060');
INSERT INTO PACIENTE(CPF, Numero_Cartao) VALUES ('30340450566', 'CASSI-708090');
INSERT INTO PACIENTE(CPF, Numero_Cartao) VALUES ('60670780899', 'SUS543210987');
INSERT INTO PACIENTE(CPF, Numero_Cartao) VALUES ('70780890911', 'UNIMED-REC-654789');
INSERT INTO PACIENTE(CPF, Numero_Cartao) VALUES ('80890911022', 'BRADESCO-TOP-SP-987');
INSERT INTO PACIENTE(CPF, Numero_Cartao) VALUES ('70360450545', 'SUS-BA-112233');
INSERT INTO PACIENTE(CPF, Numero_Cartao) VALUES ('60450540636', 'AMIL-FACIL-445566');
INSERT INTO PACIENTE(CPF, Numero_Cartao) VALUES ('50540630727', 'NOTREDAME-778899');
INSERT INTO PACIENTE(CPF, Numero_Cartao) VALUES ('20810901001', 'BRADESCO-FLEX-101112');
INSERT INTO PACIENTE(CPF, Numero_Cartao) VALUES ('10901001192', 'UNIMED-RIO-131415');
INSERT INTO PACIENTE(CPF, Numero_Cartao) VALUES ('01001192283', 'SUS161718');
-- Funcionários que também são pacientes
INSERT INTO PACIENTE(CPF, Numero_Cartao) VALUES ('90180270363', 'FUNC-PLANO-901');
INSERT INTO PACIENTE(CPF, Numero_Cartao) VALUES ('80270360454', 'FUNC-PLANO-802');
INSERT INTO PACIENTE(CPF, Numero_Cartao) VALUES ('40630720818', 'FUNC-PLANO-406');
INSERT INTO PACIENTE(CPF, Numero_Cartao) VALUES ('30720810909', 'FUNC-PLANO-307');
INSERT INTO PACIENTE(CPF, Numero_Cartao) VALUES ('40450560677', 'FUNC-PLANO-404');


-- Especialidades
INSERT INTO ESPECIALIDADE (Nome, Descricao) VALUES ('Cardiologia', 'Especialidade que trata do coração.');
INSERT INTO ESPECIALIDADE (Nome, Descricao) VALUES ('Radiologia', 'Diagnóstico por imagem.');
INSERT INTO ESPECIALIDADE (Nome, Descricao) VALUES ('Neurologia', 'Especialidade que trata de distúrbios do sistema nervoso.');
INSERT INTO ESPECIALIDADE (Nome, Descricao) VALUES ('Ortopedia', 'Trata de lesões e doenças do sistema locomotor.');
INSERT INTO ESPECIALIDADE (Nome, Descricao) VALUES ('Ginecologia', 'Saúde do aparelho reprodutor feminino e mamas.');
INSERT INTO ESPECIALIDADE (Nome, Descricao) VALUES ('Ecocardiografia', 'Subespecialidade da cardiologia focada em ultrassom cardíaco.');
INSERT INTO ESPECIALIDADE (Nome, Descricao) VALUES ('Pneumologia', 'Tratamento do sistema respiratório.');
INSERT INTO ESPECIALIDADE (Nome, Descricao) VALUES ('Urologia', 'Tratamento do sistema urinário e reprodutor masculino.');
INSERT INTO ESPECIALIDADE (Nome, Descricao) VALUES ('Medicina Esportiva', 'Saúde e performance de atletas.');

-- Relação Médico-Especialidade
INSERT INTO MEDICO_ESPECIALIDADE(CPF_Medico, Codigo_Especialidade, Data_Obtencao) VALUES ('99988877766', 2, TO_DATE('2012-05-20', 'YYYY-MM-DD'));
INSERT INTO MEDICO_ESPECIALIDADE(CPF_Medico, Codigo_Especialidade, Data_Obtencao) VALUES ('33344455566', 1, TO_DATE('2018-01-15', 'YYYY-MM-DD'));
INSERT INTO MEDICO_ESPECIALIDADE(CPF_Medico, Codigo_Especialidade, Data_Obtencao) VALUES ('11223344556', 3, TO_DATE('2016-11-25', 'YYYY-MM-DD'));
INSERT INTO MEDICO_ESPECIALIDADE(CPF_Medico, Codigo_Especialidade, Data_Obtencao) VALUES ('40450560677', 5, TO_DATE('2021-05-10', 'YYYY-MM-DD'));
INSERT INTO MEDICO_ESPECIALIDADE(CPF_Medico, Codigo_Especialidade, Data_Obtencao) VALUES ('33344455566', 6, TO_DATE('2020-02-18', 'YYYY-MM-DD'));
INSERT INTO MEDICO_ESPECIALIDADE(CPF_Medico, Codigo_Especialidade, Data_Obtencao) VALUES ('90180270363', 7, TO_DATE('2020-08-19', 'YYYY-MM-DD'));
INSERT INTO MEDICO_ESPECIALIDADE(CPF_Medico, Codigo_Especialidade, Data_Obtencao) VALUES ('80270360454', 8, TO_DATE('2019-10-01', 'YYYY-MM-DD'));
INSERT INTO MEDICO_ESPECIALIDADE(CPF_Medico, Codigo_Especialidade, Data_Obtencao) VALUES ('30720810909', 9, TO_DATE('2022-01-20', 'YYYY-MM-DD'));
INSERT INTO MEDICO_ESPECIALIDADE(CPF_Medico, Codigo_Especialidade, Data_Obtencao) VALUES ('22233344455', 4, TO_DATE('2010-06-15', 'YYYY-MM-DD'));

-- Exames
INSERT INTO EXAME (Nome, Tipo) VALUES ('Raio-X do Tórax', 'Imagem');
INSERT INTO EXAME (Nome, Tipo) VALUES ('Tomografia Computadorizada', 'Imagem');
INSERT INTO EXAME (Nome, Tipo) VALUES ('Ultrassonografia Abdominal', 'Imagem');
INSERT INTO EXAME (Nome, Tipo) VALUES ('Ressonância Magnética', 'Imagem');
INSERT INTO EXAME (Nome, Tipo) VALUES ('Eletroencefalograma (EEG)', 'Funcional');
INSERT INTO EXAME (Nome, Tipo) VALUES ('Mamografia', 'Imagem');
INSERT INTO EXAME (Nome, Tipo) VALUES ('Ecocardiograma', 'Imagem');
INSERT INTO EXAME (Nome, Tipo) VALUES ('Teste Ergométrico', 'Funcional');
INSERT INTO EXAME (Nome, Tipo) VALUES ('Densitometria Óssea', 'Imagem');
INSERT INTO EXAME (Nome, Tipo) VALUES ('Espirometria', 'Funcional');
INSERT INTO EXAME (Nome, Tipo) VALUES ('Ultrassonografia de Próstata', 'Imagem');

-- Equipamentos
INSERT INTO EQUIPAMENTO(Numero_Serie, Tipo_Equipamento) VALUES ('RX-BR-MODELO-5000', 'Raio-X');
INSERT INTO EQUIPAMENTO(Numero_Serie, Tipo_Equipamento) VALUES ('ULTRA-GE-PRO', 'Ultrassom');
INSERT INTO EQUIPAMENTO(Numero_Serie, Tipo_Equipamento) VALUES ('TOMO-SIEMENS-XYZ', 'Tomógrafo');
INSERT INTO EQUIPAMENTO(Numero_Serie, Tipo_Equipamento) VALUES ('MRI-PHILIPS-ACHIEVA', 'Ressonância Magnética');
INSERT INTO EQUIPAMENTO(Numero_Serie, Tipo_Equipamento) VALUES ('EEG-NEUROSOFT-PRO', 'Eletroencefalógrafo');
INSERT INTO EQUIPAMENTO(Numero_Serie, Tipo_Equipamento) VALUES ('MAMMO-HOLOGIC-SELENIA', 'Mamógrafo');
INSERT INTO EQUIPAMENTO(Numero_Serie, Tipo_Equipamento) VALUES ('ECO-GE-VIVID-E95', 'Aparelho de Ecocardiograma');
INSERT INTO EQUIPAMENTO(Numero_Serie, Tipo_Equipamento) VALUES ('ESTEIRA-ATL-PRO', 'Esteira Ergométrica');
INSERT INTO EQUIPAMENTO(Numero_Serie, Tipo_Equipamento) VALUES ('ESPIR-JAEGER-MASTER', 'Espirômetro');

-- Alocação de Equipamentos
INSERT INTO ALOCACAO_EQUIPAMENTO(Numero_Serie_Equipamento, Codigo_Clinica, Numero_Sala, Data_Hora_Inicio) VALUES ('RX-BR-MODELO-5000', 1, 101, TO_TIMESTAMP('2025-01-01 08:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO ALOCACAO_EQUIPAMENTO(Numero_Serie_Equipamento, Codigo_Clinica, Numero_Sala, Data_Hora_Inicio) VALUES ('ULTRA-GE-PRO', 2, 201, TO_TIMESTAMP('2025-01-01 09:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO ALOCACAO_EQUIPAMENTO(Numero_Serie_Equipamento, Codigo_Clinica, Numero_Sala, Data_Hora_Inicio) VALUES ('TOMO-SIEMENS-XYZ', 1, 102, TO_TIMESTAMP('2025-01-01 08:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO ALOCACAO_EQUIPAMENTO(Numero_Serie_Equipamento, Codigo_Clinica, Numero_Sala, Data_Hora_Inicio) VALUES ('MRI-PHILIPS-ACHIEVA', 3, 301, TO_TIMESTAMP('2025-02-01 08:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO ALOCACAO_EQUIPAMENTO(Numero_Serie_Equipamento, Codigo_Clinica, Numero_Sala, Data_Hora_Inicio) VALUES ('EEG-NEUROSOFT-PRO', 3, 302, TO_TIMESTAMP('2025-02-01 08:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO ALOCACAO_EQUIPAMENTO(Numero_Serie_Equipamento, Codigo_Clinica, Numero_Sala, Data_Hora_Inicio) VALUES ('MAMMO-HOLOGIC-SELENIA', 5, 501, TO_TIMESTAMP('2025-06-01 07:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO ALOCACAO_EQUIPAMENTO(Numero_Serie_Equipamento, Codigo_Clinica, Numero_Sala, Data_Hora_Inicio) VALUES ('ECO-GE-VIVID-E95', 4, 401, TO_TIMESTAMP('2025-03-01 07:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO ALOCACAO_EQUIPAMENTO(Numero_Serie_Equipamento, Codigo_Clinica, Numero_Sala, Data_Hora_Inicio) VALUES ('ESTEIRA-ATL-PRO', 6, 601, TO_TIMESTAMP('2025-03-01 07:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO ALOCACAO_EQUIPAMENTO(Numero_Serie_Equipamento, Codigo_Clinica, Numero_Sala, Data_Hora_Inicio) VALUES ('ESPIR-JAEGER-MASTER', 2, 201, TO_TIMESTAMP('2025-04-01 07:00:00', 'YYYY-MM-DD HH24:MI:SS'));

-- FLUXO COMPLETO: AGENDAMENTO -> REALIZAÇÃO -> LAUDO -> DIAGNÓSTICO
-- Agendamento 1 a 20
INSERT INTO AGENDAMENTO (CPF_Paciente, Codigo_Exame, Data_Hora_Agendada, Prioridade, Status) VALUES ('11122233344', 1, TO_TIMESTAMP('2025-07-10 14:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Normal', 'Realizado');
INSERT INTO AGENDAMENTO (CPF_Paciente, Codigo_Exame, Data_Hora_Agendada, Prioridade, Status) VALUES ('55566677788', 2, TO_TIMESTAMP('2025-07-15 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Urgente', 'Realizado');
INSERT INTO AGENDAMENTO (CPF_Paciente, Codigo_Exame, Data_Hora_Agendada, Prioridade, Status) VALUES ('66677788899', 3, TO_TIMESTAMP('2025-07-28 09:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Normal', 'Realizado');
INSERT INTO AGENDAMENTO (CPF_Paciente, Codigo_Exame, Data_Hora_Agendada, Prioridade, Status) VALUES ('77788899900', 1, TO_TIMESTAMP('2025-07-30 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Urgente', 'Realizado');
INSERT INTO AGENDAMENTO (CPF_Paciente, Codigo_Exame, Data_Hora_Agendada, Prioridade, Status) VALUES ('88899900011', 4, TO_TIMESTAMP('2025-08-05 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Urgente', 'Realizado');
INSERT INTO AGENDAMENTO (CPF_Paciente, Codigo_Exame, Data_Hora_Agendada, Prioridade, Status) VALUES ('55667788990', 5, TO_TIMESTAMP('2025-08-10 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Normal', 'Realizado');
INSERT INTO AGENDAMENTO (CPF_Paciente, Codigo_Exame, Data_Hora_Agendada, Prioridade, Status) VALUES ('77889900112', 1, TO_TIMESTAMP('2025-08-12 16:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Normal', 'Cancelado');
INSERT INTO AGENDAMENTO (CPF_Paciente, Codigo_Exame, Data_Hora_Agendada, Prioridade, Status) VALUES ('11122233344', 3, TO_TIMESTAMP('2025-09-20 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Normal', 'Agendado');
INSERT INTO AGENDAMENTO (CPF_Paciente, Codigo_Exame, Data_Hora_Agendada, Prioridade, Status) VALUES ('10120230344', 7, TO_TIMESTAMP('2025-08-20 19:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Emergência', 'Realizado');
INSERT INTO AGENDAMENTO (CPF_Paciente, Codigo_Exame, Data_Hora_Agendada, Prioridade, Status) VALUES ('30340450566', 6, TO_TIMESTAMP('2025-09-01 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Normal', 'Realizado');
INSERT INTO AGENDAMENTO (CPF_Paciente, Codigo_Exame, Data_Hora_Agendada, Prioridade, Status) VALUES ('66677788899', 9, TO_TIMESTAMP('2025-09-05 08:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Normal', 'Realizado');
INSERT INTO AGENDAMENTO (CPF_Paciente, Codigo_Exame, Data_Hora_Agendada, Prioridade, Status) VALUES ('20230340455', 4, TO_TIMESTAMP('2025-09-15 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Normal', 'Aguardando');
INSERT INTO AGENDAMENTO (CPF_Paciente, Codigo_Exame, Data_Hora_Agendada, Prioridade, Status) VALUES ('60670780899', 8, TO_TIMESTAMP('2025-09-18 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Normal', 'Cancelado');
INSERT INTO AGENDAMENTO (CPF_Paciente, Codigo_Exame, Data_Hora_Agendada, Prioridade, Status) VALUES ('70780890911', 1, TO_TIMESTAMP('2025-10-02 11:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Normal', 'Agendado');
INSERT INTO AGENDAMENTO (CPF_Paciente, Codigo_Exame, Data_Hora_Agendada, Prioridade, Status) VALUES ('80890911022', 2, TO_TIMESTAMP('2025-10-10 16:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Urgente', 'Agendado');
INSERT INTO AGENDAMENTO (CPF_Paciente, Codigo_Exame, Data_Hora_Agendada, Prioridade, Status) VALUES ('01001192283', 1, TO_TIMESTAMP('2025-10-15 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Normal', 'Realizado');
INSERT INTO AGENDAMENTO (CPF_Paciente, Codigo_Exame, Data_Hora_Agendada, Prioridade, Status) VALUES ('01001192283', 2, TO_TIMESTAMP('2025-10-22 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Urgente', 'Realizado');
INSERT INTO AGENDAMENTO (CPF_Paciente, Codigo_Exame, Data_Hora_Agendada, Prioridade, Status) VALUES ('20810901001', 11, TO_TIMESTAMP('2025-11-05 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Normal', 'Realizado');
INSERT INTO AGENDAMENTO (CPF_Paciente, Codigo_Exame, Data_Hora_Agendada, Prioridade, Status) VALUES ('70360450545', 11, TO_TIMESTAMP('2025-11-05 08:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Normal', 'Agendado');
INSERT INTO AGENDAMENTO (CPF_Paciente, Codigo_Exame, Data_Hora_Agendada, Prioridade, Status) VALUES ('11122233344', 8, TO_TIMESTAMP('2025-11-10 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Normal', 'Realizado');

-- Realizações, Laudos e Diagnósticos
INSERT INTO REALIZACAO_EXAME (Codigo_Agendamento, CPF_Tecnico, Numero_Serie_Equipamento, Codigo_Clinica, Numero_Sala, Data_Hora_Execucao, Observacoes) VALUES (1, '12345678900', 'RX-BR-MODELO-5000', 1, 101, TO_TIMESTAMP('2025-07-10 14:35:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paciente colaborativo.');
INSERT INTO LAUDO (Codigo, Data_Hora, Resultado, Status) VALUES (1, TO_TIMESTAMP('2025-07-10 15:10:00', 'YYYY-MM-DD HH24:MI:SS'), 'Não foram observadas opacidades ou anormalidades.', 'Emitido');
INSERT INTO DIAGNOSTICO (Codigo_Laudo, CPF_Medico, Data_Hora, Resultado, Status) VALUES (1, '99988877766', TO_TIMESTAMP('2025-07-11 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Exame dentro dos padrões da normalidade.', 'Final');

INSERT INTO REALIZACAO_EXAME (Codigo_Agendamento, CPF_Tecnico, Numero_Serie_Equipamento, Codigo_Clinica, Numero_Sala, Data_Hora_Execucao, Observacoes) VALUES (2, '44455566677', 'TOMO-SIEMENS-XYZ', 1, 102, TO_TIMESTAMP('2025-07-15 10:15:00', 'YYYY-MM-DD HH24:MI:SS'), 'Claustrofobia inicial.');
INSERT INTO LAUDO (Codigo, Data_Hora, Resultado, Status) VALUES (2, TO_TIMESTAMP('2025-07-15 11:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Pequena lesão isquêmica em lobo frontal direito.', 'Em análise');
INSERT INTO DIAGNOSTICO (Codigo_Laudo, CPF_Medico, Data_Hora, Resultado, Status) VALUES (2, '99988877766', TO_TIMESTAMP('2025-07-16 08:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'Achado incidental de lesão isquêmica crônica.', 'Final');

INSERT INTO REALIZACAO_EXAME (Codigo_Agendamento, CPF_Tecnico, Numero_Serie_Equipamento, Codigo_Clinica, Numero_Sala, Data_Hora_Execucao, Observacoes) VALUES (3, '44455566677', 'ULTRA-GE-PRO', 2, 201, TO_TIMESTAMP('2025-07-28 09:35:00', 'YYYY-MM-DD HH24:MI:SS'), 'Sem intercorrências.');
INSERT INTO LAUDO (Codigo, Data_Hora, Resultado, Status) VALUES (3, TO_TIMESTAMP('2025-07-28 10:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Ultrassonografia abdominal sem alterações.', 'Emitido');
INSERT INTO DIAGNOSTICO (Codigo_Laudo, CPF_Medico, Data_Hora, Resultado, Status) VALUES (3, '22233344455', TO_TIMESTAMP('2025-07-29 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Exame dentro dos limites da normalidade.', 'Final');

INSERT INTO REALIZACAO_EXAME (Codigo_Agendamento, CPF_Tecnico, Numero_Serie_Equipamento, Codigo_Clinica, Numero_Sala, Data_Hora_Execucao, Observacoes) VALUES (4, '12345678900', 'RX-BR-MODELO-5000', 1, 101, TO_TIMESTAMP('2025-07-30 15:10:00', 'YYYY-MM-DD HH24:MI:SS'), 'Exame de rotina.');
INSERT INTO LAUDO (Codigo, Data_Hora, Resultado, Status) VALUES (4, TO_TIMESTAMP('2025-07-30 16:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Campos pulmonares transparentes.', 'Emitido');
INSERT INTO DIAGNOSTICO (Codigo_Laudo, CPF_Medico, Data_Hora, Resultado, Status) VALUES (4, '33344455566', TO_TIMESTAMP('2025-07-31 09:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Radiografia de tórax sem alterações.', 'Final');

INSERT INTO REALIZACAO_EXAME (Codigo_Agendamento, CPF_Tecnico, Numero_Serie_Equipamento, Codigo_Clinica, Numero_Sala, Data_Hora_Execucao, Observacoes) VALUES (5, '33445566778', 'MRI-PHILIPS-ACHIEVA', 3, 301, TO_TIMESTAMP('2025-08-05 11:10:00', 'YYYY-MM-DD HH24:MI:SS'), 'Contraste administrado.');
INSERT INTO LAUDO (Codigo, Data_Hora, Resultado, Status) VALUES (5, TO_TIMESTAMP('2025-08-05 12:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Sinais compatíveis com esclerose múltipla em atividade.', 'Emitido');
INSERT INTO DIAGNOSTICO (Codigo_Laudo, CPF_Medico, Data_Hora, Resultado, Status) VALUES (5, '11223344556', TO_TIMESTAMP('2025-08-06 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Corroborada hipótese de Esclerose Múltipla.', 'Final');

INSERT INTO REALIZACAO_EXAME (Codigo_Agendamento, CPF_Tecnico, Numero_Serie_Equipamento, Codigo_Clinica, Numero_Sala, Data_Hora_Execucao, Observacoes) VALUES (6, '33445566778', 'EEG-NEUROSOFT-PRO', 3, 302, TO_TIMESTAMP('2025-08-10 09:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paciente sonolento.');
INSERT INTO LAUDO (Codigo, Data_Hora, Resultado, Status) VALUES (6, TO_TIMESTAMP('2025-08-10 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Atividade epileptiforme focal na região temporal esquerda.', 'Revisão pendente');
INSERT INTO DIAGNOSTICO (Codigo_Laudo, CPF_Medico, Data_Hora, Resultado, Status) VALUES (6, '11223344556', TO_TIMESTAMP('2025-08-11 09:15:00', 'YYYY-MM-DD HH24:MI:SS'), 'Foco epileptogênico em lobo temporal esquerdo.', 'Preliminar');

INSERT INTO REALIZACAO_EXAME (Codigo_Agendamento, CPF_Tecnico, Numero_Serie_Equipamento, Codigo_Clinica, Numero_Sala, Data_Hora_Execucao, Observacoes) VALUES (9, '50560670788', 'ECO-GE-VIVID-E95', 4, 401, TO_TIMESTAMP('2025-08-20 19:40:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paciente com dor precordial intensa.');
INSERT INTO LAUDO (Codigo, Data_Hora, Resultado, Status) VALUES (7, TO_TIMESTAMP('2025-08-20 20:15:00', 'YYYY-MM-DD HH24:MI:SS'), 'Acinesia em parede anterior. FE de 35%. Sugestivo de IAM.', 'Emitido');
INSERT INTO DIAGNOSTICO (Codigo_Laudo, CPF_Medico, Data_Hora, Resultado, Status) VALUES (7, '33344455566', TO_TIMESTAMP('2025-08-20 20:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Confirmação de IAM anterior.', 'Final');

INSERT INTO REALIZACAO_EXAME (Codigo_Agendamento, CPF_Tecnico, Numero_Serie_Equipamento, Codigo_Clinica, Numero_Sala, Data_Hora_Execucao, Observacoes) VALUES (10, '12345678900', 'MAMMO-HOLOGIC-SELENIA', 5, 501, TO_TIMESTAMP('2025-09-01 10:10:00', 'YYYY-MM-DD HH24:MI:SS'), 'Mamografia de rotina.');
INSERT INTO LAUDO (Codigo, Data_Hora, Resultado, Status) VALUES (8, TO_TIMESTAMP('2025-09-01 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Mamas densas, sem nódulos ou calcificações. BI-RADS 2.', 'Emitido');
INSERT INTO DIAGNOSTICO (Codigo_Laudo, CPF_Medico, Data_Hora, Resultado, Status) VALUES (8, '40450560677', TO_TIMESTAMP('2025-09-02 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Sem alterações de relevância.', 'Final');

INSERT INTO REALIZACAO_EXAME (Codigo_Agendamento, CPF_Tecnico, Numero_Serie_Equipamento, Codigo_Clinica, Numero_Sala, Data_Hora_Execucao, Observacoes) VALUES (11, '44455566677', 'RX-BR-MODELO-5000', 1, 101, TO_TIMESTAMP('2025-09-05 08:40:00', 'YYYY-MM-DD HH24:MI:SS'), 'Densitometria óssea.');
INSERT INTO LAUDO (Codigo, Data_Hora, Resultado, Status) VALUES (9, TO_TIMESTAMP('2025-09-05 09:10:00', 'YYYY-MM-DD HH24:MI:SS'), 'T-score em coluna de -2.8 e fêmur de -2.6. Compatível com osteoporose.', 'Emitido');
INSERT INTO DIAGNOSTICO (Codigo_Laudo, CPF_Medico, Data_Hora, Resultado, Status) VALUES (9, '22233344455', TO_TIMESTAMP('2025-09-06 11:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Diagnóstico de osteoporose.', 'Final');

INSERT INTO REALIZACAO_EXAME (Codigo_Agendamento, CPF_Tecnico, Numero_Serie_Equipamento, Codigo_Clinica, Numero_Sala, Data_Hora_Execucao, Observacoes) VALUES (16, '12345678900', 'RX-BR-MODELO-5000', 1, 101, TO_TIMESTAMP('2025-10-15 09:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Tosse persistente.');
INSERT INTO LAUDO (Codigo, Data_Hora, Resultado, Status) VALUES (10, TO_TIMESTAMP('2025-10-15 09:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'Nódulo pulmonar no lobo superior direito. Sugere-se TC.', 'Emitido');
INSERT INTO DIAGNOSTICO (Codigo_Laudo, CPF_Medico, Data_Hora, Resultado, Status) VALUES (10, '90180270363', TO_TIMESTAMP('2025-10-15 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Achado de nódulo suspeito. Solicito Tomografia.', 'Final');

INSERT INTO REALIZACAO_EXAME (Codigo_Agendamento, CPF_Tecnico, Numero_Serie_Equipamento, Codigo_Clinica, Numero_Sala, Data_Hora_Execucao, Observacoes) VALUES (17, '44455566677', 'TOMO-SIEMENS-XYZ', 1, 102, TO_TIMESTAMP('2025-10-22 14:10:00', 'YYYY-MM-DD HH24:MI:SS'), 'TC de tórax com contraste.');
INSERT INTO LAUDO (Codigo, Data_Hora, Resultado, Status) VALUES (11, TO_TIMESTAMP('2025-10-22 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Nódulo espiculado de 2cm no LSD. Suspeito para neoplasia.', 'Emitido');
INSERT INTO DIAGNOSTICO (Codigo_Laudo, CPF_Medico, Data_Hora, Resultado, Status) VALUES (11, '90180270363', TO_TIMESTAMP('2025-10-23 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Lesão maligna. Encaminhado para biópsia.', 'Final');

INSERT INTO REALIZACAO_EXAME (Codigo_Agendamento, CPF_Tecnico, Numero_Serie_Equipamento, Codigo_Clinica, Numero_Sala, Data_Hora_Execucao) VALUES (18, '50560670788', 'ULTRA-GE-PRO', 2, 201, TO_TIMESTAMP('2025-11-05 08:10:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO LAUDO (Codigo, Data_Hora, Resultado, Status) VALUES (12, TO_TIMESTAMP('2025-11-05 08:40:00', 'YYYY-MM-DD HH24:MI:SS'), 'Próstata com volume normal, ecotextura homogênea.', 'Emitido');
INSERT INTO DIAGNOSTICO (Codigo_Laudo, CPF_Medico, Data_Hora, Resultado, Status) VALUES (12, '80270360454', TO_TIMESTAMP('2025-11-06 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Exame dentro da normalidade.', 'Final');

INSERT INTO REALIZACAO_EXAME (Codigo_Agendamento, CPF_Tecnico, Numero_Serie_Equipamento, Codigo_Clinica, Numero_Sala, Data_Hora_Execucao, Observacoes) VALUES (20, '50560670788', 'ESTEIRA-ATL-PRO', 6, 601, TO_TIMESTAMP('2025-11-10 10:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Teste ergométrico máximo.');
INSERT INTO LAUDO (Codigo, Data_Hora, Resultado, Status) VALUES (13, TO_TIMESTAMP('2025-11-10 11:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Capacidade funcional excelente.', 'Emitido');
INSERT INTO DIAGNOSTICO (Codigo_Laudo, CPF_Medico, Data_Hora, Resultado, Status) VALUES (13, '30720810909', TO_TIMESTAMP('2025-11-11 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Apto para atividades esportivas.', 'Final');

-- Agendamentos e Realizações do Último Lote
INSERT INTO AGENDAMENTO (CPF_Paciente, Codigo_Exame, Data_Hora_Agendada, Prioridade, Status) VALUES ('60450540636', 7, TO_TIMESTAMP('2026-01-20 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Normal', 'Agendado');
INSERT INTO AGENDAMENTO (CPF_Paciente, Codigo_Exame, Data_Hora_Agendada, Prioridade, Status) VALUES ('80270360454', 11, TO_TIMESTAMP('2026-01-22 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Normal', 'Agendado');
INSERT INTO AGENDAMENTO (CPF_Paciente, Codigo_Exame, Data_Hora_Agendada, Prioridade, Status) VALUES ('50540630727', 4, TO_TIMESTAMP('2026-01-25 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Normal', 'Cancelado');

INSERT INTO AGENDAMENTO (CPF_Paciente, Codigo_Exame, Data_Hora_Agendada, Prioridade, Status) VALUES ('40630720818', 8, TO_TIMESTAMP('2025-12-01 08:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Normal', 'Realizado');
INSERT INTO REALIZACAO_EXAME (Codigo_Agendamento, CPF_Tecnico, Numero_Serie_Equipamento, Codigo_Clinica, Numero_Sala, Data_Hora_Execucao, Observacoes) VALUES (24, '50560670788', 'ESTEIRA-ATL-PRO', 6, 601, TO_TIMESTAMP('2025-12-01 08:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'Avaliação pré-temporada.');
INSERT INTO LAUDO (Codigo, Data_Hora, Resultado, Status) VALUES (14, TO_TIMESTAMP('2025-12-01 09:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Boa performance, sem sinais de alerta.', 'Emitido');
INSERT INTO DIAGNOSTICO (Codigo_Laudo, CPF_Medico, Data_Hora, Resultado, Status) VALUES (14, '30720810909', TO_TIMESTAMP('2025-12-02 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Liberado para atividades físicas.', 'Final');

INSERT INTO AGENDAMENTO (CPF_Paciente, Codigo_Exame, Data_Hora_Agendada, Prioridade, Status) VALUES ('30720810909', 10, TO_TIMESTAMP('2025-12-03 16:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Normal', 'Realizado');
INSERT INTO REALIZACAO_EXAME (Codigo_Agendamento, CPF_Tecnico, Numero_Serie_Equipamento, Codigo_Clinica, Numero_Sala, Data_Hora_Execucao) VALUES (25, '40630720818', 'ESPIR-JAEGER-MASTER', 2, 201, TO_TIMESTAMP('2025-12-03 16:10:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO LAUDO (Codigo, Data_Hora, Resultado, Status) VALUES (15, TO_TIMESTAMP('2025-12-03 16:40:00', 'YYYY-MM-DD HH24:MI:SS'), 'Função pulmonar normal.', 'Emitido');
INSERT INTO DIAGNOSTICO (Codigo_Laudo, CPF_Medico, Data_Hora, Resultado, Status) VALUES (15, '90180270363', TO_TIMESTAMP('2025-12-04 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Exame de rotina sem alterações.', 'Final');

INSERT INTO AGENDAMENTO (CPF_Paciente, Codigo_Exame, Data_Hora_Agendada, Prioridade, Status) VALUES ('20810901001', 2, TO_TIMESTAMP('2025-12-05 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Urgente', 'Realizado');
INSERT INTO REALIZACAO_EXAME (Codigo_Agendamento, CPF_Tecnico, Numero_Serie_Equipamento, Codigo_Clinica, Numero_Sala, Data_Hora_Execucao) VALUES (26, '44455566677', 'TOMO-SIEMENS-XYZ', 1, 102, TO_TIMESTAMP('2025-12-05 14:15:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO LAUDO (Codigo, Data_Hora, Resultado, Status) VALUES (16, TO_TIMESTAMP('2025-12-05 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'TC de abdome sem alterações agudas.', 'Emitido');
INSERT INTO DIAGNOSTICO (Codigo_Laudo, CPF_Medico, Data_Hora, Resultado, Status) VALUES (16, '99988877766', TO_TIMESTAMP('2025-12-06 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Nenhuma causa aparente para a dor abdominal.', 'Final');

INSERT INTO AGENDAMENTO (CPF_Paciente, Codigo_Exame, Data_Hora_Agendada, Prioridade, Status) VALUES ('10901001192', 6, TO_TIMESTAMP('2025-12-10 09:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Normal', 'Realizado');
INSERT INTO REALIZACAO_EXAME (Codigo_Agendamento, CPF_Tecnico, Numero_Serie_Equipamento, Codigo_Clinica, Numero_Sala, Data_Hora_Execucao) VALUES (27, '12345678900', 'MAMMO-HOLOGIC-SELENIA', 5, 501, TO_TIMESTAMP('2025-12-10 09:40:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO LAUDO (Codigo, Data_Hora, Resultado, Status) VALUES (17, TO_TIMESTAMP('2025-12-10 10:20:00', 'YYYY-MM-DD HH24:MI:SS'), 'Check-up anual sem alterações.', 'Emitido');
INSERT INTO DIAGNOSTICO (Codigo_Laudo, CPF_Medico, Data_Hora, Resultado, Status) VALUES (17, '40450560677', TO_TIMESTAMP('2025-12-11 11:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'BI-RADS 1. Retorno em um ano.', 'Final');

INSERT INTO AGENDAMENTO (CPF_Paciente, Codigo_Exame, Data_Hora_Agendada, Prioridade, Status) VALUES ('66677788899', 9, TO_TIMESTAMP('2026-02-01 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Normal', 'Agendado');

INSERT INTO AGENDAMENTO (CPF_Paciente, Codigo_Exame, Data_Hora_Agendada, Prioridade, Status) VALUES ('11122233344', 8, TO_TIMESTAMP('2026-02-05 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Normal', 'Realizado');
INSERT INTO REALIZACAO_EXAME (Codigo_Agendamento, CPF_Tecnico, Numero_Serie_Equipamento, Codigo_Clinica, Numero_Sala, Data_Hora_Execucao) VALUES (29, '50560670788', 'ESTEIRA-ATL-PRO', 6, 601, TO_TIMESTAMP('2026-02-05 11:15:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO LAUDO (Codigo, Data_Hora, Resultado, Status) VALUES (18, TO_TIMESTAMP('2026-02-05 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Acompanhamento anual, sem alterações.', 'Emitido');
INSERT INTO DIAGNOSTICO (Codigo_Laudo, CPF_Medico, Data_Hora, Resultado, Status) VALUES (18, '30720810909', TO_TIMESTAMP('2026-02-06 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Mantém bom condicionamento.', 'Final');

INSERT INTO AGENDAMENTO (CPF_Paciente, Codigo_Exame, Data_Hora_Agendada, Prioridade, Status) VALUES ('55566677788', 5, TO_TIMESTAMP('2026-02-10 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Normal', 'Realizado');
INSERT INTO REALIZACAO_EXAME (Codigo_Agendamento, CPF_Tecnico, Numero_Serie_Equipamento, Codigo_Clinica, Numero_Sala, Data_Hora_Execucao) VALUES (30, '33445566778', 'EEG-NEUROSOFT-PRO', 3, 302, TO_TIMESTAMP('2026-02-10 15:30:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO LAUDO (Codigo, Data_Hora, Resultado, Status) VALUES (19, TO_TIMESTAMP('2026-02-10 16:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'EEG de acompanhamento. Padrão estável.', 'Emitido');
INSERT INTO DIAGNOSTICO (Codigo_Laudo, CPF_Medico, Data_Hora, Resultado, Status) VALUES (19, '11223344556', TO_TIMESTAMP('2026-02-11 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paciente clinicamente estável.', 'Final');

-- **INÍCIO DA CORREÇÃO**
INSERT INTO AGENDAMENTO (CPF_Paciente, Codigo_Exame, Data_Hora_Agendada, Prioridade, Status) VALUES ('90180270363', 10, TO_TIMESTAMP('2026-04-01 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Normal', 'Realizado');
-- O agendamento acima é o 31º. O valor 39 estava errado.
INSERT INTO REALIZACAO_EXAME (Codigo_Agendamento, CPF_Tecnico, Numero_Serie_Equipamento, Codigo_Clinica, Numero_Sala, Data_Hora_Execucao) VALUES (31, '40630720818', 'ESPIR-JAEGER-MASTER', 2, 201, TO_TIMESTAMP('2026-04-01 10:10:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO LAUDO (Codigo, Data_Hora, Resultado, Status) VALUES (20, TO_TIMESTAMP('2026-04-01 10:40:00', 'YYYY-MM-DD HH24:MI:SS'), 'Acompanhamento anual de função pulmonar. Estável.', 'Emitido');
INSERT INTO DIAGNOSTICO (Codigo_Laudo, CPF_Medico, Data_Hora, Resultado, Status) VALUES (20, '90180270363', TO_TIMESTAMP('2026-04-02 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Função pulmonar preservada.', 'Final');
-- **FIM DA CORREÇÃO**

-- Mais agendamentos futuros e diversos
INSERT INTO AGENDAMENTO (CPF_Paciente, Codigo_Exame, Data_Hora_Agendada, Prioridade, Status) VALUES ('77788899900', 1, TO_TIMESTAMP('2026-02-15 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Normal', 'Agendado');
INSERT INTO AGENDAMENTO (CPF_Paciente, Codigo_Exame, Data_Hora_Agendada, Prioridade, Status) VALUES ('88899900011', 4, TO_TIMESTAMP('2026-02-20 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Normal', 'Agendado');
INSERT INTO AGENDAMENTO (CPF_Paciente, Codigo_Exame, Data_Hora_Agendada, Prioridade, Status) VALUES ('55667788990', 5, TO_TIMESTAMP('2026-03-01 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Normal', 'Agendado');
INSERT INTO AGENDAMENTO (CPF_Paciente, Codigo_Exame, Data_Hora_Agendada, Prioridade, Status) VALUES ('10120230344', 7, TO_TIMESTAMP('2026-03-05 16:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Normal', 'Agendado');
INSERT INTO AGENDAMENTO (CPF_Paciente, Codigo_Exame, Data_Hora_Agendada, Prioridade, Status) VALUES ('30340450566', 6, TO_TIMESTAMP('2026-03-10 08:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Normal', 'Cancelado');
INSERT INTO AGENDAMENTO (CPF_Paciente, Codigo_Exame, Data_Hora_Agendada, Prioridade, Status) VALUES ('60670780899', 1, TO_TIMESTAMP('2026-03-12 09:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Normal', 'Aguardando');
INSERT INTO AGENDAMENTO (CPF_Paciente, Codigo_Exame, Data_Hora_Agendada, Prioridade, Status) VALUES ('70780890911', 3, TO_TIMESTAMP('2026-03-18 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Normal', 'Agendado');
INSERT INTO AGENDAMENTO (CPF_Paciente, Codigo_Exame, Data_Hora_Agendada, Prioridade, Status) VALUES ('80890911022', 2, TO_TIMESTAMP('2026-03-22 15:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Normal', 'Agendado');
INSERT INTO AGENDAMENTO (CPF_Paciente, Codigo_Exame, Data_Hora_Agendada, Prioridade, Status) VALUES ('70360450545', 11, TO_TIMESTAMP('2026-04-05 11:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Normal', 'Agendado');


COMMIT;
