using System;
using System.ComponentModel.DataAnnotations;

namespace ApiPousadaRecantoDosPapagaios.Models.ViewModels
{
    public class FuncionarioViewModel
    {
        public int Id { get; set; }

        public string NomeCompleto { get; set; }

        public string Cpf { get; set; }

        public string Nacionalidade { get; set; }

        [DataType(DataType.Date)]
        public DateTime DataDeNascimento { get; set; }

        public string Sexo { get; set; }

        public string Rg { get; set; }

        public string Cargo { get; set; }

        public string Setor { get; set; }

        [DataType(DataType.Currency)]
        public double Salario { get; set; }

        public UsuarioViewModel Usuario { get; set; }

        public ContatosViewModel Contatos { get; set; }

        public EnderecoViewModel Endereco { get; set; }
        
        public DadosBancariosViewModel DadosBancarios { get; set; }
        
        public CategoriaAcessoViewModel CategoriaAcesso { get; set; }
    }
}
