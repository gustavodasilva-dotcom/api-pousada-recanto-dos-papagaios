using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using VerificarReservas.Repository;

namespace VerificarReservas
{
    public class Worker : BackgroundService
    {
        private readonly ILogger<Worker> _logger;

        private readonly IReservaRepository _reservaRepository;

        public Worker(ILogger<Worker> logger, IReservaRepository reservaRepository)
        {
            _logger = logger;

            _reservaRepository = reservaRepository;
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            while (!stoppingToken.IsCancellationRequested)
            {
                try
                {
                    await ReservasSemCheckIn();
                    _logger.LogInformation("Execução realizada com sucesso!");
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Um erro ocorreu ao executar as rotinas de verificação de reserva.");
                }
                finally
                {
                    _logger.LogInformation("Worker running at: {time}", DateTimeOffset.Now);
                }
                
                await Task.Delay(1000, stoppingToken);
            }
        }

        private async Task ReservasSemCheckIn()
        {
            try
            {
                await _reservaRepository.VerificarReservasSemCheckIn();
            }
            catch (SqlException ex)
            {
                _logger.LogError(ex.Message);
            }
        }
    }
}
