﻿/////////////////////////////////////////////////////////////////////////
///////СВЕДЕНИЯ ОБ ОБРАБОТКЕ

Функция ПолучитьТаблицуКоманд()
	
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
	МассивНазначений.Добавить("Документ.КадровыйПеревод");
	ПараметрыРегистрации.Вставить("Вид", "ПечатнаяФорма"); //может быть - ЗаполнениеОбъекта, ДополнительныйОтчет, СозданиеСвязанныхОбъектов... 
	ПараметрыРегистрации.Вставить("Назначение", МассивНазначений);
	ПараметрыРегистрации.Вставить("Наименование", " Т5 (собственный) "); //имя под которым обработка будет зарегестрирована в справочнике внешних обработок
	ПараметрыРегистрации.Вставить("Версия", "1.0");
	ПараметрыРегистрации.Вставить("БезопасныйРежим", Ложь);
	ПараметрыРегистрации.Вставить("Информация", " ППФ Т5 (собственный)");//так будет выглядеть описание печ.формы для пользователя
	ТаблицаКоманд = ПолучитьТаблицуКоманд();
	ДобавитьКоманду(ТаблицаКоманд, "ППФ Т5 (собственный)", "Т5_Собственный", "ВызовСерверногоМетода", Истина);
	ПараметрыРегистрации.Вставить("Команды", ТаблицаКоманд);
	Возврат ПараметрыРегистрации;
КонецФункции

/////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////
///////СЕРВИСНЫЕ ПРОЦЕДУРЫ И ФУКНЦИИ

// Процедура печати документа.
// Возвращает табличный документ - сформированную печатную форму приказа о приеме или увольнении 
//
// Параметры:
//	МассивОбъектов - массив сотрудников
//  ОбъектыПечати  - Список значений  - Объекты печати (значение - ссылка на объект, представление - имя области в которой был выведен объект)
//	ВидПриказа     - "ПриказОПриеме" или "ПриказОбУвольнении"
//
// Возвращаемое значение:
//	Табличный документ
//
Функция ПолучитьТабличныйДокументПриказаТ5(Макет, МассивОбъектов, ОбъектыПечати)
	
	ДокументРезультат = Новый ТабличныйДокумент;
	НомерСтрокиНачало = ДокументРезультат.ВысотаТаблицы + 1;

	МассивДанныхЗаполнения = ПолучитьДанныеДляПечатиКадровогоПриказаТ5(МассивОбъектов);
	
	ВывестиДанныеКадровогоПриказаВТабличныйДокумент(Макет, ДокументРезультат, МассивДанныхЗаполнения, ОбъектыПечати);
	
	Возврат ДокументРезультат;

КонецФункции 

Функция ПолучитьДанныеДляПечатиКадровогоПриказаТ5(МассивОбъектов)
		
	МассивПараметров = Новый Массив;	
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	КадровыйПеревод.Номер,
	               |	КадровыйПеревод.Дата,
	               |	КадровыйПеревод.Организация.КодПоОКПО КАК КодПоОКПО,
	               |	КадровыйПеревод.Организация.НаименованиеПолное КАК НазваниеОрганизации,
	               |	КадровыйПеревод.ДатаНачала,
	               |	КадровыйПеревод.Сотрудник.Наименование КАК Сотрудник,
	               |	КадровыйПеревод.Должность,
	               |	КадровыйПеревод.Подразделение,
	               |	КадровыйПеревод.Комментарий КАК НомерИзКом,
	               |	ПриемНаРаботу.ТрудовойДоговорНомер,
	               |	ПриемНаРаботу.ТрудовойДоговорДата,
	               |	СведенияОбОтветственныхЛицахСрезПоследних.ДолжностьРуководителя,
	               |	ФИОФизическихЛицСрезПоследних.Фамилия,
	               |	ФИОФизическихЛицСрезПоследних.Имя,
	               |	ФИОФизическихЛицСрезПоследних.Отчество,
	               |	КадровыйПеревод.СовокупнаяТарифнаяСтавка КАК ТарифнаяСтавка,
	               |	КадровыйПеревод.ФизическоеЛицо.Пол КАК Пол,
	               |	КадровыйПеревод.Ссылка
	               |ИЗ
	               |	Документ.КадровыйПеревод КАК КадровыйПеревод
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПриемНаРаботу КАК ПриемНаРаботу
	               |		ПО КадровыйПеревод.Сотрудник = ПриемНаРаботу.Сотрудник,
	               |	РегистрСведений.СведенияОбОтветственныхЛицах.СрезПоследних КАК СведенияОбОтветственныхЛицахСрезПоследних
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ФИОФизическихЛиц.СрезПоследних КАК ФИОФизическихЛицСрезПоследних
	               |		ПО СведенияОбОтветственныхЛицахСрезПоследних.Руководитель = ФИОФизическихЛицСрезПоследних.ФизическоеЛицо
	               |ГДЕ
	               |	КадровыйПеревод.Ссылка В(&Ссылка)";
	Запрос.УстановитьПараметр("Ссылка",МассивОбъектов);				   
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда 
		Выборка = Результат.Выбрать();
		Если Выборка.Следующий() Тогда 
			
			// Получим должность и подразделение
			Должность = "";
			Подразделение = "";
			СписокДолжностей 	= ПолучитьДолжности(Выборка.Должность);
			СписокПодразделений = ПолучитьПодразделения(Выборка.Подразделение);
			Для Каждого СтрокаДолжности Из СписокДолжностей Цикл 
				Если СтрокаДолжности.Свойство.Заголовок = "Дательный падеж" Тогда 
					Должность = "" + СтрокаДолжности.Значение;
				КонецЕсли;
			КонецЦикла;
			Для Каждого СтрокаПодразделения ИЗ СписокПодразделений Цикл 
				Если СтрокаПодразделения.Свойство.Заголовок = "Родительный падеж" Тогда 
					Подразделение = Подразделение + " "+СтрокаПодразделения.Значение;
				КонецЕсли;
			КонецЦикла;
			Должность = НРег(СокрЛП(Должность));
			Подразделение = СокрЛП(Подразделение);
			
			ДатаТД = Выборка.ТрудовойДоговорДата;
			ПредставлениеДатыТрудовогоДоговора = Формат(ДатаТД, "ДЛФ=DD");
			ТрудовойДоговорЧисло    = ?(ЗначениеЗаполнено(ДатаТД), СокрЛП(Лев(ПредставлениеДатыТрудовогоДоговора,2)), "        ");
			ТрудовойДоговорМесяцГод = ?(ЗначениеЗаполнено(ДатаТД), НРЕГ(СокрЛП(Прав(ПредставлениеДатыТрудовогоДоговора, СтрДлина(ПредставлениеДатыТрудовогоДоговора)-2))), "                                г.");
			
			Работник = "";
			ФизическиеЛицаЗарплатаКадры.Просклонять(Выборка.Сотрудник, 3, Работник, Выборка.Пол);
			
			ФИОРуководителя = "";
			
			ФИОРуководителя = Лев(Выборка.Имя,1)+"."+Лев(Выборка.Отчество,1)+"."+Выборка.Фамилия;
			
			Параметры = Новый Структура;
			Параметры.Вставить("Ссылка",					Выборка.Ссылка);			
			Параметры.Вставить("КодПоОКПО",					Выборка.КодПоОКПО);
			Параметры.Вставить("НазваниеОрганизации",		Выборка.НазваниеОрганизации);
			Параметры.Вставить("НомерДок",					Выборка.Номер);
			Параметры.Вставить("ДатаДок",					Выборка.Дата);
			Параметры.Вставить("ДатаНачала",				Формат(Выборка.ДатаНачала,"ДФ=dd.MM.yyyy"));
			Параметры.Вставить("Работник",					Работник);
			Параметры.Вставить("НоваяДолжность",			Должность);
			Параметры.Вставить("НовоеПодразделение",		Подразделение);
			Параметры.Вставить("ОкладТарифнаяСтавка",		Выборка.ТарифнаяСтавка);
			Параметры.Вставить("НомерИзКом",				Выборка.НомерИзКом);
			Параметры.Вставить("ТрудовойДоговорНомер",		Выборка.ТрудовойДоговорНомер);
			Параметры.Вставить("ТрудовойДоговорЧисло",  	ТрудовойДоговорЧисло);
			Параметры.Вставить("ТрудовойДоговорМесяцГод",  	ТрудовойДоговорМесяцГод);			
			Параметры.Вставить("ДолжностьРуководителя",  	Выборка.ДолжностьРуководителя);				
			Параметры.Вставить("ФИОРуководителя",		  	ФИОРуководителя);				
			
		КонецЕсли;
		МассивПараметров.Добавить(Параметры);
	КонецЕсли;
	
	Возврат МассивПараметров;

КонецФункции	
  
Процедура ВывестиДанныеКадровогоПриказаВТабличныйДокумент(Макет, ТабличныйДокумент, МассивДанныхЗаполнения, ОбъектыПечати)
	
	Если Макет <> Неопределено Тогда
		
		Для каждого ПараметрыМакета из МассивДанныхЗаполнения Цикл
			
			НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
			
			Макет.Параметры.Заполнить(ПараметрыМакета);
			ТабличныйДокумент.Вывести(Макет);
			
			УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ПараметрыМакета.Ссылка);	
			
			ТабличныйДокумент.Автомасштаб = Истина;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры	

Функция ПолучитьДолжности(Должность)
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	|	ДополнительныеСведения.Свойство,
	|	ДополнительныеСведения.Значение
	|ИЗ
	|	РегистрСведений.ДополнительныеСведения КАК ДополнительныеСведения
	|ГДЕ
	|	ДополнительныеСведения.Объект = &Объект";
	Запрос.УстановитьПараметр("Объект",Должность);
	Результат = Запрос.Выполнить();
	Таблица = Результат.Выгрузить();
	Возврат Таблица;
КонецФункции

Функция ПолучитьПодразделения(Подразделение)
	
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
	
	Таблица = ЗапросПоПодразделениям.Выполнить().Выгрузить();
			
	Возврат Таблица;
	
КонецФункции


/////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////
///////ПРОЦЕДУРА ПЕЧАТИ

Процедура Печать(МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Макет = ПолучитьМакет("Т5_Собственный");
	
	УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
	"Т5_Собственный", "ППФ Т5 (собственный)",	ПолучитьТабличныйДокументПриказаТ5(Макет,МассивОбъектов, ОбъектыПечати));
	
КонецПроцедуры

/////////////////////////////////////////////////////////////////////////

