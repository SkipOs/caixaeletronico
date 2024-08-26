package ifsp.edu.source.Model.AbstractFactory.FactoryConta;

import ifsp.edu.source.Model.AbstractFactory.StatusContaCorrente.ContaCorrente;
import ifsp.edu.source.Model.AbstractFactory.StatusContaCorrente.ContaCorrenteOuro;
import ifsp.edu.source.Model.AbstractFactory.StatusContaPoupanca.ContaPoupanca;
import ifsp.edu.source.Model.AbstractFactory.StatusContaPoupanca.ContaPoupancaOuro;

public class FactoryContaOuro implements AbstractFactoryConta{
    @Override
    public ContaPoupanca FactoryContaPoupanca() {
        return new ContaPoupancaOuro();
    }

    @Override
    public ContaCorrente FactoryContaCorrente() {
        return new ContaCorrenteOuro();
    }
}
