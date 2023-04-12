using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace FinancistoCloneV4.Models.Maps
{
    public class AccountMap : IEntityTypeConfiguration<Account>
    {
        public void Configure(EntityTypeBuilder<Account> builder)
        {
            builder.ToTable("Account");
            builder.HasKey(o => o.Id);

            builder.HasOne(o => o.Type)
                .WithMany()
                .HasForeignKey(o => o.TypeId);

            builder.HasMany(o => o.Transactions)
                .WithOne()
                .HasForeignKey(o => o.CuentaId);
        }
    }
}
