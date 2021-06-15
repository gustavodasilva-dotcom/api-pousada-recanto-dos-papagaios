using ApiPousadaRecantoDosPapagaios.Models.ViewModels;
using ApiPousadaRecantoDosPapagaios.Repositories;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ApiPousadaRecantoDosPapagaios.Services
{
    public class EnderecoService : IEnderecoService
    {
        private readonly IEnderecoRepository _enderecoRepository;

        public EnderecoService(IEnderecoRepository enderecoRepository)
        {
            _enderecoRepository = enderecoRepository;
        }

        public async Task<List<EnderecoViewModel>> Obter()
        {
            var enderecos = await _enderecoRepository.Obter();

            return enderecos.Select(e => new EnderecoViewModel
            {
                Cep = e.Cep,
                Logradouro = e.Logradouro,
                Numero = e.Numero,
                Complemento = e.Complemento,
                Bairro = e.Bairro,
                Cidade = e.Cidade,
                Estado = e.Estado,
                Pais = e.Pais
            }).ToList();
        }
    }
}
