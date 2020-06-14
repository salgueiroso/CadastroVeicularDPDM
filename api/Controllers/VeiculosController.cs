using System.Collections.Generic;
using System.Linq;
using api.model;
using Microsoft.AspNetCore.Mvc;

namespace api.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class VeiculosController : ControllerBase
    {
        private readonly ApplicationDbContext _ctx;

        public VeiculosController(ApplicationDbContext ctx)
        {
            _ctx = ctx;
        }

        [HttpGet]
        public IActionResult Get()
        {
            var result = _ctx.Veiculos
                .OrderBy(x => x.Descricao)
                .ToList()
                .Select(e => new VeiculoDTO(e))
                .ToList();
            return Ok(result);
        }


        [HttpGet("{id}")]
        public IActionResult Get(int id)
        {

            var entity = _ctx.Veiculos.FirstOrDefault(x => x.Id == id);
            if (entity != null)
                return Ok(new VeiculoDTO(entity));
            else
                return NotFound();
        }

        [HttpPost]
        public IActionResult Post([FromBody] VeiculoDTO model)
        {
            var esp = _ctx.Modelos.FirstOrDefault(x => x.Id == model.Id);

            var entity = new Veiculo
            {
                Descricao = model.Descricao,
                Ano = model.Ano,
                Cor = model.Cor,
                ModeloId = model.Modelo.Id.Value,
                MarcaId = model.Marca.Id.Value
            };

            _ctx.Veiculos.Add(entity);
            _ctx.SaveChanges();

            return Ok();
        }

        [HttpPut]
        public IActionResult Put([FromBody] VeiculoDTO model)
        {
            var entity = _ctx.Veiculos.FirstOrDefault(x => x.Id == model.Id);

            entity.Descricao = model.Descricao;
            entity.Ano = model.Ano;
            entity.Cor = model.Cor;
            entity.ModeloId = model.Modelo.Id.Value;
            entity.MarcaId = model.Marca.Id.Value;

            _ctx.Veiculos.Update(entity);
            _ctx.SaveChanges();

            return Ok();
        }


        [HttpDelete("{id}")]
        public IActionResult Delete(int id)
        {
            var entity = _ctx.Veiculos.FirstOrDefault(x => x.Id == id);

            _ctx.Veiculos.Remove(entity);
            _ctx.SaveChanges();

            return Ok();
        }
    }
}
