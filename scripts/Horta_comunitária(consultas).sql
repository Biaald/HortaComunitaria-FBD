-- ==========================================
-- SCRIPT DE CONSULTAS (DQL) - HORTA COMUNITÁRIA
-- ==========================================

-- 1. CONSULTA SIMPLES COM JOIN (Herança)
-- Objetivo: Listar o nome, email e disponibilidade de todos os usuários que são Voluntários.
-- O que demonstra: Domínio sobre relacionamento 1:1 oriundo de herança.
SELECT 
    u.nome_completo, 
    u.email, 
    v.disponibilidade
FROM usuario u
INNER JOIN voluntario v ON u.id_usuario = v.id_usuario;

-- 2. AGREGAÇÃO E AGRUPAMENTO (GROUP BY)
-- Objetivo: Descobrir qual a quantidade total colhida de cada tipo de cultura, ordenada da maior para a menor.
-- O que demonstra: Uso de funções de agregação (SUM) e ordenação (ORDER BY).
SELECT 
    cu.nome_comum AS cultura, 
    SUM(co.quantidade_colhida) AS total_colhido
FROM cultura cu
INNER JOIN colheita co ON cu.id_cultura = co.id_cultura
GROUP BY cu.nome_comum
ORDER BY total_colhido DESC;

-- 3. MÚLTIPLOS JOINS (Cruzamento de 4 tabelas)
-- Objetivo: Listar as tarefas pendentes, mostrando quem é o responsável, em qual canteiro e de qual horta.
-- O que demonstra: Navegação complexa entre chaves estrangeiras de diferentes módulos.
SELECT 
    t.descricao AS tarefa, 
    t.data_prevista, 
    u.nome_completo AS responsavel, 
    c.id_canteiro, 
    h.nome AS horta
FROM tarefa t
INNER JOIN usuario u ON t.id_usuario = u.id_usuario
INNER JOIN canteiro c ON t.id_canteiro = c.id_canteiro
INNER JOIN horta h ON c.id_horta = h.id_horta
WHERE t.status = 'Pendente'; 

-- 4. CONSULTA DE RASTREABILIDADE COM FILTRO DE DATA E STATUS
-- Objetivo: Mostrar quais ferramentas estão atualmente emprestadas (não devolvidas) e quem as retirou.
-- O que demonstra: Filtros condicionais e rastreamento de infraestrutura.
SELECT 
    f.nome AS ferramenta, 
    u.nome_completo AS retirado_por, 
    e.data_retirada, 
    e.data_devolucao
FROM emprestimos e
INNER JOIN ferramentas f ON e.id_ferramenta = f.id_ferramenta
INNER JOIN usuario u ON e.id_usuario = u.id_usuario
WHERE e.status_emprestimo = 'Em andamento';

-- 5. ANÁLISE DE DADOS (Subquery / Count)
-- Objetivo: Listar as culturas que tiveram registro de ocorrência de pragas e a quantidade de ocorrências, ranqueando as mais problemáticas.
-- O que demonstra: Capacidade de gerar relatórios analíticos para tomada de decisão.
SELECT 
    cu.nome_comum, 
    COUNT(op.id_ocorrencia) AS numero_de_pragas
FROM ocorrencia_pragas op
INNER JOIN cultura cu ON op.id_cultura = cu.id_cultura
GROUP BY cu.nome_comum
HAVING COUNT(op.id_ocorrencia) > 0
ORDER BY numero_de_pragas DESC;