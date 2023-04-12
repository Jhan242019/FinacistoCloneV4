using FinancistoCloneV4.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace FinancistoCloneV4.Controllers
{
    [Authorize]
    public class AccountController : BaseController
    {
        private readonly FinancistoContext _context;
        private readonly IHostEnvironment _hostEnv;
        public AccountController(FinancistoContext context, IHostEnvironment hostEnv) : base(context)
        {
            _context = context;
            _hostEnv = hostEnv;
        }

        [HttpGet]
        public ActionResult Index()
        {
            var accounts = _context.Accounts
                .Where(o => o.UserId == LoggedUser().Id) //para traer las cuentas del usuario logueado
                .Include(o => o.Type)
                .OrderByDescending(o => o.Id)
                .ToList();

            ViewBag.Types = _context.Types.ToList();

            return View("Index", accounts);
        }

        [HttpPost]
        public async Task<ActionResult> Create(Account account, IFormFile image)
        {
            account.UserId = LoggedUser().Id;

            if (account.Name == null)
                ModelState.AddModelError("Name1", "Ingres nombre");

            if (ModelState.IsValid)
            {
                account.ImagePath = SaveImage(image);

                if (account.TypeId == 3)
                {
                    account.CreditLimit = account.Amount;
                    account.Amount = 0;
                }

                if (account.Amount > 0)
                {
                    account.Transactions = new List<Transaction>
                    {
                        new Transaction
                        {
                            FechaHora = DateTime.Now,
                            Tipo = "Ingreso",
                            Monto = account.Amount,
                            Motivo = "Monto Inicial"
                        }
                    };
                }
                await _context.Accounts.AddAsync(account);
                await _context.SaveChangesAsync();

                return RedirectToAction(nameof(Index));
            }
            ViewBag.Types = _context.Types.ToList();
            return View("Create", account);
        }

        [HttpGet]
        public ActionResult Edit(int id)
        {
            ViewBag.Types = _context.Types.ToList();
            var account = _context.Accounts
                .Where(o => o.Id == id)
                .FirstOrDefault();
            return View("Edit", account);
        }

        [HttpPost]
        public ActionResult Edit(Account account, IFormFile image) 
        {
            if (account.Name == null)
                ModelState.AddModelError("Name1","Ingrese Nombre");


            if (ModelState.IsValid)
            {
                account.ImagePath = SaveImage(image);
                account.UserId = LoggedUser().Id;
                _context.Accounts.Update(account);
                _context.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.Types = _context.Types.ToList();
            return View("Edit", account);
        }
        [HttpGet]
        public ActionResult Delete(int id)
        {
            var DBaccount = _context.Accounts.Where(o => o.Id == id).FirstOrDefault();
            _context.Accounts.Remove(DBaccount);
            _context.SaveChanges();
            return RedirectToAction("Index");
        }

        private string SaveImage(IFormFile image)
        {
            if (image != null && image.Length > 0)
            {
                var basePath = _hostEnv.ContentRootPath + @"\wwwroot";
                var ruta = @"\files\" + image.FileName;

                using (var strem = new FileStream(basePath + ruta, FileMode.Create))
                {
                    image.CopyTo(strem);
                    return ruta;
                }
            }

            return "/files/imageAccount.png";
        }
    }
}
