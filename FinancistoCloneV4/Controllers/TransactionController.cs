using ClosedXML.Excel;
using DocumentFormat.OpenXml.Drawing.Charts;
using DocumentFormat.OpenXml.Spreadsheet;
using FinancistoCloneV4.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http.Extensions;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Rotativa.AspNetCore;
using SelectPdf;
using System.Diagnostics;
using System.Drawing;

namespace FinancistoCloneV4.Controllers
{
    [Authorize]
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
            if (ModelState.IsValid)
            {
                context.Transactions.Update(transaction);
                context.SaveChanges();

                // Actualizar saldo de la cuenta
                UpdateAmountAccount(transaction.CuentaId);

                return RedirectToAction("Transactions", new { cuentaId = transaction.CuentaId });
            }
            ViewBag.TipoTransaccion = new List<string> { "Gasto", "Ingreso" };
            ViewBag.Account = context.Accounts.FirstOrDefault(o => o.Id == transaction.CuentaId);
            return View(transaction);
        }

        //PDF
        public IActionResult PDF(int cuentaId)
        {
            try
            {
                var transactions = context.Transactions
                    .Include(o => o.Account)
                    .Where(o => o.CuentaId == cuentaId)
                    .OrderByDescending(o => o.FechaHora)
                    .ToList();

                ViewBag.Account = context.Accounts.FirstOrDefault(o => o.Id == cuentaId);

                return new ViewAsPdf("PDF", transactions)
                {
                    //FileName = $"Transactiones - {ViewBag.Account.Name}.pdf",
                    //PageOrientation = Rotativa.AspNetCore.Options.Orientation.Portrait,
                    //PageSize = Rotativa.AspNetCore.Options.Size.A4
                };
            }
            catch (Exception){
                return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
            }
        }

        [HttpGet]
        public IActionResult Transaction_Transferencia(int cuentaId)
        { 
            ViewBag.account = context.Accounts
                .Where(o => o.UserId == LoggedUser().Id)
                .ToList();

            ViewBag.cuentaOrigen = context.Accounts.FirstOrDefault(o => o.Id == cuentaId);

            return View(new Account());
        }

        [HttpPost]
        public IActionResult Transaction_Transferencia(int cuentaOrigen, int cuentaDestino, int monto)
        {
            ViewBag.account = context.Accounts
                .Where(o => o.UserId == LoggedUser().Id)
                .ToList();

            ViewBag.cuentaOrigen = context.Accounts.FirstOrDefault(o => o.Id == cuentaOrigen);

            var transactionOrigen = new Transaction
            {
                CuentaId = cuentaOrigen,
                Tipo = "Gasto",
                FechaHora = DateTime.Now,
                Motivo = "Transferencia",
                Monto = monto * -1
            };

            var transactionDestino = new Transaction
            {
                CuentaId = cuentaDestino,
                Tipo = "Ingreso",
                FechaHora = DateTime.Now,
                Motivo = "Transferencia",
                Monto = monto
            };

            if (cuentaOrigen == cuentaDestino)
                ModelState.AddModelError("cuentaIgual","No puede seleccionar las mismas cuentas");

            if (monto < 1)
                ModelState.AddModelError("monto", "Ingrese un monto mayor o igual que S/. 1.00");

            if (ModelState.IsValid)
            {
                context.Transactions.Add(transactionOrigen);
                context.Transactions.Add(transactionDestino);

                context.SaveChanges();

                UpdateAmountAccount(cuentaOrigen);
                UpdateAmountAccount(cuentaDestino);

            return RedirectToAction("Transactions", new { cuentaId = transactionOrigen.CuentaId });
            }
            return View();
        }

        //Reporte en Excel
        public IActionResult ReporteExcel(int cuentaId)
        {
            try
            {
                var transactions = context.Transactions
                .Include(o => o.Account)
                .Where(o => o.CuentaId == cuentaId)
                .OrderByDescending(o => o.FechaHora)
                .ToList();

                var acc = context.Accounts.FirstOrDefault(o => o.Id == cuentaId);

                using (var worklibro = new XLWorkbook())
                {
                    //Generamos la hoja
                    var workhoja = worklibro.Worksheets.Add("Transacciones");
                    var currenRow = 3;
                    var currenCol = transactions.Count(o => o.CuentaId == cuentaId) + 4;

                    #region Header
                    //Generamos la cabecera
                    workhoja.Cell(1, 3).Value = "Cuenta " + acc.Name;
                    workhoja.Cell(1, 3).Style.Font.FontSize = 20;
                    workhoja.Cell(1, 3).Style.Fill.BackgroundColor = XLColor.AppleGreen;

                    workhoja.Cell(currenRow, 1).Value = "N°";
                    workhoja.Cell(currenRow, 2).Value = "Tipo";
                    workhoja.Cell(currenRow, 3).Value = "FechaHora";
                    workhoja.Cell(currenRow, 4).Value = "Motivo";
                    workhoja.Cell(currenRow, 5).Value = "Monto";
                    workhoja.Cell(currenCol, 4).Value = "TOTAL:";
                    workhoja.Cell(currenCol, 4).Style.Border.SetOutsideBorder(XLBorderStyleValues.Medium);
                    workhoja.Cell(currenCol, 4).Style.Font.FontSize = 14; //Indicamos el tamaño de la fuente
                    workhoja.Cell(currenCol, 4).Style.Fill.BackgroundColor = XLColor.AppleGreen;

                    //-----------Le damos el formato a la cabecera----------------
                    var rango = workhoja.Range("A3:E3"); //Seleccionamos un rango
                    rango.Style.Border.SetOutsideBorder(XLBorderStyleValues.Medium); //Generamos las lineas exteriores
                    rango.Style.Border.SetInsideBorder(XLBorderStyleValues.Medium); //Generamos las lineas interiores
                    rango.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center; //Alineamos horizontalmente
                    rango.Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;  //Alineamos verticalmente
                    rango.Style.Font.FontSize = 14; //Indicamos el tamaño de la fuente
                    rango.Style.Fill.BackgroundColor = XLColor.AppleGreen; //Indicamos el color de background

                    #endregion

                    #region Body
                    foreach (var transaction in transactions)
                    {
                        currenRow++;
                        workhoja.Cell(currenRow, 1).Value = currenRow - 3;
                        workhoja.Cell(currenRow, 1).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                        workhoja.Cell(currenRow, 2).Value = transaction.Tipo;
                        workhoja.Cell(currenRow, 3).Value = transaction.FechaHora.ToString("dddd dd MMM yyyy - hh:mm tt");
                        workhoja.Cell(currenRow, 4).Value = transaction.Motivo;
                        workhoja.Cell(currenRow, 5).Value = transaction.Monto;
                        workhoja.Columns(1, 5).AdjustToContents();
                    }
                    workhoja.Cell(currenCol, 5).Value = transactions.Sum(o => o.Monto);
                    workhoja.Cell(currenCol, 5).Style.Border.SetOutsideBorder(XLBorderStyleValues.Medium);
                    workhoja.Cell(currenCol, 5).Style.Font.FontSize = 14;

                    #endregion

                    using (var stream = new MemoryStream())
                    {
                        worklibro.SaveAs(stream);
                        var content = stream.ToArray();

                        return File(
                            content,
                            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                            "Transacciones de " + acc.Name + ".xlsx"
                            );
                    }
                }
            }
            catch (Exception)
            {
                return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
            } 
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
