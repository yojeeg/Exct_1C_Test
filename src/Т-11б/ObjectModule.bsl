﻿Функция ПолучитьТаблицуКоманд()
	
	Команды = Новый ТаблицаЗначений;
	Команды.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка"));
	Команды.Колонки.Добавить("Идентификатор", Новый ОписаниеТипов("Строка"));
	Команды.Колонки.Добавить("Использование", Новый ОписаниеТипов("Строка"));
	Команды.Колонки.Добавить("ПоказыватьОповещение", Новый ОписаниеТипов("Булево"));
	Команды.Колонки.Добавить("Модификатор", Новый ОписаниеТипов("Строка"));
	
	Возврат Команды;
	
КонецФункции

//Создает в таблице команд новую строку

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
	МассивНазначений.Добавить("Документ.Премия");
	МассивНазначений.Добавить("Документ.РазовоеНачисление");
	ПараметрыРегистрации.Вставить("Вид", "ПечатнаяФорма");
	ПараметрыРегистрации.Вставить("Назначение", МассивНазначений);
	ПараметрыРегистрации.Вставить("Наименование", " Приказ о премировании Т-11б"); 
	ПараметрыРегистрации.Вставить("Версия", "1.0");
	ПараметрыРегистрации.Вставить("БезопасныйРежим", Ложь);
	ПараметрыРегистрации.Вставить("Информация", " Приказ о премировании Т-11б ");
	ТаблицаКоманд = ПолучитьТаблицуКоманд();
	ДобавитьКоманду(ТаблицаКоманд, "ППФ Приказ о премировании (Т-11б)", "ПФ_MXL_Т11б", "ВызовСерверногоМетода", Истина, "ПечатьMXL");
	ПараметрыРегистрации.Вставить("Команды", ТаблицаКоманд);
	Возврат ПараметрыРегистрации;
КонецФункции

Процедура Печать(МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Макет = ПолучитьМакет("ПФ_MXL_Т11б");
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_Т11б") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
		"ПФ_MXL_Т11б", "Приказ о премировании Т-11б",	ТабличныйДокументПриказОПоощренииСотрудника(Макет,МассивОбъектов, ОбъектыПечати));
	КонецЕсли;
	
КонецПроцедуры

Функция ТабличныйДокументПриказОПоощренииСотрудника(Макет, МассивОбъектов, ОбъектыПечати)
	
	НастройкиПечатныхФорм = ЗарплатаКадрыПовтИсп.НастройкиПечатныхФорм();
	
	ОбластьМакетаПриказ = Макет.ПолучитьОбласть("Приказ");
	
	ДокументРезультат = Новый ТабличныйДокумент;
	
	ДокументРезультат.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_Премия_Т11";
	ДокументРезультат.ОриентацияСтраницы= ОриентацияСтраницы.Портрет;
	ДокументРезультат.АвтоМасштаб = Истина;
	
	ВалютаУчета = ЗарплатаКадры.ВалютаУчетаЗаработнойПлаты();
	
	// получаем данные для печати
	ДанныеДляПечати = ДанныеДляПечатиОПоощренииСотрудника(МассивОбъектов).Выбрать();
	Пока ДанныеДляПечати.СледующийПоЗначениюПоля("Ссылка") Цикл
		
		ПервыйДокумент = Истина;
		Пока ДанныеДляПечати.Следующий() Цикл
			
			Если ПервыйДокумент Тогда
				ПервыйДокумент = Ложь;
			Иначе
				// Все документы нужно выводить на разных страницах.
				ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
			КонецЕсли;
			
			// Запомним номер строки, с которой начали выводить текущий документ.
			НомерСтрокиНачало = ДокументРезультат.ВысотаТаблицы + 1;
			
			ОбластьМакетаПриказ.Параметры.Заполнить(ДанныеДляПечати);
			
			// Подразделение
			Если ЗначениеЗаполнено(ДанныеДляПечати.Подразделение) Тогда 
				Подразделение = ДанныеДляПечати.Подразделение;
				
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
				
				СтрокаПодразделения = "";
				МассивУровней = Новый Массив;
				МассивУровней.Добавить("1");
				МассивУровней.Добавить("2");
				МассивУровней.Добавить("3");
				Для Каждого УровеньВложенности из МассивУровней Цикл 
					Отбор = Новый Структура("УровеньВложенности",УровеньВложенности);
					ТаблицаСОтбором = ВыгрузкаПодразделений.Скопировать(Отбор);
					Если УровеньВложенности = "1" И ТаблицаСОтбором.Количество()=0 Тогда 
						СтрокаПодразделения = Подразделение;
						Прервать;
					КонецЕсли;
					
					Если УровеньВложенности = "1" Тогда 
						Для Каждого Строка из ТаблицаСОтбором Цикл 
							Если Строка.Свойство.Заголовок = "Винительный падеж" Тогда 
								СтрокаПодразделения = СтрокаПодразделения + " " + Строка.Значение;
							КонецЕсли;
						КонецЦикла;
					Иначе 
						Для Каждого Строка из ТаблицаСОтбором Цикл 
							Если Строка.Свойство.Заголовок = "Родительный падеж" Тогда 
								СтрокаПодразделения = СтрокаПодразделения + " " + Строка.Значение;
							КонецЕсли;
						КонецЦикла;	
					КонецЕсли;
				КонецЦикла;
				ОбластьМакетаПриказ.Параметры.Подразделение = СтрокаПодразделения;
			КонецЕсли;
			
			
			ОбластьМакетаПриказ.Параметры.НомерДокумента = КадровыйУчетРасширенный.НомерКадровогоПриказа(ДанныеДляПечати.НомерДокумента);
			ОбластьМакетаПриказ.Параметры.Сотрудник = ДанныеДляПечати.ФИОПолные;
					
			ОбластьМакетаПриказ.Параметры.ПредставлениеВеличины = РаботаСКурсамиВалют.СформироватьСуммуПрописью(ДанныеДляПечати.Результат, ВалютаУчета);
			ОбластьМакетаПриказ.Параметры.СуммаРублей = Цел(ДанныеДляПечати.Результат);
			СуммаКопеек = (ДанныеДляПечати.Результат - Цел(ДанныеДляПечати.Результат)) * 100;
			ОбластьМакетаПриказ.Параметры.СуммаКопеек = ?(СуммаКопеек=0,"00",СуммаКопеек);
			
			ОбщаяСумма = ДанныеДляПечати.Результат + ДанныеДляПечати.Результат * ?(ЗначениеЗаполнено(ДанныеДляПечати.СевернаяНадбавка),ДанныеДляПечати.СевернаяНадбавка/100,0) + ДанныеДляПечати.Результат*?(ЗначениеЗаполнено(ДанныеДляПечати.РайонныйКоэффициент),ДанныеДляПечати.РайонныйКоэффициент/100,0);
			ОбластьМакетаПриказ.Параметры.ПредставлениеВеличиныСКоэфф = РаботаСКурсамиВалют.СформироватьСуммуПрописью(Окр(ОбщаяСумма,2), ВалютаУчета);
			
			ОбластьМакетаПриказ.Параметры.ПредставлениеВеличиныСКоэфф = РаботаСКурсамиВалют.СформироватьСуммуПрописью(Окр(ОбщаяСумма,2), ВалютаУчета);
			
			Если НастройкиПечатныхФорм.ВыводитьПолнуюИерархиюПодразделений И ЗначениеЗаполнено(ОбластьМакетаПриказ.Параметры.Подразделение) Тогда
				ОбластьМакетаПриказ.Параметры.Подразделение = ОбластьМакетаПриказ.Параметры.Подразделение.ПолноеНаименование();
			КонецЕсли;
					
			РуководительДолжность = РегистрыСведений.СведенияОбОтветственныхЛицах.ПолучитьПоследнее(ТекущаяДата());
			ОбластьМакетаПриказ.Параметры.ДолжностьРуководителя = РуководительДолжность.ДолжностьРуководителя;
			ФИОРуководителя = РегистрыСведений.ФИОФизическихЛиц.ПолучитьПоследнее(ТекущаяДата(),Новый Структура("ФизическоеЛицо", РуководительДолжность.Руководитель));
			РуководительФамилия	 = ФИОРуководителя.Фамилия;
			РуководительИмя		 = ФИОРуководителя.Имя;
			РуководительОтчество = ФИОРуководителя.Отчество;
			ОбластьМакетаПриказ.Параметры.РуководительРасшифровкаПодписи = ""+РуководительФамилия + " " + Лев(РуководительИмя,1) + "."+лев(РуководительОтчество,1)+".";		
			ДокументРезультат.Вывести(ОбластьМакетаПриказ);
			
			// В табличном документе необходимо задать имя области, в которую был 
			// выведен объект. Нужно для возможности печати покомплектно 
			УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ДокументРезультат, НомерСтрокиНачало, ОбъектыПечати, ДанныеДляПечати.Сотрудник);
			
		КонецЦикла;
		
	КонецЦикла;
	
	ДокументРезультат.АвтоМасштаб = Истина;
	Возврат ДокументРезультат;
	
КонецФункции

Функция ДанныеДляПечатиОПоощренииСотрудника(МассивОбъектов)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("БезОтбораПоСтрокам", Истина);
	Запрос.УстановитьПараметр("ДатаСреза", МассивОбъектов[0].Дата);
	
	Если ТипЗнч(МассивОбъектов[0]) = Тип("ДокументСсылка.Премия") Тогда 
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	Неопределено КАК Ссылка,
		|	Неопределено КАК НомерСтроки
		|ПОМЕСТИТЬ ВТСтрокиДокументов";
		
		Запрос.Выполнить();
		
		Запрос.УстановитьПараметр("МассивДокументов", МассивОбъектов);
		Запрос.УстановитьПараметр("РасчетСтрокойПриз", НСтр("ru = 'Ценный приз'"));
		Запрос.УстановитьПараметр("РасчетСтрокойПодарок", НСтр("ru = 'Ценный подарок'"));
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	Премия.Ссылка КАК Ссылка,
		|	Премия.Организация КАК Организация,
		|	Премия.ПериодРегистрации КАК ПериодРегистрации,
		|	Премия.Дата КАК Дата,
		|	Премия.Дата КАК ДатаДокумента,
		|	Премия.Номер КАК НомерДокумента,
		|	ВЫБОР
		|		КОГДА Организации.НаименованиеПолное ПОДОБНО """"
		|			ТОГДА Организации.Наименование
		|		ИНАЧЕ Организации.НаименованиеПолное
		|	КОНЕЦ КАК НазваниеОрганизации,
		|	Организации.КодПоОКПО КАК КодПоОКПО,
		|	Премия.ВидПремии.Наименование КАК РасчетСтрокой,
		|	Премия.Руководитель КАК Руководитель,
		|	Премия.ДолжностьРуководителя КАК ДолжностьРуководителя,
		|	Премия.МотивПоощрения
		|ПОМЕСТИТЬ ВТДанныеШапкиДокумента
		|ИЗ
		|	Документ.Премия КАК Премия
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Организации КАК Организации
		|		ПО Премия.Организация = Организации.Ссылка
		|ГДЕ
		|	Премия.Ссылка В(&МассивДокументов)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ПризПодарок.Ссылка,
		|	ПризПодарок.Организация,
		|	ПризПодарок.ПериодРегистрации,
		|	ПризПодарок.Дата,
		|	ПризПодарок.Дата,
		|	ПризПодарок.Номер,
		|	ВЫБОР
		|		КОГДА Организации.НаименованиеПолное ПОДОБНО """"
		|			ТОГДА Организации.Наименование
		|		ИНАЧЕ Организации.НаименованиеПолное
		|	КОНЕЦ,
		|	Организации.КодПоОКПО,
		|	ВЫБОР
		|		КОГДА ПризПодарок.ВидПризаПодарка = ЗНАЧЕНИЕ(Перечисление.ВидыПризовПодарков.Приз)
		|			ТОГДА &РасчетСтрокойПриз
		|		ИНАЧЕ &РасчетСтрокойПодарок
		|	КОНЕЦ,
		|	ПризПодарок.Руководитель,
		|	ПризПодарок.ДолжностьРуководителя,
		|	ПризПодарок.МотивПоощрения
		|ИЗ
		|	Документ.ПризПодарок КАК ПризПодарок
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Организации КАК Организации
		|		ПО ПризПодарок.Организация = Организации.Ссылка
		|ГДЕ
		|	ПризПодарок.Ссылка В(&МассивДокументов)";
		
		УстановитьПривилегированныйРежим(Истина);
		Запрос.Выполнить();
		УстановитьПривилегированныйРежим(Ложь);
		
		ЗарплатаКадры.СоздатьВТФИООтветственныхЛиц(Запрос.МенеджерВременныхТаблиц, Истина, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве("Руководитель"), "ВТДанныеШапкиДокумента");
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ДанныеШапкиДокумента.Ссылка КАК Ссылка,
		|	ДанныеШапкиДокумента.ПериодРегистрации КАК ПериодРегистрации,
		|	КОНЕЦПЕРИОДА(ДанныеШапкиДокумента.ПериодРегистрации, МЕСЯЦ) КАК Период,
		|	ДанныеШапкиДокумента.ДатаДокумента КАК ДатаДокумента,
		|	ДанныеШапкиДокумента.НомерДокумента КАК НомерДокумента,
		|	ДанныеШапкиДокумента.Организация КАК Организация,
		|	ДанныеШапкиДокумента.НазваниеОрганизации КАК НазваниеОрганизации,
		|	ДанныеШапкиДокумента.КодПоОКПО КАК КодПоОКПО,
		|	ДанныеШапкиДокумента.РасчетСтрокой КАК РасчетСтрокой,
		|	ДанныеШапкиДокумента.ДолжностьРуководителя КАК ДолжностьРуководителя,
		|	ДанныеШапкиДокумента.МотивПоощрения,
		|	ФИООтветственныхЛиц.РасшифровкаПодписи КАК РуководительРасшифровкаПодписи,
		|	ЕСТЬNULL(ПремияНачисления.НомерСтроки, ПризПодарокНачисления.НомерСтроки) КАК НомерСтроки,
		|	ЕСТЬNULL(ПремияНачисления.Сотрудник, ПризПодарокНачисления.Сотрудник) КАК Сотрудник,
		|	ЕСТЬNULL(ПремияНачисления.Результат, ПризПодарокНачисления.Результат) КАК Результат
		|ПОМЕСТИТЬ ВТДанныеДокумента
		|ИЗ
		|	ВТДанныеШапкиДокумента КАК ДанныеШапкиДокумента
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТСтрокиДокументов КАК СтрокиДокументов
		|		ПО (НЕ &БезОтбораПоСтрокам)
		|			И ДанныеШапкиДокумента.Ссылка = СтрокиДокументов.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Премия.Начисления КАК ПремияНачисления
		|		ПО ДанныеШапкиДокумента.Ссылка = ПремияНачисления.Ссылка
		|			И (ВЫБОР
		|				КОГДА НЕ &БезОтбораПоСтрокам
		|					ТОГДА ПремияНачисления.НомерСтроки = СтрокиДокументов.НомерСтроки
		|				ИНАЧЕ ИСТИНА
		|			КОНЕЦ)
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПризПодарок.Начисления КАК ПризПодарокНачисления
		|		ПО ДанныеШапкиДокумента.Ссылка = ПризПодарокНачисления.Ссылка
		|			И (ВЫБОР
		|				КОГДА НЕ &БезОтбораПоСтрокам
		|					ТОГДА ПризПодарокНачисления.НомерСтроки = СтрокиДокументов.НомерСтроки
		|				ИНАЧЕ ИСТИНА
		|			КОНЕЦ)
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТФИООтветственныхЛиц КАК ФИООтветственныхЛиц
		|		ПО ДанныеШапкиДокумента.Дата = ФИООтветственныхЛиц.Дата
		|			И ДанныеШапкиДокумента.Ссылка = ФИООтветственныхЛиц.Ссылка
		|			И ДанныеШапкиДокумента.Руководитель = ФИООтветственныхЛиц.ФизическоеЛицо";
		
		УстановитьПривилегированныйРежим(Истина);
		Запрос.Выполнить();
		УстановитьПривилегированныйРежим(Ложь);
		
		ОписательВременныхТаблиц = КадровыйУчет.ОписательВременныхТаблицДляСоздатьВТКадровыеДанныеСотрудников(
		Запрос.МенеджерВременныхТаблиц,
		"ВТДанныеДокумента");
		КадровыйУчет.СоздатьВТКадровыеДанныеСотрудников(ОписательВременныхТаблиц, Истина, "ФизическоеЛицо,ФИОПолные,Подразделение,Должность,ТабельныйНомер,Пол");
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	РезультатЗапроса.Ссылка,
		|	РезультатЗапроса.ПериодРегистрации,
		|	РезультатЗапроса.ДатаДокумента,
		|	РезультатЗапроса.НомерДокумента,
		|	РезультатЗапроса.Организация,
		|	РезультатЗапроса.НазваниеОрганизации,
		|	РезультатЗапроса.КодПоОКПО,
		|	РезультатЗапроса.РасчетСтрокой,
		|	РезультатЗапроса.ДолжностьРуководителя,
		|	РезультатЗапроса.РуководительРасшифровкаПодписи,
		|	РезультатЗапроса.НомерСтроки,
		|	РезультатЗапроса.МотивПоощрения,
		|	РезультатЗапроса.Сотрудник,
		|	РезультатЗапроса.ФИОПолные,
		|	РезультатЗапроса.Результат,
		|	РезультатЗапроса.ТабельныйНомер,
		|	РезультатЗапроса.Пол,
		|	РезультатЗапроса.ФизическоеЛицо,
		|	РезультатЗапроса.Подразделение,
		|	РезультатЗапроса.Должность,
		|	РезультатЗапроса.РайонныйКоэффициент,
		|	ПроцентыСевернойНадбавкиФизическихЛицСрезПоследних.ПроцентСевернойНадбавки КАК СевернаяНадбавка
		|ИЗ
		|	(ВЫБРАТЬ
		|		ДанныеДокумента.Ссылка КАК Ссылка,
		|		ДанныеДокумента.ПериодРегистрации КАК ПериодРегистрации,
		|		ДанныеДокумента.ДатаДокумента КАК ДатаДокумента,
		|		ДанныеДокумента.НомерДокумента КАК НомерДокумента,
		|		ДанныеДокумента.Организация КАК Организация,
		|		ДанныеДокумента.НазваниеОрганизации КАК НазваниеОрганизации,
		|		ДанныеДокумента.КодПоОКПО КАК КодПоОКПО,
		|		ДанныеДокумента.РасчетСтрокой КАК РасчетСтрокой,
		|		ДанныеДокумента.ДолжностьРуководителя КАК ДолжностьРуководителя,
		|		ДанныеДокумента.РуководительРасшифровкаПодписи КАК РуководительРасшифровкаПодписи,
		|		ДанныеДокумента.НомерСтроки КАК НомерСтроки,
		|		ДанныеДокумента.МотивПоощрения КАК МотивПоощрения,
		|		КадровыеДанныеСотрудников.Сотрудник КАК Сотрудник,
		|		КадровыеДанныеСотрудников.ФИОПолные КАК ФИОПолные,
		|		ДанныеДокумента.Результат КАК Результат,
		|		КадровыеДанныеСотрудников.ТабельныйНомер КАК ТабельныйНомер,
		|		КадровыеДанныеСотрудников.Пол КАК Пол,
		|		КадровыеДанныеСотрудников.ФизическоеЛицо КАК ФизическоеЛицо,
		|		КадровыеДанныеСотрудников.Подразделение КАК Подразделение,
		|		КадровыеДанныеСотрудников.Должность КАК Должность,
		|		ВЫБОР
		|			КОГДА ЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудниковСрезПоследних.Значение = 0
		|				ТОГДА 0
		|			ИНАЧЕ ЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудниковСрезПоследних.Значение - 1
		|		КОНЕЦ КАК РайонныйКоэффициент
		|	ИЗ
		|		ВТДанныеДокумента КАК ДанныеДокумента
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТКадровыеДанныеСотрудников КАК КадровыеДанныеСотрудников
		|			ПО ДанныеДокумента.Сотрудник = КадровыеДанныеСотрудников.Сотрудник
		|				И ДанныеДокумента.Период = КадровыеДанныеСотрудников.Период
		|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудников.СрезПоследних(, Показатель = ЗНАЧЕНИЕ(Справочник.ПоказателиРасчетаЗарплаты.РайонныйКоэффициент)) КАК ЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудниковСрезПоследних
		|			ПО ДанныеДокумента.Сотрудник = ЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудниковСрезПоследних.Сотрудник
		|	ГДЕ
		|		ДанныеДокумента.Результат <> 0
		|	
		|	СГРУППИРОВАТЬ ПО
		|		ДанныеДокумента.ПериодРегистрации,
		|		ДанныеДокумента.Ссылка,
		|		ДанныеДокумента.ДатаДокумента,
		|		ДанныеДокумента.НомерДокумента,
		|		ДанныеДокумента.Организация,
		|		ДанныеДокумента.НазваниеОрганизации,
		|		ДанныеДокумента.КодПоОКПО,
		|		ДанныеДокумента.РасчетСтрокой,
		|		ДанныеДокумента.ДолжностьРуководителя,
		|		ДанныеДокумента.РуководительРасшифровкаПодписи,
		|		ДанныеДокумента.НомерСтроки,
		|		ДанныеДокумента.МотивПоощрения,
		|		КадровыеДанныеСотрудников.Сотрудник,
		|		КадровыеДанныеСотрудников.ФИОПолные,
		|		ДанныеДокумента.Результат,
		|		КадровыеДанныеСотрудников.ТабельныйНомер,
		|		КадровыеДанныеСотрудников.Пол,
		|		КадровыеДанныеСотрудников.ФизическоеЛицо,
		|		КадровыеДанныеСотрудников.Подразделение,
		|		КадровыеДанныеСотрудников.Должность,
		|		ВЫБОР
		|			КОГДА ЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудниковСрезПоследних.Значение = 0
		|				ТОГДА 0
		|			ИНАЧЕ ЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудниковСрезПоследних.Значение - 1
		|		КОНЕЦ) КАК РезультатЗапроса
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПроцентыСевернойНадбавкиФизическихЛиц.СрезПоследних(&ДатаСреза, ) КАК ПроцентыСевернойНадбавкиФизическихЛицСрезПоследних
		|		ПО РезультатЗапроса.ФизическоеЛицо = ПроцентыСевернойНадбавкиФизическихЛицСрезПоследних.ФизическоеЛицо";
		
	ИначеЕсли ТипЗнч(МассивОбъектов[0]) = Тип("ДокументСсылка.РазовоеНачисление") Тогда  
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	Неопределено КАК Ссылка,
		|	Неопределено КАК НомерСтроки
		|ПОМЕСТИТЬ ВТСтрокиДокументов";
		
		Запрос.Выполнить();
		
		Запрос.УстановитьПараметр("МассивДокументов", МассивОбъектов);
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	РазовоеНачисление.Ссылка КАК Ссылка,
		|	РазовоеНачисление.Организация КАК Организация,
		|	РазовоеНачисление.Дата КАК ПериодРегистрации,
		|	РазовоеНачисление.Дата КАК Дата,
		|	РазовоеНачисление.Дата КАК ДатаДокумента,
		|	"""" КАК Руководитель,
		|	"""" КАК ДолжностьРуководителя,		
		|	РазовоеНачисление.Номер КАК НомерДокумента,
		|	ВЫБОР
		|		КОГДА Организации.НаименованиеПолное ПОДОБНО """"
		|			ТОГДА Организации.Наименование
		|		ИНАЧЕ Организации.НаименованиеПолное
		|	КОНЕЦ КАК НазваниеОрганизации,
		|	Организации.КодПоОКПО КАК КодПоОКПО,
		|	РазовоеНачисление.Начисление.Наименование КАК РасчетСтрокой,
		|	РазовоеНачисление.Комментарий КАК МотивПоощрения
		|ПОМЕСТИТЬ ВТДанныеШапкиДокумента
		|ИЗ
		|	Документ.РазовоеНачисление КАК РазовоеНачисление
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Организации КАК Организации
		|		ПО РазовоеНачисление.Организация = Организации.Ссылка
		|ГДЕ
		|	РазовоеНачисление.Ссылка В(&МассивДокументов)";
		
		Запрос.Выполнить();
		
		ЗарплатаКадры.СоздатьВТФИООтветственныхЛиц(Запрос.МенеджерВременныхТаблиц, Истина, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве("Руководитель"), "ВТДанныеШапкиДокумента");
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ДанныеШапкиДокумента.Ссылка КАК Ссылка,
		|	ДанныеШапкиДокумента.ПериодРегистрации КАК ПериодРегистрации,
		|	ДанныеШапкиДокумента.ПериодРегистрации КАК Период,
		|	ДанныеШапкиДокумента.ДатаДокумента КАК ДатаДокумента,
		|	ДанныеШапкиДокумента.НомерДокумента КАК НомерДокумента,
		|	ДанныеШапкиДокумента.Организация КАК Организация,
		|	ДанныеШапкиДокумента.НазваниеОрганизации КАК НазваниеОрганизации,
		|	ДанныеШапкиДокумента.КодПоОКПО КАК КодПоОКПО,
		|	ДанныеШапкиДокумента.РасчетСтрокой КАК РасчетСтрокой,
		|	ДанныеШапкиДокумента.МотивПоощрения,
		|	ЕСТЬNULL(РазовоеНачислениеНачисления.НомерСтроки, 1) КАК НомерСтроки,
		|	ЕСТЬNULL(РазовоеНачислениеНачисления.Сотрудник, ПризПодарок.Сотрудник) КАК Сотрудник,
		|	ЕСТЬNULL(РазовоеНачислениеНачисления.Результат, ПризПодарок.СуммаДохода) КАК Результат
		|ПОМЕСТИТЬ ВТДанныеДокумента
		|ИЗ
		|	ВТДанныеШапкиДокумента КАК ДанныеШапкиДокумента
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТСтрокиДокументов КАК СтрокиДокументов
		|		ПО (НЕ &БезОтбораПоСтрокам)
		|			И ДанныеШапкиДокумента.Ссылка = СтрокиДокументов.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.РазовоеНачисление.Начисления КАК РазовоеНачислениеНачисления
		|		ПО ДанныеШапкиДокумента.Ссылка = РазовоеНачислениеНачисления.Ссылка
		|			И (ВЫБОР
		|				КОГДА НЕ &БезОтбораПоСтрокам
		|					ТОГДА РазовоеНачислениеНачисления.НомерСтроки = СтрокиДокументов.НомерСтроки
		|				ИНАЧЕ ИСТИНА
		|			КОНЕЦ)
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПризПодарок КАК ПризПодарок
		|		ПО ДанныеШапкиДокумента.Ссылка = ПризПодарок.Ссылка";
		
		Запрос.Выполнить();
		
		ОписательВременныхТаблиц = КадровыйУчет.ОписательВременныхТаблицДляСоздатьВТКадровыеДанныеСотрудников(
		Запрос.МенеджерВременныхТаблиц,
		"ВТДанныеДокумента");
		КадровыйУчет.СоздатьВТКадровыеДанныеСотрудников(ОписательВременныхТаблиц, Истина, "ФизическоеЛицо,ФИОПолные,Подразделение,Должность,ТабельныйНомер,Пол");
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	РезультатЗапроса.Ссылка,
		|	РезультатЗапроса.ПериодРегистрации,
		|	РезультатЗапроса.ДатаДокумента,
		|	РезультатЗапроса.НомерДокумента,
		|	РезультатЗапроса.Организация,
		|	РезультатЗапроса.НазваниеОрганизации,
		|	РезультатЗапроса.КодПоОКПО,
		|	РезультатЗапроса.РасчетСтрокой,
		|	РезультатЗапроса.НомерСтроки,
		|	РезультатЗапроса.МотивПоощрения,
		|	РезультатЗапроса.Сотрудник,
		|	РезультатЗапроса.ФИОПолные,
		|	РезультатЗапроса.Результат,
		|	РезультатЗапроса.ТабельныйНомер,
		|	РезультатЗапроса.Пол,
		|	РезультатЗапроса.ФизическоеЛицо,
		|	КадроваяИсторияСотрудниковСрезПоследних.Подразделение,
		|	КадроваяИсторияСотрудниковСрезПоследних.Должность,
		|	РезультатЗапроса.РайонныйКоэффициент,
		|	ПроцентыСевернойНадбавкиФизическихЛицСрезПоследних.ПроцентСевернойНадбавки КАК СевернаяНадбавка
		|ИЗ
		|	(ВЫБРАТЬ
		|		ДанныеДокумента.Ссылка КАК Ссылка,
		|		ДанныеДокумента.ПериодРегистрации КАК ПериодРегистрации,
		|		ДанныеДокумента.ДатаДокумента КАК ДатаДокумента,
		|		ДанныеДокумента.НомерДокумента КАК НомерДокумента,
		|		ДанныеДокумента.Организация КАК Организация,
		|		ДанныеДокумента.НазваниеОрганизации КАК НазваниеОрганизации,
		|		ДанныеДокумента.КодПоОКПО КАК КодПоОКПО,
		|		ДанныеДокумента.РасчетСтрокой КАК РасчетСтрокой,
		|		ДанныеДокумента.НомерСтроки КАК НомерСтроки,
		|		ДанныеДокумента.МотивПоощрения КАК МотивПоощрения,
		|		КадровыеДанныеСотрудников.Сотрудник КАК Сотрудник,
		|		КадровыеДанныеСотрудников.ФИОПолные КАК ФИОПолные,
		|		ДанныеДокумента.Результат КАК Результат,
		|		КадровыеДанныеСотрудников.ТабельныйНомер КАК ТабельныйНомер,
		|		КадровыеДанныеСотрудников.Пол КАК Пол,
		|		КадровыеДанныеСотрудников.ФизическоеЛицо КАК ФизическоеЛицо,
		|		КадровыеДанныеСотрудников.Подразделение КАК Подразделение,
		|		КадровыеДанныеСотрудников.Должность КАК Должность,
		|		ВЫБОР
		|			КОГДА ЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудниковСрезПоследних.Значение = 0
		|				ТОГДА 0
		|			ИНАЧЕ ЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудниковСрезПоследних.Значение - 1
		|		КОНЕЦ КАК РайонныйКоэффициент
		|	ИЗ
		|		ВТДанныеДокумента КАК ДанныеДокумента
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТКадровыеДанныеСотрудников КАК КадровыеДанныеСотрудников
		|			ПО ДанныеДокумента.Сотрудник = КадровыеДанныеСотрудников.Сотрудник
		|				И ДанныеДокумента.Период = КадровыеДанныеСотрудников.Период
		|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудников.СрезПоследних(, Показатель = ЗНАЧЕНИЕ(Справочник.ПоказателиРасчетаЗарплаты.РайонныйКоэффициент)) КАК ЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудниковСрезПоследних
		|			ПО ДанныеДокумента.Сотрудник = ЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудниковСрезПоследних.Сотрудник
		|	ГДЕ
		|		ДанныеДокумента.Результат <> 0) КАК РезультатЗапроса
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПроцентыСевернойНадбавкиФизическихЛиц.СрезПоследних(&ДатаСреза, ) КАК ПроцентыСевернойНадбавкиФизическихЛицСрезПоследних
		|		ПО РезультатЗапроса.ФизическоеЛицо = ПроцентыСевернойНадбавкиФизическихЛицСрезПоследних.ФизическоеЛицо
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КадроваяИсторияСотрудников.СрезПоследних(&ДатаСреза, ) КАК КадроваяИсторияСотрудниковСрезПоследних
		|		ПО РезультатЗапроса.Сотрудник = КадроваяИсторияСотрудниковСрезПоследних.Сотрудник";
		
	КонецЕсли;	
	
	Возврат Запрос.Выполнить();
	
КонецФункции

