using System;
using System.ComponentModel.DataAnnotations;

namespace ApiPousadaRecantoDosPapagaios.Models.ViewModels
{
    public class HospedeViewModel
    {
        public int Id { get; set; }

        public string NomeCompleto { get; set; }

        public string Cpf { get; set; }

        [DataType(DataType.Date)]
        public DateTime DataDeNascimento { get; set; }

        public UsuarioViewModel Usuario { get; set; }

        public ContatosViewModel Contatos { get; set; }

        public EnderecoViewModel Endereco { get; set; }
    }
}
