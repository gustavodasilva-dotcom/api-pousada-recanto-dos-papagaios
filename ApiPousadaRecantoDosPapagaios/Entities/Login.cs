namespace ApiPousadaRecantoDosPapagaios.Entities
{
    public class Login
    {
        public Retorno Retorno { get; set; }
        public int Id { get; set; }
        public string Cpf { get; set; }
        public string NomeUsuario { get; set; }
        public string SenhaUsuario { get; set; }
    }
}
