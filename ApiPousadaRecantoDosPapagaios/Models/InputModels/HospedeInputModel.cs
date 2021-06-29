using System;
using System.ComponentModel.DataAnnotations;

namespace ApiPousadaRecantoDosPapagaios.Models.InputModels
{
    public class HospedeInputModel
    {
        public string NomeCompleto { get; set; }

        [StringLength(maximumLength: 11, MinimumLength = 11, ErrorMessage = "O CPF deve conter 11 caracteres.")]
        [RegularExpression("^[0-9]*$", ErrorMessage = "O CPF deve conter apenas números.")]
        public string Cpf { get; set; }

        [DataType(DataType.Date, ErrorMessage = "O dado inserido não corresponde a uma data.")]
        public DateTime DataDeNascimento { get; set; }
        
        [DataType(DataType.EmailAddress, ErrorMessage = "O dado inserido não corresponde a um e-mail.")]
        public string Email { get; set; }
        
        [DataType(DataType.Password, ErrorMessage = "O dado inserido não corresponde a uma senha.")]
        public string Senha { get; set; }

        [StringLength(maximumLength: 13, MinimumLength = 13, ErrorMessage = "O número de telefone deve seguir ao seguinte padrão: 5511900001111 (sem espaços).")]
        [DataType(DataType.PhoneNumber, ErrorMessage = "O dado inserido não corresponde a um número de celular.")]
        public string Celular { get; set; }
        
        public EnderecoInputModel Endereco { get; set; }
    }
}
