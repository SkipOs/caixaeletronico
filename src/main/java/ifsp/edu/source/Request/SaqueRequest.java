package ifsp.edu.source.Request;

public class SaqueRequest {
    private long idConta;
    private int valorSaque;

    // Construtor
    public SaqueRequest() {}

    public SaqueRequest(long idConta, int valorSaque) {
        this.idConta = idConta;
        this.valorSaque = valorSaque;
    }

    // Getters e Setters
    public long getIdConta() {
        return idConta;
    }

    public void setIdConta(long idConta) {
        this.idConta = idConta;
    }

    public int getValorSaque() {
        return valorSaque;
    }

    public void setValorSaque(int valorSaque) {
        this.valorSaque = valorSaque;
    }
}
