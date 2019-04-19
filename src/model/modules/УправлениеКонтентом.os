
#Использовать xml-parser
#Использовать semver

// TODO: разобрать модуль на мелкие составляющие.

Функция ПолучитьСодержимоеСтраницыКонтента(Знач ИдентификаторСекции, Знач ИдентификаторСтраницы) Экспорт
	
	Перем Значение;
	
	Заголовок = "";
	ЭтоMD = Ложь;
	
	ИдентификаторСекции = ?(ИдентификаторСекции = Неопределено, "docs", ИдентификаторСекции);
	ИдентификаторСтраницы = ?(ИдентификаторСтраницы = Неопределено, "index", ИдентификаторСтраницы);
	
	Если ИдентификаторСтраницы = "index" И Не ИдентификаторСекции = "dev" И Не ИдентификаторСекции = "syntax" Тогда
		Значение = "index"; 
	Иначе
		
		ЭтоMD = Истина;
		ПутьКФайлу = ПолучитьПутьККонтентуMD(ИдентификаторСекции, ИдентификаторСтраницы);
		//Сообщить("Путь к файлу MD: " + ПутьКФайлу, СтатусСообщения.Важное);
		
		Попытка
			ТекстКонтента = МодульОбщегоНазначения.ПолучитьСодержимоеMDФайла(ПутьКФайлу, КодировкаТекста.UTF8);
			Значение = МодульОбщегоНазначения.ПреобразоватьMDВHTML(ТекстКонтента);
			Заголовок = ПолучитьЗаголовокИзMD(Значение);

			//Сообщить("Заголовок: " + Заголовок, СтатусСообщения.Важное);
		Исключение
			Значение = ""; // пока так
			Заголовок = "";
		КонецПопытки;
		
	КонецЕсли;
	
	Возврат Новый Структура("Заголовок, Значение, ЭтоMD", Заголовок, Значение, ЭтоMD);
	
КонецФункции

Функция ПолучитьЗаголовокИзMD(ТекстКонтента)
	
	Результат = "";
	
	Регулярное = Новый РегулярноеВыражение("\<h1(.*|)\>([^\<]+)\<\/h1\>");
	Регулярное.ИгнорироватьРегистр = Истина;
	Регулярное.Многострочный = Истина;
	
	Совпадения = Регулярное.НайтиСовпадения(ТекстКонтента);
	
	Если Совпадения.Количество() = 0 Тогда
		Возврат Результат;
	КонецЕсли;
	
	ПервыйЭлементСовпадения = Совпадения[0];
	Если ПервыйЭлементСовпадения.Группы.Количество() > 1 Тогда 
		Результат = ПервыйЭлементСовпадения.Группы[ПервыйЭлементСовпадения.Группы.Количество() - 1].Значение;
	Иначе
		Результат = ПервыйЭлементСовпадения.Значение; 
	КонецЕсли;

	Возврат Результат;
	
КонецФункции

Функция ПолучитьПутьККонтентуMD(ИдентификаторСекции, ИдентификаторСтраницы)
	
	Если ИдентификаторСекции = "syntax" И ИдентификаторСтраницы <> "index" Тогда
		Секция = ОбъединитьПути(ИдентификаторСекции, "stdlib");	
	Иначе
		Секция = ИдентификаторСекции;	
	КонецЕсли; 
	
	Каталог = ПолучитьКаталогКонтента();
	Возврат ОбъединитьПути(Каталог, "markdown", Секция, ИдентификаторСтраницы + ".md");
	
КонецФункции

Функция ПолучитьЭкземплярНавигационногоМеню(ИдентификаторСекции) Экспорт
	
	// хранение реализовать через json файл, для удобства редактирования?
	// только будет неудобно получать ссылку на страницу
	
	НавигационноеМеню = Новый НавигационноеМеню();
	НавигационноеМеню.Заголовок = ПолучитьЗаголовокПоИдентификаторуСекции(ИдентификаторСекции);
	
	Если ИдентификаторСекции = Неопределено Тогда
		
		БазовыйURL = "/docs/page/"; 
		
		НавигационноеМеню.ДобавитьНавигационнуюСсылку(
		"install", 
		"Установка и развертывание", 
		"Установка и развертывание", 
		БазовыйURL + "install");	
		
		НавигационноеМеню.ДобавитьНавигационнуюСсылку(
		"running", 
		"Запуск сценариев", 
		"Запуск сценариев", 
		БазовыйURL + "running");
		
		НавигационноеМеню.ДобавитьНавигационнуюСсылку(
		"libraries", 
		"Организация библиотек", 
		"Организация библиотек", 
		БазовыйURL + "libraries");
		
		НавигационноеМеню.ДобавитьНавигационнуюСсылку(
		"http", 
		"HTTP-сервисы (модуль ISAPI)", 
		"HTTP-сервисы (модуль ISAPI)", 
		БазовыйURL + "http");
		
		НавигационноеМеню.ДобавитьНавигационнуюСсылку(
		"annotations", 
		"Аннотации", 
		"Аннотации", 
		БазовыйURL + "annotations");
		
		НавигационноеМеню.ДобавитьНавигационнуюСсылку(
		"snegopat", 
		"Интеграция с проектом ""Снегопат""", 
		"Интеграция с проектом ""Снегопат""", 
		БазовыйURL + "snegopat");
		
		НавигационноеМеню.ДобавитьНавигационнуюСсылку(
		"testing", 
		"Тестирование", 
		"Тестирование", 
		БазовыйURL + "testing");
		
		НавигационноеМеню.ДобавитьНавигационнуюСсылку(
		"examples", 
		"Примеры скриптов", 
		"Примеры скриптов", 
		БазовыйURL + "examples");
		
		НавигационноеМеню.ДобавитьНавигационнуюСсылку(
		"language", 
		"Отличия от платформы 1С", 
		"Отличия от платформы 1С", 
		БазовыйURL + "language");
		
	ИначеЕсли ИдентификаторСекции = "library" Тогда
		
		БазовыйURL = "/library/page/";
		
		НавигационноеМеню.ДобавитьНавигационнуюСсылку(
		"asserts", 
		"asserts", 
		"asserts", 
		БазовыйURL + "asserts");
		
		НавигационноеМеню.ДобавитьНавигационнуюСсылку(
		"cmdline", 
		"cmdline", 
		"cmdline", 
		БазовыйURL + "cmdline");
		
		НавигационноеМеню.ДобавитьНавигационнуюСсылку(
		"gitsync", 
		"gitsync", 
		"gitsync", 
		БазовыйURL + "gitsync");
		
		НавигационноеМеню.ДобавитьНавигационнуюСсылку(
		"logos", 
		"logos", 
		"logos", 
		БазовыйURL + "logos");
		
		НавигационноеМеню.ДобавитьНавигационнуюСсылку(
		"tool1cd", 
		"tool1cd", 
		"tool1cd", 
		БазовыйURL + "tool1cd");
		
		НавигационноеМеню.ДобавитьНавигационнуюСсылку(
		"v8runner", 
		"v8runner", 
		"v8runner", 
		БазовыйURL + "v8runner");
		
	ИначеЕсли ИдентификаторСекции = "dev" Тогда 
		
		БазовыйURL = "/dev/page/";
		
		НавигационноеМеню.ДобавитьНавигационнуюСсылку(
		"getting-started", 
		"С чего начать", 
		"С чего начать", 
		БазовыйURL + "getting-started");
		
		НавигационноеМеню.ДобавитьНавигационнуюСсылку(
		"Как устроен проект", 
		"Как устроен проект", 
		"Как устроен проект", 
		БазовыйURL + "Как устроен проект");
		
		НавигационноеМеню.ДобавитьНавигационнуюСсылку(
		"Как добавить класс", 
		"Как добавить класс", 
		"Как добавить класс", 
		БазовыйURL + "Как добавить класс");
		
		НавигационноеМеню.ДобавитьНавигационнуюСсылку(
		"Глобальный контекст", 
		"Как добавить глобальный контекст", 
		"Как добавить глобальный контекст", 
		БазовыйURL + "Глобальный контекст");
		
		НавигационноеМеню.ДобавитьНавигационнуюСсылку(
		"components", 
		"Как создать внешнюю компоненту", 
		"Как создать внешнюю компоненту", 
		БазовыйURL + "components");
		
		НавигационноеМеню.ДобавитьНавигационнуюСсылку(
		"contribute", 
		"Помощь проекту", 
		"Помощь проекту", 
		БазовыйURL + "contribute");
		
		НавигационноеМеню.ДобавитьНавигационнуюСсылку(
		"sources", 
		"Исходные коды", 
		"Исходные коды", 
		БазовыйURL + "sources");
		
	КонецЕсли;
	
	Возврат НавигационноеМеню;
	
КонецФункции

Функция ПолучитьЗаголовокПоИдентификаторуСекции(ИдентификаторСекции)
	
	Значение = "Оглавление";
	
	Если ИдентификаторСекции = Неопределено Или ИдентификаторСекции = "docs" Тогда
		Значение = "Документация";
	ИначеЕсли ИдентификаторСекции = "library" Тогда	
		Значение = "Библиотеки";
	ИначеЕсли ИдентификаторСекции = "dev" Тогда	
		Значение = "Разработка";
	КонецЕсли;
	
	Возврат Значение;
	
КонецФункции

Функция ПолучитьПараметрыСтраницыКонтента(ИдентификаторСтраницы, ИдентификаторСекции) Экспорт
	
	СодержимоеСтраницы = ПолучитьСодержимоеСтраницыКонтента(ИдентификаторСекции, ИдентификаторСтраницы);
	
	// Через контроллер
	//Если СодержимоеСтраницы.ЭтоMD И СодержимоеСтраницы.Значение = Неопределено Тогда 
	//	Возврат ПеренаправлениеНаДействие("page404", "home");
	//КонецЕсли;
	
	ПараметрыСтраницы = Новый ПараметрыСтраницыКонтекта();
	ПараметрыСтраницы.Заголовок = СодержимоеСтраницы.Заголовок;
	ПараметрыСтраницы.Содержимое = СодержимоеСтраницы.Значение;
	ПараметрыСтраницы.ЭтоMD = СодержимоеСтраницы.ЭтоMD;
	ПараметрыСтраницы.ИдентификаторСекции = ИдентификаторСекции;
	ПараметрыСтраницы.НавигационноеМеню = ПолучитьЭкземплярНавигационногоМеню(ИдентификаторСекции);
	
	Возврат ПараметрыСтраницы;
	
КонецФункции

Функция ПолучитьСписокНовостей() Экспорт
	
	Возврат ПолучитьСписокВерсийПО();
	
КонецФункции

Функция ПолучитьСписокВерсийПО() Экспорт
	
	Путь = ОбъединитьПути(ПолучитьКаталогКонтента(), "news.xml");
	ФайлНовостей = Новый Файл(Путь);
	Если Не ФайлНовостей.Существует() Тогда
		Возврат Новый Массив;
	КонецЕсли;

	Данные = Новый Массив;
	
	ПроцессорXML = Новый СериализацияДанныхXML();
	РезультатЧтения = ПроцессорXML.ПрочитатьИзФайла(Путь);
	
	Для Каждого Узел Из РезультатЧтения["news"] Цикл 
		
		ЗначенияПолей = Узел["item"]._Атрибуты;
		
		СтруктураСтроки = Новый Структура();
		СтруктураСтроки.Вставить("Ссылка", ЗначенияПолей["url"]);
		СтруктураСтроки.Вставить("Заголовок", ЗначенияПолей["title"]);
		СтруктураСтроки.Вставить("ДатаЗаписи", МодульОбщегоНазначения.ПреобразоватьФорматДаты(ЗначенияПолей["date"]));
		
		Данные.Добавить(СтруктураСтроки);
		
	КонецЦикла;
	
	Возврат Данные; 
	
КонецФункции

// так и просится все держать в какой-нибудь бд
Функция ПолучитьСписокСборок() Экспорт
	
	СписокИменИсключений = ПолучитьИменаИсключенияСборокДляОбщегоСписка();
	
	КаталогПоиска = ОбъединитьПути(ПолучитьКаталогКонтента(), "markdown", "archive");
	Файлы = НайтиФайлы(КаталогПоиска, "*.md");
	
	СписокСборок = Новый Массив;
	ВременныйМассив = Новый Массив;
	Соответствие = Новый Соответствие;
	Для Каждого Файл Из Файлы Цикл
		
		ИмяВерсии = Файл.ИмяБезРасширения;
		
		Если СписокИменИсключений.Найти(нРег(ИмяВерсии)) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ЗначениеВФорматеВерсии = СтрЗаменить(ИмяВерсии, "_", ".");
		ВременныйМассив.Добавить(ЗначениеВФорматеВерсии);
		Соответствие.Вставить(ЗначениеВФорматеВерсии, ИмяВерсии);
		
	КонецЦикла;
	
	Версии.СортироватьВерсии(ВременныйМассив, "УБЫВ");
	
	Для Каждого ЭлементМассива Из ВременныйМассив Цикл
		
		ЗначениеИзСоответвия = Соответствие.Получить(ЭлементМассива); 
		
		ТекущаяСборка = Новый Сборка();
		ТекущаяСборка.Ссылка = "/downloads/archive/" + ЗначениеИзСоответвия;
		ТекущаяСборка.Заголовок = ЭлементМассива;	
		
		СписокСборок.Добавить(ТекущаяСборка);	
		
	КонецЦикла;
	
	Возврат СписокСборок;
	
КонецФункции

Функция ПолучитьЗначениеПараметраИзКонфигурации(ИмяПараметра)
	
	// todo: в отдельный класс?
	МенеджерПараметров = Новый МенеджерПараметров();
	МенеджерПараметров.ИспользоватьПровайдерJSON();
	МенеджерПараметров.УстановитьФайлПараметров(ОбъединитьПути(СтартовыйСценарий().Каталог, "config.json"));
	МенеджерПараметров.Прочитать();
	
	РежимЗапуска = МенеджерПараметров.Параметр("РежимЗапуска");
	Значение = МенеджерПараметров.Параметр(РежимЗапуска + "." + ИмяПараметра);
	Возврат Значение;
	
КонецФункции

Функция ПолучитьКаталогКонтента()
	
	Возврат ЗначениеКонфигурацииПриложения(
		"OS_CONTENT_DIRECTORY", 
		"КаталогКонтента", 
		ОбъединитьПути(СтартовыйСценарий().Каталог, "data", "content"));
	
КонецФункции

Функция ПолучитьКаталогСборок() Экспорт
	
	Возврат ЗначениеКонфигурацииПриложения(
		"OS_DOWNLOAD_DIRECTORY", 
		"КаталогКонтента", 
		ОбъединитьПути(СтартовыйСценарий().Каталог, "data", "download"));
	
КонецФункции

Функция ЗначениеКонфигурацииПриложения(ПеременнаяСреды, ИмяПараметраКонфигурации, ДефолтноеЗначение)

	Значение = ПолучитьПеременнуюСреды(ПеременнаяСреды);
	Если Не ЗначениеЗаполнено(Значение) Тогда
		Значение = ПолучитьЗначениеПараметраИзКонфигурации(ИмяПараметраКонфигурации);
		Если Не ЗначениеЗаполнено(Значение) Тогда
			Значение = ДефолтноеЗначение;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Значение;

КонецФункции

Функция ПолучитьСоставСборки(ИмяСборки) Экспорт
	
	Сборка = Новый СоставСборкиПО();
	Сборка.Версия = ИмяСборки;
	
	// проверить есть ли каталог
	ПутьККаталогу = ОбъединитьПути(ПолучитьКаталогСборок(), ИмяСборки);
	Если ФС.КаталогСуществует(ПутьККаталогу) Тогда
		
		Для Каждого ВариантСборки Из Сборка.СписокВаринтовСборки Цикл
			ФайлВариантаСборки = ПолучитьПервыйФайлПоРасширению(ПутьККаталогу, ВариантСборки.Расширение);
			Если ФайлВариантаСборки <> Неопределено Тогда
				//Сообщить("А файл-то не настоящий: " + ФайлВариантаСборки.Имя, СтатусСообщения.Важное);
				Сборка.ДобавитьСтрокуСоставаСборки(
				ФайлВариантаСборки.Имя, 
				Сборка.ПолучитьСсылкуНаФайл(ИмяСборки, ФайлВариантаСборки.Имя), 
				ВариантСборки.Представление, 
				ФайлВариантаСборки.ПолучитьВремяИзменения());	
			КонецЕсли;
			
		КонецЦикла;
		
	Иначе
		//Сообщить("Не сущестует: " + ПутьККаталогу, СтатусСообщения.Важное);
	КонецЕсли;
	
	Возврат Сборка;
	
КонецФункции

Функция ПолучитьПервыйФайлПоРасширению(Каталог, Знач Расширение)
	
	Расширение = ?(Лев(Расширение, 1) = ".", Расширение, "." + Расширение);
	Файлы = НайтиФайлы(ОбъединитьПути(Каталог, ""), "*" + Расширение);
	Возврат ?(Файлы.Количество() > 0, Файлы[0], Неопределено);
	
КонецФункции

Функция ПолучитьПутьКФайлуСборки(Сборка, Идентификатор) Экспорт
	
	Возврат ОбъединитьПути(ПолучитьКаталогСборок(), Сборка, Идентификатор);
	
КонецФункции

Функция ПолучитьИменаИсключенияСборокДляОбщегоСписка()
	
	Результат = Новый Массив;
	Результат.Добавить("latest");
	Результат.Добавить("night-build");
	Возврат Результат;
	
КонецФункции

Процедура ДополнитьПараметрыСтраницыХлебнымиКрошками(ПараметрыСтраницы, Заголовок, Ссылка, ИдентификаторСтраницы) Экспорт

	ЛокальныеПараметры = Новый ЛокальныеПараметрыСтраницы(Заголовок, ИдентификаторСтраницы = Неопределено, Ссылка);
	ПараметрыСтраницы.ЛокальнаяНавигация.Добавить(ЛокальныеПараметры);
	Если ЗначениеЗаполнено(ИдентификаторСтраницы) Тогда		
		ЛокальныеПараметры = Новый ЛокальныеПараметрыСтраницы(
			?(ПустаяСтрока(ПараметрыСтраницы.Заголовок), ИдентификаторСтраницы, ПараметрыСтраницы.Заголовок), 
			Истина);

		ПараметрыСтраницы.ЛокальнаяНавигация.Добавить(ЛокальныеПараметры);
	КонецЕсли;

КонецПроцедуры

Процедура УстановитьЗаголовокСтраницы(Контроллер, Заголовок) Экспорт
	Контроллер.ДанныеПредставления["Title"] = Заголовок;
КонецПроцедуры

Процедура УстановитьПризнакСтраницы(Контроллер, Значение) Экспорт
	Контроллер.ДанныеПредставления["Url"] = Значение;
КонецПроцедуры