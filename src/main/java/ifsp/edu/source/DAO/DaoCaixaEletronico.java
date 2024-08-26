package ifsp.edu.source.DAO;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import ifsp.edu.source.Model.CaixaEletronico;

public class DaoCaixaEletronico {
    public CaixaEletronico buscarCaixa1() {
        DataBaseCom.conectar();
        CaixaEletronico caixa = null;
        try {
            String query = "SELECT * FROM caixa_eletronico LIMIT 1"; // Supondo que exista apenas um caixa
            ResultSet rs = DataBaseCom.getStatement().executeQuery(query);

            if (rs.next()) {
                caixa = new CaixaEletronico();
                caixa.setNotasDe2(rs.getInt("notas_de_2"));
                caixa.setNotasDe5(rs.getInt("notas_de_5"));
                caixa.setNotasDe10(rs.getInt("notas_de_10"));
                caixa.setNotasDe20(rs.getInt("notas_de_20"));
                caixa.setNotasDe50(rs.getInt("notas_de_50"));
                caixa.setNotasDe100(rs.getInt("notas_de_100"));
                caixa.setNotasDe200(rs.getInt("notas_de_200"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return caixa;
    }

    public void atualizarCaixa(CaixaEletronico caixa) {
        DataBaseCom.conectar();
        try {
            String query = "UPDATE caixa_eletronico SET nota_2 = ?, nota_5 = ?, nota_10 = ?, nota_20 = ?, nota_50 = ?, nota_100 = ?, nota_200 = ? WHERE id = 1"; // Supondo que o ID do caixa seja 1
            PreparedStatement stmt = DataBaseCom.getConnection().prepareStatement(query);
            stmt.setInt(1, caixa.getNotasDe2());
            stmt.setInt(2, caixa.getNotasDe5());
            stmt.setInt(3, caixa.getNotasDe10());
            stmt.setInt(4, caixa.getNotasDe20());
            stmt.setInt(5, caixa.getNotasDe50());
            stmt.setInt(6, caixa.getNotasDe100());
            stmt.setInt(7, caixa.getNotasDe200());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public CaixaEletronico buscarCaixa() {
        CaixaEletronico caixa = null;
        try {
            ResultSet rs = DataBaseCom.getStatement().executeQuery("SELECT * FROM caixa_eletronico");
            if (rs.next()) {
                caixa = new CaixaEletronico();
                caixa.setNotasDe200(rs.getInt("nota_200"));
                caixa.setNotasDe100(rs.getInt("nota_100"));
                caixa.setNotasDe50(rs.getInt("nota_50"));
                caixa.setNotasDe20(rs.getInt("nota_20"));
                caixa.setNotasDe10(rs.getInt("nota_10"));
                caixa.setNotasDe5(rs.getInt("nota_5"));
                caixa.setNotasDe2(rs.getInt("nota_2"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return caixa;
    }
}
