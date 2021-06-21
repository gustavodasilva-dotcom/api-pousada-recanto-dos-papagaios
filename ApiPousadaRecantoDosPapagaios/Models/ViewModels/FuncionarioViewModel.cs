using System;

namespace ApiPousadaRecantoDosPapagaios.Models.ViewModels
{
    public class FuncionarioViewModel
    {
        public string NomeCompleto { get; set; }
        public string Cpf { get; set; }
        public DateTime DataDeNascimento { get; set; }
        public string Email { get; set; }
        public string Login { get; set; }
        public string Senha { get; set; }
        public string Celular { get; set; }
        public string Nacionalidade { get; set; }
        public string Sexo { get; set; }
        public string Rg { get; set; }
        public string Cargo { get; set; }
        public string Setor { get; set; }
        public double Salario { get; set; }
        public EnderecoViewModel Endereco { get; set; }
        public DadosBancariosViewModel DadosBancarios { get; set; }
        public CategoriaAcessoViewModel CategoriaAcesso { get; set; }
    }
}
