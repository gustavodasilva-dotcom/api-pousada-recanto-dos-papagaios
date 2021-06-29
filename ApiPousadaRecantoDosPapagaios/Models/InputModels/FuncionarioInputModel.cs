using System;
using System.ComponentModel.DataAnnotations;

namespace ApiPousadaRecantoDosPapagaios.Models.InputModels
{
    public class FuncionarioInputModel
    {
        [DataType(DataType.Text, ErrorMessage = "O dado inserido não corresponde a um texto.")]
        public string NomeCompleto { get; set; }

        [StringLength(maximumLength: 11, MinimumLength = 11, ErrorMessage = "O CPF deve conter 11 caracteres.")]
        [RegularExpression("^[0-9]*$", ErrorMessage = "O CPF deve conter apenas números.")]
        public string Cpf { get; set; }

        [DataType(DataType.Date, ErrorMessage = "O dado inserido não corresponde a uma data.")]
        public DateTime DataDeNascimento { get; set; }

        [DataType(DataType.EmailAddress, ErrorMessage = "O dado inserido não corresponde a um e-mail.")]
        public string Email { get; set; }

        public string Login { get; set; }

        [DataType(DataType.Password, ErrorMessage = "O dado inserido não corresponde a uma senha.")]
        public string Senha { get; set; }

        [DataType(DataType.PhoneNumber, ErrorMessage = "O dado inserido não corresponde a um telefone.")]
        public string Celular { get; set; }
        
        [DataType(DataType.Text, ErrorMessage = "O dado inserido não corresponde a um texto.")]
        public string Nacionalidade { get; set; }

        [StringLength(maximumLength: 1, MinimumLength = 1, ErrorMessage = "O dado inserido deve conter apenas um caractere.")]
        public string Sexo { get; set; }

        [StringLength(maximumLength: 9, MinimumLength = 9, ErrorMessage = "O RG deve conter 9 caracteres.")]
        [RegularExpression("^[0-9]*$", ErrorMessage = "O RG deve conter apenas números.")]
        public string Rg { get; set; }

        [DataType(DataType.Text, ErrorMessage = "O dado inserido não corresponde a um texto.")]
        public string Cargo { get; set; }

        [DataType(DataType.Text, ErrorMessage = "O dado inserido não corresponde a um texto.")]
        public string Setor { get; set; }

        [DataType(DataType.Currency, ErrorMessage = "O dado inserido não corresponde à moeda.")]
        [RegularExpression("^[0-9]*$", ErrorMessage = "O salário deve conter apenas números.")]
        public double Salario { get; set; }

        public EnderecoInputModel Endereco { get; set; }
        
        public DadosBancariosInputModel DadosBancarios { get; set; }
        
        public CategoriaAcessoInputModel CategoriaAcesso { get; set; }
    }
}
