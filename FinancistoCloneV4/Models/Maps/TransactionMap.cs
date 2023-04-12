using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace FinancistoCloneV4.Models.Maps
{
    public class TransactionMap : IEntityTypeConfiguration<Transaction>
    {
        public void Configure(EntityTypeBuilder<Transaction> builder)
        {
            builder.ToTable("Transaction");
            builder.HasKey(x => x.Id);

            builder.HasOne(o => o.Account)
                .WithMany(o => o.Transactions)
                .HasForeignKey(o => o.CuentaId);
        }
    }
}
