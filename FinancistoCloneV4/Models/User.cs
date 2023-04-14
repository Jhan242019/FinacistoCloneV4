using System.ComponentModel.DataAnnotations;

namespace FinancistoCloneV4.Models
{
    public class User
    {
        public int Id { get; set; }
        [Required(ErrorMessage ="Nombre de Usuario es Obligatorio")]
        public string Username { get; set; }
        [Required(ErrorMessage ="Contraseña es Obligatorio")]
        public string Password { get; set; }
    }
}
