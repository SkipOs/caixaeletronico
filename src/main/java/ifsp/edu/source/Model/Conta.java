package ifsp.edu.source.Model;

public class Conta {
  private long id;
  private tipoConta tipoConta;
  private statusConta statusConta;
  private double valor;
  private String numeroConta;

  public String getNumeroConta() {
	return numeroConta;
}

public void setNumeroConta(String numeroConta) {
	this.numeroConta = numeroConta;
}

public long getId() {
    return id;
  }

  public void setId(long id) {
    this.id = id;
  }

  public tipoConta getTipoConta() {
    return tipoConta;
  }

  public void setTipoConta(tipoConta tipoConta) {
    this.tipoConta = tipoConta;
  }

  public statusConta getStatusConta() {
    return statusConta;
  }

  public void setStatusConta(statusConta statusConta) {
    this.statusConta = statusConta;
  }

  public double getValor() {
    return valor;
  }

  public void setValor(double valor) {
    this.valor = valor;
  }

  // Enums for account type and status
  public enum tipoConta {
    CORRENTE,
    POUPANCA
  }

  public enum statusConta {
    OURO,
    PRATA,
    BRONZE
  }
}