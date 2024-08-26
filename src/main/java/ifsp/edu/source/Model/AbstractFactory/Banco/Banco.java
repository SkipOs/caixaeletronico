package ifsp.edu.source.Model.AbstractFactory.Banco;

import ifsp.edu.source.Model.AbstractFactory.FactoryConta.AbstractFactoryConta;
import ifsp.edu.source.Model.AbstractFactory.FactoryConta.FactoryContaBronze;
import ifsp.edu.source.Model.AbstractFactory.FactoryConta.FactoryContaOuro;
import ifsp.edu.source.Model.AbstractFactory.FactoryConta.FactoryContaPrata;
import ifsp.edu.source.Model.AbstractFactory.StatusContaCorrente.ContaCorrente;
import ifsp.edu.source.Model.AbstractFactory.StatusContaPoupanca.ContaPoupanca;

public class Banco {
    AbstractFactoryConta fabricaConta = null;
    
    public void injetarDependencia(AbstractFactoryConta fabrica){
        this.fabricaConta = fabrica;
    }
    
    public ContaCorrente produzirContaCorrente(){
        return fabricaConta.FactoryContaCorrente();
    }
    
    public ContaPoupanca produzirContaPoupanca(){
        return fabricaConta.FactoryContaPoupanca();
    }
    
    public static AbstractFactoryConta escolherFabricaPorSalario(double salario) {
        if (salario < 2000) {
            return new FactoryContaBronze();
        } else if (salario >= 2000 && salario < 5000) {
            return new FactoryContaPrata();
        } else {
            return new FactoryContaOuro();
        }
    }
}
