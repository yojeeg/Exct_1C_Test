﻿Функция ПолучитьТаблицуКоманд()
	
	Команды = Новый ТаблицаЗначений;
	// Как будет выглядеть описание печатной формы для пользователя
	Команды.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка"));
	// Имя нашего макета, что бы могли отличить вызванную команду в обработке печати
	Команды.Колонки.Добавить("Идентификатор", Новый ОписаниеТипов("Строка"));
	// Тут задается, как должна вызваться команда обработки
	// Возможные варианты:
	// - ОткрытиеФормы - в этом случае в колонке идентификатор должно быть указано имя формы, которое должна будет открыть система
	// - ВызовКлиентскогоМетода - вызвать клиентскую экспортную процедуру из модуля формы обработки
	// - ВызовСерверногоМетода - вызвать серверную экспортную процедуру из модуля объекта обработки
	Команды.Колонки.Добавить("Использование", Новый ОписаниеТипов("Строка"));
	// Следующий параметр указывает, необходимо ли показывать оповещение при начале и завершению работы обработки. Не имеет смысла при открытии формы
	Команды.Колонки.Добавить("ПоказыватьОповещение", Новый ОписаниеТипов("Булево"));
	// Для печатной формы должен содержать строку ПечатьMXL 
	Команды.Колонки.Добавить("Модификатор", Новый ОписаниеТипов("Строка"));
	
	Возврат Команды;
	
КонецФункции

Функция ДобавитьКоманду(ТаблицаКоманд, Представление, Идентификатор, Использование, ПоказыватьОповещение = Ложь, Модификатор = "")
	НоваяКоманда = ТаблицаКоманд.Добавить();
	НоваяКоманда. Представление = Представление;
	НоваяКоманда. Идентификатор= Идентификатор;
	НоваяКоманда. Использование= Использование;
	НоваяКоманда. ПоказыватьОповещение= ПоказыватьОповещение;
	НоваяКоманда. Модификатор= Модификатор;
КонецФункции

Функция СведенияОВнешнейОбработке() Экспорт
	ПараметрыРегистрации = Новый Структура;
	МассивНазначений = Новый Массив;
	МассивНазначений.Добавить("Документ.РаботаВВыходныеИПраздничныеДни");
	ПараметрыРегистрации.Вставить("Вид", "ПечатнаяФорма"); //может быть - ЗаполнениеОбъекта, ДополнительныйОтчет, СозданиеСвязанныхОбъектов... 
	ПараметрыРегистрации.Вставить("Назначение", МассивНазначений);
	ПараметрыРегистрации.Вставить("Наименование", " Заявление на работу в выходные 2"); //имя под которым обработка будет зарегестрирована в справочнике внешних обработок
	ПараметрыРегистрации.Вставить("Версия", "1.0");
	ПараметрыРегистрации.Вставить("БезопасныйРежим", Ложь);
	ПараметрыРегистрации.Вставить("Информация", " Заявление на работу в выходные 2");//так будет выглядеть описание печ.формы для пользователя
	ТаблицаКоманд = ПолучитьТаблицуКоманд();
	ДобавитьКоманду(ТаблицаКоманд, "ППФ Заявление на работу в выходные 2", "ЗаявлениеКПриказуНаРаботуВВыходные", "ВызовСерверногоМетода", Истина);
	ПараметрыРегистрации.Вставить("Команды", ТаблицаКоманд);
	Возврат ПараметрыРегистрации;
КонецФункции

Процедура Печать(МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Макет = ПолучитьМакет("ЗаявлениеКПриказуНаРаботуВВыходные");
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ЗаявлениеКПриказуНаРаботуВВыходные") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
		"ЗаявлениеКПриказуНаРаботуВВыходные", "Заявление к приказу на работу в выходные",	ПолучитьТабличныйДокументЗаявления(Макет,МассивОбъектов, ОбъектыПечати));
	КонецЕсли;
	
КонецПроцедуры

Функция ОпределитьПодразделение(Подразделение)
	
	ЗапросПоПодразделениям = Новый Запрос;
	ТекстЗапроса = "ВЫБРАТЬ
	|	ДополнительныеСведения.Объект КАК Объект,
	|	ДополнительныеСведения.Свойство КАК Свойство,
	|	ДополнительныеСведения.Значение КАК Значение,
	|	""1"" КАК УровеньВложенности
	|ИЗ
	|	РегистрСведений.ДополнительныеСведения КАК ДополнительныеСведения
	|ГДЕ
	|	ДополнительныеСведения.Объект = &Ссылка
	|ОБЪЕДИНИТЬ ВСЕ                             	
	|ВЫБРАТЬ
	|	ДополнительныеСведения.Объект,
	|	ДополнительныеСведения.Свойство,
	|	ДополнительныеСведения.Значение,
	|	""2""
	|ИЗ
	|	РегистрСведений.ДополнительныеСведения КАК ДополнительныеСведения
	|ГДЕ
	|	ДополнительныеСведения.Объект = &СсылкаРодитель
	
	|ОБЪЕДИНИТЬ ВСЕ
	
	|ВЫБРАТЬ
	|	ДополнительныеСведения.Объект,
	|	ДополнительныеСведения.Свойство,
	|	ДополнительныеСведения.Значение,
	|	""3""
	|ИЗ
	|	РегистрСведений.ДополнительныеСведения КАК ДополнительныеСведения
	|ГДЕ
	|	ДополнительныеСведения.Объект = &СсылкаРодительРодитель";
	ЗапросПоПодразделениям.Текст = ТекстЗапроса;
	ЗапросПоПодразделениям.УстановитьПараметр("Ссылка",Подразделение);
	ЗапросПоПодразделениям.УстановитьПараметр("СсылкаРодитель",Подразделение.Родитель);
	ЗапросПоПодразделениям.УстановитьПараметр("СсылкаРодительРодитель",Подразделение.Родитель.Родитель);
	
	ВыгрузкаПодразделений = ЗапросПоПодразделениям.Выполнить().Выгрузить();
			
	Возврат ВыгрузкаПодразделений;
	
КонецФункции

Функция ОпределитьДолжность(Должность)
	
	ЗапросПоДолжностям = Новый Запрос;
	ТекстЗапроса = "ВЫБРАТЬ
	               |	ДополнительныеСведения.Объект,
	               |	ДополнительныеСведения.Свойство КАК Свойство,
	               |	ДополнительныеСведения.Значение КАК Значение
	               |ИЗ
	               |	РегистрСведений.ДополнительныеСведения КАК ДополнительныеСведения
	               |ГДЕ
	               |	ДополнительныеСведения.Объект = &Объект";
	ЗапросПоДолжностям.Текст = ТекстЗапроса;
	ЗапросПоДолжностям.УстановитьПараметр("Объект",Должность);
	
	ВыгрузкаДолжностей = ЗапросПоДолжностям.Выполнить().Выгрузить();
		
	Возврат ВыгрузкаДолжностей;	
	
КонецФункции

Функция ПолучитьТабличныйДокументЗаявления(Макет, МассивОбъектов, ОбъектыПечати)
	
	ТабДокумент = Новый ТабличныйДокумент;
	
	Если ТипЗнч(МассивОбъектов) <> Тип("Массив") И МассивОбъектов.Количество() <> 0 Тогда 
		Возврат Неопределено;
	КонецЕсли;
	
	ОбъединенныеНачисления = МассивОбъектов[0].Сотрудники.Выгрузить();
	
	ОбъединенныеНачисления.Свернуть("Сотрудник,Дата", "ОтработаноЧасов");
	
	ЗаполнитьПодразделение(ОбъединенныеНачисления,МассивОбъектов[0].Дата);
	
	Для каждого стр из ОбъединенныеНачисления Цикл
		
		Сотрудник = стр.Сотрудник;
		ДатаВыхода = стр.Дата;
		
		ШапкаДокумента = Макет.ПолучитьОбласть("Шапка");
		
		ШапкаДокумента.Параметры.ФИО = СокрЛП(стр.Сотрудник);
		РезультатСклонения = "";
		ФизическиеЛицаЗарплатаКадры.Просклонять(ШапкаДокумента.Параметры.ФИО,2,ШапкаДокумента.Параметры.ФИОРодПадеж,стр.Сотрудник.ФизическоеЛицо.Пол);
		
		ДанныеПоСотруднику = ПолучитьДанныеСотрудника(стр.Сотрудник, стр.Дата);
		Если ДанныеПоСотруднику.Количество() <> 0 Тогда
			ТаблицаДолжностей	 = ОпределитьДолжность(ДанныеПоСотруднику.Должность);
			ДолжностьВРодПадеже = "";
			Для Каждого СтрокаДолжности Из ТаблицаДолжностей Цикл 
				Если СтрокаДолжности.Свойство.Заголовок = "Родительный падеж" Тогда 
					ДолжностьВРодПадеже = СтрокаДолжности.Значение;
				КонецЕсли;
			КонецЦикла;
			ШапкаДокумента.Параметры.Должность = ДолжностьВРодПадеже;
			
			ТаблицаПодразделений = ОпределитьПодразделение(ДанныеПоСотруднику.Подразделение);
			ПодразделениеВПадеже = "";
			Для Каждого СтрокаПодразделения Из ТаблицаПодразделений Цикл 
				Если СтрокаПодразделения.Свойство.Заголовок = "Родительный падеж" Тогда 
					ПодразделениеВПадеже=ПодразделениеВПадеже + СокрЛП(СтрокаПодразделения.Значение) + " ";
				КонецЕсли;
			КонецЦикла;	
			ШапкаДокумента.Параметры.Подразделение = СокрЛП(ПодразделениеВПадеже);			
		КонецЕсли;
		
		ШапкаДокумента.Параметры.ДатаРаботы = Формат(стр.Дата, "ДЛФ=Д");
		ШапкаДокумента.Параметры.Дата = Формат(МассивОбъектов[0].Дата, "ДЛФ=Д");
		
		//ОтветсвтенноеЛицо = Новый Запрос("ВЫБРАТЬ
		//|	СведенияОбОтветственныхЛицахСрезПоследних.Руководитель
		//|ИЗ
		//|	РегистрСведений.СведенияОбОтветственныхЛицах.СрезПоследних(&Дата, ) КАК СведенияОбОтветственныхЛицахСрезПоследних");
		//ОтветсвтенноеЛицо.УстановитьПараметр("Дата",МассивОбъектов[0].Дата);
		//ВыборкаПоОтв = ОтветсвтенноеЛицо.Выполнить().Выбрать();
		
		//Если ВыборкаПоОтв.Следующий() Тогда 			
		//	ФизическиеЛицаЗарплатаКадры.Просклонять(ВыборкаПоОтв.Руководитель.Наименование, 3,ШапкаДокумента.Параметры.РукФИОДатПадеж,ВыборкаПоОтв.Руководитель.Пол);
		//КонецЕсли;
		
		ШапкаДокумента.Параметры.Организация = МассивОбъектов[0].Организация.НаименованиеСокращенное;
		
		ТабДокумент.Вывести(ШапкаДокумента);
		ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		
	КонецЦикла;

	ТабДокумент.ОриентацияСтраницы 	= ОриентацияСтраницы.Портрет;
	ТабДокумент.АвтоМасштаб 		= Истина;
	ТабДокумент.ТолькоПросмотр 		= Истина;
	ТабДокумент.ОтображатьСетку 	= Ложь;
	ТабДокумент.ОтображатьЗаголовки = Ложь;
	Возврат ТабДокумент;
	
КонецФункции 

Процедура ЗаполнитьПодразделение(Таблица, Дата)
	
	МассивСотрудников = Таблица.ВыгрузитьКолонку("Сотрудник");
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	КадроваяИсторияСотрудниковСрезПоследних.Подразделение,
	                      |	КадроваяИсторияСотрудниковСрезПоследних.Сотрудник
	                      |ИЗ
	                      |	РегистрСведений.КадроваяИсторияСотрудников.СрезПоследних(&Дата, Сотрудник В (&Сотрудник)) КАК КадроваяИсторияСотрудниковСрезПоследних");
	Запрос.УстановитьПараметр("Дата",Дата);					  
	Запрос.УстановитьПараметр("Сотрудник",МассивСотрудников);				
	ТаблицаПодразделений = Запрос.Выполнить().Выгрузить();
	
	Таблица.Колонки.Добавить("Подразделение");
	
	Для Каждого Строка Из Таблица Цикл 
		СтрокаТаблицы = ТаблицаПодразделений.Найти(Строка.Сотрудник);
		Если СтрокаТаблицы<>Неопределено Тогда 
			Строка.Подразделение = СтрокаТаблицы.Подразделение;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьДанныеСотрудника(Сотрудник, Дата)
	
	запрос = новый запрос;
	запрос.Текст =
	"ВЫБРАТЬ
	|	КадроваяИсторияСотрудниковСрезПоследних.Подразделение,
	|	КадроваяИсторияСотрудниковСрезПоследних.Должность
	|ИЗ
	|	РегистрСведений.КадроваяИсторияСотрудников.СрезПоследних(&Дата, Сотрудник = &Сотрудник) КАК КадроваяИсторияСотрудниковСрезПоследних";
	запрос.УстановитьПараметр("Дата", Дата);
	запрос.УстановитьПараметр("Сотрудник", Сотрудник);
	выборка = запрос.Выполнить().Выбрать();
	выборка.Следующий();
	возврат выборка;
	
КонецФункции
	