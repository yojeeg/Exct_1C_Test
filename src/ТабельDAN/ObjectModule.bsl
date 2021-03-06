﻿#Область ОписаниеИнтерфейсов
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
	
	РегистрационныеДанные = Новый Структура;
	РегистрационныеДанные.Вставить("Наименование", "Агентский табель DAN");
	РегистрационныеДанные.Вставить("БезопасныйРежим", Ложь);
	РегистрационныеДанные.Вставить("Версия", "1.0");
	РегистрационныеДанные.Вставить("Вид", "ДополнительнаяОбработка");
	РегистрационныеДанные.Вставить("Информация", "Агентский табель DAN");
	
	Команды = Новый ТаблицаЗначений;
	Команды.Колонки.Добавить("Идентификатор");
	Команды.Колонки.Добавить("Представление");
	Команды.Колонки.Добавить("Модификатор");
	Команды.Колонки.Добавить("ПоказыватьОповещение");
	Команды.Колонки.Добавить("Использование");
	
	Команда = Команды.Добавить();
	Команда.Идентификатор = "АгентскийТабельDAN";
	Команда.Представление = "Агентский табель DAN";
	Команда.ПоказыватьОповещение = Истина;
	Команда.Использование = "ВызовСерверногоМетода";
	
	РегистрационныеДанные.Вставить("Команды", Команды);
	
	Возврат РегистрационныеДанные;
	
	
КонецФункции

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

Процедура ВыполнитьКоманду(ИдентификаторКоманды = Неопределено) Экспорт
	//ИдентификаторПроцесса = НачатьПроцесс("18");
	
	Попытка
		ВыгрузитьПроизводственныйКалендарь();
	Исключение
	КонецПопытки;
	
	Попытка	
		ВыгрузитьАгентов();
	Исключение
	КонецПопытки;
	
	//ЗавершитьПроцесс(ИдентификаторПроцесса, 2);
КонецПроцедуры


#КонецОбласти

#Область ПроцедурыНСинхронизации
Процедура ВыгрузитьПроизводственныйКалендарь() Экспорт 
	
	Соединение = ППФ_Сервер.MSSQL_ПолучитьСоединение();
	Если Соединение<>Неопределено Тогда 
		
		ТЗ_DAN_ВесьКалендарь = ППФ_Сервер.MSSQL_ПолучитьРезультатЗапроса(ПолучитьТекстЗапросаВесьКалендарь(), Соединение);
		МассивВсехДатКалендаряDAN_UnixTime = ТЗ_DAN_ВесьКалендарь.ВыгрузитьКолонку("date");
		МассивВсехДатКалендаряDAN = Новый Массив;
		Для Каждого Дата Из МассивВсехДатКалендаряDAN_UnixTime Цикл 
			МассивВсехДатКалендаряDAN.Добавить(UnixtimeВДату(Дата));
		КонецЦикла;
		
		ТаблицаПКОбновить = ПолучитьПроизводственныйКалендарь1С(МассивВсехДатКалендаряDAN, Истина);
		ТаблицаПКВставить = ПолучитьПроизводственныйКалендарь1С(МассивВсехДатКалендаряDAN, Ложь);
		
		Для Каждого СтрокаКалендаря Из ТаблицаПКОбновить Цикл 
			Если Не ППФ_Сервер.MSSQL_ВыполнитьЗапрос(ПолучитьТекстЗапросаОбновитьПроизводственныйКалендарь(СтрокаКалендаря.date,СтрокаКалендаря.Type),Соединение) Тогда 			 
				Отказ = Истина;
				ППФ_Сервер.MSSQL_ЗаписатьВЖурналРегистрации("Произошла ошибка синхронизации с DAN. Ошибка возникла при синхронизации производственного календаря: " + СтрокаКалендаря.date);
			КонецЕсли;
		КонецЦикла;
		
		Для Каждого СтрокаКалендаря Из ТаблицаПКВставить Цикл 
			Если Не ППФ_Сервер.MSSQL_ВыполнитьЗапрос(ПолучитьТекстЗапросаВставитьПроизводственныйКалендарь(СтрокаКалендаря.date,СтрокаКалендаря.Type),Соединение) Тогда 			 
				Отказ = Истина;
				ППФ_Сервер.MSSQL_ЗаписатьВЖурналРегистрации("Произошла ошибка синхронизации с DAN. Ошибка возникла при синхронизации производственного календаря" + СтрокаКалендаря.date);
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
		
КонецПроцедуры

Процедура ВыгрузитьАгентов() Экспорт 
	
	Соединение = ППФ_Сервер.MSSQL_ПолучитьСоединение();
	Если Соединение<>Неопределено Тогда 
		
		//ТЗ_DAN_ВсеАгенты = ППФ_Сервер.MSSQL_ПолучитьРезультатЗапроса(ПолучитьТекстЗапросаВыбратьВсехАгентов(), Соединение);
		//МассивIDАгентовDAN = ТЗ_DAN_ВсеАгенты.ВыгрузитьКолонку("id");
		
		//ТаблицаАгентовОбновить = ПолучитьАгентов1С(МассивIDАгентовDAN, Истина);	
		//ТаблицаАгентовВставить = ПолучитьАгентов1С(МассивIDАгентовDAN, Ложь);
		
		ТаблицаАгентов = ПолучитьАгентов1С();
		//КоррекцияНомераАгентства(ТаблицаАгентовОбновить);
		//КоррекцияНомераАгентства(ТаблицаАгентовВставить);
		КоррекцияНомераАгентства(ТаблицаАгентов);
		
		Если ТаблицаАгентов.Количество() > 0 Тогда 
			
			НачатьТранзакцию();
			
			Если Не ППФ_Сервер.MSSQL_ВыполнитьЗапрос(ОчиститьТаблицуАгентов(),Соединение) Тогда 
				ППФ_Сервер.MSSQL_ЗаписатьВЖурналРегистрации("Не удалось очистить таблицу агентов. Синхронизация не будет продолжена.");
				Возврат;
			КонецЕсли;
			
			Попытка
				Для Каждого СтрокаАгентов Из ТаблицаАгентов Цикл 
					Если Не ППФ_Сервер.MSSQL_ВыполнитьЗапрос(ПолучитьТекстЗапросаВставитьАгенты(СтрокаАгентов.id,СтрокаАгентов.full_name, СтрокаАгентов.start_date, СтрокаАгентов.end_date, СтрокаАгентов.agency_number, СтрокаАгентов.position),Соединение) Тогда 			 
						КоррекцияПоследнегоСимволаНомераАгентства(СтрокаАгентов);
						Если Не ППФ_Сервер.MSSQL_ВыполнитьЗапрос(ПолучитьТекстЗапросаВставитьАгенты(СтрокаАгентов.id,СтрокаАгентов.full_name, СтрокаАгентов.start_date, СтрокаАгентов.end_date, СтрокаАгентов.agency_number, СтрокаАгентов.position),Соединение) Тогда 			 
							КоррекцияНомераАгентстваПереносНуляИзСерединыВКонец(СтрокаАгентов);
							Если Не ППФ_Сервер.MSSQL_ВыполнитьЗапрос(ПолучитьТекстЗапросаВставитьАгенты(СтрокаАгентов.id,СтрокаАгентов.full_name, СтрокаАгентов.start_date, СтрокаАгентов.end_date, СтрокаАгентов.agency_number, СтрокаАгентов.position),Соединение) Тогда 			 
								Отказ = Истина;
								ППФ_Сервер.MSSQL_ЗаписатьВЖурналРегистрации("Произошла ошибка синхронизации с DAN. Ошибка возникла при синхронизации агентов: "  +СтрокаАгентов.id);
							КонецЕсли;
						КонецЕсли;
					КонецЕсли;
				КонецЦикла;
				
				ЗафиксироватьТранзакцию();
				
			Исключение
				
				ОтменитьТранзакцию();
				
			КонецПопытки;
			
		КонецЕсли;
		//
		//Для Каждого СтрокаАгентов Из ТаблицаАгентовОбновить Цикл 
		//	Если Не ППФ_Сервер.MSSQL_ВыполнитьЗапрос(ПолучитьТекстЗапросаОбновитьАгенты(СтрокаАгентов.id,СтрокаАгентов.full_name, СтрокаАгентов.start_date, СтрокаАгентов.end_date, СтрокаАгентов.agency_number, СтрокаАгентов.position),Соединение) Тогда 			 
		//		КоррекцияПоследнегоСимволаНомераАгентства(СтрокаАгентов);
		//		Если Не ППФ_Сервер.MSSQL_ВыполнитьЗапрос(ПолучитьТекстЗапросаОбновитьАгенты(СтрокаАгентов.id,СтрокаАгентов.full_name, СтрокаАгентов.start_date, СтрокаАгентов.end_date, СтрокаАгентов.agency_number, СтрокаАгентов.position),Соединение) Тогда 			 
		//			КоррекцияНомераАгентстваПереносНуляИзСерединыВКонец(СтрокаАгентов);
		//			Если Не ППФ_Сервер.MSSQL_ВыполнитьЗапрос(ПолучитьТекстЗапросаВставитьАгенты(СтрокаАгентов.id,СтрокаАгентов.full_name, СтрокаАгентов.start_date, СтрокаАгентов.end_date, СтрокаАгентов.agency_number, СтрокаАгентов.position),Соединение) Тогда 			 
		//				Отказ = Истина;
		//				ППФ_Сервер.MSSQL_ЗаписатьВЖурналРегистрации("Произошла ошибка синхронизации с DAN. Ошибка возникла при синхронизации агентов: "  +СтрокаАгентов.id);
		//			КонецЕсли;
		//		КонецЕсли;
		//	КонецЕсли;
		//КонецЦикла;	
		//
	КонецЕсли;

КонецПроцедуры
#КонецОбласти

#Область СлужебныеПроцедурыФункции
Функция ДатаВUnixtime(Дата)
	Возврат Формат(Дата - Дата(1970,1,1,1,0,0) - 7200, "ЧГ=0");	
КонецФункции // ДатаВUnixtime()

Функция UnixtimeВДату(unixtime)
	Возврат Дата(1970,1,1,1,0,0) + unixtime + 7200;	
КонецФункции // UnixtimeВДату()

Процедура КоррекцияНомераАгентства(Таблица)
	Для Каждого СтрокаДанных Из Таблица Цикл 
		СтрокаДанных.agency_number = СтрЗаменить(СтрокаДанных.agency_number, "A","B"); // англ. А на англ. В
		СтрокаДанных.agency_number = СтрЗаменить(СтрокаДанных.agency_number, "А","B"); // рус.  А на англ. В
	КонецЦикла;
КонецПроцедуры

Процедура КоррекцияПоследнегоСимволаНомераАгентства(СтрокаДанных)
	СтрокаДанных.agency_number = Лев(СтрокаДанных.agency_number, СтрДлина(СтрокаДанных.agency_number)-1)+"0";
КонецПроцедуры

Процедура КоррекцияНомераАгентстваПереносНуляИзСерединыВКонец(СтрокаДанных)
	СтрокаДанных.agency_number =Лев(СтрокаДанных.agency_number,4) + Прав(СтрокаДанных.agency_number,4) + "0" ;
КонецПроцедуры

Функция ПолучитьМассивМВЗИсключений()
	Массив = Новый Массив;
	Массив.Добавить(Справочники.ППФ_МВЗ.НайтиПоКоду("010_00499"));
	Массив.Добавить(Справочники.ППФ_МВЗ.НайтиПоКоду("010_00399"));
	Массив.Добавить(Справочники.ППФ_МВЗ.НайтиПоКоду("010_00299"));
	Массив.Добавить(Справочники.ППФ_МВЗ.НайтиПоКоду("010A07100"));	
	Возврат Массив;
КонецФункции
#КонецОбласти

#Область ТекстыЗапросов1С
// Функция ПолучитьАгентов1С(МассивАгентов, Обновить)
Функция ПолучитьАгентов1С()
	Запрос = Новый Запрос;
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	КадроваяИсторияСотрудниковСрезПоследних.Сотрудник КАК Сотрудник,
	|	КадроваяИсторияСотрудниковСрезПоследних.ДолжностьПоШтатномуРасписанию КАК ДолжностьПоШтатномуРасписанию,
	|	КадроваяИсторияСотрудниковСрезПоследних.Подразделение КАК Подразделение,
	|	КадроваяИсторияСотрудниковСрезПоследних.Должность КАК Должность
	|ПОМЕСТИТЬ ВТ_КадроваяИстория
	|ИЗ
	|	РегистрСведений.КадроваяИсторияСотрудников.СрезПоследних(, НЕ Сотрудник.ППФ_Агент) КАК КадроваяИсторияСотрудниковСрезПоследних
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ППФ_СоответствиеПодразделенийИМВЗСрезПоследних.Подразделение КАК Подразделение
	|ПОМЕСТИТЬ ВТ_ПодразделенияИсключения
	|ИЗ
	|	РегистрСведений.ППФ_СоответствиеПодразделенийИМВЗ.СрезПоследних КАК ППФ_СоответствиеПодразделенийИМВЗСрезПоследних
	|ГДЕ
	|	ППФ_СоответствиеПодразделенийИМВЗСрезПоследних.МВЗ В(&МВЗИсключения)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТекущиеКадровыеДанныеСотрудников.Сотрудник КАК Сотрудник,
	|	ВЫРАЗИТЬ(ТекущиеКадровыеДанныеСотрудников.Сотрудник.Код КАК СТРОКА(20)) КАК СотрудникКод,
	|	ТекущиеКадровыеДанныеСотрудников.ДатаПриема КАК ДатаПриема,
	|	ТекущиеКадровыеДанныеСотрудников.ДатаУвольнения КАК ДатаУвольнения,
	|	ВЫРАЗИТЬ(ВТ_КадроваяИстория.Должность.Наименование КАК СТРОКА(100)) КАК ТекущаяДолжностьНаименование,
	|	ВЫРАЗИТЬ(ТекущиеКадровыеДанныеСотрудников.Сотрудник.Наименование КАК СТРОКА(100)) КАК СотрудникНаименование,
	|	""COffice"" КАК Поле1
	|ПОМЕСТИТЬ ВТ_ДополнительныеДанные
	|ИЗ
	|	РегистрСведений.ТекущиеКадровыеДанныеСотрудников КАК ТекущиеКадровыеДанныеСотрудников
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_КадроваяИстория КАК ВТ_КадроваяИстория
	|		ПО ТекущиеКадровыеДанныеСотрудников.Сотрудник = ВТ_КадроваяИстория.Сотрудник
	|ГДЕ
	|	ВТ_КадроваяИстория.Подразделение В ИЕРАРХИИ(&МассивДополнительныхПодразделений)
	|	И НЕ ТекущиеКадровыеДанныеСотрудников.Сотрудник.ППФ_Агент
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КадроваяИсторияСотрудниковСрезПоследних.Сотрудник КАК Сотрудник,
	|	ВЫРАЗИТЬ(КадроваяИсторияСотрудниковСрезПоследних.Сотрудник.Код КАК СТРОКА(20)) КАК СотрудникКод,
	|	ВЫРАЗИТЬ(КадроваяИсторияСотрудниковСрезПоследних.Сотрудник.Наименование КАК СТРОКА(100)) КАК full_name,
	|	ВЫРАЗИТЬ(КадроваяИсторияСотрудниковСрезПоследних.Должность.Наименование КАК СТРОКА(100)) КАК ТекущаяДолжность,
	|	ППФ_СоответствиеПодразделенийИМВЗСрезПоследних.МВЗ.Код КАК МВЗ,
	|	ТекущиеКадровыеДанныеСотрудников.ДатаПриема КАК ДатаПриема,
	|	ТекущиеКадровыеДанныеСотрудников.ДатаУвольнения КАК ДатаУвольнения
	|ПОМЕСТИТЬ ВТ_РегиональныеТренеры
	|ИЗ
	|	РегистрСведений.КадроваяИсторияСотрудников.СрезПоследних(, НЕ Сотрудник.ППФ_Агент) КАК КадроваяИсторияСотрудниковСрезПоследних
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ППФ_СоответствиеПодразделенийИМВЗ.СрезПоследних КАК ППФ_СоответствиеПодразделенийИМВЗСрезПоследних
	|		ПО КадроваяИсторияСотрудниковСрезПоследних.Подразделение = ППФ_СоответствиеПодразделенийИМВЗСрезПоследних.Подразделение
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ТекущиеКадровыеДанныеСотрудников КАК ТекущиеКадровыеДанныеСотрудников
	|		ПО КадроваяИсторияСотрудниковСрезПоследних.Сотрудник = ТекущиеКадровыеДанныеСотрудников.Сотрудник
	|ГДЕ
	|	КадроваяИсторияСотрудниковСрезПоследних.Должность.Наименование ПОДОБНО ""%региональный тренер%""
	|	И ТекущиеКадровыеДанныеСотрудников.ДатаПриема <> ДАТАВРЕМЯ(1, 1, 1)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТекущиеКадровыеДанныеСотрудников.Сотрудник КАК Сотрудник,
	|	ВЫРАЗИТЬ(ТекущиеКадровыеДанныеСотрудников.Сотрудник.Код КАК СТРОКА(20)) КАК СотрудникКод,
	|	ВЫРАЗИТЬ(ВТ_КадроваяИстория.Должность.Наименование КАК СТРОКА(100)) КАК ТекущаяДолжность,
	|	ТекущиеКадровыеДанныеСотрудников.ДатаПриема КАК ДатаПриема,
	|	ТекущиеКадровыеДанныеСотрудников.ДатаУвольнения КАК ДатаУвольнения,
	|	""COffice"" КАК МВЗ,
	|	ВЫРАЗИТЬ(ТекущиеКадровыеДанныеСотрудников.Сотрудник.Наименование КАК СТРОКА(100)) КАК full_name
	|ПОМЕСТИТЬ ВТ_ДиректорАгентств
	|ИЗ
	|	РегистрСведений.ТекущиеКадровыеДанныеСотрудников КАК ТекущиеКадровыеДанныеСотрудников
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_КадроваяИстория КАК ВТ_КадроваяИстория
	|		ПО ТекущиеКадровыеДанныеСотрудников.Сотрудник = ВТ_КадроваяИстория.Сотрудник
	|ГДЕ
	|	ВТ_КадроваяИстория.ДолжностьПоШтатномуРасписанию.Наименование = ""Директор агентской сети /Администрация/""
	|	И НЕ ТекущиеКадровыеДанныеСотрудников.Сотрудник.ППФ_Агент
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТекущиеКадровыеДанныеСотрудников.Сотрудник КАК Сотрудник,
	|	ВЫРАЗИТЬ(ТекущиеКадровыеДанныеСотрудников.Сотрудник.Код КАК СТРОКА(20)) КАК id,
	|	ТекущиеКадровыеДанныеСотрудников.ДатаПриема КАК start_date,
	|	ТекущиеКадровыеДанныеСотрудников.ДатаУвольнения КАК end_date,
	|	ВЫРАЗИТЬ(ВТ_КадроваяИстория.Должность.Наименование КАК СТРОКА(100)) КАК position,
	|	ВЫРАЗИТЬ(ТекущиеКадровыеДанныеСотрудников.Сотрудник.Наименование КАК СТРОКА(100)) КАК full_name,
	|	ВЫРАЗИТЬ(ППФ_СоответствиеПодразделенийИМВЗСрезПоследних.МВЗ.Код КАК СТРОКА(9)) КАК agency_number
	|ПОМЕСТИТЬ ВТ_Предварительная
	|ИЗ
	|	РегистрСведений.ТекущиеКадровыеДанныеСотрудников КАК ТекущиеКадровыеДанныеСотрудников
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_КадроваяИстория КАК ВТ_КадроваяИстория
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ППФ_СоответствиеПодразделенийИМВЗ.СрезПоследних КАК ППФ_СоответствиеПодразделенийИМВЗСрезПоследних
	|			ПО (ППФ_СоответствиеПодразделенийИМВЗСрезПоследних.Подразделение = ВТ_КадроваяИстория.Подразделение)
	|		ПО ТекущиеКадровыеДанныеСотрудников.Сотрудник = ВТ_КадроваяИстория.Сотрудник
	|ГДЕ
	|	ВТ_КадроваяИстория.Подразделение В ИЕРАРХИИ(&УправлениеАгентскихПродаж)
	|	И ТекущиеКадровыеДанныеСотрудников.ДатаПриема <> ДАТАВРЕМЯ(1, 1, 1)
	|	И НЕ ВТ_КадроваяИстория.Подразделение В
	|				(ВЫБРАТЬ
	|					ВТ_ПодразделенияИсключения.Подразделение
	|				ИЗ
	|					ВТ_ПодразделенияИсключения КАК ВТ_ПодразделенияИсключения)
	|	И НЕ ТекущиеКадровыеДанныеСотрудников.Сотрудник.ППФ_Агент
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВТ_ДополнительныеДанные.Сотрудник,
	|	ВТ_ДополнительныеДанные.СотрудникКод,
	|	ВТ_ДополнительныеДанные.ДатаПриема,
	|	ВТ_ДополнительныеДанные.ДатаУвольнения,
	|	ВТ_ДополнительныеДанные.ТекущаяДолжностьНаименование,
	|	ВТ_ДополнительныеДанные.СотрудникНаименование,
	|	ВТ_ДополнительныеДанные.Поле1
	|ИЗ
	|	ВТ_ДополнительныеДанные КАК ВТ_ДополнительныеДанные
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВТ_РегиональныеТренеры.Сотрудник,
	|	ВТ_РегиональныеТренеры.СотрудникКод,
	|	ВТ_РегиональныеТренеры.ДатаПриема,
	|	ВТ_РегиональныеТренеры.ДатаУвольнения,
	|	ВТ_РегиональныеТренеры.ТекущаяДолжность,
	|	ВТ_РегиональныеТренеры.full_name,
	|	ВТ_РегиональныеТренеры.МВЗ
	|ИЗ
	|	ВТ_РегиональныеТренеры КАК ВТ_РегиональныеТренеры
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВТ_ДиректорАгентств.Сотрудник,
	|	ВТ_ДиректорАгентств.СотрудникКод,
	|	ВТ_ДиректорАгентств.ДатаПриема,
	|	ВТ_ДиректорАгентств.ДатаУвольнения,
	|	ВТ_ДиректорАгентств.ТекущаяДолжность,
	|	ВТ_ДиректорАгентств.full_name,
	|	ВТ_ДиректорАгентств.МВЗ
	|ИЗ
	|	ВТ_ДиректорАгентств КАК ВТ_ДиректорАгентств
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Предварительная.Сотрудник КАК Сотрудник,
	|	ВТ_Предварительная.id КАК id,
	|	ВТ_Предварительная.start_date КАК start_date,
	|	ВТ_Предварительная.end_date КАК end_date,
	|	ВТ_Предварительная.position КАК position,
	|	ВТ_Предварительная.full_name КАК full_name,
	|	ВТ_Предварительная.agency_number КАК agency_number
	|ИЗ
	|	ВТ_Предварительная КАК ВТ_Предварительная
	|ГДЕ
	|	НЕ ВТ_Предварительная.Сотрудник.ППФ_Агент
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТ_ДополнительныеДанные
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТ_ДиректорАгентств
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТ_ПодразделенияИсключения
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТ_КадроваяИстория
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТ_РегиональныеТренеры";
	//Если Обновить Тогда 
	//	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "#УСЛОВИЕ", " ВТ_Предварительная.id В (&МассивАгентов) ");
	//Иначе 
	//	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "#УСЛОВИЕ", " НЕ ВТ_Предварительная.id В (&МассивАгентов) ");
	//КонецЕсли;
	
	Запрос.Текст = ТекстЗапроса;
	МассивМВЗИсключений = ПолучитьМассивМВЗИсключений();	
	МассивДополнительныхПодразделений = Новый Массив;
	МассивДополнительныхПодразделений.Добавить(Справочники.ПодразделенияОрганизаций.НайтиПоКоду("640"));//Координационный отдел 
	МассивДополнительныхПодразделений.Добавить(Справочники.ПодразделенияОрганизаций.НайтиПоКоду("7106"));// Координационное управление
	
	Запрос.УстановитьПараметр("УправлениеАгентскихПродаж", Справочники.ПодразделенияОрганизаций.НайтиПоКоду("504"));
	Запрос.УстановитьПараметр("МассивДополнительныхПодразделений",МассивДополнительныхПодразделений);
	//Запрос.УстановитьПараметр("МассивАгентов",МассивАгентов);
	Запрос.УстановитьПараметр("МВЗИсключения", МассивМВЗИсключений);  	
	
	Возврат Запрос.Выполнить().Выгрузить();
КонецФункции

Функция ПолучитьПроизводственныйКалендарь1С(МассивДат, Обновить)
	Запрос = Новый Запрос;
	ТекстЗапроса = "ВЫБРАТЬ
	               |	ДанныеПроизводственногоКалендаря.Дата КАК date,
	               |	ВЫБОР
	               |		КОГДА ДанныеПроизводственногоКалендаря.ВидДня = ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Рабочий)
	               |			ТОГДА 1
	               |		ИНАЧЕ ВЫБОР
	               |				КОГДА ДанныеПроизводственногоКалендаря.ВидДня = ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Суббота)
	               |					ТОГДА 2
	               |				ИНАЧЕ ВЫБОР
	               |						КОГДА ДанныеПроизводственногоКалендаря.ВидДня = ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Воскресенье)
	               |							ТОГДА 3
	               |						ИНАЧЕ ВЫБОР
	               |								КОГДА ДанныеПроизводственногоКалендаря.ВидДня = ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Предпраздничный)
	               |									ТОГДА 4
	               |								ИНАЧЕ ВЫБОР
	               |										КОГДА ДанныеПроизводственногоКалендаря.ВидДня = ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Праздник)
	               |											ТОГДА 5
	               |									КОНЕЦ
	               |							КОНЕЦ
	               |					КОНЕЦ
	               |			КОНЕЦ
	               |	КОНЕЦ КАК Type
	               |ИЗ
	               |	РегистрСведений.ДанныеПроизводственногоКалендаря КАК ДанныеПроизводственногоКалендаря
				   |	#УСЛОВИЕ";
				   			   
	Если Обновить Тогда 
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "#УСЛОВИЕ", " ГДЕ ДанныеПроизводственногоКалендаря.Дата В(&МассивДат) ");
	Иначе 
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "#УСЛОВИЕ", " ГДЕ НЕ ДанныеПроизводственногоКалендаря.Дата В(&МассивДат) ");
	КонецЕсли;
	
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("МассивДат",МассивДат);
	Возврат Запрос.Выполнить().Выгрузить();

КонецФункции
#КонецОбласти

#Область ТекстыЗапросовDAN
Функция ПолучитьТекстЗапросаВставитьПроизводственныйКалендарь(Дата, ВидДня)
	Возврат "INSERT INTO 
	|	calendar (
	|		[date],
	|		[type]
	|	) SELECT 
	|	'" + ДатаВUnixtime(Дата)	+ "',
	|	'" + ВидДня					+ "'";		
КонецФункции // ПолучитьТекстЗапросаВставитьПроизводственныйКалендарь()

Функция ПолучитьТекстЗапросаОбновитьПроизводственныйКалендарь(Дата, ВидДня)
	Возврат "UPDATE 
	|	dbo.calendar SET
	|	type =" + ВидДня + "
	|	WHERE date =" + ?(Дата <> Дата(1,1,1), ДатаВUnixtime(Дата), "Null");
КонецФункции // ПолучитьТекстЗапросаОбновитьПроизводственныйКалендарь()

Функция ПолучитьТекстЗапросаВставитьАгенты(id,full_name,start_date,end_date,agency_number, position)
	Возврат "INSERT INTO 
	|	agents (
	|		[id],
	|		[full_name],
	|		[start_date], 
	|		[end_date],
	|		[agency_number],
	|		[position]
	|	) SELECT 
	|	'" + id	+ "',
	|	'" + СокрЛП(full_name)			+ "',
	|	" + ДатаВUnixtime(start_date)	+ ",
	|	" + ?(end_date <> Дата(1,1,1), ДатаВUnixtime(end_date), "Null")+ ",
	|	'" + СокрЛП(agency_number)		+ "',
	|	'" + СокрЛП(position)		+ "'";		
КонецФункции // ПолучитьТекстЗапросаВставитьАгенты()

Функция ОчиститьТаблицуАгентов()
	
	Возврат "truncate table agents";
	
КонецФункции

Функция ПолучитьТекстЗапросаОбновитьАгенты(id,full_name,start_date,end_date,agency_number, position)
	Возврат "UPDATE 
	|	dbo.agents SET
	|	full_name	='" + СокрЛП(full_name) + "',
	|	start_date 	=" + ДатаВUnixtime(start_date) + ", 
	|	end_date 	=" + ?(end_date <> Дата(1,1,1), ДатаВUnixtime(end_date), "Null") + ", 
	|	agency_number	='" + СокрЛП(agency_number) + "',
	|	position	='" + СокрЛП(position)		+ "' 	
	|	WHERE id ='" + СокрЛП(id) + "'";		
КонецФункции // ПолучитьТекстЗапросаВставитьАгенты()

Функция ПолучитьТекстЗапросаВесьКалендарь()
	Возврат "SELECT [date]
			|      ,[type]
			|  FROM [calendar]";
КонецФункции // ПолучитьТекстЗапросаВесьКалендарь()

Функция ПолучитьТекстЗапросаВыбратьВсехАгентов()
	Возврат "SELECT [id]
			|      ,[full_name]
			|      ,[start_date]
			|      ,[end_date]
			|      ,[agency_number]
			|  FROM [agents]";
КонецФункции // ПолучитьТекстЗапросаВыбратьВсехАгентов()

Функция НачатьПроцесс(КодСервиса)
	
	Попытка
	
		Соединение = Новый HTTPСоединение("bg:8889/");	
		
		ИмяВыходногоФайла = ПолучитьимяВременногоФайла("txt");
		
		HTTPЗапрос = Новый HTTPЗапрос("/start/" + СокрЛП(КодСервиса));
		
		Соединение.Получить(HTTPЗапрос, ИмяВыходногоФайла);
		
		ЧтениеТекста = Новый ЧтениеТекста(имяВыходногоФайла);
		
		ИдентификаторПроцесса = ЧтениеТекста.Прочитать();
		
		ЧтениеТекста.Закрыть();	
		
		УдалитьФайлы(ИмяВыходногоФайла);
		
		Возврат ИдентификаторПроцесса;
	
	Исключение
		
		Возврат Неопределено;
		
	КонецПопытки;

КонецФункции // НачатьПроцесс()
   
Функция ЗавершитьПроцесс(ИдентификаторПроцесса, Отказ, ТекстСообщения = "")
	
	Если ИдентификаторПроцесса = Неопределено Тогда
		
		Возврат Неопределено;
		
	КонецЕсли;
	
	Попытка
	
		Соединение = Новый HTTPСоединение("bg:8889/");
		
		ИмяВременногоФайла = ПолучитьИмяВременногоФайла("txt");
		
		ЗаписьТекста = Новый ЗаписьТекста(ИмяВременногоФайла, "CESU-8");
		ЗаписьТекста.Записать(ТекстСообщения);
		ЗаписьТекста.Закрыть();
		
		ИмяВыходногоФайла = ПолучитьимяВременногоФайла("txt");
		
		ДвоичныеДанные = Новый ДвоичныеДанные(ИмяВременногоФайла);
		
		УдалитьФайлы(ИмяВременногоФайла);
		
		Строка = СтрЗаменить(СтрЗаменить(СтрЗаменить(Base64Строка(ДвоичныеДанные), "+", "PPF1PPF"), Символы.ПС, ""), " ", "");
		КоличествоСтрок = СтрЧислоСтрок(Строка);
		
		НоваяСтрока = "";
		
		Для Сч = 1 По КоличествоСтрок Цикл
			
			НоваяСтрока = НоваяСтрока + СтрПолучитьСтроку(Строка, Сч);	
		
		КонецЦикла;  
		
		HTTPЗапрос = Новый HTTPЗапрос("/end/" + СокрЛП(ИдентификаторПроцесса) + "/" + ?(Отказ = Истина, "3", "2") + "/" + НоваяСтрока);
		Соединение.Получить(HTTPЗапрос, имяВыходногоФайла);
		
		ЧтениеТекста = Новый ЧтениеТекста(имяВыходногоФайла);	
		Результат = ЧтениеТекста.Прочитать();
		ЧтениеТекста.Закрыть();	
		
		УдалитьФайлы(ИмяВыходногоФайла);
		
		Возврат Результат;
		
	Исключение
		
		Возврат Неопределено;
		
	КонецПопытки;
	
КонецФункции // ЗавершитьПроцесс()

#КонецОбласти

