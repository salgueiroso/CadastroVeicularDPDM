using System.Collections.Generic;
using System.Linq;
using api.model;
using Microsoft.AspNetCore.Mvc;

namespace api.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ModelosController : ControllerBase
    {
        private readonly ApplicationDbContext _ctx;

        public ModelosController(ApplicationDbContext ctx)
        {
            _ctx = ctx;
        }

        [HttpGet]
        public IActionResult Get()
        {
            var result = _ctx.Modelos
                .OrderBy(x => x.Descricao)
                .ToList()
                .Select(e => new ModeloDTO(e))
                .ToList();
            return Ok(result);
        }


        [HttpGet("{id}")]
        public IActionResult Get(int id)
        {

            var entity = _ctx.Modelos.FirstOrDefault(x => x.Id == id);
            if (entity != null)
                return Ok(new ModeloDTO(entity));
            else
                return NotFound();
        }

        [HttpPost]
        public IActionResult Post([FromBody] ModeloDTO model)
        {
            var esp = _ctx.Modelos.FirstOrDefault(x => x.Id == model.Id);

            var entity = new Modelo
            {
                Descricao = model.Descricao,
                Codigo = model.Codigo,
                MarcaId = model.Marca.Id.Value
            };

            _ctx.Modelos.Add(entity);
            _ctx.SaveChanges();

            return Ok();
        }

        [HttpPut]
        public IActionResult Put([FromBody] ModeloDTO model)
        {
            var entity = _ctx.Modelos.FirstOrDefault(x => x.Id == model.Id);

            entity.Descricao = model.Descricao;
            entity.Codigo = model.Codigo;
            entity.MarcaId = model.Marca.Id.Value;

            _ctx.Modelos.Update(entity);
            _ctx.SaveChanges();

            return Ok();
        }


        [HttpDelete("{id}")]
        public IActionResult Delete(int id)
        {
            var entity = _ctx.Modelos.FirstOrDefault(x => x.Id == id);

            _ctx.Modelos.Remove(entity);
            _ctx.SaveChanges();

            return Ok();
        }
    }
}
