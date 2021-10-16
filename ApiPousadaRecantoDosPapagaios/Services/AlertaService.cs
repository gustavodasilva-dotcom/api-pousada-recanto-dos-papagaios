using ApiPousadaRecantoDosPapagaios.Business;
using ApiPousadaRecantoDosPapagaios.Entities;
using ApiPousadaRecantoDosPapagaios.Models.InputModels;
using ApiPousadaRecantoDosPapagaios.Models.ViewModels;
using ApiPousadaRecantoDosPapagaios.Models.ViewModels.CheckOutViewModels;
using ApiPousadaRecantoDosPapagaios.Repositories;
using System;
using System.Collections.Generic;
using System.Linq;
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

        public async Task<List<AlertaViewModel>> Obter(int pagina, int quantidade)
        {
            List<Alerta> alertas;

            try
            {
                alertas = await _alertaRepository.Obter(pagina, quantidade);
            }
            catch (Exception)
            {
                throw;
            }

            return alertas.Select(a => new AlertaViewModel
            {
                Id = a.Id,
                Titulo = a.Titulo,
                Mensagem = a.Mensagem,
                Funcionario = new FuncionarioCheckOutViewModel
                {
                    NomeCompleto = a.Funcionario.NomeCompleto,
                    Usuario = new UsuarioViewModel
                    {
                        NomeUsuario = a.Funcionario.Usuario.NomeUsuario
                    }
                }
            }).ToList();
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
                    Funcionario = new Funcionario
                    {
                        Id = alertaInput.IdFuncionario
                    }
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

        public async Task<RetornoViewModel> Deletar(int idAlerta)
        {
            Retorno retorno;

            try
            {
                retorno = await _alertaRepository.Deletar(idAlerta);
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
