package ifsp.edu.source.Request;

import ifsp.edu.source.Model.Conta;
import ifsp.edu.source.Model.Usuario;

public class UsuarioContaRequest {
    private Usuario usuario;
    private Conta conta;

    // Getters e Setters
    public Usuario getUsuario() {
        return usuario;
    }

    public void setUsuario(Usuario usuario) {
        this.usuario = usuario;
    }

    public Conta getConta() {
        return conta;
    }

    public void setConta(Conta conta) {
        this.conta = conta;
    }
}
