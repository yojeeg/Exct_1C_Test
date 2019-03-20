﻿Функция ПолучитьТабДокПочтоыйПеревод(Макет,МассивОбъектов, ОбъектыПечати) Экспорт
	
	ТабДокумент = Новый ТабличныйДокумент;
	
	Запрос = Новый Запрос;	
	Запрос.Текст = "ВЫБРАТЬ
	               |	СУММА(ВедомостьНаВыплатуЗарплатыВБанкЗарплата.КВыплате + ВедомостьНаВыплатуЗарплатыВБанкЗарплата.КомпенсацияЗаЗадержкуЗарплаты) КАК Сумма,
	               |	ФИОФизическихЛицСрезПоследних.Фамилия КАК Фамилия,
	               |	ФИОФизическихЛицСрезПоследних.Имя,
	               |	ФИОФизическихЛицСрезПоследних.Отчество,
	               |	ВедомостьНаВыплатуЗарплатыВБанкЗарплата.Сотрудник,
	               |	ВедомостьНаВыплатуЗарплатыВБанкЗарплата.Ссылка.ПериодРегистрации,
	               |	ВедомостьНаВыплатуЗарплатыВБанкЗарплата.Ссылка.Дата,
	               |	СведенияОбОтветственныхЛицахСрезПоследних.ДолжностьРуководителя,
	               |	СведенияОбОтветственныхЛицахСрезПоследних.Руководитель КАК ФИОРуководителя,
	               |	ВедомостьНаВыплатуЗарплатыВБанкЗарплата.Ссылка.СпособВыплаты КАК ВидПеречисления,
	               |	ВедомостьНаВыплатуЗарплатыВБанкЗарплата.Ссылка.Организация,
	               |	АдресПроживания.Счет
	               |ИЗ
	               |	Документ.ВедомостьНаВыплатуЗарплатыВБанк.Зарплата КАК ВедомостьНаВыплатуЗарплатыВБанкЗарплата
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ФИОФизическихЛиц.СрезПоследних КАК ФИОФизическихЛицСрезПоследних
	               |		ПО ВедомостьНаВыплатуЗарплатыВБанкЗарплата.Сотрудник.ФизическоеЛицо = ФИОФизическихЛицСрезПоследних.ФизическоеЛицо
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СведенияОбОтветственныхЛицах.СрезПоследних КАК СведенияОбОтветственныхЛицахСрезПоследних
	               |		ПО ВедомостьНаВыплатуЗарплатыВБанкЗарплата.Ссылка.Организация = СведенияОбОтветственныхЛицахСрезПоследних.Организация
	               |		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	               |			ФизическиеЛицаКонтактнаяИнформация.Ссылка КАК ФизЛицо,
	               |			ФизическиеЛицаКонтактнаяИнформация.Представление КАК Счет
	               |		ИЗ
	               |			Справочник.ФизическиеЛица.КонтактнаяИнформация КАК ФизическиеЛицаКонтактнаяИнформация
	               |		ГДЕ
	               |			ФизическиеЛицаКонтактнаяИнформация.Вид = &Вид) КАК АдресПроживания
	               |		ПО ВедомостьНаВыплатуЗарплатыВБанкЗарплата.Сотрудник.ФизическоеЛицо = АдресПроживания.ФизЛицо
	               |ГДЕ
	               |	ВедомостьНаВыплатуЗарплатыВБанкЗарплата.Ссылка = &Ссылка
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ВедомостьНаВыплатуЗарплатыВБанкЗарплата.Ссылка.Организация,
	               |	АдресПроживания.Счет,
	               |	ФИОФизическихЛицСрезПоследних.Фамилия,
	               |	ФИОФизическихЛицСрезПоследних.Имя,
	               |	ФИОФизическихЛицСрезПоследних.Отчество,
	               |	ВедомостьНаВыплатуЗарплатыВБанкЗарплата.Сотрудник,
	               |	ВедомостьНаВыплатуЗарплатыВБанкЗарплата.Ссылка.ПериодРегистрации,
	               |	ВедомостьНаВыплатуЗарплатыВБанкЗарплата.Ссылка.Дата,
	               |	СведенияОбОтветственныхЛицахСрезПоследних.ДолжностьРуководителя,
	               |	СведенияОбОтветственныхЛицахСрезПоследних.Руководитель,
	               |	ВедомостьНаВыплатуЗарплатыВБанкЗарплата.Ссылка.СпособВыплаты
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Фамилия";
	Запрос.УстановитьПараметр("Ссылка",МассивОбъектов[0]);				   
	Запрос.УстановитьПараметр("Вид",Справочники.ВидыКонтактнойИнформации.АдресМестаПроживанияФизическиеЛица);
	Запрос.УстановитьПараметр("СпособВыплаты",Справочники.СпособыВыплатыЗарплаты.Зарплата);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ШапкаДокумента = Макет.ПолучитьОбласть("Шапка");
	ПодвалДокумента = Макет.ПолучитьОбласть("Подвал");
	СтрокаДокумента = Макет.ПолучитьОбласть("Строка");
	
	Итого=0;
	Итого2=0;
	
	ШапкаВыведена = Ложь;
	
	Счетчик=1;
	
	Пока Выборка.Следующий() Цикл 
		
		Если не ШапкаВыведена Тогда 
						
			Если Месяц(Выборка.ПериодРегистрации)=1 Тогда
				МесПер="январь"
			ИначеЕсли Месяц(Выборка.ПериодРегистрации)=2 Тогда
				МесПер="февраль"
			ИначеЕсли Месяц(Выборка.ПериодРегистрации)=3 Тогда
				МесПер="март"
			ИначеЕсли Месяц(Выборка.ПериодРегистрации)=4 Тогда
				МесПер="апрель"
			ИначеЕсли Месяц(Выборка.ПериодРегистрации)=5 Тогда
				МесПер="май"
			ИначеЕсли Месяц(Выборка.ПериодРегистрации)=6 Тогда
				МесПер="июнь"
			ИначеЕсли Месяц(Выборка.ПериодРегистрации)=7 Тогда
				МесПер="июль"
			ИначеЕсли Месяц(Выборка.ПериодРегистрации)=8 Тогда
				МесПер="август"
			ИначеЕсли Месяц(Выборка.ПериодРегистрации)=9 Тогда
				МесПер="сентябрь"
			ИначеЕсли Месяц(Выборка.ПериодРегистрации)=10 Тогда
				МесПер="октябрь"
			ИначеЕсли Месяц(Выборка.ПериодРегистрации)=11 Тогда
				МесПер="ноябрь"
			ИначеЕсли Месяц(Выборка.ПериодРегистрации)=12 Тогда
				МесПер="декабрь"
			КонецЕсли;
			ШапкаДокумента.Параметры.МесяцПеречисления=МесПер+" "+Формат(Год(Выборка.ПериодРегистрации),"ЧГ=")+" г.";
			ШапкаДокумента.Параметры.ВидПеречисления=Выборка.ВидПеречисления;
			ШапкаДокумента.Параметры.ДатаДок=Формат(Выборка.Дата,"ДФ=dd.MM.yyyy");
			ШапкаДокумента.Параметры.ОрганизацияСокр = Выборка.Организация.НаименованиеСокращенное;
			
			ПодвалДокумента.Параметры.ФИОРуководителя = Выборка.ФИОРуководителя;
			ПодвалДокумента.Параметры.ДолжностьРуководителя = Выборка.ДолжностьРуководителя;			
			
			ТабДокумент.Вывести(ШапкаДокумента);
			ШапкаВыведена = Истина;
			
		КонецЕсли;
	
		СтрокаДокумента.Параметры.Заполнить(Выборка);
		Счет = СтрокаДокумента.Параметры.Счет;
		Если Не ПустаяСтрока(Счет) Тогда
			НомерЗапятой = СтрНайти(Счет,",");
			Если НомерЗапятой<>0 Тогда 
				СтрокаПроверки = СокрЛП(Лев(Счет, НомерЗапятой-1));
				Попытка
					Проверка = Число(СтрокаПроверки);
				Исключение
					СтрокаДокумента.Параметры.Счет = СокрЛП(Прав(Счет, СтрДлина(Счет)-НомерЗапятой));
				КонецПопытки;
			КонецЕсли;
		КонецЕсли;
		СтрокаДокумента.Параметры.Номер = Счетчик;
		Если МассивОбъектов[0].Дата>=Дата('20150401') Тогда 
			СтрокаДокумента.Параметры.ВтороеЗначение=Макс(Окр(Выборка.Сумма*0.02,2),50);
		Иначе 
			СтрокаДокумента.Параметры.ВтороеЗначение=Макс(Окр(Выборка.Сумма*0.018,2),50);
		КонецЕсли;
		
		Итого=Итого+Выборка.Сумма;
		Если МассивОбъектов[0].Дата>=Дата('20150401') Тогда 
			Итого2=Итого2+Макс(Окр(Выборка.Сумма*0.02,2),50);
		Иначе 
			Итого2=Итого2+Макс(Окр(Выборка.Сумма*0.018,2),50);
		КонецЕсли;
		
		ТабДокумент.Вывести(СтрокаДокумента);
		Счетчик = Счетчик + 1;

	КонецЦикла;
	
	ПодвалДокумента.Параметры.Итого=Итого;
	ПодвалДокумента.Параметры.ВтороеЗначение=Итого2;
	ПодвалДокумента.Параметры.ИтогоПрописью = РаботаСКурсамиВалют.СформироватьСуммуПрописью(Итого, ЗарплатаКадры.ВалютаУчетаЗаработнойПлаты());
	
	ТабДокумент.Вывести(ПодвалДокумента);
	
	ТабДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	ТабДокумент.ТолькоПросмотр = Истина;
	
	Возврат ТабДокумент;
	
КонецФункции

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
	МассивНазначений.Добавить("Документ.ВедомостьНаВыплатуЗарплатыВБанк");
	ПараметрыРегистрации.Вставить("Вид", "ПечатнаяФорма"); //может быть - ЗаполнениеОбъекта, ДополнительныйОтчет, СозданиеСвязанныхОбъектов... 
	ПараметрыРегистрации.Вставить("Назначение", МассивНазначений);
	ПараметрыРегистрации.Вставить("Наименование", " Почтовые переводы "); //имя под которым обработка будет зарегестрирована в справочнике внешних обработок
	ПараметрыРегистрации.Вставить("Версия", "1.0");
	ПараметрыРегистрации.Вставить("БезопасныйРежим", Ложь);
	ПараметрыРегистрации.Вставить("Информация", " Почтовые переводы ");//так будет выглядеть описание печ.формы для пользователя
	ТаблицаКоманд = ПолучитьТаблицуКоманд();
	ДобавитьКоманду(ТаблицаКоманд, "Почтовые переводы", "ПочтовыеПереводы", "ВызовСерверногоМетода", Истина);
	ПараметрыРегистрации.Вставить("Команды", ТаблицаКоманд);
	Возврат ПараметрыРегистрации;
КонецФункции

Процедура Печать(МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Макет = ПолучитьМакет("ПочтовыеПереводы");
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПочтовыеПереводы") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
		"ПочтовыеПереводы", "Почтовые переводы",	ПолучитьТабДокПочтоыйПеревод(Макет,МассивОбъектов, ОбъектыПечати));
	КонецЕсли;
	
КонецПроцедуры
