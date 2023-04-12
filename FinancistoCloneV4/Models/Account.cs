using Microsoft.Build.Framework;
using Microsoft.Extensions.Localization;
using System.ComponentModel;

namespace FinancistoCloneV4.Models
{
    public class Account
    {
        public int Id { get; set; }
        [Required]
        public int TypeId { get; set; }
        [Required]
        public string Name { get; set; }
        public string Currency { get; set; }
        [Required]
        public decimal Amount { get; set; }
        public string ImagePath { get; set; }
        public int UserId { get; set; }
        public decimal? CreditLimit { get; set; }

        //Relaciones
        public Types Type { get; set; }
        public List<Transaction> Transactions { get; set; }
    }
}
