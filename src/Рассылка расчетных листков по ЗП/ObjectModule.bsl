﻿Перем НП Экспорт;  				  // Настройка периода
Перем ДокументРезультат;
Перем ПутьКВремФайлу;


Функция ПолучитьИнтернетПочтовыйПрофиль(УчетнаяЗаписьПочты)

	Профиль = Новый ИнтернетПочтовыйПрофиль;
	
	Профиль.АдресСервераSMTP = УчетнаяЗаписьПочты.SMTPСервер;
	Профиль.ПортSMTP = УчетнаяЗаписьПочты.ПортSMTP;
	
	Если УчетнаяЗаписьПочты.ТребуетсяSMTPАутентификация Тогда
		Профиль.АутентификацияSMTP = СпособSMTPАутентификации.ПоУмолчанию;
		Профиль.ПарольSMTP = УчетнаяЗаписьПочты.ПарольSMTP;
		Профиль.ПользовательSMTP = УчетнаяЗаписьПочты.ЛогинSMTP;
	Иначе
		Профиль.АутентификацияSMTP = СпособSMTPАутентификации.БезАутентификации;
		Профиль.ПарольSMTP = "";
		Профиль.ПользовательSMTP = "";
	КонецЕсли; 
	
	//Если ВремяОжиданияСервера > 0 Тогда
	//	Профиль.ВремяОжидания = УчетнаяЗаписьПочты.ВремяОжиданияСервера;
	//КонецЕсли; 
	
	//Профиль.АдресСервераPOP3 = УчетнаяЗаписьПочты.POP3Сервер;
	//Профиль.ПортPOP3 = УчетнаяЗаписьПочты.ПортPOP3;
	//Профиль.Пользователь = УчетнаяЗаписьПочты.Логин;
	//Профиль.Пароль = УчетнаяЗаписьПочты.Пароль;
	
	Возврат Профиль;

КонецФункции // ПолучитьИнтернетПочтовыйПрофиль()

Процедура ОтправитьСообщение(СтруктураПолучателя)
	
	//CDO_СерверSMTP=?(СтруктураПараметров.Свойство("CDO_СерверSMTP"),СтруктураПараметров.CDO_СерверSMTP,"");
	//Аутентификация=?(СтруктураПараметров.Свойство("Аутентификация"),СтруктураПараметров.Аутентификация,0);
	//CDO_ПользовательSMTP=?(СтруктураПараметров.Свойство("CDO_ПользовательSMTP"),СтруктураПараметров.CDO_ПользовательSMTP,"");
	//CDO_ПарольSMTP=?(СтруктураПараметров.Свойство("CDO_ПарольSMTP"),СтруктураПараметров.CDO_ПарольSMTP,"");
	//CDO_ПортSMTP=?(СтруктураПараметров.Свойство("CDO_ПортSMTP"),СтруктураПараметров.CDO_ПортSMTP,25);
	//Отправитель=?(СтруктураПараметров.Свойство("Отправитель"),СтруктураПараметров.Отправитель,"");
	
	
	Письмо = Новый COMОбъект("CDO.Message");
	Письмо.to 		= СтруктураПолучателя.Кому;
	Письмо.from 	= СтруктураПолучателя.Отправитель;
	Письмо.cc 		= СтруктураПолучателя.Копия;
	Письмо.bcc 		= СтруктураПолучателя.СкрКопия;
	
	МассивВложения 	= МассивИзСтроки(СтруктураПолучателя.Вложения,";");
	Для Каждого Элемент Из МассивВложения Цикл
		Письмо.AddAttachment(Элемент);
	КонецЦикла;
	
	Письмо.Subject = СтруктураПолучателя.Тема;
	Письмо.TextBody = СтруктураПолучателя.Текст;
	
	Письмо.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing").Value			= 2;
	Письмо.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver").Value			= CDO_СерверSMTP;
	Письмо.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate").Value	= Аутентификация;
	Письмо.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusername").Value		= CDO_ПользовательSMTP;
	Письмо.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendpassword").Value		= CDO_ПарольSMTP;
	Письмо.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport").Value		= CDO_ПортSMTP;
	Письмо.Configuration.Fields.Update();
	Письмо.Send();
	
КонецПроцедуры

Процедура Отправить(Стр, ТабличныеДокументы) Экспорт 
	
	Отказ = Ложь;
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	Если Стр.Адрес = "" Тогда 
		Сообщить("У сотрудника " + Стр.Физлицо + " не обнаружен e-mail (основной) для отправки сообщения.");
	Иначе
		ПодготовитьИОтправитьДанные(Стр.Физлицо, Стр.Адрес, Организация, ТабличныйДокумент, Отказ);
		Если Отказ Тогда
			Сообщить("Для " +  Стр.Физлицо+" расчетный лист не отправлен.");
			Возврат;
		КонецЕсли;
		ТабличныеДокументы.Добавить(ТабличныйДокумент, Стр.Адрес);
	КонецЕсли;  		
	
КонецПроцедуры

Процедура ПодготовитьИОтправитьДанные(ТекРаботник, ТекАдрес, Организация, ТабличныйДокумент, Отказ) Экспорт 
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	Отчет = Отчеты.АнализНачисленийИУдержаний.Создать();

	Отчет.КомпоновщикНастроек.ЗагрузитьНастройки(Отчет.СхемаКомпоновкиДанных.ВариантыНастроек.РасчетныйЛисток.Настройки);
	
	ЭлементОтбора = Отчет.КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Сотрудник"); 
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно; 
	ЭлементОтбора.ПравоеЗначение = ТекРаботник; 
	ЭлементОтбора.Использование = Истина;   
	
	Настройки = Отчет.КомпоновщикНастроек.ПолучитьНастройки();
	
	Для Каждого ЭлементНастроек из Настройки.Отбор.Элементы Цикл 
		Если ЭлементНастроек.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ФизическоеЛицо") Тогда 
			ЭлементНастроек.Использование = Истина;
			ЭлементНастроек.ПравоеЗначение = ТекРаботник.ФизическоеЛицо;
			ЭлементНастроек.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		КонецЕсли;
	КонецЦикла;
		
	// проверим заполнение настроек отчета
	ОтборНайден = Ложь;
	Для Каждого ЭлементНастроек из Настройки.Отбор.Элементы Цикл 
		Если ЭлементНастроек.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Сотрудник") Тогда 
			ОтборСотрудникаНайден = Истина;
			Если ЭлементНастроек.ПравоеЗначение = Неопределено  ИЛИ Не ЗначениеЗаполнено(ЭлементНастроек.ПравоеЗначение) ИЛИ Не ЭлементНастроек.ПравоеЗначение = ТекРаботник Тогда 
				Отказ = Истина;
				Возврат;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если Не ОтборСотрудникаНайден Тогда 
		Отказ=Истина;
		Возврат;
	КонецЕсли;

	
	ПериодСКД = Настройки.ПараметрыДанных.Элементы.Найти("Период");
	ПериодСКД.Значение = Период;	
	ПериодСКД.Использование = Истина;

	Отчет.КомпоновщикНастроек.ЗагрузитьНастройки(Настройки); 		
	Отчет.СкомпоноватьРезультат(ТабличныйДокумент);
	
КонецПроцедуры

Функция ПолучитьАдресЭлектроннойПочты(ТекРаботник) Экспорт
	
	Адрес = "";
	
	Запрос = Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ ПЕРВЫЕ 1
	             |	КонтактнаяИнформация.Представление
	             |ИЗ
	             |	РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
	             |ГДЕ
	             |	КонтактнаяИнформация.Объект.Ссылка = &Объект
	             |	И КонтактнаяИнформация.Тип.Ссылка = &Тип
				 |	И КонтактнаяИнформация.ЗначениеПоУмолчанию";
				 
	Запрос.УстановитьПараметр("Объект", ТекРаботник);
	Запрос.УстановитьПараметр("Тип", Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты);
	
	Результат = Запрос.Выполнить().Выбрать();
	Если Результат.Следующий() Тогда
		Адрес = Результат.Представление;
	КонецЕсли;
	
	Если Адрес = "" Тогда
		Запрос = Новый Запрос;
		Запрос.Текст="ВЫБРАТЬ ПЕРВЫЕ 1
		|	КонтактнаяИнформация.Представление
		|ИЗ
		|	РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
		|ГДЕ
		|	КонтактнаяИнформация.Объект.Ссылка = &Объект
		|	И КонтактнаяИнформация.Тип.Ссылка = &Тип";
		
		Запрос.УстановитьПараметр("Объект", ТекРаботник);
		Запрос.УстановитьПараметр("Тип", Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты);
		
		Результат = Запрос.Выполнить().Выбрать();
		Если Результат.Следующий() Тогда
			Адрес = Результат.Представление;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Адрес;
КонецФункции

Функция МассивИзСтроки(Знач Строка,Разделитель)
	Массив=Новый Массив;
	МнСтр=СтрЗаменить(Строка,Разделитель,Символы.ПС);
	Для н=1 По СтрЧислоСтрок(МнСтр) Цикл
		Массив.Добавить(СтрПолучитьСтроку(МнСтр,н));	
	КонецЦикла;
	Возврат Массив;
КонецФункции

/////////////////////////////////////////////////////////////////////////////
// ОПИСАНИЕ ИНТЕРФЕЙСОВ

// Интерфейс для регистрации обработки.
// Вызывается при добавлении обработки в справочник "ВнешниеОбработки"
//
// Возвращаемое значение:
// Структура:
// Вид - строка - возможные значения:	"ДополнительнаяОбработка"
//										"ДополнительныйОтчет"
//										"ЗаполнениеОбъекта"
//										"Отчет"
//										"ПечатнаяФорма"
//										"СозданиеСвязанныхОбъектов"
//
// Назначение - массив строк имен объектов метаданных в формате:
//			<ИмяКлассаОбъектаМетаданного>.[ * | <ИмяОбъектаМетаданных>]
//			Например, "Документ.СчетЗаказ" или "Справочник.*"
//			Прим. параметр имеет смысл только для назначаемых обработок
//
// Наименование - строка - наименование обработки, которым будет заполнено
//						наименование справочника по умолчанию - краткая строка для
//						идентификации обработки администратором
//
// Версия - строка - версия обработки в формате <старший номер>.<младший номер>
//					используется при загрузке обработок в информационную базу
// БезопасныйРежим – Булево – Если истина, обработка будет запущена в безопасном режиме.
//							Более подбробная информация в справке.
//
// Информация - Строка- краткая информация по обработке, описание обработки
//
// Команды - ТаблицаЗначений - команды, поставляемые обработкой, одная строка таблицы соотвествует
//							одной команде
//				колонки: 
//				 - Представление - строка - представление команды конечному пользователю
//				 - Идентификатор - строка - идентефикатор команды. В случае печатных форм
//											перечисление через запятую списка макетов
//				 - Использование - строка - варианты запуска обработки:
//						"ОткрытиеФормы" - открыть форму обработки
//						"ВызовКлиентскогоМетода" - вызов клиентского экспортного метода из формы обработки
//						"ВызовСерверногоМетода" - вызов серверного экспортного метода из модуля объекта обработки
//				 - ПоказыватьОповещение – Булево – если Истина, требуется оказывать оповещение при начале
//								и при окончании запуска обработки. Прим. Имеет смысл только
//								при запуске обработки без открытия формы.
//				 - Модификатор – строка - для печатных форм MXL, которые требуется
//										отображать в форме ПечатьДокументов подсистемы Печать
//										требуется установить как "ПечатьMXL"
//
Функция СведенияОВнешнейОбработке() Экспорт
	
	ПараметрыРегистрации = Новый Структура;
	
	ПараметрыРегистрации.Вставить("Вид", "ДополнительнаяОбработка");
	ПараметрыРегистрации.Вставить("Назначение", Неопределено);
	ПараметрыРегистрации.Вставить("Наименование", НСтр("ru = 'Рассылка расчетных листков'"));
	ПараметрыРегистрации.Вставить("Версия", "0.1");
	ПараметрыРегистрации.Вставить("БезопасныйРежим", Ложь);
	ПараметрыРегистрации.Вставить("Информация", НСтр("ru = 'Рассылка расчетных листков'"));
	
	ТаблицаКоманд = ПолучитьТаблицуКоманд();
		
	ДобавитьКоманду(ТаблицаКоманд,
					НСтр("ru = 'ППФ Рассылка расчетных листков'"),
					"ФормированиеРасчетныхЛистковПоЗП",
					"ОткрытиеФормы");
	
	ПараметрыРегистрации.Вставить("Команды", ТаблицаКоманд);
	
	Возврат ПараметрыРегистрации;
	
КонецФункции

/////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция ПолучитьТаблицуКоманд()
	
	Команды = Новый ТаблицаЗначений;
	Команды.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка"));
	Команды.Колонки.Добавить("Идентификатор", Новый ОписаниеТипов("Строка"));
	Команды.Колонки.Добавить("Использование", Новый ОписаниеТипов("Строка"));
	Команды.Колонки.Добавить("ПоказыватьОповещение", Новый ОписаниеТипов("Булево"));
	Команды.Колонки.Добавить("Модификатор", Новый ОписаниеТипов("Строка"));
	
	Возврат Команды;
	
КонецФункции

Процедура ДобавитьКоманду(ТаблицаКоманд, Представление, Идентификатор, Использование, ПоказыватьОповещение = Ложь, Модификатор = "")
	
	НоваяКоманда = ТаблицаКоманд.Добавить();
	НоваяКоманда.Представление = Представление;
	НоваяКоманда.Идентификатор = Идентификатор;
	НоваяКоманда.Использование = Использование;
	НоваяКоманда.ПоказыватьОповещение = ПоказыватьОповещение;
	НоваяКоманда.Модификатор = Модификатор;
	
КонецПроцедуры

