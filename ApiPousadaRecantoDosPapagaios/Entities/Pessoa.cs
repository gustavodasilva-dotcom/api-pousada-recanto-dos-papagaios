using System;

namespace ApiPousadaRecantoDosPapagaios.Entities
{
    public abstract class Pessoa
    {
        public int Id { get; set; }
        public string NomeCompleto { get; set; }
        public string Cpf { get; set; }
        public DateTime DataDeNascimento { get; set; }
        public Usuario Usuario { get; set; }
        public Contatos Contatos { get; set; }
        public Endereco Endereco { get; set; }
    }
}
