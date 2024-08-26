package ifsp.edu.source.Request;

public class DepositoRequest {
	private long idContaRemetente;
    private double valorDeposito;

    // Getters e Setters
    public long getIdContaRemetente() {
        return idContaRemetente;
    }

    public void setIdContaRemetente(long idContaRemetente) {
        this.idContaRemetente = idContaRemetente;
    }

    public double getValorDeposito() {
        return valorDeposito;
    }

    public void setValorDeposito(double valorDeposito) {
        this.valorDeposito = valorDeposito;
    }
}
