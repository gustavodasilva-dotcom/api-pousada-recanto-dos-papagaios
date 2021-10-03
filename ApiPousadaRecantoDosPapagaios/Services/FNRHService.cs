using ApiPousadaRecantoDosPapagaios.Business;
using ApiPousadaRecantoDosPapagaios.Entities;
using ApiPousadaRecantoDosPapagaios.Exceptions;
using ApiPousadaRecantoDosPapagaios.Models.InputModels;
using ApiPousadaRecantoDosPapagaios.Models.ViewModels;
using ApiPousadaRecantoDosPapagaios.Repositories;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Services
{
    public class FNRHService : IFNRHService
    {
        private readonly IFNRHRepository _FNRHRepository;

        private readonly Json _json;

        public FNRHService(IFNRHRepository FNRHRepository)
        {
            _FNRHRepository = FNRHRepository;

            _json = new Json();
        }

        public async Task<List<FNRHViewModel>> Obter(int idHospede)
        {
            var fnrhs = await _FNRHRepository.ObterFNRHsPorHospede(idHospede);

            if (fnrhs.Count == 0)
                throw new NaoEncontradoException();

            return fnrhs.Select(f => new FNRHViewModel
            {
                Id = f.Id,
                Profissao = f.Profissao,
                Nacionalidade = f.Nacionalidade,
                Sexo = f.Sexo,
                Rg = f.Rg,
                ProximoDestino = f.ProximoDestino,
                UltimoDestino = f.UltimoDestino,
                MotivoViagem = f.MotivoViagem,
                MeioDeTransporte = f.MeioDeTransporte,
                PlacaAutomovel = f.PlacaAutomovel,
                NumAcompanhantes = f.NumAcompanhantes,
                DataCadastro = f.DataCadastro
            }).ToList();
        }

        public async Task<RetornoViewModel> Inserir(int idHospede, FNRHInputModel fnrhInputModel)
        {
            var fnrhInsert = new FNRH
            {
                Profissao = fnrhInputModel.Profissao,
                Nacionalidade = fnrhInputModel.Nacionalidade,
                Sexo = fnrhInputModel.Sexo,
                Rg = fnrhInputModel.Rg,
                UltimoDestino = fnrhInputModel.UltimoDestino,
                ProximoDestino = fnrhInputModel.ProximoDestino,
                MotivoViagem = fnrhInputModel.MotivoViagem,
                MeioDeTransporte = fnrhInputModel.MeioDeTransporte,
                PlacaAutomovel = fnrhInputModel.PlacaAutomovel,
                NumAcompanhantes = fnrhInputModel.NumAcompanhantes
            };

            var json = _json.ConverterModelParaJson(fnrhInputModel);

            var r = await _FNRHRepository.Inserir(idHospede, fnrhInsert, json);

            return new RetornoViewModel
            {
                StatusCode = r.StatusCode,
                Mensagem = r.Mensagem
            };
        }

        public async Task<RetornoViewModel> Atualizar(int idFNRH, FNRHInputModel fnrhInputModel)
        {
            var fnrhUpdate = new FNRH
            {
                Profissao = fnrhInputModel.Profissao,
                Nacionalidade = fnrhInputModel.Nacionalidade,
                Sexo = fnrhInputModel.Sexo,
                Rg = fnrhInputModel.Rg,
                UltimoDestino = fnrhInputModel.UltimoDestino,
                ProximoDestino = fnrhInputModel.ProximoDestino,
                MotivoViagem = fnrhInputModel.MotivoViagem,
                MeioDeTransporte = fnrhInputModel.MeioDeTransporte,
                PlacaAutomovel = fnrhInputModel.PlacaAutomovel,
                NumAcompanhantes = fnrhInputModel.NumAcompanhantes
            };

            var json = _json.ConverterModelParaJson(fnrhInputModel);

            var r = await _FNRHRepository.Atualizar(idFNRH, fnrhUpdate, json);

            return new RetornoViewModel
            {
                StatusCode = r.StatusCode,
                Mensagem = r.Mensagem
            };
        }
    }
}
