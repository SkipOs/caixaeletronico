package ifsp.edu.source.Model.AbstractFactory.FactoryConta;

import ifsp.edu.source.Model.AbstractFactory.StatusContaCorrente.ContaCorrente;
import ifsp.edu.source.Model.AbstractFactory.StatusContaCorrente.ContaCorrentePrata;
import ifsp.edu.source.Model.AbstractFactory.StatusContaPoupanca.ContaPoupanca;
import ifsp.edu.source.Model.AbstractFactory.StatusContaPoupanca.ContaPoupancaPrata;

public class FactoryContaPrata implements AbstractFactoryConta{
    @Override
    public ContaPoupanca FactoryContaPoupanca() {
        return new ContaPoupancaPrata();
    }

    @Override
    public ContaCorrente FactoryContaCorrente() {
        return new ContaCorrentePrata();
    }
}
