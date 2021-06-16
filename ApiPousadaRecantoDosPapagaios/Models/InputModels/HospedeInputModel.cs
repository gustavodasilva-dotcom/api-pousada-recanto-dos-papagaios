using System;
using System.ComponentModel.DataAnnotations;

namespace ApiPousadaRecantoDosPapagaios.Models.InputModels
{
    public class HospedeInputModel
    {
        public string NomeCompleto { get; set; }

        [StringLength(maximumLength: 11, MinimumLength = 11)]
        public string Cpf { get; set; }

        public DateTime DataDeNascimento { get; set; }
        
        public string Email { get; set; }
        
        public string Login { get; set; }
        
        public string Senha { get; set; }

        [StringLength(maximumLength: 15, MinimumLength = 13)]
        public string Celular { get; set; }
        
        public EnderecoInputModel Endereco { get; set; }
    }
}
