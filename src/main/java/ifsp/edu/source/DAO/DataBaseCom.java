package ifsp.edu.source.DAO;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Classe para gerenciar a conexão e operações com o banco de dados SQLite.
 * Inclui criação de tabelas e métodos para obter conexão e statement.
 * 
 * @author skip0s
 */
public class DataBaseCom {

    private static final String DATABASE_URL = "jdbc:sqlite:sample.db"; // Ajuste a URL conforme necessário
    private static final Logger LOGGER = Logger.getLogger(DataBaseCom.class.getName());
    private static Connection connection = null;
    private static final Object lock = new Object(); // Objeto de bloqueio para sincronização

    public DataBaseCom() {
        conectar();
        criarTabelas();
    }

    /**
     * Obtém a conexão com o banco de dados.
     * 
     * @return A conexão com o banco de dados.
     */
    public static Connection getConnection() {
        return conectar();
    }
    
    /**
     * Obtém o statement para executar comandos SQL.
     * 
     * @return O statement para executar comandos SQL.
     */
    public static Statement getStatement() {
        Connection conn = conectar();
        try {
            return conn.createStatement();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Erro ao criar statement.", e);
            throw new RuntimeException("Erro ao criar statement.", e);
        }
    }

    /**
     * Estabelece a conexão com o banco de dados se ainda não estiver estabelecida.
     * 
     * @return A conexão com o banco de dados.
     */
    static Connection conectar() {
        if (connection == null || !isValidConnection(connection)) {
            synchronized (lock) {  // Garantir que apenas uma thread faça a conexão por vez
                if (connection == null || !isValidConnection(connection)) {  // Verificar novamente dentro do bloco sincronizado
                    try {
                        connection = DriverManager.getConnection(DATABASE_URL);
                        LOGGER.info("Conexão com o banco de dados estabelecida com sucesso.");
                    } catch (SQLException e) {
                        LOGGER.log(Level.SEVERE, "Erro ao conectar ao banco de dados. URL: " + DATABASE_URL, e);
                        throw new RuntimeException("Não foi possível estabelecer a conexão com o banco de dados.", e);
                    }
                }
            }
        }
        return connection;
    }

    /**
     * Verifica se a conexão é válida.
     * 
     * @param conn A conexão a ser verificada.
     * @return True se a conexão for válida, false caso contrário.
     */
    private static boolean isValidConnection(Connection conn) {
        try {
            return conn != null && !conn.isClosed() && conn.isValid(2);
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Erro ao verificar a validade da conexão.", e);
            return false;
        }
    }

    /**
     * Cria as tabelas necessárias no banco de dados.
     * 
     * @return True se a criação das tabelas for bem-sucedida.
     */
    public boolean criarTabelas() {
        Connection conn = conectar();
        try (Statement stmt = conn.createStatement()) {
            conn.setAutoCommit(false);  // Inicia a transação

            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS usuario (" +
                    "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
                    "nome TEXT, " +
                    "senha TEXT, " +
                    "id_conta INTEGER, " +
                    "salario REAL)");

            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS conta (" +
                    "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
                    "tipo TEXT, " +
                    "status TEXT, " +
                    "valor REAL, " +
                    "numero_conta TEXT)");

            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS caixa_eletronico (" +
                    "id INTEGER PRIMARY KEY, " +
                    "nota_2 INT DEFAULT 200, " +
                    "nota_5 INT DEFAULT 100, " +
                    "nota_10 INT DEFAULT 50, " +
                    "nota_20 INT DEFAULT 20, " +
                    "nota_50 INT DEFAULT 10, " +
                    "nota_100 INT DEFAULT 5, " +
                    "nota_200 INT DEFAULT 2)");

            stmt.executeUpdate("INSERT INTO caixa_eletronico (id, nota_2, nota_5, nota_10, nota_20, nota_50, nota_100, nota_200) " +
                    "VALUES (1, 200, 100, 50, 20, 10, 5, 2) " +
                    "ON CONFLICT (id) DO NOTHING;");

            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS movimento (" +
                    "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
                    "id_conta_remetente INTEGER, " +
                    "id_conta_destinatario INTEGER, " +
                    "tipo_movimento TEXT CHECK(tipo_movimento IN ('SAQUE', 'TRANSFERENCIA', 'DEPOSITO', 'PIX')), " +
                    "valor REAL, " +
                    "data TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                    "FOREIGN KEY (id_conta_remetente) REFERENCES conta(id), " +
                    "FOREIGN KEY (id_conta_destinatario) REFERENCES conta(id))");

            conn.commit();  // Comita a transação
            return true;
        } catch (SQLException ex) {
            try {
                conn.rollback();  // Reverte a transação se ocorrer um erro
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Erro ao reverter transação.", e);
            }
            LOGGER.log(Level.SEVERE, "Erro ao criar tabelas.", ex);
            return false;
        } finally {
            try {
                conn.setAutoCommit(true);  // Reseta o auto-commit
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Erro ao resetar auto-commit.", e);
            }
        }
    }
    
    /**
     * Fecha a conexão e o statement com o banco de dados.
     */
    public static void close() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Erro ao fechar conexão.", ex);
        }
    }
}