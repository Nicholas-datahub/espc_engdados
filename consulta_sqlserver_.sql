WITH agregados AS (
  SELECT * FROM (
    SELECT 'Ceará' AS localidade, 
    mes, 
    ano,
    COUNT(*) AS num_atracacoes,
    AVG(DATEDIFF(hour, TRY_CONVERT(datetime, data_chegada, 103), TRY_CONVERT(datetime, data_início_operação, 103))) AS tempo_espera_medio_em_horas,
    AVG(DATEDIFF(hour, TRY_CONVERT(datetime, data_início_operação, 103), TRY_CONVERT(datetime, data_término_operação, 103))) AS tempo_atracado_medio_em_horas
    
    FROM dbo.atracacao_fato
    WHERE uf = 'CE' AND ano IN (2020,2021,2022,2023)
    GROUP BY mes, ano
    UNION ALL
    
    SELECT 'Nordeste', mes, ano,
           COUNT(*),
           AVG(DATEDIFF(hour, TRY_CONVERT(datetime, data_chegada, 103), TRY_CONVERT(datetime, data_início_operação, 103))),
           AVG(DATEDIFF(hour, TRY_CONVERT(datetime, data_início_operação, 103), TRY_CONVERT(datetime, data_término_operação, 103)))
    
    FROM dbo.atracacao_fato
    WHERE região_geográfica = 'Nordeste' AND ano IN (2020,2021,2022,2023)
    GROUP BY mes, ano
    UNION ALL
    
    SELECT 'Brasil', mes, ano,
           COUNT(*),
           AVG(DATEDIFF(hour, TRY_CONVERT(datetime, data_chegada, 103), TRY_CONVERT(datetime, data_início_operação, 103))),
           AVG(DATEDIFF(hour, TRY_CONVERT(datetime, data_início_operação, 103), TRY_CONVERT(datetime, data_término_operação, 103)))
    FROM dbo.atracacao_fato
    WHERE ano IN (2020,2021,2022,2023)
    GROUP BY mes, ano
  ) t
  WHERE ano IN (2021,2023)
)

SELECT 
  localidade,
  num_atracacoes,
  num_atracacoes - LAG(num_atracacoes) OVER (PARTITION BY localidade, mes ORDER BY ano) AS variacao,
  tempo_espera_medio_em_horas,
  tempo_atracado_medio_em_horas,
  mes,
  ano
FROM agregados
ORDER BY localidade,
         CASE mes
             WHEN 'jan' THEN 1 WHEN 'fev' THEN 2 WHEN 'mar' THEN 3 WHEN 'abr' THEN 4 
             WHEN 'mai' THEN 5 WHEN 'jun' THEN 6 WHEN 'jul' THEN 7 WHEN 'ago' THEN 8 
             WHEN 'set' THEN 9 WHEN 'out' THEN 10 WHEN 'nov' THEN 11 WHEN 'dez' THEN 12
         END, ano;