﻿#Область ПрограммныйИнтерфейс

Функция СведенияОВнешнейОбработке() Экспорт
	
	ПараметрыРегистрации = ДополнительныеОтчетыИОбработки.СведенияОВнешнейОбработке("2.2.2.4");
	
	ПараметрыРегистрации.Вид = ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиДополнительныйОтчет();
	ПараметрыРегистрации.Версия = "1.2";
	ПараметрыРегистрации.ОпределитьНастройкиФормы = Истина;
	
	НоваяКоманда = ПараметрыРегистрации.Команды.Добавить();
	НоваяКоманда.Представление = НСтр("ru = 'Вносы в фонды помесячно'");
	НоваяКоманда.Идентификатор = "ВзносыВФондыПомесячно";
	НоваяКоманда.Использование = ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыОткрытиеФормы();
	НоваяКоманда.ПоказыватьОповещение = Ложь;
	
	Возврат ПараметрыРегистрации;
	
КонецФункции

#КонецОбласти


Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ТаблДок = Новый ТабличныйДокумент;
	
	ТаблицаПФР = ПолучитьТаблицуПФР();
	ТаблицаФОМС = ПолучитьТаблицуФОМС();
	ТаблицаФСС = ПолучитьТаблицуФСС();
	ТаблицаФСС_НС = ПолучитьТаблицуФСС_НС();
	
	Макет = ПолучитьМакет("Макет");
	ОбластьНазвание = Макет.ПолучитьОбласть("НавзаниеВзноса");
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьСтрокаДанных = Макет.ПолучитьОбласть("СтрокаДанных");
	ОбластьСтрокаИтога = Макет.ПолучитьОбласть("СтрокаИтога");
	
	Если ТаблицаПФР.Количество() > 0 Тогда 
		ОбластьНазвание.Параметры.НазваниеВзноса = "ПФР";
		ТаблДок.Вывести(ОбластьНазвание);
		ТаблДок.Вывести(ОбластьШапка);
		Для Каждого СтрокаДанных Из ТаблицаПФР Цикл 
			ЗаполнитьЗначенияСвойств(ОбластьСтрокаДанных.Параметры, СтрокаДанных);
			ТаблДок.Вывести(ОбластьСтрокаДанных);
		КонецЦикла;
		ОбластьСтрокаИтога.Параметры.Итого = ТаблицаПФР.Итог("Сумма");
		ТаблДок.Вывести(ОбластьСтрокаИтога);
	КонецЕсли;
	
	Если ТаблицаФОМС.Количество() > 0 Тогда 
		ОбластьНазвание.Параметры.НазваниеВзноса = "ФОМС";
		ТаблДок.Вывести(ОбластьНазвание);
		ТаблДок.Вывести(ОбластьШапка);
		Для Каждого СтрокаДанных Из ТаблицаФОМС Цикл 
			ЗаполнитьЗначенияСвойств(ОбластьСтрокаДанных.Параметры, СтрокаДанных);
			ТаблДок.Вывести(ОбластьСтрокаДанных);
		КонецЦикла;
		ОбластьСтрокаИтога.Параметры.Итого = ТаблицаФОМС.Итог("Сумма");
		ТаблДок.Вывести(ОбластьСтрокаИтога);		
	КонецЕсли;
	
	Если ТаблицаФСС.Количество() > 0 Тогда 
		ОбластьНазвание.Параметры.НазваниеВзноса = "ФСС";
		ТаблДок.Вывести(ОбластьНазвание);
		ТаблДок.Вывести(ОбластьШапка);
		Для Каждого СтрокаДанных Из ТаблицаФСС Цикл 
			ЗаполнитьЗначенияСвойств(ОбластьСтрокаДанных.Параметры, СтрокаДанных);
			ТаблДок.Вывести(ОбластьСтрокаДанных);
		КонецЦикла;
		ОбластьСтрокаИтога.Параметры.Итого = ТаблицаФСС.Итог("Сумма");
		ТаблДок.Вывести(ОбластьСтрокаИтога);		
	КонецЕсли;
	
	Если ТаблицаФСС_НС.Количество() > 0 Тогда 
		ОбластьНазвание.Параметры.НазваниеВзноса = "ФСС НС";
		ТаблДок.Вывести(ОбластьНазвание);
		ТаблДок.Вывести(ОбластьШапка);
		Для Каждого СтрокаДанных Из ТаблицаФСС_НС Цикл 
			ЗаполнитьЗначенияСвойств(ОбластьСтрокаДанных.Параметры, СтрокаДанных);
			ТаблДок.Вывести(ОбластьСтрокаДанных);
		КонецЦикла;
		ОбластьСтрокаИтога.Параметры.Итого = ТаблицаФСС_НС.Итог("Сумма");
		ТаблДок.Вывести(ОбластьСтрокаИтога);
	КонецЕсли;

	ДокументРезультат.Вывести(ТаблДок);
	
КонецПроцедуры

Функция ПолучитьТаблицуПФР()
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	НАЧАЛОПЕРИОДА(ИсчисленныеСтраховыеВзносы.Период, МЕСЯЦ) КАК Период,
	               |	СУММА(ЕСТЬNULL(ИсчисленныеСтраховыеВзносы.ПФРДоПредельнойВеличины, 0) + ЕСТЬNULL(ИсчисленныеСтраховыеВзносы.ПФРСПревышения, 0) + ЕСТЬNULL(ИсчисленныеСтраховыеВзносы.ПФРПоСуммарномуТарифу, 0) + ЕСТЬNULL(ИсчисленныеСтраховыеВзносы.ПФРПоСуммарномуТарифуСПревышения, 0)) КАК Сумма
	               |ИЗ
	               |	РегистрНакопления.ИсчисленныеСтраховыеВзносы КАК ИсчисленныеСтраховыеВзносы
	               |ГДЕ
	               |	ИсчисленныеСтраховыеВзносы.Период >= &НачалоПериода
	               |	И ИсчисленныеСтраховыеВзносы.Период <= &КонецПериода
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	НАЧАЛОПЕРИОДА(ИсчисленныеСтраховыеВзносы.Период, МЕСЯЦ)
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Период";
	Запрос.УстановитьПараметр("НачалоПериода",ДатаНачала);	
	Запрос.УстановитьПараметр("КонецПериода",ДатаОкончания);	
	Возврат Запрос.Выполнить().Выгрузить();
КонецФункции

Функция ПолучитьТаблицуФОМС()
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	НАЧАЛОПЕРИОДА(ИсчисленныеСтраховыеВзносы.Период, МЕСЯЦ) КАК Период,
	               |	СУММА(ЕСТЬNULL(ИсчисленныеСтраховыеВзносы.ФФОМС, 0)) КАК Сумма
	               |ИЗ
	               |	РегистрНакопления.ИсчисленныеСтраховыеВзносы КАК ИсчисленныеСтраховыеВзносы
	               |ГДЕ
	               |	ИсчисленныеСтраховыеВзносы.Период >= &НачалоПериода
	               |	И ИсчисленныеСтраховыеВзносы.Период <= &КонецПериода
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	НАЧАЛОПЕРИОДА(ИсчисленныеСтраховыеВзносы.Период, МЕСЯЦ)
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Период";
	Запрос.УстановитьПараметр("НачалоПериода",ДатаНачала);	
	Запрос.УстановитьПараметр("КонецПериода",ДатаОкончания);	
	Возврат Запрос.Выполнить().Выгрузить();
КонецФункции

Функция ПолучитьТаблицуФСС()
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	НАЧАЛОПЕРИОДА(ИсчисленныеСтраховыеВзносы.Период, МЕСЯЦ) КАК Период,
	               |	СУММА(ЕСТЬNULL(ИсчисленныеСтраховыеВзносы.ФСС, 0)) КАК Сумма
	               |ИЗ
	               |	РегистрНакопления.ИсчисленныеСтраховыеВзносы КАК ИсчисленныеСтраховыеВзносы
	               |ГДЕ
	               |	ИсчисленныеСтраховыеВзносы.Период >= &НачалоПериода
	               |	И ИсчисленныеСтраховыеВзносы.Период <= &КонецПериода
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	НАЧАЛОПЕРИОДА(ИсчисленныеСтраховыеВзносы.Период, МЕСЯЦ)
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Период";
	Запрос.УстановитьПараметр("НачалоПериода",ДатаНачала);	
	Запрос.УстановитьПараметр("КонецПериода",ДатаОкончания);	
	Возврат Запрос.Выполнить().Выгрузить();
КонецФункции

Функция ПолучитьТаблицуФСС_НС()
	Запрос = Новый Запрос();
		Запрос.Текст = "ВЫБРАТЬ
		               |	НАЧАЛОПЕРИОДА(ИсчисленныеСтраховыеВзносы.Период, МЕСЯЦ) КАК Период,
		               |	СУММА(ЕСТЬNULL(ИсчисленныеСтраховыеВзносы.ФССНесчастныеСлучаи, 0)) КАК Сумма
		               |ИЗ
		               |	РегистрНакопления.ИсчисленныеСтраховыеВзносы КАК ИсчисленныеСтраховыеВзносы
		               |ГДЕ
		               |	ИсчисленныеСтраховыеВзносы.Период >= &НачалоПериода
		               |	И ИсчисленныеСтраховыеВзносы.Период <= &КонецПериода
		               |
		               |СГРУППИРОВАТЬ ПО
		               |	НАЧАЛОПЕРИОДА(ИсчисленныеСтраховыеВзносы.Период, МЕСЯЦ)
		               |
		               |УПОРЯДОЧИТЬ ПО
		               |	Период";
	Запрос.УстановитьПараметр("НачалоПериода",ДатаНачала);	
	Запрос.УстановитьПараметр("КонецПериода",ДатаОкончания);	
	Возврат Запрос.Выполнить().Выгрузить();
КонецФункции
