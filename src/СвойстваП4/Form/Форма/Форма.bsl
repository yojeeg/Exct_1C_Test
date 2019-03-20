﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Начисления.Ссылка
	               |ИЗ
	               |	ПланВидовРасчета.Начисления КАК Начисления
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Начисления.Наименование";
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл 
		НоваяСтрока = Объект.Начисления.Добавить();
		НоваяСтрока.Начисление = Выборка.Ссылка;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСвойстваНаСервере()
	
	П4_8 = ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию("П4.8");
	П4_10 = ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию("П4.10");
	Для Каждого СтрокаДанных Из Объект.Начисления Цикл 
		                                                           		
		НачислениеОбъект = СтрокаДанных.Начисление.ПолучитьОбъект();
		ТЧДопРеквизиты = НачислениеОбъект.ДополнительныеРеквизиты;
		
		Если СтрокаДанных.П4_8 Тогда 

			НайденныеСтроки = ТЧДопРеквизиты.НайтиСтроки(Новый Структура("Свойство",П4_8));
			Если НайденныеСтроки.Количество() = 0 Тогда 
				СтрокаДопРеквизита = ТЧДопРеквизиты.Добавить();
			Иначе 
				СтрокаДопРеквизита = НайденныеСтроки[0];
			КонецЕсли;
			
			СтрокаДопРеквизита.Свойство = П4_8;
			СтрокаДопРеквизита.Значение = Истина;
			
		ИначеЕсли СтрокаДанных.П4_10 Тогда
			
			НайденныеСтроки = ТЧДопРеквизиты.НайтиСтроки(Новый Структура("Свойство",П4_10));
			Если НайденныеСтроки.Количество() = 0 Тогда 
				СтрокаДопРеквизита = ТЧДопРеквизиты.Добавить();
			Иначе 
				СтрокаДопРеквизита = НайденныеСтроки[0];
			КонецЕсли;
			
			СтрокаДопРеквизита.Свойство = П4_10;
			СтрокаДопРеквизита.Значение = Истина;
			
		Иначе 
			
			ВсегоДопРеквизитов = ТЧДопРеквизиты.Количество();
			счётчик = ВсегоДопРеквизитов - 1;
			Пока счётчик>=0 Цикл 
				СтрокаДопРеквизита = ТЧДопРеквизиты[счётчик];
				Если СтрокаДопРеквизита.Свойство = П4_10 Или СтрокаДопРеквизита.Свойство = П4_8 Тогда 
					ТЧДопРеквизиты.Удалить(СтрокаДопРеквизита);
				КонецЕсли;
				счётчик = счётчик - 1;
			КонецЦикла;
			
			
		КонецЕсли;
		
		Попытка
			НачислениеОбъект.Записать();
		Исключение
			Сообщить(ПодробноеПредставлениеОшибки(ОписаниеОшибки()));
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСвойства(Команда)
	ЗаполнитьСвойстваНаСервере();
	Сообщить("Готово");
КонецПроцедуры
