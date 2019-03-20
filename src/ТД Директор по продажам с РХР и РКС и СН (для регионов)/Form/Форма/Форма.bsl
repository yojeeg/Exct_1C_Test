﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ОбъектыНазначения") Тогда
		Для Каждого Ссылка Из Параметры.ОбъектыНазначения Цикл
			ОбъектыНазначения.Добавить(Ссылка);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СформироватьПечатнуюФорму(Команда)
	
	ОбъектыНазначения = Новый СписокЗначений;
	ОбъектыНазначения.Добавить(Объект.СсылкаНаОбъект);
	
	Печать("ТД_ДиректорПоПродажамРХРРКССНРегионы", ОбъектыНазначения.ВыгрузитьЗначения());
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Клиент - Программный интерфейс
&НаКлиенте
Процедура Печать(ИдентификаторКоманды, МассивДокументов) Экспорт
	
	ШаблонДоговора = ПолучитьМакет_Сервер(ИдентификаторКоманды);
	
	Если ШаблонДоговора = Неопределено Тогда
		Возврат;                            		
	КонецЕсли;
	
	АдресФайла = ШаблонДоговора.НавигационнаяСсылкаТекущейВерсии;
	ИмяСРасширением = ОбщегоНазначенияКлиентСервер.ПолучитьИмяСРасширением(
	ШаблонДоговора.ПолноеНаименованиеВерсии, ШаблонДоговора.Расширение);
	Расширение = ШаблонДоговора.Расширение;
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла(Расширение);
	
	ПередаваемыеФайлы = Новый Массив;
	Описание = Новый ОписаниеПередаваемогоФайла(ИмяВременногоФайла, АдресФайла);
	ПередаваемыеФайлы.Добавить(Описание);
	Если ПолучитьФайлы(ПередаваемыеФайлы,, ИмяВременногоФайла, Ложь) Тогда
		
		// Для варианта с хранением файлов на диске (на сервере) удаляем Файл из временного хранилища после получения.
		Если ЭтоАдресВременногоХранилища(АдресФайла) Тогда
			УдалитьИзВременногоХранилища(АдресФайла);
		КонецЕсли;
		
		НовыйФайл = Новый Файл(ИмяВременногоФайла);
		
		НовыйФайл.УстановитьУниверсальноеВремяИзменения(
		ШаблонДоговора.ДатаМодификацииУниверсальная);
		
	КонецЕсли;
	
	Попытка
		Ворд = Новый COMОбъект("Word.Application");	
		
		Ворд.Documents.Open(ИмяВременногоФайла);
		
		
		Если МассивДокументов.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;
		
		Состояние(НСтр("ru = 'Формирование печатных форм...'"));
		
		ИмяМакета = ИдентификаторКоманды;
		
		МассивИменМакетов = Новый Массив;
		МассивИменМакетов.Добавить(ИмяМакета);
		
		МакетИДанныеОбъекта = ПолучитьМакетИДанныеОбъекта(МассивДокументов);
		
		ПечатьДокументаWord(МакетИДанныеОбъекта, Ворд);
		
		Ворд.Application.Visible = Истина;
		Ворд.Activate();
		
	Исключение
		
		Если Ворд <> Неопределено Тогда
			
			Ворд.Application.Visible = Ложь;
			Ворд.Quit(0);
			Ворд = 0;
			УдалитьФайлы(ИмяВременногоФайла);
			
		КонецЕсли;
		
		ПоказатьОповещениеПользователя("Ошибка: " + ОписаниеОшибки(), СтатусСообщения.ОченьВажное);
		
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатьДокументаWord(МакетИДанныеОбъекта, Ворд) Экспорт
	Для Каждого Параметр ИЗ МакетИДанныеОбъекта Цикл 
		ЗаменитьТекстВВорде(Ворд, "["+Параметр.Ключ+"]", Параметр.Значение);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ЗаменитьТекстВВорде(Ворд, ИсходнаяСтрока, СтрокаЗамены)
	Ворд.Application.Selection.Find.ClearFormatting();
	Ворд.Application.Selection.Find.Text				= ИсходнаяСтрока;
	Ворд.Application.Selection.Find.Replacement.Text	= Строка(СтрокаЗамены);
	Ворд.Application.Selection.Find.Forward				= Истина;
	Ворд.Application.Selection.Find.Wrap				= 1; //wdFindContinue;
	Ворд.Application.Selection.Find.Format				= Ложь;
	Ворд.Application.Selection.Find.MatchCase			= Истина;
	Ворд.Application.Selection.Find.MatchWholeWord		= Ложь;
	Ворд.Application.Selection.Find.MatchWildcards		= Ложь;
	Ворд.Application.Selection.Find.MatchSoundsLike		= Ложь;
	Ворд.Application.Selection.Find.MatchAllWordForms	= Ложь;
	Ворд.Application.Selection.Find.Execute(,,,,,,,,,,2);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Вызов сервера, Сервер
&НаСервере
Функция ПолучитьМакет_Сервер(Идентификатор)
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	МакетыПечатныхФорм.Ссылка КАК Ссылка
	               |ПОМЕСТИТЬ ВТ_МАКЕТ
	               |ИЗ
	               |	Справочник.ППФ_МакетыПечатныхФорм КАК МакетыПечатныхФорм
	               |ГДЕ
	               |	МакетыПечатныхФорм.ПечатнаяФорма.Команды.Идентификатор = &Идентификатор
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ ПЕРВЫЕ 1
	               |	Файлы.Ссылка КАК Ссылка,
	               |	Файлы.ТекущаяВерсия КАК ТекущаяВерсия
	               |ИЗ
	               |	ВТ_МАКЕТ КАК ВТ_МАКЕТ
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Файлы КАК Файлы
	               |		ПО ВТ_МАКЕТ.Ссылка = Файлы.ВладелецФайла
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Файлы.ДатаСоздания УБЫВ
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |УНИЧТОЖИТЬ ВТ_МАКЕТ";
	
	Запрос.УстановитьПараметр("Идентификатор",Идентификатор);	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда 
		ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляСохранения(Выборка.Ссылка, Выборка.ТекущаяВерсия, УникальныйИдентификатор);
		Возврат ДанныеФайла;
	Иначе 
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ПолучитьМакетИДанныеОбъекта(МассивДокументов)
	
	Объект1 = РеквизитФормыВЗначение("Объект");
	МакетыИДанные = Объект1.ПолучитьДанныеПечати(МассивДокументов);
	
	Возврат МакетыИДанные;
	
КонецФункции

#КонецОбласти
