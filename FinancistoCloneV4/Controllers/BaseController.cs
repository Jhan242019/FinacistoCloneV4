using FinancistoCloneV4.Models;
using Microsoft.AspNetCore.Mvc;

namespace FinancistoCloneV4.Controllers
{
    public abstract class BaseController : Controller
    {
        private readonly FinancistoContext context;

        public BaseController(FinancistoContext context)
        {
            this.context = context;
        }
        protected User LoggedUser()
        {
            var claim = HttpContext.User.Claims.FirstOrDefault();
            var user = context.Users.Where(o => o.Username == claim.Value).FirstOrDefault();
            return user;
        }
    }
}
