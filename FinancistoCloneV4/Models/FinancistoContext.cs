using FinancistoCloneV4.Models.Maps;
using Microsoft.EntityFrameworkCore;
using System.Security.Principal;

namespace FinancistoCloneV4.Models
{
    public class FinancistoContext: DbContext
    {
        public DbSet<User> Users { get; set; } = null!;
        public DbSet<Types> Types { get; set; } = null!;
        public DbSet<Account> Accounts { get; set; } = null!;
        public DbSet<Transaction> Transactions { get; set; } = null!;

        public FinancistoContext(DbContextOptions<FinancistoContext> options)
            : base(options)
        {
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.ApplyConfiguration(new UserMap());
            modelBuilder.ApplyConfiguration(new TypesMap());
            modelBuilder.ApplyConfiguration(new AccountMap());
            modelBuilder.ApplyConfiguration(new TransactionMap());
        }
    }
}
