package ifsp.edu.source.Request;

public class TransferenciaRequest {
    private long idContaRemetente;
    private String numeroContaDestinatario;
    private double valorTransferencia;

    // Getters e Setters
    public long getIdContaRemetente() {
        return idContaRemetente;
    }

    public void setIdContaRemetente(long idContaRemetente) {
        this.idContaRemetente = idContaRemetente;
    }

    public String getNumeroContaDestinatario() {
        return numeroContaDestinatario;
    }

    public void setNumeroContaDestinatario(String numeroContaDestinatario) {
        this.numeroContaDestinatario = numeroContaDestinatario;
    }

    public double getValorTransferencia() {
        return valorTransferencia;
    }

    public void setValorTransferencia(double valorTransferencia) {
        this.valorTransferencia = valorTransferencia;
    }
}
