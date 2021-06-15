using System;

namespace ApiPousadaRecantoDosPapagaios.Models.InputModels
{
    public class HospedeInputModel
    {
        public string NomeCompleto { get; set; }
        public string Cpf { get; set; }
        public DateTime DataDeNascimento { get; set; }
        public string Email { get; set; }
        public string Login { get; set; }
        public string Senha { get; set; }
        public string Celular { get; set; }
        public EnderecoInputModel Endereco { get; set; }
    }
}
