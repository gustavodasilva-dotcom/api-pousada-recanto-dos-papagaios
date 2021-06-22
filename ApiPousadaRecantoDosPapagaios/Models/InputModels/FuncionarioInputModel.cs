using System;

namespace ApiPousadaRecantoDosPapagaios.Models.InputModels
{
    public class FuncionarioInputModel
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
        public EnderecoInputModel Endereco { get; set; }
        public DadosBancariosInputModel DadosBancarios { get; set; }
        public CategoriaAcessoInputModel CategoriaAcesso { get; set; }
    }
}
