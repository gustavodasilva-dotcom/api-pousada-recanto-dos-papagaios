using System;

namespace ApiPousadaRecantoDosPapagaios.Entities
{
    public abstract class Pessoa
    {
        public int Id { get; set; }
        public string NomeCompleto { get; set; }
        public string Cpf { get; set; }
        public DateTime DataDeNascimento { get; set; }
        public string Email { get; set; }
        public string Login { get; set; }
        public string Senha { get; set; }
        public string Celular { get; set; }
        public Endereco Endereco { get; set; }
        public int Excluido { get; set; }
    }
}
