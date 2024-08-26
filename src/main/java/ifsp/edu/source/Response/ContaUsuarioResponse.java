package ifsp.edu.source.Response;

import ifsp.edu.source.Model.Conta;
import ifsp.edu.source.Model.Usuario;

public class ContaUsuarioResponse {
	 private Conta conta;
	    private Usuario usuario;

	    public ContaUsuarioResponse(Conta conta, Usuario usuario) {
	        this.conta = conta;
	        this.usuario = usuario;
	    }

	    // Getters e Setters
	    public Conta getConta() {
	        return conta;
	    }

	    public void setConta(Conta conta) {
	        this.conta = conta;
	    }

	    public Usuario getUsuario() {
	        return usuario;
	    }

	    public void setUsuario(Usuario usuario) {
	        this.usuario = usuario;
	    }
}
