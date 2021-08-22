using ApiPousadaRecantoDosPapagaios.Entities;
using ApiPousadaRecantoDosPapagaios.Models.ViewModels;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Repositories
{
    public interface IHospedeRepository
    {
        Task<List<Hospede>> Obter(int pagina, int quantidade);

        Task<Hospede> Obter(int idHospede);
        //Task<Hospede> ObterPorCpf(string cpfHospede);
        //Task Inserir(Hospede hospede);
        //Task Atualizar(string cpfHospede, Hospede hospede);
        //Task Remover(string cpfHospede);
        //Task<Hospede> ObterUltimoHospede();
    }
}
