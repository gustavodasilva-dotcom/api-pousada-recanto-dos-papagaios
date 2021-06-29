using System;
using System.ComponentModel.DataAnnotations;

namespace ApiPousadaRecantoDosPapagaios.Models.ViewModels
{
    public class FuncionarioViewModel
    {
        public string NomeCompleto { get; set; }

        public string Cpf { get; set; }

        [DataType(DataType.Date)]
        public DateTime DataDeNascimento { get; set; }

        [DataType(DataType.EmailAddress)]
        public string Email { get; set; }

        public string Login { get; set; }

        [DataType(DataType.Password)]
        public string Senha { get; set; }

        [DataType(DataType.PhoneNumber)]
        public string Celular { get; set; }

        public string Nacionalidade { get; set; }
        
        public string Sexo { get; set; }

        public string Rg { get; set; }

        public string Cargo { get; set; }

        public string Setor { get; set; }

        [DataType(DataType.Currency)]
        public double Salario { get; set; }
        
        public EnderecoViewModel Endereco { get; set; }
        
        public DadosBancariosViewModel DadosBancarios { get; set; }
        
        public CategoriaAcessoViewModel CategoriaAcesso { get; set; }
    }
}
