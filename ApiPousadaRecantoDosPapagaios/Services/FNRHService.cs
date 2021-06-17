using ApiPousadaRecantoDosPapagaios.Entities;
using ApiPousadaRecantoDosPapagaios.Models.InputModels;
using ApiPousadaRecantoDosPapagaios.Models.ViewModels;
using ApiPousadaRecantoDosPapagaios.Repositories;
using System;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Services
{
    public class FNRHService : IFNRHService
    {
        private readonly IFNRHRepository _FNRHRepository;

        private readonly IHospedeRepository _hospedeRepository;

        public FNRHService(IFNRHRepository FNRHRepository, IHospedeRepository hospedeRepository)
        {
            _FNRHRepository = FNRHRepository;

            _hospedeRepository = hospedeRepository;
        }

        public async Task<FNRHViewModel> Obter(string cpfHospede)
        {
            var fnrh = await _FNRHRepository.Obter(cpfHospede);

            if (fnrh == null)
                throw new Exception();

            return new FNRHViewModel
            {
                CpfHospede = fnrh.CpfHospede,
                Profissao = fnrh.Profissao,
                Nacionalidade = fnrh.Nacionalidade,
                Sexo = fnrh.Sexo,
                Rg = fnrh.Rg,
                ProximoDestino = fnrh.ProximoDestino,
                UltimoDestino = fnrh.UltimoDestino,
                MotivoViagem = fnrh.MotivoViagem,
                MeioDeTransporte = fnrh.MeioDeTransporte,
                PlacaAutomovel = fnrh.PlacaAutomovel,
                NumAcompanhantes = fnrh.NumAcompanhantes
            };
        }

        public async Task<FNRHViewModel> Inserir(string cpfHospede, FNRHInputModel fnrhInputModel)
        {
            var hospede = await _hospedeRepository.Obter(cpfHospede);

            if (hospede == null)
                throw new Exception();

            var fnrhInsert = new FNRH
            {
                CpfHospede = fnrhInputModel.CpfHospede,
                Profissao = fnrhInputModel.Profissao,
                Nacionalidade = fnrhInputModel.Nacionalidade,
                Sexo = fnrhInputModel.Sexo,
                Rg = fnrhInputModel.Rg,
                UltimoDestino = fnrhInputModel.UltimoDestino,
                ProximoDestino = fnrhInputModel.ProximoDestino,
                MotivoViagem = fnrhInputModel.MotivoViagem,
                MeioDeTransporte = fnrhInputModel.MeioDeTransporte,
                PlacaAutomovel = fnrhInputModel.PlacaAutomovel,
                NumAcompanhantes = fnrhInputModel.NumAcompanhantes,
                HospedeId = hospede.Id,
                Excluido = 0
            };
            
            await _FNRHRepository.Inserir(cpfHospede, fnrhInsert);

            return new FNRHViewModel
            {
                CpfHospede = fnrhInsert.CpfHospede,
                Profissao = fnrhInsert.Profissao,
                Nacionalidade = fnrhInsert.Nacionalidade,
                Sexo = fnrhInsert.Sexo,
                Rg = fnrhInsert.Rg,
                ProximoDestino = fnrhInsert.ProximoDestino,
                UltimoDestino = fnrhInsert.UltimoDestino,
                MotivoViagem = fnrhInsert.MotivoViagem,
                MeioDeTransporte = fnrhInsert.MeioDeTransporte,
                PlacaAutomovel = fnrhInsert.PlacaAutomovel,
                NumAcompanhantes = fnrhInsert.NumAcompanhantes
            };
        }

    }
}
