using System;
using System.ComponentModel.DataAnnotations;

namespace api.model
{
    public class Marca : IModel
    {
        [Key]
        public int Id { get; set; }
        public string Codigo { get; set; }
        public string Descricao { get; set; }
    }

    public class MarcaDTO
    {
        public int? Id { get; set; }
        public string Codigo { get; set; }
        public string Descricao { get; set; }

        public MarcaDTO() { }
        public MarcaDTO(Marca entity)
        {
            this.Id = entity.Id;
            this.Codigo = entity.Codigo;
            this.Descricao = entity.Descricao;
        }
    }
}