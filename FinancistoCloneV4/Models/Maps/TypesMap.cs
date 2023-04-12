using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace FinancistoCloneV4.Models.Maps
{
    public class TypesMap : IEntityTypeConfiguration<Types>
    {
        public void Configure(EntityTypeBuilder<Types> builder)
        {
            builder.ToTable("Types");
            builder.HasKey(x => x.Id);
        }
    }
}
