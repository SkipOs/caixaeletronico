package ifsp.edu.source.Controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import ifsp.edu.source.DAO.DataBaseCom;
import ifsp.edu.source.Model.CaixaEletronico;
import ifsp.edu.source.Model.Conta;
import ifsp.edu.source.Model.Movimento;
import ifsp.edu.source.Model.Usuario;
import ifsp.edu.source.Model.AbstractFactory.Banco.Banco;
import ifsp.edu.source.Model.AbstractFactory.FactoryConta.FactoryContaBronze;
import ifsp.edu.source.Model.AbstractFactory.FactoryConta.FactoryContaOuro;
import ifsp.edu.source.Model.AbstractFactory.FactoryConta.FactoryContaPrata;
import ifsp.edu.source.Request.ContaUsuarioRequest;
import ifsp.edu.source.Request.DepositoRequest;
import ifsp.edu.source.Request.SaqueRequest;
import ifsp.edu.source.Request.TransferenciaRequest;
import ifsp.edu.source.Request.UsuarioContaRequest;
import ifsp.edu.source.Response.ContaUsuarioResponse;
import ifsp.edu.source.DAO.DaoCaixaEletronico;
import ifsp.edu.source.DAO.DaoConta;
import ifsp.edu.source.DAO.DaoMovimento;
import ifsp.edu.source.DAO.DaoUsuario;

@RestController
public class UsuarioController {
	DataBaseCom database = new DataBaseCom();
	DaoUsuario cadUsuario = new DaoUsuario();
	DaoConta cadConta = new DaoConta();
	DaoCaixaEletronico cadCaixa = new DaoCaixaEletronico();
	DaoMovimento cadMovimento = new DaoMovimento();
	
	/*
	@PostMapping("/usuario") // incluir
	public String Post(@Validated @RequestBody Usuario usuario, Conta conta) {
		long idConta = cadConta.incluir(conta);
		
		cadUsuario.incluir(usuario);
		return "Usuario Cadastrada";
		
		if (idConta > 0) {  // Verifica se a conta foi inserida corretamente
            // Associa o ID da conta ao usuário
            usuario.setIdConta(idConta);
            cadUsuario.incluir(usuario);
            return "Usuario e conta cadastradas com sucesso!";
        } else {
            return "Erro ao cadastrar conta!";
        }
	}
	*/
	/*
	@PostMapping("/usuario")
	public String Post(@Validated @RequestBody UsuarioContaRequest request) {
	    Conta conta = request.getConta();
	    Usuario usuario = request.getUsuario();

	    long idConta = cadConta.incluir(conta);

	    if (idConta > 0) {  // Verifica se a conta foi inserida corretamente
	        // Associa o ID da conta ao usuário
	        usuario.setIdConta(idConta);
	        cadUsuario.incluir(usuario);
	        return "Pessoa e conta cadastradas com sucesso!";
	    } else {
	        return "Erro ao cadastrar conta!";
	    }
	}*/
	
	/*@PostMapping("/usuario")
	public String Post(@Validated @RequestBody UsuarioContaRequest request) {
	    Conta conta = request.getConta();
	    Usuario usuario = request.getUsuario();

	    // Gerar o número da conta
	    String numeroConta = gerarNumeroContaUnico();
	    conta.setNumeroConta(numeroConta);

	    // Definir o status da conta com base no salário informado
	    double salario = usuario.getSalario();
	    if (salario < 2000) {
	        conta.setStatusConta(Conta.statusConta.BRONZE);
	    } else if (salario >= 2000 && salario < 5000) {
	        conta.setStatusConta(Conta.statusConta.PRATA);
	    } else {
	        conta.setStatusConta(Conta.statusConta.OURO);
	    }

	    long idConta = cadConta.incluir(conta);

	    if (idConta > 0) {  // Verifica se a conta foi inserida corretamente
	        // Associa o ID da conta ao usuário
	        usuario.setIdConta(idConta);
	        cadUsuario.incluir(usuario);
	        return "Pessoa e conta cadastradas com sucesso! Número da conta: " + numeroConta;
	    } else {
	        return "Erro ao cadastrar conta!";
	    }
	}*/
	
	@PostMapping("/usuario")
	public ResponseEntity<Map<String, Object>> cadastrarUsuarioConta(@Validated @RequestBody UsuarioContaRequest request) {
	    Conta conta = request.getConta();
	    Usuario usuario = request.getUsuario();

	    // Gerar o número da conta
	    String numeroConta = gerarNumeroContaUnico();
	    conta.setNumeroConta(numeroConta);

	    long idConta = cadConta.incluir(conta);

	    if (idConta > 0) {
	        // Associa o ID da conta ao usuário
	        usuario.setIdConta(idConta);
	        cadUsuario.incluir(usuario);

	        // Preparar o retorno como um mapa de resposta JSON
	        Map<String, Object> response = new HashMap<>();
	        response.put("message", "Pessoa e conta cadastradas com sucesso!");
	        response.put("numeroConta", numeroConta);
	        response.put("idConta", idConta);

	        return ResponseEntity.ok(response);
	    } else {
	        Map<String, Object> response = new HashMap<>();
	        response.put("message", "Erro ao cadastrar conta!");

	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
	    }
	}

	
	@PostMapping("/login")
	public ResponseEntity<?> logar(@Validated @RequestBody ContaUsuarioRequest request) {
	    Conta conta = cadConta.buscarContaPorNumero(request.getNumeroConta());
	    if (conta != null) {
	        long idConta = conta.getId();
	        Usuario usuario = cadUsuario.buscarUsuarioPorIdConta(idConta);

	        if (usuario != null && usuario.getSenha().trim().equals(request.getSenha().trim())) {
	            // Retorna a conta se as credenciais estiverem corretas
	            return ResponseEntity.ok(idConta);
	        }
	    }
	    return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Usuário ou conta não encontrados");
	}


	// Função para gerar um número de conta único
	private String gerarNumeroContaUnico() {
	    Random random = new Random();
	    String numeroConta;

	    do {
	        numeroConta = String.format("%06d", random.nextInt(1000000));
	    } while (cadConta.verificarNumeroContaExistente(numeroConta));  // Verifica se o número já existe no banco

	    return numeroConta;
	}
	
	@GetMapping("/conta")
	public ResponseEntity<Object> verificarConta(@RequestParam String nome, @RequestParam String numeroConta, @RequestParam String senha) {
	    // Lógica para verificar a conta
	    Conta conta = cadConta.buscarContaPorNumero(numeroConta);
	    if (conta != null) {
	        long idConta = conta.getId();
	        Usuario usuario = cadUsuario.buscarUsuarioPorIdConta(idConta);
	        if (usuario != null && usuario.getNome().equals(nome) && usuario.getSenha().equals(senha)) {
	            return ResponseEntity.ok(usuario);
	        }
	    }
	    return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Usuário ou conta não encontrados");
	}
	
	@GetMapping("/usuario")
	public List<Usuario> listar() {
		return cadUsuario.listar();
	}
	
	@PostMapping("/transferencia")
	public ResponseEntity<String> transferir(@RequestBody TransferenciaRequest request) {
	    long idContaRemetente = request.getIdContaRemetente();
	    double valorTransferencia = request.getValorTransferencia();
	    String numeroContaDestinatario = request.getNumeroContaDestinatario();

	    Conta contaRemetente = cadConta.buscarContaPorId(idContaRemetente);

	    if (contaRemetente == null) {
	        System.out.println("Conta remetente não encontrada");
	        return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Conta remetente não encontrada");
	    }

	    if (contaRemetente.getValor() < valorTransferencia) {
	        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Saldo insuficiente na conta remetente");
	    }

	    Conta contaDestinatario = cadConta.buscarContaPorNumero(numeroContaDestinatario);

	    if (contaDestinatario == null) {
	        System.out.println("Conta destinatário não encontrada");
	        return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Conta destinatário não encontrada");
	    }

	    contaRemetente.setValor(contaRemetente.getValor() - valorTransferencia);
	    cadConta.atualizarConta(contaRemetente);

	    contaDestinatario.setValor(contaDestinatario.getValor() + valorTransferencia);
	    cadConta.atualizarConta(contaDestinatario);

	    cadMovimento.registrarTransferencia(contaRemetente.getId(), contaDestinatario.getId(), valorTransferencia);

	    return ResponseEntity.ok("{\"success\": true, \"message\": \"Transferência realizada com sucesso\"}");

	}

	@PostMapping("/deposito")
	public ResponseEntity<String> realizarDeposito(@RequestBody DepositoRequest request) {
	    // Buscar a conta do remetente pelo ID
	    Conta contaRemetente = cadConta.buscarContaPorId(request.getIdContaRemetente());

	    if (contaRemetente != null) {
	        // Adicionar o valor depositado ao saldo da conta do remetente
	        double novoSaldo = contaRemetente.getValor() + request.getValorDeposito();
	        contaRemetente.setValor(novoSaldo);

	        // Atualizar a conta no banco de dados
	        cadConta.atualizarConta(contaRemetente);

	        // Registrar o depósito no histórico de movimentos
	        cadMovimento.registrarDeposito(contaRemetente.getId(), request.getValorDeposito());

	        return ResponseEntity.ok("{\"success\": true, \"mensagem\": \"Depósito realizado com sucesso\", \"novoSaldo\": " + novoSaldo + "}");
	    } else {
	        return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Conta não encontrada.");
	    }
	}

	@PostMapping("/saque")
	public ResponseEntity<?> realizarSaque(@RequestBody SaqueRequest request) {
	    // Buscar a conta do solicitante pelo ID
	    Conta conta = cadConta.buscarContaPorId(request.getIdConta());
	    CaixaEletronico caixa = cadCaixa.buscarCaixa();

	    if (conta == null) {
	        return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Conta não encontrada.");
	    }

	    double valorSaque = request.getValorSaque();
	    
	    // Verifica se é possivel fazer a operação
	    if ((conta.getValor() - valorSaque) < 0) {
	    	return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Não há dinheiro suficiente na conta.");
	    };
	        
	    
	    // Verifica se há dinheiro suficiente no caixa
	    if (valorSaque > caixa.getTotalDinheiro()) {
	        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Não há dinheiro suficiente no caixa.");
	    }

	    // Verifica se é possível dispensar o valor solicitado com as notas disponíveis
	    Map<Integer, Integer> notas = caixa.dispensarValor((int) valorSaque);
	    if (notas.isEmpty()) {
	        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Não é possível dispensar o valor solicitado com as notas disponíveis.");
	    }

	    // Atualiza o saldo da conta do solicitante
	    conta.setValor(conta.getValor() - valorSaque);
	    cadConta.atualizarConta(conta);

	    // Atualiza as quantidades de notas no caixa
	    cadCaixa.atualizarCaixa(caixa);

	    // Registrar o saque no histórico de movimentos
	    cadMovimento.registrarSaque(conta.getId(), valorSaque);

	    // Retorna a quantidade de notas utilizadas
	    return ResponseEntity.ok(notas);
	}

	@GetMapping("/saldo")
    public ResponseEntity<Map<String, Object>> consultarSaldo(@RequestParam long idConta) {
        Conta conta = cadConta.buscarContaPorId(idConta);
        Map<String, Object> response = new HashMap<>();
        if (conta != null) {
            response.put("saldo", conta.getValor());
            return ResponseEntity.ok(response);
        } else {
            response.put("message", "Conta não encontrada.");
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
        }
    }

	@PostMapping("/extrato")
	public ResponseEntity<Map<String, Object>> obterExtrato(@RequestBody Map<String, String> body) {	    long idConta = Long.parseLong(body.get("numeroConta"));
	    List<Movimento> extrato = cadMovimento.obterExtratoComNomes(idConta);

	    Map<String, Object> response = new HashMap<>();
	    if (extrato != null && !extrato.isEmpty()) {
	        response.put("extrato", extrato); // Alinhar com o nome da chave
	        return ResponseEntity.ok(response);
	    } else {
	        response.put("message", "Nenhum movimento encontrado ou conta não encontrada.");
	        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
	    }
	}
	
	@GetMapping("/detalhes-usuario")
	public ResponseEntity<Map<String, Object>> obterDetalhesUsuario(@RequestParam long numeroConta) {
	    // Lógica para buscar o usuário pelo número da conta
	    Usuario usuario = cadUsuario.buscarUsuarioPorIdConta(numeroConta);

	    if (usuario != null) {
	        Map<String, Object> response = new HashMap<>();
	        response.put("nome", usuario.getNome());
	        return ResponseEntity.ok(response);
	    } else {
	        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
	    }
	}
//
}