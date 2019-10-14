
1000 руб скидки на курс по C#
Professor Web
C# 5.0 и .NET 4.5 
WPF 
Темы WPF 
Silverlight 5
Работа с БД 
LINQ 
ASP.NET 
Windows 8/10 
Программы 
Загрузка изображений из базы данных
ASP.NET --- Интернет магазин --- Загрузка изображений из базы данных

Исходный код проекта
В завершение пользовательского интерфейса приложения GameStore мы добавим несколько более сложную функциональность: мы позволим администратору загружать изображения товаров и сохранять их в базе данных, чтобы впоследствии они отображались в каталоге товаров. Сама по себе эта возможность не является особо интересной или полезной, однако она позволит продемонстрировать ряд важных функциональных средств MVC Framework.

Расширение базы данных
Откройте окно Server Explorer в среде Visual Studio и перейдите к таблице Games базы данных, созданной ранее. Может понадобиться изменить имя подключения к данным на EFDbContext, которое представляет собой имя, назначенное подключению в файле Web.config. Среда Visual Studio несколько непоследовательна в отношении переименования подключения, поэтому вы вполне можете увидеть исходное имя, которое отображалось при создании подключения.

Исходная база данных GameStore
Щелкните правой кнопкой мыши на таблице Games и выберите в контекстном меню пункт New Query (Новый запрос) и введите в текстовой области следующий оператор SQL:

ALTER TABLE Games 
	ADD
		ImageData		VARBINARY(MAX)	NULL,
		ImageMimeType	VARCHAR(50)		NULL
Щелкните на кнопке Execute (Выполнить), помеченной с помощью стрелки, в левом верхнем углу окна и Visual Studio обновит базу данных, добавив два новых столбца в таблицу. Чтобы протестировать обновление, щелкните правой кнопкой на таблице Games в окне Server Explorer и выберите в контекстном меню пункт Open Table Definition (Открыть определение таблицы). Вы увидите, что теперь присутствуют столбцы с именами ImageData и ImageMimeType, как показано на рисунке ниже:


 

 
Добавление столбцов в таблицу Games
Если столбцы не видны, закройте окно визуального конструктора, щелкните правой кнопкой на подключении к данным в окне Server Explorer и выберите в контекстном меню пункт Refresh (Обновить). Теперь после выбора пункта Open Table Definition в контекстном меню новые столбцы должны быть видны.

Расширение модели предметной области
В класс Game проекта GameStore.Domain необходимо добавить два поля, соответствующие столбцам, которые были добавлены в таблицу базы данных:

using System.Web.Mvc;
using System.ComponentModel.DataAnnotations;

namespace GameStore.Domain.Entities
{
    public class Game
    {
        // ...

        public byte[] ImageData { get; set; }
        public string ImageMimeType { get; set; }
    }
}
Удостоверьтесь, что имена свойств, добавленных в класс Game, в точности совпадают с именами новых столбцов в таблице базы данных.

Создание элементов пользовательского интерфейса для загрузки
Следующий шаг заключается в добавлении поддержки для обработки загрузок файлов. Это предусматривает создание пользовательского интерфейса, с помощью которого администратор сможет загружать изображение. Измените представление Views/Admin/Edit.cshtml так, чтобы оно соответствовало примеру:

@model GameStore.Domain.Entities.Game

@{
    ViewBag.Title = "Админ панель: редактирование товара";
    Layout = "~/Views/Shared/_AdminLayout.cshtml";
}

<div class="panel">
    <div class="panel-heading">
        <h3>Редактирование игры «@Model.Name»</h3>
    </div>

    @using (Html.BeginForm("Edit", "Admin",
        FormMethod.Post, new { enctype = "multipart/form-data" }))
    {
        <div class="panel-body">
            @Html.HiddenFor(m => m.GameId)
            @foreach (var property in ViewData.ModelMetadata.Properties)
            {
                switch (property.PropertyName) {
                    case "GameId":
                    case "ImageData":
                    case "ImageMimeType":
                        // Ничего не делать
                        break;
                    default:
                        <div class="form-group">
                        <label>@(property.DisplayName ?? property.PropertyName)</label>
                            @if (property.PropertyName == "Description")
                            {
                                @Html.TextArea(property.PropertyName, null,
                                    new { @class = "form-control", rows = 5 })
                            }
                            else
                            {
                                @Html.TextBox(property.PropertyName, null,
                                    new { @class = "form-control" })
                            }
                            @Html.ValidationMessage(property.PropertyName)
                        </div>
                        break;
                }
            }
            <div class="form-group">
                <div style="position:relative;">
                    <label>Картинка</label>
                    <a class='btn' href='javascript:;'>
                        Выберите файл...
                        <input type="file" name="Image" size="40"
                               style="position:absolute;z-index:2;top:0;
                                left:0;filter: alpha(opacity=0); opacity:0;
                                background-color:transparent;color:transparent;"
                               onchange='$("#upload-file-info").html($(this).val());'>
                    </a>
                    <span class='label label-info' id="upload-file-info"></span>
                </div>
                @if (Model.ImageData == null)
                {
                    <div class="form-control-static">Нет картинки</div>
                }
                else
                {
                    <img class="img-thumbnail" width="150" height="150"
                         src="@Url.Action("GetImage", "Game",
                        new { Model.GameId })" />
                }
            </div>
        </div>
        <div class="panel-footer">
            <input type="submit" value="Сохранить" class="btn btn-primary" />
            @Html.ActionLink("Отменить изменения и вернуться к списку", "Index", null, new
            {
                @class = "btn btn-default"
            })
        </div>
    }
</div>
Возможно, вы уже знаете, что веб-браузеры будут корректно загружать файлы, только если в HTML-элементе <form> для значения атрибута enctype указано multipart-form-data. Другими словами, для успешной загрузки элемент <form> должен выглядеть следующим образом:

<form action="/Admin/Edit" enctype="multipart/form-data" method="post">
Без атрибута enctype браузер будет передавать только имя файла, но не его содержимое, что совершенно не подходит для наших целей. Чтобы обеспечить наличие атрибута enctype, необходимо использовать перегруженную версию вспомогательного метода Html.BeginForm(), которая позволяет указывать атрибуты HTML-элемента <form>:

@using (Html.BeginForm("Edit", "Admin",
    FormMethod.Post, new { enctype = "multipart/form-data" }))
В представление были внесены еще два изменения. Первое - было заменено Razor-выражение if, применяемое при генерации элементов <input> с помощью оператора <switch>. Результат остался прежним, но это выражение позволяет более точно указать свойства модели, которые должны быть пропущены, к тому же нежелательно отображать пользователю свойства, относящиеся к изображению.

Второе изменение связано с добавлением элемента <input>, атрибут type которого установлен в file, чтобы предоставить возможность загрузки файлов, наряду с элементом <img>, который предназначен для вывода изображения, связанного с товаром, если оно присутствует в базе данных.

Запутанная смесь встроенных стилей CSS и кода JavaScript решает один недостаток библиотеки Bootstrap: она стилизует элементы <input> типа file неподходящим образом. Доступно несколько расширений, добавляющих недостающую функциональность, но мы предпочли решение, показанное в примере выше, поскольку оно является самодостаточным и надежным. Оно не изменяет манеру функционирования MVC Framework, а только способ стилизации элементов в файле Edit.cshtml.

Сохранение изображений в базе данных
Мы должны расширить версию POST метода действия Edit() в контроллере Admin, чтобы принимать загруженные данные изображения и сохранять их в базе данных. Необходимые изменения приведены в примере ниже:

// ...
using System.Web;

namespace GameStore.WebUI.Controllers
{
    [Authorize]
    public class AdminController : Controller
    {
        // ...

        [HttpPost]
        public ActionResult Edit(Game game, HttpPostedFileBase image = null)
        {
            if (ModelState.IsValid)
            {
                if (image != null)
                {
                    game.ImageMimeType = image.ContentType;
                    game.ImageData = new byte[image.ContentLength];
                    image.InputStream.Read(game.ImageData, 0, image.ContentLength);
                }
                repository.SaveGame(game);
                TempData["message"] = string.Format("Изменения в игре \"{0}\" были сохранены", game.Name);
                return RedirectToAction("Index");
            }
            else
            {
                // Что-то не так со значениями данных
                return View(game);
            }
        }

        // ...
	}
}
К методу Edit() был добавлен новый параметр, который MVC Framework использует для передачи данных загруженного файла методу действия. Мы проверяем значение этого параметра на предмет равенства null, и если он не равен null, то копируем данные и тип MIME из параметра в объект Game, что в результате приводит к сохранению сведений в базе данных. Кроме того, необходимо обновить код класса EFGameRepository в проекте GameStore.Domain, обеспечив сохранение в базе данных значений, которые были присвоены свойствам ImageData и ImageMimeType. Требуемые изменения в методе SaveGame() показаны в примере ниже:

using System.Collections.Generic;
using GameStore.Domain.Entities;
using GameStore.Domain.Abstract;

namespace GameStore.Domain.Concrete
{
    public class EFGameRepository : IGameRepository
    {
        // ...

        public void SaveGame(Game game)
        {
            if (game.GameId == 0)
                context.Games.Add(game);
            else
            {
                Game dbEntry = context.Games.Find(game.GameId);
                if (dbEntry != null)
                {
                    dbEntry.Name = game.Name;
                    dbEntry.Description = game.Description;
                    dbEntry.Price = game.Price;
                    dbEntry.Category = game.Category;
                    dbEntry.ImageData = game.ImageData;
                    dbEntry.ImageMimeType = game.ImageMimeType;
                }
            }
            context.SaveChanges();
        }

        // ...
    }
}
Реализация метода действия GetImage()
В примере представления Edit.cshtml выше, был добавлен элемент <img>, содержимое которого получается через метод действия GetImage() контроллера Game. Мы собираемся реализовать этот метод действия так, чтобы иметь возможность показывать изображения, содержащиеся в базе данных. В примере ниже приведено определение упомянутого метода действия:

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using GameStore.Domain.Abstract;
using GameStore.Domain.Entities;
using GameStore.WebUI.Models;

namespace GameStore.WebUI.Controllers
{
    public class GameController : Controller
    {
        // ...

        public FileContentResult GetImage(int gameId)
        {
            Game game = repository.Games
                .FirstOrDefault(g => g.GameId == gameId);

            if (game != null)
            {
                return File(game.ImageData, game.ImageMimeType);
            }
            else
            {
                return null;
            }
        }
	}
}
Этот метод пытается найти товар с идентификатором, значение которого указано в параметре. Класс FileContentResult применяется в качестве результата метода действия, когда нужно возвратить файл клиентскому браузеру, а экземпляры создаются с использованием метода File() базового класса контроллера.

Модульное тестирование: извлечение изображений

Мы должны удостовериться в том, что метод GetImage() возвращает корректный тип MIME из хранилища, и что никакие данные не возвращаются, если запрошенный идентификатор товара не существует. Ниже показаны необходимые тестовые методы, которые определены в новом файле модульных тестов по имени ImageTests.cs.

using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using GameStore.Domain.Abstract;
using GameStore.Domain.Entities;
using GameStore.WebUI.Controllers;
using System.Linq;
using System.Web.Mvc;
using System.Collections.Generic;

namespace GameStore.UnitTests
{
    [TestClass]
    public class ImageTests
    {
        [TestMethod]
        public void Can_Retrieve_Image_Data()
        {
            // Организация - создание объекта Game с данными изображения
            Game game = new Game
            {
                GameId = 2,
                Name = "Игра2",
                ImageData = new byte[] { },
                ImageMimeType = "image/png"
            };

            // Организация - создание имитированного хранилища
            Mock<IGameRepository> mock = new Mock<IGameRepository>();
            mock.Setup(m => m.Games).Returns(new List<Game> {
                new Game {GameId = 1, Name = "Игра1"},
                game,
                new Game {GameId = 3, Name = "Игра3"}
            }.AsQueryable());

            // Организация - создание контроллера
            GameController controller = new GameController(mock.Object);

            // Действие - вызов метода действия GetImage()
            ActionResult result = controller.GetImage(2);

            // Утверждение
            Assert.IsNotNull(result);
            Assert.IsInstanceOfType(result, typeof(FileResult));
            Assert.AreEqual(game.ImageMimeType, ((FileResult)result).ContentType);
        }

        [TestMethod]
        public void Cannot_Retrieve_Image_Data_For_Invalid_ID()
        {
            // Организация - создание имитированного хранилища
            Mock<IGameRepository> mock = new Mock<IGameRepository>();
            mock.Setup(m => m.Games).Returns(new List<Game> {
                new Game {GameId = 1, Name = "Игра1"},
                new Game {GameId = 2, Name = "Игра2"}
            }.AsQueryable());

            // Организация - создание контроллера
            GameController controller = new GameController(mock.Object);

            // Действие - вызов метода действия GetImage()
            ActionResult result = controller.GetImage(10);

            // Утверждение
            Assert.IsNull(result);
        }
    }
}
Когда мы имеем дело с допустимым идентификатором товара, мы проверяем получение результата FileResult из метода действия и соответствие типа содержимого типу имитированных данных. Класс FileResult не позволяет иметь доступ к двоичному содержимому файла, поэтому придется довольствоваться таким недостаточно надежным тестом. В случае запроса недопустимого идентификатора товара мы просто проверяем, что результатом является null.

Теперь администратор может загружать изображения для товаров. Можете проверить это, запустив приложение, перейдя на URL вида /Admin/Index и отредактировав данные одного из товаров. На рисунке показан пример.

Добавление изображения из базы данных к сведениям о товаре
Вывод изображений товаров
Осталось только вывести изображения рядом с описаниями товаров в каталоге. Отредактируйте представление Views/Shared/GameSummary.cshtml с учетом изменений:

@model GameStore.Domain.Entities.Game

<div class="well">
    @if (Model.ImageData != null)
    {
        <div class="pull-left" style="margin-right: 10px">
            <img class="img-thumbnail" width="75" height="75"
                 src="@Url.Action("GetImage", "Game",
                new { Model.GameId })" />
        </div>
    }

    <h3>
        <strong>@Model.Name</strong>
        <span class="pull-right label label-primary">@Model.Price.ToString("# руб")</span>
    </h3>
    @using (Html.BeginForm("AddToCart", "Cart"))
    {
        <div class="pull-right">
            @Html.HiddenFor(x => x.GameId)
            @Html.Hidden("returnUrl", Request.Url.PathAndQuery)
            <input type="submit" class="btn btn-success" value="Добавить в корзину" />
        </div>
    }
    <span class="lead">@Model.Description</span>
</div>
После внесения всех изменений пользователи при просмотре каталога смогут видеть изображения, выводимые как часть описания товара:

Пример вывода изображений из базы данных в приложении ASP.NET MVC 5
Разместить вакансию
Пройди тесты 
C# тест (легкий)
 
.NET тест (средний)
 
Лучший чат для C# программистов
Professor Web
Наш любимый хостинг
