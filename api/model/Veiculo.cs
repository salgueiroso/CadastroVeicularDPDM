using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace api.model
{
    public class Veiculo : IModel
    {
        [Key]
        public int Id { get; set; }
        public string Descricao { get; set; }
        public int Ano { get; set; }
        public string Cor { get; set; }


        [Column("Marca")]
        [ForeignKey("Marca")]
        public int MarcaId { get; set; }
        public virtual Marca Marca { get; set; }


        [Column("Modelo")]
        [ForeignKey("Modelo")]
        public int ModeloId { get; set; }
        public virtual Modelo Modelo { get; set; }
    }

    public class VeiculoDTO
    {


        public int? Id { get; set; }
        public string Descricao { get; set; }
        public int Ano { get; set; }
        public string Cor { get; set; }

        public MarcaDTO Marca { get; set; }
        public ModeloDTO Modelo { get; set; }

        public VeiculoDTO() { }
        public VeiculoDTO(Veiculo entity)
        {
            this.Id = entity.Id;
            this.Descricao = entity.Descricao;
            this.Ano = entity.Ano;
            this.Cor = entity.Cor;
            this.Marca = new MarcaDTO(entity.Marca);
            this.Modelo = new ModeloDTO(entity.Modelo);
        }
    }
}