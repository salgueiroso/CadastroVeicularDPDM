using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace api.model
{
    public class Modelo : IModel
    {
        [Key]
        public int Id { get; set; }
        public string Codigo { get; set; }
        public string Descricao { get; set; }


        [Column("Marca")]
        [ForeignKey("Marca")]
        public int MarcaId { get; set; }
        public virtual Marca Marca { get; set; }
    }

    public class ModeloDTO
    {
        public int? Id { get; set; }
        public string Codigo { get; set; }
        public string Descricao { get; set; }
        public MarcaDTO Marca { get; set; }

        public ModeloDTO() { }
        public ModeloDTO(Modelo entity)
        {
            this.Id = entity.Id;
            this.Codigo = entity.Codigo;
            this.Descricao = entity.Descricao;
            this.Marca = new MarcaDTO(entity.Marca);
        }
    }
}