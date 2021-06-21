namespace ApiPousadaRecantoDosPapagaios.Entities
{
    public class DadosBancarios
    {
        public int Id { get; set; }
        public string Banco { get; set; }
        public string Agencia { get; set; }
        public string NumeroDaConta { get; set; }
        public int IdFuncionario { get; set; }
        public string CpfFuncionario { get; set; }
        public int Excluido { get; set; }
    }
}
