﻿
&НаКлиенте
Процедура Очистить(Команда)
	Объект.СписокФизЛиц.Очистить();
КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)
	Объект.СписокФизЛиц.Очистить();
	ЗаполнитьНаСервере();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере()
	
	МассивСпособовВыплаты = Новый Массив;
	МассивСпособовВыплаты.Добавить(Справочники.СпособыВыплатыЗарплаты.НайтиПоНаименованию("Больничные листы"));
	МассивСпособовВыплаты.Добавить(Справочники.СпособыВыплатыЗарплаты.НайтиПоНаименованию("Отпуска"));
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ОтпускНДФЛ.ФизическоеЛицо,
	               |	ОтпускНДФЛ.Подразделение,
	               |	ОтпускНДФЛ.Подразделение.РегистрацияВНалоговомОргане КАК РегистрацияВНалоговомОргане,
	               |	СУММА(ОтпускНДФЛ.Налог) КАК Сумма
	               |ИЗ
	               |	Документ.Отпуск.НДФЛ КАК ОтпускНДФЛ
	               |ГДЕ
	               |	ОтпускНДФЛ.Ссылка.ПериодРегистрации МЕЖДУ &ДатаНачала И &ДатаОкончания
	               |	И ОтпускНДФЛ.Ссылка.Проведен = ИСТИНА
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ОтпускНДФЛ.Подразделение,
	               |	ОтпускНДФЛ.ФизическоеЛицо,
	               |	ОтпускНДФЛ.Подразделение.РегистрацияВНалоговомОргане
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	БольничныйЛистНДФЛ.ФизическоеЛицо,
	               |	БольничныйЛистНДФЛ.Подразделение,
	               |	БольничныйЛистНДФЛ.Подразделение.РегистрацияВНалоговомОргане,
	               |	СУММА(БольничныйЛистНДФЛ.Налог)
	               |ИЗ
	               |	Документ.БольничныйЛист.НДФЛ КАК БольничныйЛистНДФЛ
	               |ГДЕ
	               |	БольничныйЛистНДФЛ.Ссылка.ПериодРегистрации МЕЖДУ &ДатаНачала И &ДатаОкончания
	               |	И БольничныйЛистНДФЛ.Ссылка.Проведен = ИСТИНА
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	БольничныйЛистНДФЛ.ФизическоеЛицо,
	               |	БольничныйЛистНДФЛ.Подразделение,
	               |	БольничныйЛистНДФЛ.Подразделение.РегистрацияВНалоговомОргане";
	Запрос.УстановитьПараметр("ДатаНачала",НачалоМесяца(Период));
	Запрос.УстановитьПараметр("ДатаОкончания",КонецМесяца(Период));

	//Запрос.Текст =
	//"ВЫБРАТЬ
	//|	ВедомостьНаВыплатуЗарплатыВБанкНДФЛ.ФизическоеЛицо КАК ФизическоеЛицо,
	//|	СУММА(ВедомостьНаВыплатуЗарплатыВБанкНДФЛ.Сумма) КАК Сумма,
	//|	ВедомостьНаВыплатуЗарплатыВБанкНДФЛ.Подразделение КАК Подразделение,
	//|	ВедомостьНаВыплатуЗарплатыВБанкНДФЛ.РегистрацияВНалоговомОргане КАК РегистрацияВНалоговомОргане
	//|ИЗ
	//|	Документ.ВедомостьНаВыплатуЗарплатыВБанк.НДФЛ КАК ВедомостьНаВыплатуЗарплатыВБанкНДФЛ
	//|ГДЕ
	//|	ВедомостьНаВыплатуЗарплатыВБанкНДФЛ.Ссылка.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
	//|	И ВедомостьНаВыплатуЗарплатыВБанкНДФЛ.Ссылка.Проведен = ИСТИНА
	//|	И НЕ ВедомостьНаВыплатуЗарплатыВБанкНДФЛ.Ссылка.СпособВыплаты В (&СпособВыплаты)
	//|
	//|СГРУППИРОВАТЬ ПО
	//|	ВедомостьНаВыплатуЗарплатыВБанкНДФЛ.ФизическоеЛицо,
	//|	ВедомостьНаВыплатуЗарплатыВБанкНДФЛ.РегистрацияВНалоговомОргане,
	//|	ВедомостьНаВыплатуЗарплатыВБанкНДФЛ.Подразделение
	//|
	//|УПОРЯДОЧИТЬ ПО
	//|	ВедомостьНаВыплатуЗарплатыВБанкНДФЛ.ФизическоеЛицо.Наименование";
	//Запрос.УстановитьПараметр("ДатаНачала",НачалоДня(Период));
	//Запрос.УстановитьПараметр("ДатаОкончания",КонецДня(Период));
	Запрос.УстановитьПараметр("СпособВыплаты",МассивСпособовВыплаты);
	
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Организация = Справочники.Организации.ОрганизацияПоУмолчанию();
		РегистрацияОрганизации = Организация.РегистрацияВНалоговомОргане;
		Пока Выборка.Следующий() Цикл
			НоваяСтрока = Объект.СписокФизЛиц.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
			НоваяСтрока.ДатаПлатежа = Период;
			Если ЗначениеЗаполнено(Выборка.Подразделение) Тогда
				Если ЗначениеЗаполнено(Выборка.Подразделение.РегистрацияВНалоговомОргане) Тогда
					НоваяСтрока.РегистрацияВНалоговомОргане = Выборка.Подразделение.РегистрацияВНалоговомОргане;	
					НоваяСтрока.ОКТМО_КПП = Выборка.Подразделение.РегистрацияВНалоговомОргане.КодПоОКТМО + "/" + Выборка.Подразделение.РегистрацияВНалоговомОргане.КПП;	
				Иначе
					НоваяСтрока.РегистрацияВНалоговомОргане = РегистрацияОрганизации;
					НоваяСтрока.ОКТМО_КПП = "45382000   /997950001";	
				КонецЕсли;
			Иначе
				НоваяСтрока.РегистрацияВНалоговомОргане = РегистрацияОрганизации;
				НоваяСтрока.ОКТМО_КПП = "45382000   /997950001";	
			КонецЕсли;
		КонецЦикла; 
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПолучитьНДФЛПоРегистрацииРазовыхНачислений()
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РазовыеНачисленияНДФЛ.Подразделение КАК ПодразделениеОрганизации,
	|	РазовыеНачисленияНДФЛ.ФизическоеЛицо КАК ФизЛицо,
	|	СУММА(ЕСТЬNULL(РазовыеНачисленияНДФЛ.Налог, 0)) КАК Сумма,
	|	РазовыеНачисленияНДФЛ.Ссылка.ПланируемаяДатаВыплаты КАК ДатаПлатежа
	|ПОМЕСТИТЬ ВТ_НДФЛ
	|ИЗ
	|	Документ.РазовоеНачисление.НДФЛ КАК РазовыеНачисленияНДФЛ
	|ГДЕ
	|	РазовыеНачисленияНДФЛ.Ссылка.Проведен = ИСТИНА
	|	И РазовыеНачисленияНДФЛ.Ссылка.ПланируемаяДатаВыплаты = &ПланируемаяДатаВыплаты
	|
	|СГРУППИРОВАТЬ ПО
	|	РазовыеНачисленияНДФЛ.Подразделение,
	|	РазовыеНачисленияНДФЛ.ФизическоеЛицо,
	|	РазовыеНачисленияНДФЛ.Ссылка.ПланируемаяДатаВыплаты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_НДФЛ.ПодразделениеОрганизации,
	|	ВТ_НДФЛ.ФизЛицо,
	|	ВТ_НДФЛ.Сумма,
	|	ВТ_НДФЛ.ДатаПлатежа
	|ИЗ
	|	ВТ_НДФЛ КАК ВТ_НДФЛ
	|ГДЕ
	|	ВТ_НДФЛ.Сумма <> 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТ_НДФЛ";
	
	Запрос.УстановитьПараметр("ПланируемаяДатаВыплаты", НачалоДня(Период));
	
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		Возврат Результат.Выгрузить();
	Иначе
		ТабЗнч = Новый ТаблицаЗначений;
		ТабЗнч.Колонки.Добавить("ПодразделениеОрганизации", Новый ОписаниеТипов("СправочникСсылка.ПодразделенияОрганизаций"));
		ТабЗнч.Колонки.Добавить("ФизЛицо", Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица"));
		ТабЗнч.Колонки.Добавить("Сумма", Новый ОписаниеТипов("Число"));
		ТабЗнч.Колонки.Добавить("ДатаПлатежа", Новый ОписаниеТипов("Дата"));
		
		Возврат ТабЗнч;
	КонецЕсли; 	
КонецФункции // ПолучитьНДФЛПоРегистрацииРазовыхНачислений()

&НаСервере
Функция ПолучитьНДФЛПоНачислениюЗаработнойПлаты()
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НачислениеЗарплатыНДФЛ.Подразделение КАК ПодразделениеОрганизации,
	|	НачислениеЗарплатыНДФЛ.ФизическоеЛицо КАК ФизЛицо,
	|	ЕСТЬNULL(НачислениеЗарплатыНДФЛ.Налог, 0) КАК Сумма,
	|	НачислениеЗарплатыНДФЛ.Ссылка.ПланируемаяДатаВыплаты КАК ДатаПлатежа
	|ПОМЕСТИТЬ ВТ_НДФЛ
	|ИЗ
	|	Документ.НачислениеЗарплаты.НДФЛ КАК НачислениеЗарплатыНДФЛ
	|ГДЕ
	|	НачислениеЗарплатыНДФЛ.Ссылка.Проведен = ИСТИНА
	|	И НачислениеЗарплатыНДФЛ.Ссылка.ПланируемаяДатаВыплаты = &ПланируемаяДатаВыплаты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_НДФЛ.ПодразделениеОрганизации,
	|	ВТ_НДФЛ.ФизЛицо КАК ФизЛицо,
	|	ЕСТЬNULL(ВТ_НДФЛ.Сумма, 0) КАК Сумма,
	|	ВТ_НДФЛ.ДатаПлатежа
	|ИЗ
	|	ВТ_НДФЛ КАК ВТ_НДФЛ
	|ГДЕ
	|	ЕСТЬNULL(ВТ_НДФЛ.Сумма, 0) <> 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	ФизЛицо
	|АВТОУПОРЯДОЧИВАНИЕ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТ_НДФЛ";
	
	Запрос.УстановитьПараметр("ПланируемаяДатаВыплаты", НачалоДня(Период));
	
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		Возврат Результат.Выгрузить();
	Иначе
		ТабЗнч = Новый ТаблицаЗначений;
		ТабЗнч.Колонки.Добавить("ПодразделениеОрганизации", Новый ОписаниеТипов("СправочникСсылка.ПодразделенияОрганизаций"));
		ТабЗнч.Колонки.Добавить("ФизЛицо", Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица"));
		ТабЗнч.Колонки.Добавить("Сумма", Новый ОписаниеТипов("Число"));
		ТабЗнч.Колонки.Добавить("ДатаПлатежа", Новый ОписаниеТипов("Дата"));
		
		Возврат ТабЗнч;
	КонецЕсли; 	
КонецФункции // ПолучитьНДФЛПоНачислениюЗаработнойПлаты()

&НаСервере
Функция ПолучитьНДФЛПоНачислениюОтпуска()
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОтпускНДФЛ.Подразделение КАК ПодразделениеОрганизации,
	|	ОтпускНДФЛ.Ссылка.ФизическоеЛицо КАК ФизЛицо,
	|	СУММА(ЕСТЬNULL(ОтпускНДФЛ.Налог, 0)) КАК Сумма,
	|	ОтпускНДФЛ.Ссылка.ПланируемаяДатаВыплаты КАК ДатаПлатежа
	|ПОМЕСТИТЬ ВТ_НДФЛ
	|ИЗ
	|	Документ.Отпуск.НДФЛ КАК ОтпускНДФЛ
	|ГДЕ
	|	ОтпускНДФЛ.Ссылка.Проведен = ИСТИНА
	|	И ОтпускНДФЛ.Ссылка.ПланируемаяДатаВыплаты = &ПланируемаяДатаВыплаты
	|
	|СГРУППИРОВАТЬ ПО
	|	ОтпускНДФЛ.Подразделение,
	|	ОтпускНДФЛ.Ссылка.ФизическоеЛицо,
	|	ОтпускНДФЛ.Ссылка.ПланируемаяДатаВыплаты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_НДФЛ.ПодразделениеОрганизации,
	|	ВТ_НДФЛ.ФизЛицо,
	|	ВТ_НДФЛ.Сумма,
	|	ВТ_НДФЛ.ДатаПлатежа
	|ИЗ
	|	ВТ_НДФЛ КАК ВТ_НДФЛ
	|ГДЕ
	|	ВТ_НДФЛ.Сумма <> 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТ_НДФЛ";
	
	Запрос.УстановитьПараметр("ПланируемаяДатаВыплаты", НачалоДня(Период));
	
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		Возврат Результат.Выгрузить();
	Иначе
		ТабЗнч = Новый ТаблицаЗначений;
		ТабЗнч.Колонки.Добавить("ПодразделениеОрганизации", Новый ОписаниеТипов("СправочникСсылка.ПодразделенияОрганизаций"));
		ТабЗнч.Колонки.Добавить("ФизЛицо", Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица"));
		ТабЗнч.Колонки.Добавить("Сумма", Новый ОписаниеТипов("Число"));
		ТабЗнч.Колонки.Добавить("ДатаПлатежа", Новый ОписаниеТипов("Дата"));
		
		Возврат ТабЗнч;
	КонецЕсли;
КонецФункции

&НаСервере
Функция ПолучитьНДФЛПоНачислениюБольничных()
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	БольничныйЛистНДФЛ.Подразделение КАК ПодразделениеОрганизации,
	|	БольничныйЛистНДФЛ.ФизическоеЛицо КАК Физлицо,
	|	СУММА(ЕСТЬNULL(БольничныйЛистНДФЛ.Налог, 0)) КАК Сумма,
	|	БольничныйЛистНДФЛ.Ссылка.ПланируемаяДатаВыплаты КАК ДатаПлатежа
	|ПОМЕСТИТЬ ВТ_НДФЛ
	|ИЗ
	|	Документ.БольничныйЛист.НДФЛ КАК БольничныйЛистНДФЛ
	|ГДЕ
	|	БольничныйЛистНДФЛ.Ссылка.Проведен = ИСТИНА
	|	И БольничныйЛистНДФЛ.Ссылка.ПланируемаяДатаВыплаты = &ПланируемаяДатаВыплаты
	|
	|СГРУППИРОВАТЬ ПО
	|	БольничныйЛистНДФЛ.Ссылка,
	|	БольничныйЛистНДФЛ.Подразделение,
	|	БольничныйЛистНДФЛ.ФизическоеЛицо,
	|	БольничныйЛистНДФЛ.Ссылка.ПланируемаяДатаВыплаты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_НДФЛ.ПодразделениеОрганизации,
	|	ВТ_НДФЛ.Физлицо,
	|	ВТ_НДФЛ.Сумма,
	|	ВТ_НДФЛ.ДатаПлатежа
	|ИЗ
	|	ВТ_НДФЛ КАК ВТ_НДФЛ
	|ГДЕ
	|	ВТ_НДФЛ.Сумма <> 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТ_НДФЛ";
	
	Запрос.УстановитьПараметр("ПланируемаяДатаВыплаты", НачалоДня(Период));
	
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		Возврат Результат.Выгрузить();
	Иначе
		ТабЗнч = Новый ТаблицаЗначений;
		ТабЗнч.Колонки.Добавить("ПодразделениеОрганизации", Новый ОписаниеТипов("СправочникСсылка.ПодразделенияОрганизаций"));
		ТабЗнч.Колонки.Добавить("ФизЛицо", Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица"));
		ТабЗнч.Колонки.Добавить("Сумма", Новый ОписаниеТипов("Число"));
		ТабЗнч.Колонки.Добавить("ДатаПлатежа", Новый ОписаниеТипов("Дата"));
		
		Возврат ТабЗнч;
	КонецЕсли;
КонецФункции

&НаСервере
Функция ПолучитьНДФЛПоНачислениюПремии()
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПремияНДФЛ.Подразделение КАК ПодразделениеОрганизации,
	|	ПремияНДФЛ.ФизическоеЛицо КАК Физлицо,
	|	СУММА(ЕСТЬNULL(ПремияНДФЛ.Налог, 0)) КАК Сумма,
	|	ПремияНДФЛ.Ссылка.ПланируемаяДатаВыплаты КАК ДатаПлатежа
	|ПОМЕСТИТЬ ВТ_НДФЛ
	|ИЗ
	|	Документ.Премия.НДФЛ КАК ПремияНДФЛ
	|ГДЕ
	|	ПремияНДФЛ.Ссылка.Проведен = ИСТИНА
	|	И ПремияНДФЛ.Ссылка.ПланируемаяДатаВыплаты = &ПланируемаяДатаВыплаты
	|
	|СГРУППИРОВАТЬ ПО
	|	ПремияНДФЛ.Ссылка,
	|	ПремияНДФЛ.Подразделение,
	|	ПремияНДФЛ.ФизическоеЛицо,
	|	ПремияНДФЛ.Ссылка.ПланируемаяДатаВыплаты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_НДФЛ.ПодразделениеОрганизации,
	|	ВТ_НДФЛ.Физлицо,
	|	ВТ_НДФЛ.Сумма,
	|	ВТ_НДФЛ.ДатаПлатежа
	|ИЗ
	|	ВТ_НДФЛ КАК ВТ_НДФЛ
	|ГДЕ
	|	ВТ_НДФЛ.Сумма <> 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТ_НДФЛ";
	
	Запрос.УстановитьПараметр("ПланируемаяДатаВыплаты", НачалоДня(Период));
	
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		Возврат Результат.Выгрузить();
	Иначе
		ТабЗнч = Новый ТаблицаЗначений;
		ТабЗнч.Колонки.Добавить("ПодразделениеОрганизации", Новый ОписаниеТипов("СправочникСсылка.ПодразделенияОрганизаций"));
		ТабЗнч.Колонки.Добавить("ФизЛицо", Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица"));
		ТабЗнч.Колонки.Добавить("Сумма", Новый ОписаниеТипов("Число"));
		ТабЗнч.Колонки.Добавить("ДатаПлатежа", Новый ОписаниеТипов("Дата"));
		
		Возврат ТабЗнч;
	КонецЕсли;
КонецФункции

&НаСервере
Функция ПолучитьНДФЛПоНачислениюОтпускаПоУходуЗаРебенком()
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОтпускНДФЛ.Подразделение КАК ПодразделениеОрганизации,
	|	ОтпускНДФЛ.ФизическоеЛицо КАК ФизЛицо,
	|	СУММА(ЕСТЬNULL(ОтпускНДФЛ.Налог, 0)) КАК Сумма,
	|	ОтпускНДФЛ.Ссылка.ПланируемаяДатаВыплаты КАК ДатаПлатежа
	|ПОМЕСТИТЬ ВТ_НДФЛ
	|ИЗ
	|	Документ.ОтпускПоУходуЗаРебенком.НДФЛ КАК ОтпускНДФЛ
	|ГДЕ
	|	ОтпускНДФЛ.Ссылка.Проведен = ИСТИНА
	|	И ОтпускНДФЛ.Ссылка.ПланируемаяДатаВыплаты = &ПланируемаяДатаВыплаты
	|
	|СГРУППИРОВАТЬ ПО
	|	ОтпускНДФЛ.Подразделение,
	|	ОтпускНДФЛ.ФизическоеЛицо,
	|	ОтпускНДФЛ.Ссылка.ПланируемаяДатаВыплаты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_НДФЛ.ПодразделениеОрганизации,
	|	ВТ_НДФЛ.ФизЛицо,
	|	ВТ_НДФЛ.Сумма,
	|	ВТ_НДФЛ.ДатаПлатежа
	|ИЗ
	|	ВТ_НДФЛ КАК ВТ_НДФЛ
	|ГДЕ
	|	ВТ_НДФЛ.Сумма <> 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТ_НДФЛ";
	
	Запрос.УстановитьПараметр("ПланируемаяДатаВыплаты", НачалоДня(Период));
	
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		Возврат Результат.Выгрузить();
	Иначе
		ТабЗнч = Новый ТаблицаЗначений;
		ТабЗнч.Колонки.Добавить("ПодразделениеОрганизации", Новый ОписаниеТипов("СправочникСсылка.ПодразделенияОрганизаций"));
		ТабЗнч.Колонки.Добавить("ФизЛицо", Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица"));
		ТабЗнч.Колонки.Добавить("Сумма", Новый ОписаниеТипов("Число"));
		ТабЗнч.Колонки.Добавить("ДатаПлатежа", Новый ОписаниеТипов("Дата"));
		
		Возврат ТабЗнч;
	КонецЕсли;
КонецФункции

&НаСервере
Функция ПолучитьНДФЛПоНачислениюМатериальнойПомощи()
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	МатериальнаяПомощьНДФЛ.Подразделение КАК ПодразделениеОрганизации,
	|	МатериальнаяПомощьНДФЛ.ФизическоеЛицо КАК ФизЛицо,
	|	СУММА(ЕСТЬNULL(МатериальнаяПомощьНДФЛ.Налог, 0)) КАК Сумма,
	|	МатериальнаяПомощьНДФЛ.Ссылка.ПланируемаяДатаВыплаты КАК ДатаПлатежа
	|ПОМЕСТИТЬ ВТ_НДФЛ
	|ИЗ
	|	Документ.МатериальнаяПомощь.НДФЛ КАК МатериальнаяПомощьНДФЛ
	|ГДЕ
	|	МатериальнаяПомощьНДФЛ.Ссылка.Проведен = ИСТИНА
	|	И МатериальнаяПомощьНДФЛ.Ссылка.ПланируемаяДатаВыплаты = &ПланируемаяДатаВыплаты
	|
	|СГРУППИРОВАТЬ ПО
	|	МатериальнаяПомощьНДФЛ.Подразделение,
	|	МатериальнаяПомощьНДФЛ.ФизическоеЛицо,
	|	МатериальнаяПомощьНДФЛ.Ссылка.ПланируемаяДатаВыплаты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_НДФЛ.ПодразделениеОрганизации,
	|	ВТ_НДФЛ.ФизЛицо,
	|	ВТ_НДФЛ.Сумма,
	|	ВТ_НДФЛ.ДатаПлатежа
	|ИЗ
	|	ВТ_НДФЛ КАК ВТ_НДФЛ
	|ГДЕ
	|	ВТ_НДФЛ.Сумма <> 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТ_НДФЛ";
	
	Запрос.УстановитьПараметр("ПланируемаяДатаВыплаты", НачалоДня(Период));
	
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		Возврат Результат.Выгрузить();
	Иначе
		ТабЗнч = Новый ТаблицаЗначений;
		ТабЗнч.Колонки.Добавить("ПодразделениеОрганизации", Новый ОписаниеТипов("СправочникСсылка.ПодразделенияОрганизаций"));
		ТабЗнч.Колонки.Добавить("ФизЛицо", Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица"));
		ТабЗнч.Колонки.Добавить("Сумма", Новый ОписаниеТипов("Число"));
		ТабЗнч.Колонки.Добавить("ДатаПлатежа", Новый ОписаниеТипов("Дата"));
		
		Возврат ТабЗнч;
	КонецЕсли;
КонецФункции

&НаСервере
Функция ПолучитьНДФЛПоНачислениюКомандировки()
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КомандировкаНДФЛ.Подразделение КАК ПодразделениеОрганизации,
	|	КомандировкаНДФЛ.ФизическоеЛицо КАК ФизЛицо,
	|	СУММА(ЕСТЬNULL(КомандировкаНДФЛ.Налог, 0)) КАК Сумма,
	|	КомандировкаНДФЛ.Ссылка.ПланируемаяДатаВыплаты КАК ДатаПлатежа
	|ПОМЕСТИТЬ ВТ_НДФЛ
	|ИЗ
	|	Документ.Командировка.НДФЛ КАК КомандировкаНДФЛ
	|ГДЕ
	|	КомандировкаНДФЛ.Ссылка.Проведен = ИСТИНА
	|	И КомандировкаНДФЛ.Ссылка.ПланируемаяДатаВыплаты = &ПланируемаяДатаВыплаты
	|
	|СГРУППИРОВАТЬ ПО
	|	КомандировкаНДФЛ.Подразделение,
	|	КомандировкаНДФЛ.ФизическоеЛицо,
	|	КомандировкаНДФЛ.Ссылка.ПланируемаяДатаВыплаты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_НДФЛ.ПодразделениеОрганизации,
	|	ВТ_НДФЛ.ФизЛицо,
	|	ВТ_НДФЛ.Сумма,
	|	ВТ_НДФЛ.ДатаПлатежа
	|ИЗ
	|	ВТ_НДФЛ КАК ВТ_НДФЛ
	|ГДЕ
	|	ВТ_НДФЛ.Сумма <> 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТ_НДФЛ";
	
	Запрос.УстановитьПараметр("ПланируемаяДатаВыплаты", НачалоДня(Период));
	
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		Возврат Результат.Выгрузить();
	Иначе
		ТабЗнч = Новый ТаблицаЗначений;
		ТабЗнч.Колонки.Добавить("ПодразделениеОрганизации", Новый ОписаниеТипов("СправочникСсылка.ПодразделенияОрганизаций"));
		ТабЗнч.Колонки.Добавить("ФизЛицо", Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица"));
		ТабЗнч.Колонки.Добавить("Сумма", Новый ОписаниеТипов("Число"));
		ТабЗнч.Колонки.Добавить("ДатаПлатежа", Новый ОписаниеТипов("Дата"));
		
		Возврат ТабЗнч;
	КонецЕсли;
КонецФункции

&НаСервере
Функция ПолучитьНДФЛПоНачислениюУвольнение()
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	УвольнениеНДФЛ.Подразделение КАК ПодразделениеОрганизации,
	|	УвольнениеНДФЛ.ФизическоеЛицо КАК ФизЛицо,
	|	СУММА(ЕСТЬNULL(УвольнениеНДФЛ.Налог, 0)) КАК Сумма,
	|	УвольнениеНДФЛ.Ссылка.ПланируемаяДатаВыплаты КАК ДатаПлатежа
	|ПОМЕСТИТЬ ВТ_НДФЛ
	|ИЗ
	|	Документ.Увольнение.НДФЛ КАК УвольнениеНДФЛ
	|ГДЕ
	|	УвольнениеНДФЛ.Ссылка.Проведен = ИСТИНА
	|	И УвольнениеНДФЛ.Ссылка.ПланируемаяДатаВыплаты = &ПланируемаяДатаВыплаты
	|
	|СГРУППИРОВАТЬ ПО
	|	УвольнениеНДФЛ.Подразделение,
	|	УвольнениеНДФЛ.ФизическоеЛицо,
	|	УвольнениеНДФЛ.Ссылка.ПланируемаяДатаВыплаты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_НДФЛ.ПодразделениеОрганизации,
	|	ВТ_НДФЛ.ФизЛицо,
	|	ВТ_НДФЛ.Сумма,
	|	ВТ_НДФЛ.ДатаПлатежа
	|ИЗ
	|	ВТ_НДФЛ КАК ВТ_НДФЛ
	|ГДЕ
	|	ВТ_НДФЛ.Сумма <> 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТ_НДФЛ";
	
	Запрос.УстановитьПараметр("ПланируемаяДатаВыплаты", НачалоДня(Период));
	
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		Возврат Результат.Выгрузить();
	Иначе
		ТабЗнч = Новый ТаблицаЗначений;
		ТабЗнч.Колонки.Добавить("ПодразделениеОрганизации", Новый ОписаниеТипов("СправочникСсылка.ПодразделенияОрганизаций"));
		ТабЗнч.Колонки.Добавить("ФизЛицо", Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица"));
		ТабЗнч.Колонки.Добавить("Сумма", Новый ОписаниеТипов("Число"));
		ТабЗнч.Колонки.Добавить("ДатаПлатежа", Новый ОписаниеТипов("Дата"));
		
		Возврат ТабЗнч;
	КонецЕсли;
КонецФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Период = НачалоДня(ТекущаяДата());
КонецПроцедуры

&НаКлиенте
Процедура СформироватьДокументы(Команда)
	СформироватьДокументыНаСервере();
КонецПроцедуры

&НаСервере
Процедура СформироватьДокументыНаСервере()
	
	Если Объект.СписокФизЛиц.Количество()=0 Тогда 
		Возврат;
	КонецЕсли;
	
	Организация = Справочники.Организации.ОрганизацияПоУмолчанию();
	ТЗ = Объект.СписокФизЛиц.Выгрузить();
	//МассивДат 			= ОбщегоНазначенияКлиентСервер.СвернутьМассив(Тз.ВыгрузитьКолонку("Датаплатежа"));
	МассивРегистраций 	= ОбщегоНазначенияКлиентСервер.СвернутьМассив(Тз.ВыгрузитьКолонку("РегистрацияВНалоговомОргане"));
	
	//Для Каждого Дата из МассивДат Цикл 
	Для Каждого Регистрация из МассивРегистраций Цикл 
		Отбор = Новый Структура("РегистрацияВНалоговомОргане", Регистрация);
		ТаблицаОтбор = ТЗ.Скопировать(Отбор);
		Если ТаблицаОтбор.Количество() <> 0 Тогда 
			ДокПеречислениеНДФЛ = Документы.ПеречислениеНДФЛВБюджет.СоздатьДокумент();
			ДокПеречислениеНДФЛ.ДатаПлатежа 				= НачалоДня(Период);
			ДокПеречислениеНДФЛ.Дата 						= НачалоДня(Период);
			ДокПеречислениеНДФЛ.Организация 				= Организация;
			ДокПеречислениеНДФЛ.МесяцНалоговогоПериода 		= НачалоДня(НачалоМесяца(Период));
			ДокПеречислениеНДФЛ.РегистрацияВНалоговомОргане	= Регистрация;			
			ДокПеречислениеНДФЛ.Ответственный 				= ПараметрыСеанса.ТекущийПользователь;
			ДокПеречислениеНДФЛ.Сумма 						= ТаблицаОтбор.Итог("Сумма");
			Попытка
				ДокПеречислениеНДФЛ.Записать(РежимЗаписиДокумента.Проведение);
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = НСтр("ru = 'Проведен документ - '") + Строка(ДокПеречислениеНДФЛ.Ссылка);
				Сообщение.Сообщить(); 
			Исключение
				ДокПеречислениеНДФЛ.Записать(РежимЗаписиДокумента.Запись);
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = НСтр("ru = 'Записан документ - '") + Строка(ДокПеречислениеНДФЛ.Ссылка);
				Сообщение.Сообщить(); 
			КонецПопытки;
		КонецЕсли;;
	КонецЦикла;
	//КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПоКПП(Команда)
	ТекущаяСтрока = Элементы.СписокФизЛиц.ТекущиеДанные;
	Если ТекущаяСтрока<>Неопределено Тогда 
		ТекущийКПП = ТекущаяСтрока.РегистрацияВНалоговомОргане;
		Если ТекущийКПП<>Неопределено Тогда 
			Режим = РежимДиалогаВопрос.ДаНет;
			Ответ = Вопрос("Строки с другими КПП будут удалены. Продолжить?",Режим,0);
			Если Ответ = КодВозвратаДиалога.Да Тогда 				
				ОтборПоКПП_НаСервере(ТекущийКПП);
			КонецЕсли;                               
		КонецЕсли;
	КонецЕсли;    
КонецПроцедуры

&НаСервере
Процедура ОтборПоКПП_НаСервере(ТекущийКПП)
		ТаблицаКопия = Объект.СписокФизЛиц.Выгрузить(Новый Структура("РегистрацияВНалоговомОргане", ТекущийКПП));
		Объект.СписокФизЛиц.Очистить();
		Объект.СписокФизЛиц.Загрузить(ТаблицаКопия);
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОтпускамиИБольничнымиНаСервере()
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	СУММА(РасчетыНалогоплательщиковСБюджетомПоНДФЛ.Сумма) КАК Сумма,
	               |	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.РегистрацияВНалоговомОргане,
	               |	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.Подразделение,
	               |	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.ФизическоеЛицо
	               |ИЗ
	               |	РегистрНакопления.РасчетыНалогоплательщиковСБюджетомПоНДФЛ КАК РасчетыНалогоплательщиковСБюджетомПоНДФЛ
	               |ГДЕ
	               |	(РасчетыНалогоплательщиковСБюджетомПоНДФЛ.Регистратор ССЫЛКА Документ.БольничныйЛист
	               |			ИЛИ РасчетыНалогоплательщиковСБюджетомПоНДФЛ.Регистратор ССЫЛКА Документ.Отпуск)
	               |	И РасчетыНалогоплательщиковСБюджетомПоНДФЛ.Регистратор.ПериодРегистрации = &ПериодРегистрации
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.РегистрацияВНалоговомОргане,
	               |	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.ФизическоеЛицо,
	               |	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.Подразделение
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.ФизическоеЛицо.Наименование";
	Запрос.УстановитьПараметр("ПериодРегистрации",НачалоМесяца(Период));				   
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда 
		Выборка = Результат.Выбрать();
		Организация = Справочники.Организации.ОрганизацияПоУмолчанию();
		РегистрацияОрганизации = Организация.РегистрацияВНалоговомОргане;
		Пока Выборка.Следующий() Цикл 
			НоваяСтрока = Объект.СписокФизЛиц.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
			НоваяСтрока.ДатаПлатежа = Период;
			Если ЗначениеЗаполнено(Выборка.Подразделение) Тогда
				Если ЗначениеЗаполнено(Выборка.Подразделение.РегистрацияВНалоговомОргане) Тогда
					НоваяСтрока.РегистрацияВНалоговомОргане = Выборка.Подразделение.РегистрацияВНалоговомОргане;	
					НоваяСтрока.ОКТМО_КПП = Выборка.Подразделение.РегистрацияВНалоговомОргане.КодПоОКТМО + "/" + Выборка.Подразделение.РегистрацияВНалоговомОргане.КПП;	
				Иначе
					НоваяСтрока.РегистрацияВНалоговомОргане = РегистрацияОрганизации;
					НоваяСтрока.ОКТМО_КПП = "45382000   /997950001";	
				КонецЕсли;
			Иначе
				НоваяСтрока.РегистрацияВНалоговомОргане = РегистрацияОрганизации;
				НоваяСтрока.ОКТМО_КПП = "45382000   /997950001";	
			КонецЕсли;

		КонецЦикла;
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура ЗаполнитьОтпускамиИБольничными(Команда)
	Объект.СписокФизЛиц.Очистить();
	ЗаполнитьОтпускамиИБольничнымиНаСервере();
КонецПроцедуры

