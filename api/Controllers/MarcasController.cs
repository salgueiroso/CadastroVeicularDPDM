using System.Collections.Generic;
using System.Linq;
using api.model;
using Microsoft.AspNetCore.Mvc;

namespace api.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class MarcasController : ControllerBase
    {
        private readonly ApplicationDbContext _ctx;

        public MarcasController(ApplicationDbContext ctx)
        {
            _ctx = ctx;
        }

        [HttpGet]
        public IActionResult Get()
        {
            var result = _ctx.Marcas
                .OrderBy(x => x.Descricao)
                .ToList()
                .Select(e => new MarcaDTO(e))
                .ToList();
            return Ok(result);
        }


        [HttpGet("{id}")]
        public IActionResult Get(int id)
        {

            var entity = _ctx.Marcas.FirstOrDefault(x => x.Id == id);
            if (entity != null)
                return Ok(new MarcaDTO(entity));
            else
                return NotFound();
        }

        [HttpPost]
        public IActionResult Post([FromBody] MarcaDTO model)
        {
            var esp = _ctx.Marcas.FirstOrDefault(x => x.Id == model.Id);

            var entity = new Marca
            {
                Descricao = model.Descricao,
                Codigo = model.Codigo,
            };

            _ctx.Marcas.Add(entity);
            _ctx.SaveChanges();

            return Ok();
        }

        [HttpPut]
        public IActionResult Put([FromBody] MarcaDTO model)
        {
            var entity = _ctx.Marcas.FirstOrDefault(x => x.Id == model.Id);

            entity.Descricao = model.Descricao;
            entity.Codigo = model.Codigo;

            _ctx.Marcas.Update(entity);
            _ctx.SaveChanges();

            return Ok();
        }


        [HttpDelete("{id}")]
        public IActionResult Delete(int id)
        {
            var entity = _ctx.Marcas.FirstOrDefault(x => x.Id == id);

            _ctx.Marcas.Remove(entity);
            _ctx.SaveChanges();

            return Ok();
        }
    }
}
