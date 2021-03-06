﻿#Область ПрограммныйИнтерфейс


Функция СведенияОВнешнейОбработке() Экспорт
	
	ПараметрыРегистрации = ДополнительныеОтчетыИОбработки.СведенияОВнешнейОбработке("2.2.2.4");
	
	ПараметрыРегистрации.Вид = ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиДополнительныйОтчет();
	ПараметрыРегистрации.Версия = "1.1";
	ПараметрыРегистрации.ОпределитьНастройкиФормы = Истина;
	
	НоваяКоманда = ПараметрыРегистрации.Команды.Добавить();
	НоваяКоманда.Представление = НСтр("ru = 'Переводимые сотрудники'");
	НоваяКоманда.Идентификатор = "ДополнительныйОтчетПолучитьПростойОтчет";
	НоваяКоманда.Использование = ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыОткрытиеФормы();
	НоваяКоманда.ПоказыватьОповещение = Ложь;
	
	Возврат ПараметрыРегистрации;
	
КонецФункции

Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.ФормироватьСразу = Истина;
КонецПроцедуры

#КонецОбласти


Функция СформироватьОтчет()  
	
	ДатаНачала 		= НачалоДня(ЭтотОбъект.НачалоПериода);
	ДатаОкончания 	= КонецДня(ЭтотОбъект.КонецПериода);
	
	ТаблицаИзменения = Новый ТаблицаЗначений;
	ТаблицаИзменения.Колонки.Добавить("ДатаПеремещения");
	ТаблицаИзменения.Колонки.Добавить("ТабНомер");
	ТаблицаИзменения.Колонки.Добавить("ДатаРождения");
	ТаблицаИзменения.Колонки.Добавить("ФИО");
	ТаблицаИзменения.Колонки.Добавить("ДолжностьСтар");
	ТаблицаИзменения.Колонки.Добавить("ПодразделениеСтар");
	ТаблицаИзменения.Колонки.Добавить("УправлениеСтар");
	ТаблицаИзменения.Колонки.Добавить("ДепартаментСтар");
	ТаблицаИзменения.Колонки.Добавить("ОкладСтар");
	ТаблицаИзменения.Колонки.Добавить("ДолжностьНов");
	ТаблицаИзменения.Колонки.Добавить("ПодразделениеНов");
	ТаблицаИзменения.Колонки.Добавить("УправлениеНов");
	ТаблицаИзменения.Колонки.Добавить("ДепартаментНов");
	ТаблицаИзменения.Колонки.Добавить("ОкладНов");
	ТаблицаИзменения.Колонки.Добавить("СтавкаНов");
	ТаблицаИзменения.Колонки.Добавить("СтавкаСтар");

	//Получим сотрудников, по которым были изменения за период
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	КадроваяИсторияСотрудников.Сотрудник,
	               |	КадроваяИсторияСотрудников.Сотрудник.ФизическоеЛицо.ДатаРождения КАК ДатаРождения,
	               |	КадроваяИсторияСотрудников.Сотрудник.Код КАК ТабНомер,
	               |	КадроваяИсторияСотрудников.Период КАК ДатаПеремещения,
	               |	КадроваяИсторияСотрудников.Подразделение КАК ПодразделениеНов,
	               |	КадроваяИсторияСотрудников.Должность КАК ДолжностьНов,
	               |	ЕСТЬNULL(ФИОФизическихЛицСрезПоследних.Фамилия, """") + "" "" + ЕСТЬNULL(ФИОФизическихЛицСрезПоследних.Имя, "" "") + "" "" + ЕСТЬNULL(ФИОФизическихЛицСрезПоследних.Отчество, """") КАК ФИО,
	               |	КадроваяИсторияСотрудников.Подразделение.Родитель КАК УправлениеНов,
	               |	КадроваяИсторияСотрудников.Подразделение.Родитель.Родитель КАК ДепартаментНов,
	               |	КадроваяИсторияСотрудников.КоличествоСтавок КАК СтавкаНов
	               |ИЗ
	               |	РегистрСведений.КадроваяИсторияСотрудников КАК КадроваяИсторияСотрудников
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ФИОФизическихЛиц.СрезПоследних(&ДатаОкончания, ) КАК ФИОФизическихЛицСрезПоследних
	               |		ПО КадроваяИсторияСотрудников.ФизическоеЛицо = ФИОФизическихЛицСрезПоследних.ФизическоеЛицо
	               |ГДЕ
	               |	КадроваяИсторияСотрудников.Период МЕЖДУ &ДатаНачала И &ДатаОкончания
	               |	И КадроваяИсторияСотрудников.ВидСобытия <> ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Прием)
	               |	И КадроваяИсторияСотрудников.ВидСобытия <> ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Увольнение)";
	Запрос.УстановитьПараметр("ДатаНачала",ДатаНачала);				   
	Запрос.УстановитьПараметр("ДатаОкончания",ДатаОкончания);
	Реузльтат = Запрос.Выполнить();
	Если Не Реузльтат.Пустой() Тогда 			
		Выборка = Реузльтат.Выбрать();
		Пока Выборка.Следующий() Цикл
			НоваяСтрока = ТаблицаИзменения.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока,Выборка);
			ПолучитьПредыдущиеДанные(Выборка.ДатаПеремещения, Выборка.Сотрудник, НоваяСтрока);
		КонецЦикла;
		
		ТаблицаИзменения.Сортировать("ДатаПеремещения Возр,ФИО");
		//Если БезОклада Тогда 
		//	Макет = ЭтотОбъект.ПолучитьМакет("ПереводимыеСотрудники");
		//ИначеЕсли сОкладом Тогда  
		//	Макет = ЭтотОбъект.ПолучитьМакет("ПереводимыеСотрудникиОклад");
		//КонецЕсли;
		//ОбластьЗаголовок 	= Макет.ПолучитьОбласть("Заголовок");
		//ОбластьШапка		= Макет.ПолучитьОбласть("Шапка");
		//ОбластьСтрока		= Макет.ПолучитьОбласть("СтрокаОтчета");
		//ТабДокумент.Вывести(ОбластьЗаголовок);
		//ТабДокумент.Вывести(ОбластьШапка);
		//НомерПП = 1; 
		//Для Каждого Строка Из ТаблицаИзменения Цикл 
		//	ОбластьСтрока.Параметры.НомерПП	= НомерПП;
		//	ЗаполнитьЗначенияСвойств(ОбластьСтрока.Параметры, Строка);
		//	ТабДокумент.Вывести(ОбластьСтрока);
		//	НомерПП = НомерПП + 1;
		//КонецЦикла;
		
	КонецЕсли;
	
	Возврат ТаблицаИзменения;
КонецФункции

Процедура ПолучитьПредыдущиеДанные(Период, Сотрудник, СтрокаТаблицы)
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	КадроваяИсторияСотрудниковСрезПоследних.Подразделение КАК ПодразделениеСтар,
	               |	КадроваяИсторияСотрудниковСрезПоследних.Должность КАК ДолжностьСтар,
	               |	ОкладСтарый.Значение КАК ОкладСтар,
	               |	ОкладНовый.Значение КАК ОкладНов,
	               |	КадроваяИсторияСотрудниковСрезПоследних.Подразделение.Родитель КАК УправлениеСтар,
	               |	КадроваяИсторияСотрудниковСрезПоследних.Подразделение.Родитель.Родитель КАК ДепартаментСтар,
	               |	КадроваяИсторияСотрудниковСрезПоследних.КоличествоСтавок КАК СтавкаСтар
	               |ИЗ
	               |	РегистрСведений.КадроваяИсторияСотрудников.СрезПоследних(&ДатаСреза, Сотрудник = &Сотрудник) КАК КадроваяИсторияСотрудниковСрезПоследних
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудников.СрезПоследних(&ДатаСреза, Показатель = ЗНАЧЕНИЕ(Справочник.ПоказателиРасчетаЗарплаты.Оклад)) КАК ОкладСтарый
	               |		ПО КадроваяИсторияСотрудниковСрезПоследних.Сотрудник = ОкладСтарый.Сотрудник
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудников.СрезПоследних(&ДатаТекущегоСреза, Показатель = ЗНАЧЕНИЕ(Справочник.ПоказателиРасчетаЗарплаты.Оклад)) КАК ОкладНовый
	               |		ПО КадроваяИсторияСотрудниковСрезПоследних.Сотрудник = ОкладНовый.Сотрудник";
	Запрос.УстановитьПараметр("ДатаСреза",Период-86400);
	Запрос.УстановитьПараметр("ДатаТекущегоСреза",Период);
	Запрос.УстановитьПараметр("Сотрудник",Сотрудник);
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда 
		Выборка = Результат.Выбрать();
		Если Выборка.Следующий() Тогда  
			ЗаполнитьЗначенияСвойств(СтрокаТаблицы,Выборка);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры


Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	СхемаКомпоновкиДанных = ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	ВариантНастроек = СхемаКомпоновкиДанных.ВариантыНастроек[ЭтотОбъект.КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.КлючВарианта];
	Настройки = ВариантНастроек.Настройки;
	ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Настройки, ДанныеРасшифровки);
	
	ИтоговаяТаблица = СформироватьОтчет();
	
	ВнешнийНаборДанных = Новый Структура;
	ВнешнийНаборДанных.Вставить("ИтоговаяТаблица", ИтоговаяТаблица);
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, ВнешнийНаборДанных, ДанныеРасшифровки);
	
	ДокументРезультат.Очистить();
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);

КонецПроцедуры

