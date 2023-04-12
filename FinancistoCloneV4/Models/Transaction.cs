using System.ComponentModel.DataAnnotations;

namespace FinancistoCloneV4.Models
{
    public class Transaction
    {
        public int Id { get; set; }
        public int CuentaId { get; set; }
        [Required(ErrorMessage = "Seleccione un tipo")]
        public string Tipo { get; set; }
        public DateTime FechaHora { get; set; }
        [Required(ErrorMessage = "El motivo es Obligatorio")]
        public string Motivo { get; set; }
        public decimal Monto { get; set; }

        public Account Account { get; set; }
    }
}
