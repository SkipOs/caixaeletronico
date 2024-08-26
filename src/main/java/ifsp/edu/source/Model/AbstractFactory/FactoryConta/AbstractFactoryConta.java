package ifsp.edu.source.Model.AbstractFactory.FactoryConta;

import ifsp.edu.source.Model.AbstractFactory.StatusContaCorrente.ContaCorrente;
import ifsp.edu.source.Model.AbstractFactory.StatusContaPoupanca.ContaPoupanca;

public interface AbstractFactoryConta {
    public ContaPoupanca FactoryContaPoupanca();
    public ContaCorrente FactoryContaCorrente();
}
