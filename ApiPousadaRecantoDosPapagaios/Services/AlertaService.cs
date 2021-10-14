using ApiPousadaRecantoDosPapagaios.Business;
using ApiPousadaRecantoDosPapagaios.Entities;
using ApiPousadaRecantoDosPapagaios.Models.InputModels;
using ApiPousadaRecantoDosPapagaios.Models.ViewModels;
using ApiPousadaRecantoDosPapagaios.Repositories;
using System;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Services
{
    public class AlertaService : IAlertaService
    {
        private readonly IAlertaRepository _alertaRepository;

        private readonly Json _json;

        public AlertaService(IAlertaRepository alertaRepository)
        {
            _alertaRepository = alertaRepository;

            _json = new Json();
        }
        
        public async Task<RetornoViewModel> Inserir(AlertaInputModel alertaInput)
        {
            Retorno retorno;

            try
            {
                var alerta = new Alerta
                {
                    Titulo = alertaInput.Titulo,
                    Mensagem = alertaInput.Mensagem,
                    IdFuncionario = alertaInput.IdFuncionario
                };

                var json = _json.ConverterModelParaJson(alertaInput);

                retorno = await _alertaRepository.Inserir(alerta, json);
            }
            catch (Exception)
            {
                throw;
            }

            return new RetornoViewModel
            {
                StatusCode = retorno.StatusCode,
                Mensagem = retorno.Mensagem
            };
        }
    }
}
