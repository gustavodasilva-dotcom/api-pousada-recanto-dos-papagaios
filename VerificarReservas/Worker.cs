using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using System;
using System.Data.SqlClient;
using System.Threading;
using System.Threading.Tasks;
using VerificarReservas.Repository;

namespace VerificarReservas
{
    public class Worker : BackgroundService
    {
        private readonly ILogger<Worker> _logger;

        private readonly IReservaRepository _reservaRepository;

        private readonly IPagamentoRepository _pagamentoRepository;

        public Worker(ILogger<Worker> logger, IReservaRepository reservaRepository, IPagamentoRepository pagamentoService)
        {
            _logger = logger;

            _reservaRepository = reservaRepository;

            _pagamentoRepository = pagamentoService;
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            while (!stoppingToken.IsCancellationRequested)
            {
                try
                {
                    await ReservasSemCheckIn();

                    await PagamentoCartaoCredito();

                    await AcomodacaoOcupadaParaDisponivel();
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Um erro ocorreu ao executar as rotinas.", ex.Message);
                }
                finally
                {
                    _logger.LogInformation("Serviço rodando em: {time}", DateTimeOffset.Now);
                }
                
                await Task.Delay(100000, stoppingToken);
            }
        }

        private async Task ReservasSemCheckIn()
        {
            try
            {
                await _reservaRepository.VerificarReservasSemCheckIn();

                _logger.LogInformation("Verificar reservas sem check-in: execução realizada com sucesso!");
            }
            catch (SqlException ex)
            {
                _logger.LogError(ex.Message);
            }
        }

        private async Task PagamentoCartaoCredito()
        {
            try
            {
                var mensagem = await _pagamentoRepository.CertaoDeCreditoPagamentoPendente();

                _logger.LogInformation(mensagem);
            }
            catch (SqlException ex)
            {
                _logger.LogError(ex.Message);
            }
        }

        private async Task AcomodacaoOcupadaParaDisponivel()
        {
            try
            {
                var mensagem = await _reservaRepository.VerificarAcomodacoesOcupadas();

                _logger.LogInformation(mensagem);
            }
            catch (SqlException ex)
            {
                _logger.LogError(ex.Message);
            }
        }
    }
}
