package ifsp.edu.source.DAO;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import ifsp.edu.source.Model.Movimento;

public class DaoMovimento {
	  public void registrarMovimento1(Movimento movimento) {
	        String query = "INSERT INTO movimento (id_conta_remetente, id_conta_destinatario, tipo_movimento, valor, data) VALUES (?, ?, ?, ?, ?)";
	        try (PreparedStatement stmt = DataBaseCom.getConnection().prepareStatement(query)) {
	            stmt.setLong(1, movimento.getIdContaRemetente());
	            stmt.setObject(2, movimento.getIdContaDestinatario());
	            stmt.setString(3, movimento.getTipoMovimento());
	            stmt.setDouble(4, movimento.getValor());
	            stmt.setTimestamp(5, Timestamp.valueOf(movimento.getData()));
	            stmt.executeUpdate();
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	    }
	  
	  public void registrarMovimento(Movimento movimento) {
	        String query = "INSERT INTO movimento (id_conta_remetente, id_conta_destinatario, tipo_movimento, valor, data) VALUES (?, ?, ?, ?, ?)";
	        try (PreparedStatement stmt = DataBaseCom.getConnection().prepareStatement(query)) {
	            stmt.setLong(1, movimento.getIdContaRemetente());
	            stmt.setObject(2, movimento.getIdContaDestinatario());
	            stmt.setString(3, movimento.getTipoMovimento());
	            stmt.setDouble(4, movimento.getValor());
	            stmt.setTimestamp(5, Timestamp.valueOf(movimento.getData()));
	            stmt.executeUpdate();
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	    }

	    // Registrar saque
	    public void registrarSaque(long idConta, double valor) {
	        Movimento movimento = new Movimento();
	        movimento.setIdContaRemetente(idConta);
	        movimento.setTipoMovimento("SAQUE");
	        movimento.setValor(valor);
	        movimento.setData(LocalDateTime.now());
	        registrarMovimento(movimento);
	    }

	    // Registrar depósito
	    public void registrarDeposito(long idConta, double valor) {
	        Movimento movimento = new Movimento();
	        movimento.setIdContaRemetente(idConta);
	        movimento.setTipoMovimento("DEPOSITO");
	        movimento.setValor(valor);
	        movimento.setData(LocalDateTime.now());
	        registrarMovimento(movimento);
	    }

	    // Registrar transferência
	    public void registrarTransferencia(long idContaRemetente, long idContaDestinatario, double valor) {
	        Movimento movimento = new Movimento();
	        movimento.setIdContaRemetente(idContaRemetente);
	        movimento.setIdContaDestinatario(idContaDestinatario);
	        movimento.setTipoMovimento("TRANSFERENCIA");
	        movimento.setValor(valor);
	        movimento.setData(LocalDateTime.now());
	        registrarMovimento(movimento);
	    }

	    // Registrar PIX
	    public void registrarPix(long idContaRemetente, long idContaDestinatario, double valor) {
	        Movimento movimento = new Movimento();
	        movimento.setIdContaRemetente(idContaRemetente);
	        movimento.setIdContaDestinatario(idContaDestinatario);
	        movimento.setTipoMovimento("PIX");
	        movimento.setValor(valor);
	        movimento.setData(LocalDateTime.now());
	        registrarMovimento(movimento);
	    }

	    // Método para obter o extrato de uma conta
	    public List<Movimento> obterExtrato(long idConta) {
	        List<Movimento> extrato = new ArrayList<>();
	        String query = "SELECT * FROM movimento WHERE id_conta_remetente = ? OR id_conta_destinatario = ? ORDER BY data DESC";

	        try (PreparedStatement stmt = DataBaseCom.getConnection().prepareStatement(query)) {
	            stmt.setLong(1, idConta);
	            stmt.setLong(2, idConta);
	            ResultSet rs = stmt.executeQuery();

	            while (rs.next()) {
	                Movimento movimento = new Movimento();
	                movimento.setId(rs.getInt("id"));
	                movimento.setIdContaRemetente(rs.getLong("id_conta_remetente"));
	                movimento.setIdContaDestinatario(rs.getLong("id_conta_destinatario"));
	                movimento.setTipoMovimento(rs.getString("tipo_movimento"));
	                movimento.setValor(rs.getDouble("valor"));
	                movimento.setData(rs.getTimestamp("data").toLocalDateTime());
	                extrato.add(movimento);
	            }
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	        return extrato;
	    }
	    
	    /*public List<Movimento> obterExtrato(long idConta) {
	        List<Movimento> extrato = new ArrayList<>();
	        String query = "SELECT m.*, c_dest.nome AS nome_destinatario " +
	                       "FROM movimento m " +
	                       "LEFT JOIN conta c_dest ON m.id_conta_destinatario = c_dest.id " +
	                       "WHERE m.id_conta_remetente = ? OR m.id_conta_destinatario = ? " +
	                       "ORDER BY m.data DESC";

	        try (PreparedStatement stmt = DataBaseCom.getConnection().prepareStatement(query)) {
	            stmt.setLong(1, idConta);
	            stmt.setLong(2, idConta);
	            ResultSet rs = stmt.executeQuery();

	            while (rs.next()) {
	                Movimento movimento = new Movimento();
	                movimento.setId(rs.getInt("id"));
	                movimento.setIdContaRemetente(rs.getLong("id_conta_remetente"));
	                movimento.setIdContaDestinatario(rs.getLong("id_conta_destinatario"));
	                movimento.setTipoMovimento(rs.getString("tipo_movimento"));
	                movimento.setValor(rs.getDouble("valor"));
	                movimento.setData(rs.getTimestamp("data").toLocalDateTime());
	                movimento.setNomeOutroUsuario(rs.getString("nome_destinatario")); // Adiciona o nome do destinatário
	                extrato.add(movimento);
	            }
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	        return extrato;
	    }*/
	    
	    public List<Movimento> obterExtratoComNomes(long idConta) {
	        List<Movimento> extrato = new ArrayList<>();
	        String query = "SELECT m.*, " +
	                       "CASE " +
	                       "   WHEN m.id_conta_remetente = ? THEN (SELECT u.nome FROM usuario u JOIN conta c ON u.id_conta = c.id WHERE c.id = m.id_conta_destinatario) " +
	                       "   WHEN m.id_conta_destinatario = ? THEN (SELECT u.nome FROM usuario u JOIN conta c ON u.id_conta = c.id WHERE c.id = m.id_conta_remetente) " +
	                       "   ELSE NULL " +
	                       "END AS nome_outro_usuario " +
	                       "FROM movimento m " +
	                       "WHERE m.id_conta_remetente = ? OR m.id_conta_destinatario = ? " +
	                       "ORDER BY m.data DESC";

	        try (PreparedStatement stmt = DataBaseCom.getConnection().prepareStatement(query)) {
	            stmt.setLong(1, idConta); // Para buscar o nome do destinatário se o id_conta_remetente for igual ao idConta
	            stmt.setLong(2, idConta); // Para buscar o nome do remetente se o id_conta_destinatario for igual ao idConta
	            stmt.setLong(3, idConta); // Filtro para id_conta_remetente
	            stmt.setLong(4, idConta); // Filtro para id_conta_destinatario
	            ResultSet rs = stmt.executeQuery();

	            while (rs.next()) {
	                Movimento movimento = new Movimento();
	                movimento.setId(rs.getInt("id"));
	                movimento.setIdContaRemetente(rs.getLong("id_conta_remetente"));
	                movimento.setIdContaDestinatario(rs.getLong("id_conta_destinatario"));
	                movimento.setTipoMovimento(rs.getString("tipo_movimento"));
	                movimento.setValor(rs.getDouble("valor"));
	                movimento.setData(rs.getTimestamp("data").toLocalDateTime());
	                movimento.setNomeOutroUsuario(rs.getString("nome_outro_usuario"));
	                extrato.add(movimento);
	            }
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	        return extrato;
	    }

}
