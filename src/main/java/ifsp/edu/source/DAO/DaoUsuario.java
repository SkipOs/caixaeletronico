package ifsp.edu.source.DAO;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import ifsp.edu.source.Model.Usuario;





public class DaoUsuario {
	
	public boolean incluir(Usuario v) {
		DataBaseCom.conectar();

		String sqlString = "insert into usuario(nome, senha, id_conta, salario) values(?,?,?,?)";
		try {
			PreparedStatement ps=DataBaseCom.getConnection().prepareStatement(sqlString);
			ps.setString(1, v.getNome());
			ps.setString(2, v.getSenha());
			ps.setLong(3, v.getIdConta());
			ps.setDouble(4, v.getSalario());

            boolean ri=ps.execute(); 
            return ri;
		} catch (SQLException ex) {
			ex.printStackTrace();
		}
		return false;
	}
	
	public Usuario buscarUsuarioPorIdConta1(long idConta) {
        DataBaseCom.conectar();
        String sql = "SELECT * FROM usuario WHERE id_conta = ?";
        
        try {
            PreparedStatement ps = DataBaseCom.getConnection().prepareStatement(sql);
            ps.setLong(1, idConta);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Usuario usuario = new Usuario();
                usuario.setId(rs.getLong("id"));
                usuario.setNome(rs.getString("nome"));
                usuario.setSenha(rs.getString("senha"));
                usuario.setIdConta(rs.getLong("id_conta"));
                return usuario;
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }
	
	public Usuario buscarUsuarioPorIdConta(long id) {
		DataBaseCom.conectar();
		Usuario p = null;
		try {
			ResultSet rs = DataBaseCom.getStatement().executeQuery("select * from usuario where id_conta=" + id);
			while (rs.next()) {
				p = new Usuario();
				p.setId(rs.getLong("id"));
				p.setNome(rs.getString("nome"));
                p.setSenha(rs.getString("senha"));
                p.setIdConta(rs.getLong("id_conta"));
                p.setSalario(rs.getDouble("salario"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return p;
	}
	
	public List<Usuario> listar() {
		List<Usuario> lista = new ArrayList<>();
		try {
			ResultSet rs = DataBaseCom.getStatement().executeQuery("select * from pessoa");
			while (rs.next()) {
				Usuario p = new Usuario();
				p.setId(rs.getInt("id"));
				p.setNome(rs.getString("nome"));
				lista.add(p);

			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return lista;
	}
	

}
