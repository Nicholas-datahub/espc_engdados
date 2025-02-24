# ETL de Dados da ANTAQ com Apache Spark e SQL Server

## Visão Geral
Este projeto implementa um pipeline de **ETL (Extração, Transformação e Carga)** para processar e armazenar dados do anuário estatístico da ANTAQ. O fluxo automatiza a coleta, limpeza e armazenamento dos dados em um banco de dados **SQL Server**, utilizando **Apache Spark** para processamento distribuído e **Prefect** para orquestração.

## Tecnologias Utilizadas
- **Apache Spark**: Processamento e transformação dos dados.
- **SQL Server**: Armazenamento das tabelas `atracacao_fato` e `carga_fato`.
- **Prefect**: Automação e orquestração das tarefas.
- **PyODBC**: Conexão com o SQL Server.
- **Docker**: Contêiner para o banco de dados.

## Arquitetura do Pipeline
1. **Extração**: Leitura de arquivos `.txt` da ANTAQ.
2. **Transformação**:
   - Normalização dos nomes das colunas.
   - Remoção de registros duplicados.
   - Garantia de integridade referencial entre tabelas.
3. **Carga**:
   - Escrita no SQL Server via JDBC.
   - Armazenamento dos dados no Data Lake (`/data/lake/antaq/`).

## Pré-requisitos
- **Python 3.12.6**
- **Docker** (para SQL Server)
- **Apache Spark**
- **Prefect**

### Instalação das Dependências
```sh
pip install pyspark prefect pyodbc
```

### Configuração do Banco de Dados (SQL Server)
1. Inicie um contêiner Docker:
```sh
docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=YourPassword!' \
   -p 1433:1433 --name sqlserver \
   -d mcr.microsoft.com/mssql/server:latest
```
2. Crie o banco de dados `antaq_db` e as tabelas `atracacao_fato` e `carga_fato`.

### Configuração do Spark
Certifique-se de que o Apache Spark está instalado corretamente:
```sh
spark-submit --version
```

### Execução do Pipeline
```sh
prefect deployment build etl_antaq.py:main --name "ETL_ANATAQ"
prefect agent start -q "default"
```

## Melhorias Futuras
- Implementação de **UPSERT** para evitar duplicação de dados.
- Configuração dinâmica do caminho do Data Lake.
- Uso de **Delta Lake** para melhor controle de versionamento de dados.

## Contribuições
Sinta-se à vontade para abrir **issues** e enviar **pull requests** para melhorias no código!

## Licença
Este projeto está licenciado sob a [MIT License](LICENSE).
