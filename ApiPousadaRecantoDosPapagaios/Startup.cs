using ApiPousadaRecantoDosPapagaios.Repositories;
using ApiPousadaRecantoDosPapagaios.Services;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.OpenApi.Models;

namespace ApiPousadaRecantoDosPapagaios
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddScoped<IHospedeService, HospedeService>();
            services.AddScoped<IHospedeRepository, HospedeRepository>();

            services.AddScoped<IFNRHService, FNRHService>();
            services.AddScoped<IFNRHRepository, FNRHRepository>();

            services.AddScoped<IFuncionarioService, FuncionarioService>();
            services.AddScoped<IFuncionarioRepository, FuncionarioRepository>();

            services.AddScoped<IAcomodacaoService, AcomodacaoService>();
            services.AddScoped<IAcomodacaoRepository, AcomodacaoRepository>();

            services.AddScoped<IReservaRepository, ReservaRepository>();
            services.AddScoped<IReservaService, ReservaService>();

            services.AddScoped<ICheckInRepository, CheckInRepository>();
            services.AddScoped<ICheckInService, CheckInService>();

            services.AddScoped<ICheckOutRepository, CheckOutRepository>();
            services.AddScoped<ICheckOutService, CheckOutService>();

            services.AddScoped<ILoginService, LoginService>();
            services.AddScoped<ILoginRepository, LoginRepository>();

            services.AddScoped<IAlertaService, AlertaService>();
            services.AddScoped<IAlertaRepository, AlertaRepository>();

            services.AddControllers();

            services.AddSwaggerGen(c =>
            {
                c.SwaggerDoc("v1", new OpenApiInfo { Title = "ApiPousadaRecantoDosPapagaios", Version = "v1" });
            });
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
                app.UseSwagger();
                app.UseSwaggerUI(c => c.SwaggerEndpoint("/swagger/v1/swagger.json", "ApiPousadaRecantoDosPapagaios v1"));
            }

            app.UseHttpsRedirection();

            app.UseRouting();

            app.UseAuthorization();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });
        }
    }
}
