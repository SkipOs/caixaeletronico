package ifsp.edu.source.Model;

import java.util.HashMap;
import java.util.Map;

public class CaixaEletronico {
	private int notasDe2;
    private int notasDe5;
    private int notasDe10;
    private int notasDe20;
    private int notasDe50;
    private int notasDe100;
    private int notasDe200;

    // Getters e Setters para as notas

    public int getNotasDe2() { return notasDe2; }
    public void setNotasDe2(int notasDe2) { this.notasDe2 = notasDe2; }

    public int getNotasDe5() { return notasDe5; }
    public void setNotasDe5(int notasDe5) { this.notasDe5 = notasDe5; }

    public int getNotasDe10() { return notasDe10; }
    public void setNotasDe10(int notasDe10) { this.notasDe10 = notasDe10; }

    public int getNotasDe20() { return notasDe20; }
    public void setNotasDe20(int notasDe20) { this.notasDe20 = notasDe20; }

    public int getNotasDe50() { return notasDe50; }
    public void setNotasDe50(int notasDe50) { this.notasDe50 = notasDe50; }

    public int getNotasDe100() { return notasDe100; }
    public void setNotasDe100(int notasDe100) { this.notasDe100 = notasDe100; }

    public int getNotasDe200() { return notasDe200; }
    public void setNotasDe200(int notasDe200) { this.notasDe200 = notasDe200; }

    // Método para verificar e dispensar o valor solicitado

    
    
    public Map<Integer, Integer> dispensarValor(int valor) {
        Map<Integer, Integer> notasDispensadas = new HashMap<>();
        int[] valoresNotas = {200, 100, 50, 20, 10, 5, 2};
        int[] quantidadeNotas = {getNotasDe200(), getNotasDe100(), getNotasDe50(), getNotasDe20(), getNotasDe10(), getNotasDe5(), getNotasDe2()};

        for (int i = 0; i < valoresNotas.length; i++) {
            int quantidade = Math.min(valor / valoresNotas[i], quantidadeNotas[i]);
            if (quantidade > 0) {
                notasDispensadas.put(valoresNotas[i], quantidade);
                valor -= quantidade * valoresNotas[i];
                quantidadeNotas[i] -= quantidade;
            }
        }

        // Atualiza o caixa com as quantidades restantes
        setNotasDe200(quantidadeNotas[0]);
        setNotasDe100(quantidadeNotas[1]);
        setNotasDe50(quantidadeNotas[2]);
        setNotasDe20(quantidadeNotas[3]);
        setNotasDe10(quantidadeNotas[4]);
        setNotasDe5(quantidadeNotas[5]);
        setNotasDe2(quantidadeNotas[6]);

        return valor == 0 ? notasDispensadas : new HashMap<>();
    }
    
    public int getTotalDinheiro() {
        int total = (notasDe2 * 2) + (notasDe5 * 5) + (notasDe10 * 10) +
                    (notasDe20 * 20) + (notasDe50 * 50) + (notasDe100 * 100) +
                    (notasDe200 * 200);
        return total;
    }

}
