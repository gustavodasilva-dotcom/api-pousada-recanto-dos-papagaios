using ApiPousadaRecantoDosPapagaios.Entities;
using ApiPousadaRecantoDosPapagaios.Models.InputModels;
using ApiPousadaRecantoDosPapagaios.Models.ViewModels;
using ApiPousadaRecantoDosPapagaios.Repositories;
using System;
using System.Collections.Generic;
using System.Linq;
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

        //public async Task<List<FNRHViewModel>> Obter(string cpfHospede)
        //{
        //    var fnrhs = await _FNRHRepository.ObterFNRHsPorHospede(cpfHospede);

        //    return fnrhs.Select(f => new FNRHViewModel
        //    {
        //        Id = f.Id,
        //        CpfHospede = f.CpfHospede,
        //        Profissao = f.Profissao,
        //        Nacionalidade = f.Nacionalidade,
        //        Sexo = f.Sexo,
        //        Rg = f.Rg,
        //        ProximoDestino = f.ProximoDestino,
        //        UltimoDestino = f.UltimoDestino,
        //        MotivoViagem = f.MotivoViagem,
        //        MeioDeTransporte = f.MeioDeTransporte,
        //        PlacaAutomovel = f.PlacaAutomovel,
        //        NumAcompanhantes = f.NumAcompanhantes
        //    }).ToList();
        //}

        //public async Task<FNRHViewModel> Inserir(string cpfHospede, FNRHInputModel fnrhInputModel)
        //{
        //    var hospede = await _hospedeRepository.Obter(cpfHospede);

        //    if (hospede == null)
        //        throw new Exception();

        //    var fnrhInsert = new FNRH
        //    {
        //        CpfHospede = fnrhInputModel.CpfHospede,
        //        Profissao = fnrhInputModel.Profissao,
        //        Nacionalidade = fnrhInputModel.Nacionalidade,
        //        Sexo = fnrhInputModel.Sexo,
        //        Rg = fnrhInputModel.Rg,
        //        UltimoDestino = fnrhInputModel.UltimoDestino,
        //        ProximoDestino = fnrhInputModel.ProximoDestino,
        //        MotivoViagem = fnrhInputModel.MotivoViagem,
        //        MeioDeTransporte = fnrhInputModel.MeioDeTransporte,
        //        PlacaAutomovel = fnrhInputModel.PlacaAutomovel,
        //        NumAcompanhantes = fnrhInputModel.NumAcompanhantes,
        //        HospedeId = hospede.Id,
        //    };
            
        //    await _FNRHRepository.Inserir(cpfHospede, fnrhInsert);

        //    var fnrh = await _FNRHRepository.ObterUltimoRegistroPorHospede(cpfHospede);

        //    return new FNRHViewModel
        //    {
        //        Id = fnrh.Id,
        //        CpfHospede = fnrh.CpfHospede,
        //        Profissao = fnrh.Profissao,
        //        Nacionalidade = fnrh.Nacionalidade,
        //        Sexo = fnrh.Sexo,
        //        Rg = fnrh.Rg,
        //        ProximoDestino = fnrh.ProximoDestino,
        //        UltimoDestino = fnrh.UltimoDestino,
        //        MotivoViagem = fnrh.MotivoViagem,
        //        MeioDeTransporte = fnrh.MeioDeTransporte,
        //        PlacaAutomovel = fnrh.PlacaAutomovel,
        //        NumAcompanhantes = fnrh.NumAcompanhantes
        //    };
        //}

        //public async Task<FNRHViewModel> Atualizar(int idFNRH, FNRHInputModel fnrhInputModel)
        //{
        //    var fnrh = await _FNRHRepository.ObterPorId(idFNRH);

        //    if (fnrh == null)
        //        throw new Exception();

        //    var fnrhInsert = new FNRH
        //    {
        //        CpfHospede = fnrhInputModel.CpfHospede,
        //        Profissao = fnrhInputModel.Profissao,
        //        Nacionalidade = fnrhInputModel.Nacionalidade,
        //        Sexo = fnrhInputModel.Sexo,
        //        Rg = fnrhInputModel.Rg,
        //        UltimoDestino = fnrhInputModel.UltimoDestino,
        //        ProximoDestino = fnrhInputModel.ProximoDestino,
        //        MotivoViagem = fnrhInputModel.MotivoViagem,
        //        MeioDeTransporte = fnrhInputModel.MeioDeTransporte,
        //        PlacaAutomovel = fnrhInputModel.PlacaAutomovel,
        //        NumAcompanhantes = fnrhInputModel.NumAcompanhantes,
        //    };

        //    await _FNRHRepository.Atualizar(idFNRH, fnrhInsert);

        //    return new FNRHViewModel
        //    {
        //        Id = fnrh.Id,
        //        CpfHospede = fnrhInsert.CpfHospede,
        //        Profissao = fnrhInsert.Profissao,
        //        Nacionalidade = fnrhInsert.Nacionalidade,
        //        Sexo = fnrhInsert.Sexo,
        //        Rg = fnrhInsert.Rg,
        //        ProximoDestino = fnrhInsert.ProximoDestino,
        //        UltimoDestino = fnrhInsert.UltimoDestino,
        //        MotivoViagem = fnrhInsert.MotivoViagem,
        //        MeioDeTransporte = fnrhInsert.MeioDeTransporte,
        //        PlacaAutomovel = fnrhInsert.PlacaAutomovel,
        //        NumAcompanhantes = fnrhInsert.NumAcompanhantes
        //    };
        //}

        //public async Task Deletar(int idFNRH)
        //{
        //    var fnrh = await _FNRHRepository.ObterPorId(idFNRH);

        //    if (fnrh == null)
        //        throw new Exception();

        //    await _FNRHRepository.Deletar(idFNRH);
        //}
    }
}
