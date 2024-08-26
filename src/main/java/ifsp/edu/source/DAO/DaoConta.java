package ifsp.edu.source.DAO;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import ifsp.edu.source.Model.Conta;
import ifsp.edu.source.Model.Conta.statusConta;
import ifsp.edu.source.Model.Conta.tipoConta;
import ifsp.edu.source.Model.Usuario;


public class DaoConta {
	
	/*public boolean incluir(Conta v) {
		DataBaseCom.conectar();

		String sqlString = "insert into usuario conta(?,?,?)";
		try {
			PreparedStatement ps=DataBaseCom.getConnection().prepareStatement(sqlString);
			ps.setString(1, v.getTipoConta().name());
			ps.setString(2, v.getStatusConta().name());
			ps.setDouble(3, v.getValor());

            boolean ri=ps.execute(); 
            return ri;
		} catch (SQLException ex) {
			ex.printStackTrace();
		}
		return false;
	}*/
	
	public long incluir(Conta v) {
        DataBaseCom.conectar();

        String sqlString = "insert into conta(tipo, status, valor, numero_conta) values (?,?,?,?)";
        try {
            PreparedStatement ps = DataBaseCom.getConnection().prepareStatement(sqlString, PreparedStatement.RETURN_GENERATED_KEYS);
            
            if (v.getTipoConta() == null) {
                v.setTipoConta(Conta.tipoConta.CORRENTE); // Define o tipo como CORRENTE se não estiver definido
            }
            
            if (v.getStatusConta() == null) {
                v.setStatusConta(Conta.statusConta.BRONZE); // Define o tipo como CORRENTE se não estiver definido
            }
            
            // Converte os enums para String
            ps.setString(1, v.getTipoConta().name());
            ps.setString(2, v.getStatusConta().name());
            ps.setDouble(3, v.getValor());
            ps.setString(4, v.getNumeroConta());

            ps.executeUpdate();

            // Recupera o ID gerado
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getLong(1); // Retorna o ID gerado
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return -1; // Retorna -1 se houver erro
    }
	
	public boolean verificarNumeroContaExistente(String numeroConta) {
        DataBaseCom.conectar();
        String sqlString = "SELECT COUNT(*) FROM conta WHERE numero_conta = ?";
        try {
            PreparedStatement ps = DataBaseCom.getConnection().prepareStatement(sqlString);
            ps.setString(1, numeroConta);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;  // Retorna true se o número já existir
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }
	
	public Conta buscarContaPorNumeroz(String numero_conta) {
        DataBaseCom.conectar();
        String sql = "SELECT * FROM conta WHERE numero_conta = ?";
        
        try {
            PreparedStatement ps = DataBaseCom.getConnection().prepareStatement(sql);
            ps.setString(1, numero_conta);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Conta conta = new Conta();
                conta.setId(rs.getLong("id"));
                conta.setTipoConta(Conta.tipoConta.valueOf(rs.getString("tipo")));
                conta.setStatusConta(Conta.statusConta.valueOf(rs.getString("status")));
                conta.setValor(rs.getDouble("valor"));
                return conta;
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }
	
	public Conta buscarContaPorNumero(String numero_conta) {
		DataBaseCom.conectar();
		Conta p = null;
		try {
			ResultSet rs = DataBaseCom.getStatement().executeQuery("select * from conta where numero_conta=" + numero_conta);
			while (rs.next()) {
				p = new Conta();
				p.setId(rs.getLong("id"));
				p.setNumeroConta(rs.getString("id"));
	            p.setTipoConta(tipoConta.valueOf(rs.getString("tipo")));  // Se `tipoConta` for um enum
	            p.setStatusConta(statusConta.valueOf(rs.getString("status")));
				p.setValor(rs.getDouble("valor"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return p;
	}
	
	public Conta buscarContaPorNumero1(String numeroConta) {
	    DataBaseCom.conectar();
	    Conta conta = null;
	    try {
	        String query = "SELECT * FROM conta WHERE numero_conta = ?";
	        PreparedStatement stmt = DataBaseCom.getConnection().prepareStatement(query);
	        stmt.setString(1, numeroConta);
	        ResultSet rs = stmt.executeQuery();
	        
	        if (rs.next()) {
	            conta = new Conta();
	            conta.setId(rs.getLong("id"));
	            conta.setNumeroConta(rs.getString("numero_conta"));
	            conta.setTipoConta(tipoConta.valueOf(rs.getString("tipo")));  // Se `tipoConta` for um enum
	            conta.setStatusConta(statusConta.valueOf(rs.getString("status")));
	            conta.setValor(rs.getDouble("valor"));
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    } 
	    return conta;
	}
	
	public Conta buscarContaPorId(long idConta) {
	    DataBaseCom.conectar();
	    Conta conta = null;
	    try {
	        String query = "SELECT * FROM conta WHERE id = ?";
	        PreparedStatement stmt = DataBaseCom.getConnection().prepareStatement(query);
	        stmt.setLong(1, idConta);
	        ResultSet rs = stmt.executeQuery();
	        
	        if (rs.next()) {
	            conta = new Conta();
	            conta.setId(rs.getLong("id"));
	            conta.setNumeroConta(rs.getString("numero_conta"));
	            conta.setTipoConta(tipoConta.valueOf(rs.getString("tipo")));  // Se `tipoConta` for um enum
	            conta.setStatusConta(statusConta.valueOf(rs.getString("status")));
	            conta.setValor(rs.getDouble("valor"));
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    } 
	    return conta;
	}
	
	public void atualizarConta(Conta conta) {
	    DataBaseCom.conectar();
	    try {
	        String query = "UPDATE conta SET valor = ? WHERE id = ?";
	        PreparedStatement stmt = DataBaseCom.getConnection().prepareStatement(query);

	        // Definindo os valores no PreparedStatement
	        // Converte o enum para String
	        stmt.setDouble(1, conta.getValor());
	        stmt.setLong(2, conta.getId());

	        // Executa a atualização no banco de dados
	        stmt.executeUpdate();
	    } catch (SQLException e) {
	        e.printStackTrace();
	    } 
	}


}
