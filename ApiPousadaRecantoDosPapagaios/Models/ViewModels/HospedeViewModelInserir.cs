using System;

namespace ApiPousadaRecantoDosPapagaios.Models.ViewModels
{
    public class HospedeViewModelInserir
    {
        public string NomeCompleto { get; set; }
        public string Cpf { get; set; }
        public DateTime DataDeNascimento { get; set; }
        public string Email { get; set; }
        public string Login { get; set; }
        public string Senha { get; set; }
        public string Celular { get; set; }
        public EnderecoViewModel Endereco { get; set; }
    }
}
