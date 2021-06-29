using System;
using System.ComponentModel.DataAnnotations;

namespace ApiPousadaRecantoDosPapagaios.Models.ViewModels
{
    public class HospedeViewModel
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
        
        public EnderecoViewModel Endereco { get; set; }
    }
}
