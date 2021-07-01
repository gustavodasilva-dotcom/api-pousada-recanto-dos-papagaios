namespace ApiPousadaRecantoDosPapagaios.Models.InputModels
{
    public class AcomodacaoInputModel
    {
        public string Nome { get; set; }
        public StatusAcomodacaoInputModel StatusAcomodacao { get; set; }
        public InformacoesAcomodacaoInputModel InformacoesAcomodacao { get; set; }
    }
}
