using ApiPousadaRecantoDosPapagaios.CustomDataAnnotations;
using System.ComponentModel.DataAnnotations;

namespace ApiPousadaRecantoDosPapagaios.Models.InputModels
{
    public class FuncionarioInputModel
    {
        [Required]
        [DataType(DataType.Text, ErrorMessage = "O dado inserido não corresponde a um texto.")]
        public string NomeCompleto { get; set; }

        [Required]
        [StringLength(maximumLength: 11, MinimumLength = 11, ErrorMessage = "O CPF deve conter 11 caracteres.")]
        [RegularExpression("^[0-9]*$", ErrorMessage = "O CPF deve conter apenas números.")]
        public string Cpf { get; set; }

        [Required]
        [DataType(DataType.Text, ErrorMessage = "O dado inserido não corresponde a um texto.")]
        public string Nacionalidade { get; set; }

        [Required]
        [DataValidacao(ErrorMessage = "O dado informado não procede como uma data.")]
        [MaiorDeIdade(ErrorMessage = "O hóspede deve ser maior de idade.")]
        public string DataDeNascimento { get; set; }

        [Required]
        [StringLength(maximumLength: 1, MinimumLength = 1, ErrorMessage = "O dado inserido deve conter apenas um caractere.")]
        public string Sexo { get; set; }

        [Required]
        [StringLength(maximumLength: 9, MinimumLength = 9, ErrorMessage = "O RG deve conter 9 caracteres.")]
        [RegularExpression("^[0-9]*$", ErrorMessage = "O RG deve conter apenas números.")]
        public string Rg { get; set; }

        [Required]
        [DataType(DataType.Text, ErrorMessage = "O dado inserido não corresponde a um texto.")]
        public string Cargo { get; set; }

        [Required]
        [DataType(DataType.Text, ErrorMessage = "O dado inserido não corresponde a um texto.")]
        public string Setor { get; set; }

        [Required]
        [DataType(DataType.Currency, ErrorMessage = "O dado inserido não corresponde à moeda.")]
        [RegularExpression("^[0-9]*$", ErrorMessage = "O salário deve conter apenas números.")]
        public double Salario { get; set; }

        public UsuarioInputModel Usuario { get; set; }

        public ContatosInputModel Contatos { get; set; }
        
        public EnderecoInputModel Endereco { get; set; }
        
        public DadosBancariosInputModel DadosBancarios { get; set; }
        
        public CategoriaAcessoInputModel CategoriaAcesso { get; set; }

        public PerguntaDeSegurancaInputModel PerguntaDeSeguranca { get; set; }
    }
}
