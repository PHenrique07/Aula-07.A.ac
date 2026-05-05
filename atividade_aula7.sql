
-- Exercicio 1
GO
-- cria ou atualiza o procedimento no banco
CREATE OR ALTER PROCEDURE dbo.student_grade_points
    -- parâmetro de entrada 
    @Conceito VARCHAR(5) 
AS
BEGIN
    -- select das colunas com apelidos
    SELECT 
        s.name AS Nome_do_Estudante,
        s.dept_name AS Departamento_do_Estudante,
        c.title AS Titulo_do_Curso,
        c.dept_name AS Departamento_do_Curso,
        t.semester AS Semestre_do_Curso,
        t.year AS Ano_do_Curso,
        t.grade AS Pontuacao_Alfanumerica,
        
        -- converte a letra da nota para um valor numérico 
      CASE t.grade 
            WHEN 'A+' THEN 10.0
            WHEN 'A'  THEN 9.0
            WHEN 'A-' THEN 8.0
            WHEN 'B+' THEN 7.5
            WHEN 'B'  THEN 7.0
            WHEN 'B-' THEN 6.5
            WHEN 'C+' THEN 6.0
            WHEN 'C'  THEN 5.0
            WHEN 'C-' THEN 4.0
            ELSE 0.0 
        END AS Pontuacao_Numerica
        
    -- começa pela tabela do aluno
    FROM dbo.student s
    
    -- liga o aluno com as matérias que ele cursou usando o ID
    INNER JOIN dbo.takes t ON s.ID = t.ID
    
    -- liga a matéria cursada com o nome do curso usando o course_id
    INNER JOIN dbo.course c ON t.course_id = c.course_id
    
    -- filtra o resultado para mostrar só quem tirou a nota passada no parâmetro
    WHERE t.grade = @Conceito; 
END;

EXEC dbo.student_grade_points @Conceito = 'A';
GO


-- Exercicio 2


GO

CREATE OR ALTER FUNCTION dbo.return_instructor_location (
    -- parâmetro de entrada com o nome exato do professor
    @NomeInstrutor VARCHAR(100) 

-- retorno da função será no formato de tabela 
)RETURNS TABLE 
AS
RETURN (
    -- select das informações do professor, do curso e da sala
    SELECT 
        i.name AS Nome_do_Instrutor,
        c.title AS Curso_Ministrado,
        t.semester AS Semestre_do_Curso,
        t.year AS Ano_do_Curso,
        s.building AS Predio,
        s.room_number AS Numero_da_Sala
        
    -- começa pela tabela do professor
    FROM dbo.instructor i
    
    -- liga o professor ao que ele ensina usando o ID
    INNER JOIN dbo.teaches t ON i.ID = t.ID
    
    -- liga com a tabela section 
  
    INNER JOIN dbo.section s ON t.course_id = s.course_id 
                             AND t.sec_id = s.sec_id 
                             AND t.semester = s.semester 
                             AND t.year = s.year
                             
 
    INNER JOIN dbo.course c ON t.course_id = c.course_id
    
   
    WHERE i.name = @NomeInstrutor
);
GO

SELECT * FROM dbo.return_instructor_location('Gustafsson');