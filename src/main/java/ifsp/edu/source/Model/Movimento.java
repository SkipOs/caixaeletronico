package ifsp.edu.source.Model;

import java.time.LocalDateTime;

public class Movimento {
	private int id;
    private long idContaRemetente;
    private Long idContaDestinatario; // Pode ser null para saques e depósitos
    private String tipoMovimento; // SAQUE, DEPOSITO, TRANSFERENCIA, PIX
    private double valor;
    private LocalDateTime data;
    private String nomeOutroDestinatario;

    // Getters e Setters

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public long getIdContaRemetente() {
        return idContaRemetente;
    }

    public void setIdContaRemetente(long idContaRemetente) {
        this.idContaRemetente = idContaRemetente;
    }

    public Long getIdContaDestinatario() {
        return idContaDestinatario;
    }

    public void setIdContaDestinatario(Long idContaDestinatario) {
        this.idContaDestinatario = idContaDestinatario;
    }

    public String getTipoMovimento() {
        return tipoMovimento;
    }

    public void setTipoMovimento(String tipoMovimento) {
        this.tipoMovimento = tipoMovimento;
    }

    public double getValor() {
        return valor;
    }

    public void setValor(double valor) {
        this.valor = valor;
    }

    public LocalDateTime getData() {
        return data;
    }

    public void setData(LocalDateTime data) {
        this.data = data;
    }

	public String getNomeOutroUsuario() {
		return nomeOutroDestinatario;
	}

	public void setNomeOutroUsuario(String nomeOutroDestinatario) {
		this.nomeOutroDestinatario = nomeOutroDestinatario;
	}
    

}
