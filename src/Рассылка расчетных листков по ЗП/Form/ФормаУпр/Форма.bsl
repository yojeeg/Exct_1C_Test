﻿#Область КомандыФормы

&НаКлиенте
Процедура Заполнить(Команда)
	ЗаполнитьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура НастроитьПериод(Команда)
	Диалог = Новый ДиалогРедактированияСтандартногоПериода();
	//Диалог.Период = ПеременнаяТипаСтандартныйПериод;
	Если Диалог.Редактировать() Тогда 
		ПеременнаяТипаСтандартныйПериод = Диалог.Период;
	Иначе 
		Возврат;
	КонецЕсли;
	Объект.ДатаНач = ПеременнаяТипаСтандартныйПериод.ДатаНачала;
	Объект.ДатаКон = ПеременнаяТипаСтандартныйПериод.ДатаОкончания;
	
КонецПроцедуры

&НаКлиенте
Процедура Отправить(Команда)
		
	Для Каждого Строка Из Объект.Работники Цикл 
		ТабличныеДокументыАдреса = Новый СписокЗначений;
		Отправить_Сервер(ТабличныеДокументыАдреса,Строка.Физлицо, Строка.Адрес);
		
		Для Каждого ТаблДок из ТабличныеДокументыАдреса Цикл
			Вложения.Очистить();
			Если Вложения.Количество()<>0 Тогда 
				Сообщить("Невозможно очистить список вложений расчетных листков. Действие обработки прекращено. Обратитесь к разработчику 1С.");
				Возврат;
			КонецЕсли;
			ТабличныеДокументы = Новый СписокЗначений;
			ТабличныеДокументы.Добавить(ТаблДок.Значение, "Расчетный листок");
			ОтправкаСообщения(ТабличныеДокументы, ТаблДок.Представление);
		КонецЦикла;
	КонецЦикла;

	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЗаполнитьПараметрыПоУмолчанию_сервер();	
КонецПроцедуры

&НаКлиенте
Процедура РаботникиФизлицоПриИзменении(Элемент)
	Элементы.Работники.ТекущиеДанные.Адрес = ПолучитьАдрес(Элементы.Работники.ТекущиеДанные.Физлицо);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьПараметрыПоУмолчанию_сервер()
	ЗаполнитьОрганизациюПоУмолчанию();
	ЗаполнитьДатыПоУмолчанию();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОрганизациюПоУмолчанию()
	
	Объект.Организация = Справочники.Организации.ОрганизацияПоУмолчанию();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДатыПоУмолчанию()
	Объект.Период.Вариант = ВариантСтандартногоПериода.ПрошлыйМесяц;		
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере()
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	Сотрудники.Ссылка КАК Физлицо,
	               |	ВложенныйЗапрос.АдресЭП КАК Адрес
	               |ИЗ
	               |	Справочник.Сотрудники КАК Сотрудники
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ТекущиеКадровыеДанныеСотрудников КАК ТекущиеКадровыеДанныеСотрудников
	               |		ПО (ТекущиеКадровыеДанныеСотрудников.Сотрудник = Сотрудники.Ссылка)
	               |		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	               |			ФизическиеЛицаКонтактнаяИнформация.АдресЭП КАК АдресЭП,
	               |			ФизическиеЛицаКонтактнаяИнформация.Ссылка КАК Ссылка
	               |		ИЗ
	               |			Справочник.ФизическиеЛица.КонтактнаяИнформация КАК ФизическиеЛицаКонтактнаяИнформация
	               |		ГДЕ
	               |			ФизическиеЛицаКонтактнаяИнформация.Вид = &ВидКИ) КАК ВложенныйЗапрос
	               |		ПО Сотрудники.ФизическоеЛицо = ВложенныйЗапрос.Ссылка
	               |ГДЕ
	               |	ТекущиеКадровыеДанныеСотрудников.ДатаПриема <> ДАТАВРЕМЯ(1, 1, 1)
	               |	И ТекущиеКадровыеДанныеСотрудников.ДатаУвольнения = ДАТАВРЕМЯ(1, 1, 1)
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Сотрудники.ФизическоеЛицо.Наименование";
	Запрос.УстановитьПараметр("ВидКИ",Справочники.ВидыКонтактнойИнформации.EMailФизическиеЛица);				   
	Выгрузка = Запрос.Выполнить().Выгрузить();
	
	Объект.Работники.Загрузить(Выгрузка);
КонецПроцедуры

&НаСервере
Функция ПолучитьАдрес(ФизЛицо)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Сотрудники.Ссылка КАК Физлицо,
	               |	ВложенныйЗапрос.АдресЭП КАК Адрес
	               |ИЗ
	               |	Справочник.Сотрудники КАК Сотрудники
	               |		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	               |			ФизическиеЛицаКонтактнаяИнформация.АдресЭП КАК АдресЭП,
	               |			ФизическиеЛицаКонтактнаяИнформация.Ссылка КАК Ссылка
	               |		ИЗ
	               |			Справочник.ФизическиеЛица.КонтактнаяИнформация КАК ФизическиеЛицаКонтактнаяИнформация
	               |		ГДЕ
	               |			ФизическиеЛицаКонтактнаяИнформация.Вид = &ВидКИ) КАК ВложенныйЗапрос
	               |		ПО Сотрудники.ФизическоеЛицо = ВложенныйЗапрос.Ссылка
	               |ГДЕ
	               |	Сотрудники.Ссылка = &Ссылка
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Сотрудники.ФизическоеЛицо.Наименование";
	Запрос.УстановитьПараметр("ВидКИ",Справочники.ВидыКонтактнойИнформации.EMailФизическиеЛица);
	Запрос.УстановитьПараметр("Ссылка",ФизЛицо);	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда 
		Возврат Выборка.Адрес;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

&НаКлиенте
Процедура ОтправкаСообщения(ТабличныеДокументы, Адрес)
	
	ФорматыСохранения = Новый Массив;
	ФорматыСохранения.Добавить(ТипФайлаТабличногоДокумента.PDF);	
	ПараметрыОтправки = Новый Структура;
	ПараметрыОтправки.Вставить("Тема", "Расчетный листок");
	ПараметрыОтправки.Вставить("Вложения", ПоместитьТабличныеДокументыВоВременноеХранилище(ФорматыСохранения,ТабличныеДокументы));
	ПараметрыОтправки.Вставить("УдалятьФайлыПослеОтправки", Истина);	
	ПараметрыОтправки.Вставить("Кому", Адрес);
	
	Если Вложения.Количество()<>0 Тогда 
		Сообщить("Невозможно очистить список вложений расчетных листков. Действие обработки прекращено. Обратитесь к разработчику 1С.");
		Возврат;
	КонецЕсли;
	
	Для Каждого Вложение Из ПараметрыОтправки.Вложения Цикл
		ОписаниеВложения = Вложения.Добавить();
		Если ТипЗнч(ПараметрыОтправки.Вложения) = Тип("СписокЗначений") Тогда
			ОписаниеВложения.Представление = Вложение.Представление;
			Если ТипЗнч(Вложение.Значение) = Тип("ДвоичныеДанные") Тогда
				ОписаниеВложения.АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(Вложение.Значение, УникальныйИдентификатор);
			Иначе
				Если ЭтоАдресВременногоХранилища(Вложение.Значение) Тогда
					ОписаниеВложения.АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(ПолучитьИзВременногоХранилища(Вложение.Значение), УникальныйИдентификатор);
				Иначе
					ОписаниеВложения.ПутьКФайлу = Вложение.Значение;
				КонецЕсли;
			КонецЕсли;
		Иначе // ТипЗнч(Параметры.Вложения) = "массив структур"
			ЗаполнитьЗначенияСвойств(ОписаниеВложения, Вложение);
			Если Не ПустаяСтрока(ОписаниеВложения.АдресВоВременномХранилище) Тогда
				ОписаниеВложения.АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(
				ПолучитьИзВременногоХранилища(ОписаниеВложения.АдресВоВременномХранилище), УникальныйИдентификатор);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если ТипЗнч(ПараметрыОтправки.Кому) = Тип("СписокЗначений") Тогда
		ПочтовыйАдресПолучателя = "";
		Для Каждого ЭлементПочтовыйАдрес Из ПараметрыОтправки.Кому Цикл
			Если ЗначениеЗаполнено(ЭлементПочтовыйАдрес.Представление) Тогда 
				ПочтовыйАдресПолучателя = ПочтовыйАдресПолучателя
				+ ЭлементПочтовыйАдрес.Представление
				+ " <"
				+ ЭлементПочтовыйАдрес.Значение
				+ ">; "
			Иначе
				ПочтовыйАдресПолучателя = ПочтовыйАдресПолучателя 
				+ ЭлементПочтовыйАдрес.Значение
				+ "; ";
			КонецЕсли;
		КонецЦикла;
	ИначеЕсли ТипЗнч(ПараметрыОтправки.Кому) = Тип("Строка") Тогда
		ПочтовыйАдресПолучателя = ПараметрыОтправки.Кому;
	ИначеЕсли ТипЗнч(ПараметрыОтправки.Кому) = Тип("Массив") Тогда
		Для Каждого СтруктураПолучателя Из ПараметрыОтправки.Кому Цикл
			МассивАдресов = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтруктураПолучателя.Адрес, ";");
			Для Каждого Адрес Из МассивАдресов Цикл
				Если ПустаяСтрока(Адрес) Тогда 
					Продолжить;
				КонецЕсли;
				ПочтовыйАдресПолучателя = ПочтовыйАдресПолучателя + СтруктураПолучателя.Представление + " <" + СокрЛП(Адрес) + ">; ";
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
	Попытка
		ПриведенныйПочтовыйАдрес = ОбщегоНазначенияКлиентСервер.РазобратьСтрокуСПочтовымиАдресами(ПочтовыйАдресПолучателя);
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
		КраткоеПредставлениеОшибки(ИнформацияОбОшибке()), ,
		ПочтовыйАдресПолучателя);
		Возврат;
	КонецПопытки;
	
	ПараметрыПисьма = Новый Структура;
	ПараметрыПисьма.Вставить("Кому", ПриведенныйПочтовыйАдрес);
	ПараметрыПисьма.Вставить("Тема", "Расчетный лист");	
	ПараметрыПисьма.Вставить("Вложения", Вложения());
	ПараметрыПисьма.Вставить("Тело", "Во вложении находится расчетный листок. Сообщение сформировано автоматически из системы 1С:ЗУП. Отвечать на письмо не требуется.");
	
	УчетнаяЗапись = ПолучитьУчетнуюЗапись();
	
	Попытка
		ОтправитьПочтовоеСообщение(УчетнаяЗапись, ПараметрыПисьма);
		Сообщить("Сообщения отпарвлены на " + Адрес);
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		Возврат;
	КонецПопытки;

КонецПроцедуры

&НаКлиенте
Функция Вложения()
	
	Результат = Новый Массив;
	Для Каждого Вложение Из Вложения Цикл
		ОписаниеВложения = Новый Структура;
		ОписаниеВложения.Вставить("Представление", Вложение.Представление);
		ОписаниеВложения.Вставить("АдресВоВременномХранилище", Вложение.АдресВоВременномХранилище);
		ОписаниеВложения.Вставить("Кодировка", Вложение.Кодировка);
		Результат.Добавить(ОписаниеВложения);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ПолучитьУчетнуюЗапись()
	ДоступныеУчетныеЗаписи = РаботаСПочтовымиСообщениями.ДоступныеУчетныеЗаписи(Истина);
	Если ДоступныеУчетныеЗаписи.Количество() = 0 Тогда
		ТекстСообщения = НСтр("ru = 'Не обнаружены доступные учетные записи электронной почты, обратитесь к администратору системы.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,,);
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ДоступныеУчетныеЗаписи[0].Ссылка;

КонецФункции

&НаСервере
Процедура Отправить_Сервер(ТабличныйДокумент, Физлицо, Адрес)
	ТаблицаЗначений = Новый ТаблицаЗначений;
	ТаблицаЗначений.Колонки.Добавить("Физлицо");
	ТаблицаЗначений.Колонки.Добавить("Адрес");
	НоваяСтрока = ТаблицаЗначений.Добавить();
	НоваяСтрока.Физлицо 	= Физлицо;
	НоваяСтрока.Адрес 		= Адрес;
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	ОбработкаОбъект.Отправить(НоваяСтрока, ТабличныйДокумент);
	
КонецПроцедуры

&НаСервере
Функция ПоместитьТабличныеДокументыВоВременноеХранилище(ВыбранныеФорматыСохранения, ТабличныеДокументы)
	Результат = Новый СписокЗначений;
	
	// Каталог временных файлов
	ИмяВременнойПапки = ПолучитьИмяВременногоФайла();
	СоздатьКаталог(ИмяВременнойПапки);
	ПолныйПутьКФайлу = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ИмяВременнойПапки);
	
	// Сохранение табличных документов.
	Для Каждого ТабличныйДокумент Из ТабличныеДокументы Цикл
		
		Если ТабличныйДокумент.Значение.Вывод = ИспользованиеВывода.Запретить Тогда
			Продолжить;
		КонецЕсли;
		
		Для Каждого ТипФайла Из ВыбранныеФорматыСохранения Цикл
			
			ИмяФайла = ТабличныйДокумент.Представление + ".pdf";
			ПолноеИмяФайла = ПолныйПутьКФайлу + ИмяФайла;
			
			ТабличныйДокумент.Значение.Записать(ПолноеИмяФайла, ТипФайла);
			
			Результат.Добавить(ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ПолноеИмяФайла), УникальныйИдентификатор), ИмяФайла);
		КонецЦикла;
		
	КонецЦикла;
	
	
	УдалитьФайлы(ИмяВременнойПапки);
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ОтправитьПочтовоеСообщение(Знач УчетнаяЗапись, Знач ПараметрыПисьма)
	
	Возврат РаботаСПочтовымиСообщениями.ОтправитьПочтовоеСообщение(УчетнаяЗапись, ПараметрыПисьма);
	
КонецФункции

#КонецОбласти

