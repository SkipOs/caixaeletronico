package ifsp.edu.source.Model.AbstractFactory.FactoryConta;

import ifsp.edu.source.Model.AbstractFactory.StatusContaCorrente.ContaCorrente;
import ifsp.edu.source.Model.AbstractFactory.StatusContaCorrente.ContaCorrenteBronze;
import ifsp.edu.source.Model.AbstractFactory.StatusContaPoupanca.ContaPoupanca;
import ifsp.edu.source.Model.AbstractFactory.StatusContaPoupanca.ContaPoupancaBronze;

public class FactoryContaBronze implements AbstractFactoryConta{
    @Override
    public ContaPoupanca FactoryContaPoupanca() {
        return new ContaPoupancaBronze();
    }

    @Override
    public ContaCorrente FactoryContaCorrente() {
        return new ContaCorrenteBronze();
    }
}
