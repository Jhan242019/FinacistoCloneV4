using ClosedXML.Excel;
using DocumentFormat.OpenXml.Drawing.Charts;
using FinancistoCloneV4.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http.Extensions;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Rotativa.AspNetCore;

namespace FinancistoCloneV4.Controllers
{
    public class TransactionController : BaseController
    {
        private readonly FinancistoContext context;

        public TransactionController(FinancistoContext context) : base(context)
        {
            this.context = context;
        }

        public IActionResult Transactions(int cuentaId)
        {
            var transactions = context.Transactions
                .Where(o => o.CuentaId == cuentaId)
                .OrderByDescending(o => o.FechaHora)
                .ToList();

            ViewBag.Account = context.Accounts.First(o => o.Id == cuentaId);

            return View(transactions);
        }
        [HttpGet]
        public IActionResult Transaction_Create(int cuentaId)
        {
            ViewBag.Account = context.Accounts.First(o => o.Id == cuentaId);
            return View(new Transaction());
        }
        [HttpPost]
        public IActionResult Transaction_Create(Transaction transaction)
        {
            ViewBag.Account = context.Accounts.First(o => o.Id == transaction.CuentaId);

            if (transaction.Monto > ViewBag.Account.CreditLimit)
                ModelState.AddModelError("LimiteCredito", "El monto no debe superar el Límite del Saldo");

            if (transaction.Monto <= 0)
                ModelState.AddModelError("Monto1", "Ingrese un valor mayor a 0");

            if (ModelState.IsValid)
            {
                if (transaction.Tipo == "Gasto")
                    transaction.Monto *= -1;

                //Guardar transacción
                context.Transactions.Add(transaction);
                context.SaveChanges();

                // Actualizar saldo de la cuenta
                UpdateAmountAccount(transaction.CuentaId);
                return RedirectToAction("Transactions", new { cuentaId = transaction.CuentaId });
            }

            return View(transaction);
        }

        [HttpGet]
        public IActionResult Transaction_Edit(int id)
        {
            ViewBag.TipoTransaccion = new List<string> { "Gasto", "Ingreso" };

            var transaction = context.Transactions.FirstOrDefault(o => o.Id == id);
            ViewBag.Account = context.Accounts.First(o => o.Id == transaction.CuentaId);

            return View(transaction);
        }
        [HttpPost]
        public IActionResult Transaction_Edit(Transaction transaction)
        {
            if (transaction.Monto <= 0)
                ModelState.AddModelError("Monto1", "Ingrese un valor mayor a 0");

            if (ModelState.IsValid)
            {
                if (transaction.Tipo == "Gasto")
                    transaction.Monto *= -1;

                context.Transactions.Update(transaction);
                context.SaveChanges();

                // Actualizar saldo de la cuenta
                UpdateAmountAccount(transaction.CuentaId);

                return RedirectToAction("Transactions", new { cuentaId = transaction.CuentaId });
            }
            ViewBag.Account = context.Accounts.FirstOrDefault(o => o.Id == transaction.CuentaId);
            return View(transaction);
        }

        //PDF
        public IActionResult PDF(int cuentaId)
        {
            var transactions = context.Transactions
                .Include(o => o.Account)
                .Where(o => o.CuentaId == cuentaId)
                .OrderByDescending(o => o.FechaHora)
                .ToList();

            ViewBag.Account = context.Accounts.FirstOrDefault(o => o.Id == cuentaId);

            //return View("PDF", transactions);
            return new ViewAsPdf("PDF", transactions)
            {
                FileName = $"Transactiones - {ViewBag.Account.Name}.pdf",
                PageOrientation = Rotativa.AspNetCore.Options.Orientation.Portrait,
                PageSize = Rotativa.AspNetCore.Options.Size.A4
            };
        }

        //Reporte en Excel
        public IActionResult ReporteExcel(int cuentaId)
        {

            DataTable tabla_transaction = new DataTable();

            //ViewBag.Account = context.Accounts.FirstOrDefault(o => o.Id == cuentaId);

            //using (var libro = new XLWorkbook()) {
            //    tabla_transaction.TableName = "";
            //    var hoja = libro.Worksheets.Add(tabla_transaction);
            //}

            return View();
        }


        private void UpdateAmountAccount(int cuentaId)
        {
            var account = context.Accounts
                .Include(o => o.Transactions)
                .FirstOrDefault(o => o.Id == cuentaId);

            var total = account.Transactions.Sum(o => o.Monto);
            account.Amount = total;
            context.SaveChanges();
        }
    }
}
