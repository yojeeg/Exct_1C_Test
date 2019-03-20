﻿////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

#Область ПрограммныйИнтерфейс

// Возвращает сведения о внешней обработке.
Функция СведенияОВнешнейОбработке() Экспорт
	
	ПараметрыРегистрации = ДополнительныеОтчетыИОбработки.СведенияОВнешнейОбработке("2.2.2.1");
	
	ПараметрыРегистрации.Вид = ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиПечатнаяФорма();
	ПараметрыРегистрации.Назначение.Добавить("Документ.ПриемНаРаботу");
	ПараметрыРегистрации.Версия = "1.3";
	ПараметрыРегистрации.БезопасныйРежим = Ложь;
	
	НоваяКоманда = ПараметрыРегистрации.Команды.Добавить();
	НоваяКоманда.Представление = НСтр("ru = 'ППФ ТД Основной с РХР (для регионов)'");
	НоваяКоманда.Идентификатор = "ТД_ОсновнойРХРРегионы";
	НоваяКоманда.Использование = ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыВызовКлиентскогоМетода();
	НоваяКоманда.ПоказыватьОповещение = Истина;
	
	Возврат ПараметрыРегистрации;
	
КонецФункции

#КонецОбласти


/////////////////////////////////////////////////////////////////////////
///////СЕРВИСНЫЕ ПРОЦЕДУРЫ И ФУКНЦИИ

Функция ПолучитьДанныеПечати(МассивОбъектов) Экспорт
	
	// Получим данные для заполнения макета
	Сотрудник = МассивОбъектов[0].Сотрудник;
	Если не Сотрудник.Пустая() Тогда 
		ФизЛицо = Сотрудник.ФизическоеЛицо;
	Иначе 
		ФизЛицо =Неопределено;
	КонецЕсли;
	
	МассивДанныхЗаполнения = ДанныеДляПечатиТрудовогоДоговора(МассивОбъектов);	
	Если МассивДанныхЗаполнения.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	Организация = МассивДанныхЗаполнения[0].Организация;
	
	Надбавки 		= "";
	ДатаДоговора 	= МассивДанныхЗаполнения[0].Ссылка.Дата;
	ДатаНачРаботы 	= МассивДанныхЗаполнения[0].ДатаПриема;
	Подразделение 	= МассивДанныхЗаполнения[0].Ссылка.Подразделение;
	Должность 		= МассивДанныхЗаполнения[0].Должность;
	Местонахождение = ПолучитьМестонахождения(Подразделение);
	ДолжностьПодразделение 	= "";
	ТаблицаПодразделений 	= ОпределитьПодразделение(Подразделение);
	ТаблицаДолжностей	 	= ОпределитьДолжность(Должность);
	ДолжностьВРодПадеже 	= "";
	ПодразделениеВПадеже 	= "";
	ПодразделениеРодПадеж	= "";
	РК=0;
	СН=0;
	ДопОтпуск = 0;
	Для Каждого СтрокаДолжности Из ТаблицаДолжностей Цикл 
		Если СтрокаДолжности.Свойство.Заголовок = "Родительный падеж" Тогда 
			ДолжностьВРодПадеже = СтрокаДолжности.Значение;
		КонецЕсли;
	КонецЦикла;
	Для Каждого СтрокаПодразделения Из ТаблицаПодразделений Цикл 
		Если СтрокаПодразделения.Свойство.Заголовок = "Винительный падеж" Тогда 
			ПодразделениеВПадеже=ПодразделениеВПадеже + СокрЛП(СтрокаПодразделения.Значение) + " ";
		КонецЕсли;
	КонецЦикла;		
	сч=1;
	Для Каждого СтрокаПодразделения Из ТаблицаПодразделений Цикл 
		Если сч=1 Тогда 
			Если СтрокаПодразделения.Свойство.Заголовок = "Винительный падеж" Тогда 
				ПодразделениеРодПадеж=ПодразделениеРодПадеж + СокрЛП(СтрокаПодразделения.Значение) + " ";
			КонецЕсли;
		Иначе 
			Если СтрокаПодразделения.Свойство.Заголовок = "Родительный падеж" Тогда 
				ПодразделениеРодПадеж=ПодразделениеРодПадеж + СокрЛП(СтрокаПодразделения.Значение) + " ";
			КонецЕсли;
		КонецЕсли;
		сч = сч+1;
	КонецЦикла;	
	ДолжностьПодразделение = СокрЛП(ДолжностьВРодПадеже);				
	ДанныеПоСотрудникуИОрганизации = СформироватьДанныеПоСотрудникуИОрганизации(Сотрудник, ФизЛицо, КонецДня(ДатаНачРаботы));
	МассивДляКИ = Новый Массив;
	МассивДляКИ.Добавить(ФизЛицо);
	ДомашнийТелефонФизЛица = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъектов(МассивДляКИ, ,Справочники.ВидыКонтактнойИнформации.ТелефонДомашнийФизическиеЛица);
	Если ДомашнийТелефонФизЛица.Количество() <> 0 Тогда 
		ДомашнийТелефонФизЛица = ДомашнийТелефонФизЛица[0].Представление;
	Иначе 
		ДомашнийТелефонФизЛица ="";
	КонецЕсли;
	МассивДляКИ.Очистить();
	МассивДляКИ.Добавить(Организация);
	ФаксОрганизации = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъектов(МассивДляКИ,,Справочники.ВидыКонтактнойИнформации.ФаксОрганизации);
	Если ФаксОрганизации.Количество() <> 0 Тогда 
		ФаксОрганизации = ФаксОрганизации[0].Представление;
	Иначе 
		ФаксОрганизации = "";
	КонецЕсли;
	ТелефонОрганизации = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъектов(МассивДляКИ,,Справочники.ВидыКонтактнойИнформации.ТелефонОрганизации);
	Если ТелефонОрганизации.Количество() <> 0 Тогда 
		ТелефонОрганизации = ТелефонОрганизации[0].Представление;
	Иначе 
		ТелефонОрганизации = "";
	КонецЕсли;	
	ДанныеПоОрганизации = СформироватьДанныеПоОрганизации(Организация);
	ЗарплатныйПроектОрганизации = ВзаиморасчетыССотрудникамиРасширенный.МестоВыплатыЗарплатыОрганизации(Организация.Ссылка).МестоВыплаты;
	Если ЗарплатныйПроектОрганизации<>Неопределено Тогда 
		БанкОрганизации = ЗарплатныйПроектОрганизации.Банк;
	Иначе 
		БанкОрганизации = Неопределено;
	КонецЕсли;
	// РК и СН
	РК = ПолучитьНадбавку(Сотрудник, Справочники.ПоказателиРасчетаЗарплаты.РайонныйКоэффициент);
	Если РК<>0 Тогда 
		РК = (РК - 1)*100;
	КонецЕсли;
	СН = ПолучитьНадбавку(Сотрудник, Справочники.ПоказателиРасчетаЗарплаты.СевернаяНадбавка);
	ДопОтпуск = ПолучитьДанныеОДопОтпуске(Сотрудник);
	
	СоответствиеПараметров = Новый Структура;
	ДобавитьПараметр(СоответствиеПараметров, "ДатаТД", 					Формат(ДатаНачРаботы,"ДЛФ=ДД"));
	ДобавитьПараметр(СоответствиеПараметров, "ДатаТД_1",				Формат(ДатаДоговора,"ДЛФ=ДД"));
	ДобавитьПараметр(СоответствиеПараметров, "НомерТД", 				МассивДанныхЗаполнения[0].ПриказОПриемеНомер);
	ДобавитьПараметр(СоответствиеПараметров, "ФИО", 					СокрЛП(МассивДанныхЗаполнения[0].ФИОПолные));
	ДобавитьПараметр(СоответствиеПараметров, "Местонахождение",			СокрЛП(Местонахождение));
	ДобавитьПараметр(СоответствиеПараметров, "ДолжностьПодразделение",	СокрЛП(ДолжностьПодразделение));
	ДобавитьПараметр(СоответствиеПараметров, "ПодразделениеАгентство",	СокрЛП(Подразделение));
	ДобавитьПараметр(СоответствиеПараметров, "Подразделение",			СокрЛП(ПодразделениеВПадеже));
	ДобавитьПараметр(СоответствиеПараметров, "ПодразделениеРодПадеж",	СокрЛП(ПодразделениеРодПадеж));
	ДобавитьПараметр(СоответствиеПараметров, "ИспСрок", 				Строка(МассивДанныхЗаполнения[0].ДлительностьИспытательногоСрока));
	ДобавитьПараметр(СоответствиеПараметров, "Сумма", 					Формат(ДанныеПоСотрудникуИОрганизации.Сумма));
	ДобавитьПараметр(СоответствиеПараметров, "СуммаПрописью",  			НРег(ЧислоПрописью(ДанныеПоСотрудникуИОрганизации.Сумма, "НП=Ложь",",,,,,,,,0")));
	ДобавитьПараметр(СоответствиеПараметров, "ТабНомер", 				ДанныеПоСотрудникуИОрганизации.ТабНомер);
	ДобавитьПараметр(СоответствиеПараметров, "ДатаРождения", 			Формат(ДанныеПоСотрудникуИОрганизации.ДатаРождения, "ДФ=дд.ММ.гггг"));
	ДобавитьПараметр(СоответствиеПараметров, "Паспорт", 				СокрЛП(ДанныеПоСотрудникуИОрганизации.Серия) + " № " + СокрЛП(ДанныеПоСотрудникуИОрганизации.Номер) + ", выдан " + СокрЛП(ДанныеПоСотрудникуИОрганизации.КемВыдан));
	ДобавитьПараметр(СоответствиеПараметров, "ДатаВыдачиПаспорта", 		Формат(ДанныеПоСотрудникуИОрганизации.ДатаВыдачи, "ДФ=дд.ММ.гггг"));
	ДобавитьПараметр(СоответствиеПараметров, "АдресРегистрации", 		МассивДанныхЗаполнения[0].АдресПоПропискеПредставление);
	ДобавитьПараметр(СоответствиеПараметров, "ИНН", 					ДанныеПоСотрудникуИОрганизации.ИНН);
	ДобавитьПараметр(СоответствиеПараметров, "СтрахСвид", 				ДанныеПоСотрудникуИОрганизации.СтраховойНомерПФР);
	ДобавитьПараметр(СоответствиеПараметров, "ДомТелефон", 				ДомашнийТелефонФизЛица);
	ДобавитьПараметр(СоответствиеПараметров, "ИОФ", 					МассивДанныхЗаполнения[0].ФамилияИО);
	ДобавитьПараметр(СоответствиеПараметров, "Организация", 			МассивДанныхЗаполнения[0].ОрганизацияНаименованиеПолное);
	ДобавитьПараметр(СоответствиеПараметров, "ОрганизацияСокр", 		ДанныеПоОрганизации.ОрганизацияСокр);
	ДобавитьПараметр(СоответствиеПараметров, "АдресОрг", 				МассивДанныхЗаполнения[0].ОрганизацияАдресФактический);
	ДобавитьПараметр(СоответствиеПараметров, "ФаксОрг", 				ФаксОрганизации);
	ДобавитьПараметр(СоответствиеПараметров, "ТелефонОрг", 				ТелефонОрганизации);
	ДобавитьПараметр(СоответствиеПараметров, "ИННОрг", 					ДанныеПоОрганизации.ИННОрг);
	ДобавитьПараметр(СоответствиеПараметров, "РК", 						РК);
	ДобавитьПараметр(СоответствиеПараметров, "СН", 						СН);
	ДобавитьПараметр(СоответствиеПараметров, "ДопОтпуск", 				ДопОтпуск);
	РеквизитыОрганизации = ПолучитьРеквизиты();
	Если РеквизитыОрганизации <> Неопределено Тогда 
		ДобавитьПараметр(СоответствиеПараметров, "БИКОрг", 		РеквизитыОрганизации.БИКОрг);	
		ДобавитьПараметр(СоответствиеПараметров, "РасчСчет",	РеквизитыОрганизации.РасчСчет);	
		ДобавитьПараметр(СоответствиеПараметров, "КорСчет", 	РеквизитыОрганизации.КорСчет);	
		ДобавитьПараметр(СоответствиеПараметров, "НаимБанка", 	РеквизитыОрганизации.НаимБанка);	
	КонецЕсли;
	
	Возврат СоответствиеПараметров;

КонецФункции

Функция ПолучитьРеквизиты()
	СтруктураРеквизитов = Новый Структура;
	Свойства = Новый Массив;
	Свойства.Добавить(ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию("Наименование банка основного счёта"));
	Свойства.Добавить(ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию("КорСчет основного счёта"));
	Свойства.Добавить(ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию("Расчетный счет основного счёта"));
	Свойства.Добавить(ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию("БИК банка основного счёта"));
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	ДополнительныеСведения.Значение,
	               |	ДополнительныеСведения.Свойство
	               |ИЗ
	               |	РегистрСведений.ДополнительныеСведения КАК ДополнительныеСведения
	               |ГДЕ
	               |	ДополнительныеСведения.Объект = &Объект
	               |	И ДополнительныеСведения.Свойство В(&Свойства)";
	Запрос.УстановитьПараметр("Свойства",Свойства);				   
	Запрос.УстановитьПараметр("Объект",Справочники.Организации.ОрганизацияПоУмолчанию());
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда 
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл 
			Если Выборка.Свойство = ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию("Наименование банка основного счёта") Тогда  
				СтруктураРеквизитов.Вставить("НаимБанка",Выборка.Значение);
			ИначеЕсли Выборка.Свойство = ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию("КорСчет основного счёта") Тогда  
				СтруктураРеквизитов.Вставить("КорСчет",Выборка.Значение);
			ИначеЕсли Выборка.Свойство = ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию("Расчетный счет основного счёта") Тогда  
				СтруктураРеквизитов.Вставить("РасчСчет",Выборка.Значение);				
			ИначеЕсли Выборка.Свойство = ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию("БИК банка основного счёта") Тогда  
				СтруктураРеквизитов.Вставить("БИКОрг",Выборка.Значение);								
			КонецЕсли;
		КонецЦикла;
		Возврат СтруктураРеквизитов;
	Иначе 
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

Процедура ДобавитьПараметр(Структура, ИсходнаяСтрока, СтрокаЗамены)
	 Структура.Вставить(ИсходнаяСтрока,СтрокаЗамены);
КонецПроцедуры

Функция ПолучитьМестонахождения(Подразделение)

	Местонахождение = "";
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ДополнительныеСведения.Объект КАК Объект,
	               |	ДополнительныеСведения.Свойство КАК Свойство,
	               |	ДополнительныеСведения.Значение КАК Значение
	               |ИЗ
	               |	РегистрСведений.ДополнительныеСведения КАК ДополнительныеСведения
	               |ГДЕ
	               |	ДополнительныеСведения.Объект = &Ссылка
	               |	И ДополнительныеСведения.Свойство = &Свойство";
	
	Запрос.УстановитьПараметр("Свойство", ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию("Местонахождение для ТД"));
	Запрос.УстановитьПараметр("Ссылка", Подразделение);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Местонахождение = Выборка.Значение;
	КонецЦикла;
	
	Возврат Местонахождение;
	
	
КонецФункции // ПолучитьМестонахождения()

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

Функция ДанныеДляПечатиТрудовогоДоговора(МассивОбъектов)
	
	МассивПараметров = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ПриемНаРаботу.ТрудовойДоговорНомер КАК ПриказОПриемеНомер,
		|	ПриемНаРаботу.Дата КАК ПриказОПриемеДата,
		|	ПриемНаРаботу.Организация.НаименованиеПолное КАК ОрганизацияНаименованиеПолное,
		|	ПриемНаРаботу.Организация.НаименованиеСокращенное КАК ОрганизацияНаименованиеСокращенное,
		|	ПриемНаРаботу.Сотрудник,
		|	ПриемНаРаботу.Должность,
		|	ПриемНаРаботу.Подразделение,
		|	ПриемНаРаботу.ВидЗанятости,
		|	ПриемНаРаботу.ТрудовойДоговорНомер,
		|	ПриемНаРаботу.ТрудовойДоговорДата,
		|	ПриемНаРаботу.Руководитель,
		|	ПриемНаРаботу.ДолжностьРуководителя,
		|	ПриемНаРаботу.ДатаПриема,
		|	ПриемНаРаботу.Ссылка,
		|	ПриемНаРаботу.Организация,
		|	ПриемНаРаботу.ДатаЗавершенияТрудовогоДоговора,
		|	ПриемНаРаботу.ДлительностьИспытательногоСрока
		|ПОМЕСТИТЬ ВТДанныеПриказаОПриеме
		|ИЗ
		|	Документ.ПриемНаРаботу КАК ПриемНаРаботу
		|ГДЕ
		|	ПриемНаРаботу.Ссылка В(&МассивОбъектов)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	ДанныеПриказаОПриеме.Сотрудник,
		|	ДанныеПриказаОПриеме.ДатаПриема КАК Период
		|ПОМЕСТИТЬ ВТСотрудникиПериоды
		|ИЗ
		|	ВТДанныеПриказаОПриеме КАК ДанныеПриказаОПриеме
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ДанныеПриказаОПриеме.Руководитель КАК ФизическоеЛицо,
		|	ДанныеПриказаОПриеме.ДатаПриема КАК Период
		|ПОМЕСТИТЬ ВТФизическиеЛицаПериоды
		|ИЗ
		|	ВТДанныеПриказаОПриеме КАК ДанныеПриказаОПриеме";
		
	Запрос.Выполнить();
	
	// Получение кадровых данных сотрудника
	ОписательВременныхТаблиц = КадровыйУчет.ОписательВременныхТаблицДляСоздатьВТКадровыеДанныеСотрудников(
		Запрос.МенеджерВременныхТаблиц,
		"ВТСотрудникиПериоды");
	КадровыеДанные = "ФИОПолные,ФамилияИО,АдресПоПропискеПредставление,ДокументПредставление,Пол";
	КадровыйУчет.СоздатьВТКадровыеДанныеСотрудников(ОписательВременныхТаблиц, Истина, КадровыеДанные);
	
	// Получение ФИО руководителей
	ОписательВременныхТаблиц = КадровыйУчет.ОписательВременныхТаблицДляСоздатьВТКадровыеДанныеФизическихЛиц(
		Запрос.МенеджерВременныхТаблиц,
		"ВТФизическиеЛицаПериоды");
	КадровыеДанные = "ФИОПолные,ФамилияИО,Пол";
	КадровыйУчет.СоздатьВТКадровыеДанныеФизическихЛиц(ОписательВременныхТаблиц, Истина, КадровыеДанные);
	
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДанныеПриказаОПриеме.Организация,
		|	ДанныеПриказаОПриеме.ПриказОПриемеДата КАК Период
		|ИЗ
		|	ВТДанныеПриказаОПриеме КАК ДанныеПриказаОПриеме";
	
	СведенияОбОрганизациях = Новый ТаблицаЗначений;
	СведенияОбОрганизациях.Колонки.Добавить("Организация", Новый ОписаниеТипов("СправочникСсылка.Организации"));
	СведенияОбОрганизациях.Колонки.Добавить("Период", Новый ОписаниеТипов("Дата"));
	СведенияОбОрганизациях.Колонки.Добавить("НаименованиеПолное", Новый ОписаниеТипов("Строка"));
	СведенияОбОрганизациях.Колонки.Добавить("АдресЮридический", Новый ОписаниеТипов("Строка"));
	СведенияОбОрганизациях.Колонки.Добавить("АдресФактический", Новый ОписаниеТипов("Строка"));
	СведенияОбОрганизациях.Колонки.Добавить("ОрганизацияГородФактическогоАдреса", Новый ОписаниеТипов("Строка"));
	
	РезультатЗапросаПоШапке = Запрос.Выполнить();
	
	АдресаОрганизаций = УправлениеКонтактнойИнформациейЗарплатаКадры.АдресаОрганизаций(РезультатЗапросаПоШапке.Выгрузить().ВыгрузитьКолонку("Организация"));
	
	Выборка = РезультатЗапросаПоШапке.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрокаСведенияОбОрганизациях = СведенияОбОрганизациях.Добавить();
		
		Сведения = Новый СписокЗначений;
		Сведения.Добавить("", "НаимЮЛПол");
	
		ОргСведения = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Выборка.Организация, Выборка.Период, Сведения);
		
		НоваяСтрокаСведенияОбОрганизациях.Организация = Выборка.Организация;
		НоваяСтрокаСведенияОбОрганизациях.Период = Выборка.Период;
		НоваяСтрокаСведенияОбОрганизациях.НаименованиеПолное = ОргСведения.НаимЮЛПол;
		
		ОписаниеЮридическогоАдреса = УправлениеКонтактнойИнформациейЗарплатаКадры.АдресОрганизации(
			АдресаОрганизаций,
			Выборка.Организация,
			Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации);
		НоваяСтрокаСведенияОбОрганизациях.АдресЮридический = ОписаниеЮридическогоАдреса.Представление;
		
		ОписаниеФактическогоАдреса = УправлениеКонтактнойИнформациейЗарплатаКадры.АдресОрганизации(
			АдресаОрганизаций,
			Выборка.Организация,
			Справочники.ВидыКонтактнойИнформации.ФактАдресОрганизации);
		НоваяСтрокаСведенияОбОрганизациях.АдресФактический = ОписаниеФактическогоАдреса.Представление;
		НоваяСтрокаСведенияОбОрганизациях.ОрганизацияГородФактическогоАдреса = ОписаниеФактическогоАдреса.Город;
		
	КонецЦИкла;
	
	Запрос.УстановитьПараметр("СведенияОбОрганизациях", СведенияОбОрганизациях);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	СведенияОбОрганизациях.Период,
		|	СведенияОбОрганизациях.Организация,
		|	СведенияОбОрганизациях.НаименованиеПолное КАК ОрганизацияНаименованиеПолное,
		|	СведенияОбОрганизациях.АдресЮридический КАК ОрганизацияАдресЮридический,
		|	СведенияОбОрганизациях.АдресФактический КАК ОрганизацияАдресФактический,
		|	СведенияОбОрганизациях.ОрганизацияГородФактическогоАдреса КАК ОрганизацияГородФактическогоАдреса
		|ПОМЕСТИТЬ ВТДанныеОрганизаций
		|ИЗ
		|	&СведенияОбОрганизациях КАК СведенияОбОрганизациях
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДанныеПриказаОПриеме.Ссылка,
		|	ДанныеПриказаОПриеме.ПриказОПриемеНомер,
		|	ДанныеПриказаОПриеме.ПриказОПриемеДата,
		|	ДанныеПриказаОПриеме.Должность,
		|	ДанныеПриказаОПриеме.ВидЗанятости,
		|	ДанныеПриказаОПриеме.ТрудовойДоговорНомер,
		|	ДанныеПриказаОПриеме.ТрудовойДоговорДата,
		|	ДанныеПриказаОПриеме.ДлительностьИспытательногоСрока,
		|	ДанныеПриказаОПриеме.ДолжностьРуководителя КАК РуководительДолжность,
		|	ДанныеПриказаОПриеме.ДатаПриема,
		|	ДанныеПриказаОПриеме.ДатаЗавершенияТрудовогоДоговора,
		|	ДанныеОрганизаций.ОрганизацияНаименованиеПолное,
		|	ДанныеОрганизаций.ОрганизацияАдресЮридический,
		|	ДанныеОрганизаций.ОрганизацияАдресФактический,
		|	ДанныеОрганизаций.ОрганизацияГородФактическогоАдреса,
		|	ДанныеОрганизаций.Организация,
		|	ЕСТЬNULL(КадровыеДанныеФизическихЛиц.ФИОПолные, """") КАК РуководительФИОПолные,
		|	КадровыеДанныеФизическихЛиц.ФамилияИО КАК РуководительФамилияИО,
		|	КадровыеДанныеСотрудников.ФИОПолные КАК ФИОПолные,
		|	КадровыеДанныеСотрудников.ФамилияИО КАК ФамилияИО,
		|	КадровыеДанныеСотрудников.АдресПоПропискеПредставление КАК АдресПоПропискеПредставление,
		|	КадровыеДанныеСотрудников.ДокументПредставление КАК ДокументПредставление
		|ИЗ
		|	ВТДанныеПриказаОПриеме КАК ДанныеПриказаОПриеме
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТДанныеОрганизаций КАК ДанныеОрганизаций
		|		ПО ДанныеПриказаОПриеме.Организация = ДанныеОрганизаций.Организация
		|			И ДанныеПриказаОПриеме.ПриказОПриемеДата = ДанныеОрганизаций.Период
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТКадровыеДанныеФизическихЛиц КАК КадровыеДанныеФизическихЛиц
		|		ПО ДанныеПриказаОПриеме.Руководитель = КадровыеДанныеФизическихЛиц.ФизическоеЛицо
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТКадровыеДанныеСотрудников КАК КадровыеДанныеСотрудников
		|		ПО ДанныеПриказаОПриеме.Сотрудник = КадровыеДанныеСотрудников.Сотрудник";
		
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ФИО = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Выборка.ФИОПолные, " ");		
		СтрокаФИО = "";
		Если ФИО.Количество()=3 Тогда 
			СтрокаФИО = Лев(ФИО[1],1) +"."+ Лев(ФИО[2],1)+". "+ ФИО[0];
		КонецЕсли;
				
		ПараметрыТрудовогоДоговора = ПараметрыТрудовогоДоговора();
		ЗаполнитьЗначенияСвойств(ПараметрыТрудовогоДоговора, Выборка);
					
		РезультатСклонения = "";
		Если ФизическиеЛицаЗарплатаКадры.Просклонять(ПараметрыТрудовогоДоговора.РуководительФИОПолные, 4, РезультатСклонения, ПараметрыТрудовогоДоговора.Пол) Тогда
			ПараметрыТрудовогоДоговора.РуководительФИОПолные = РезультатСклонения
		КонецЕсли;
		
		ПараметрыТрудовогоДоговора.ТрудовойДоговорДата = Формат(Выборка.ТрудовойДоговорДата, "ДЛФ=DD; ДП='""___"" ____________ 20___ г.'");
		ПараметрыТрудовогоДоговора.ПриказОПриемеДата = Формат(Выборка.ПриказОПриемеДата, "ДЛФ=D; ДЛФ=DD");
		ПараметрыТрудовогоДоговора.ДатаПриема = Выборка.ДатаПриема;
		
		Если Выборка.ВидЗанятости = Перечисления.ВидыЗанятости.ОсновноеМестоРаботы Тогда
			ПараметрыТрудовогоДоговора.ВидЗанятостиПоДоговору = НСтр("ru='основным местом работы'");
		Иначе
			ПараметрыТрудовогоДоговора.ВидЗанятостиПоДоговору = НСтр("ru='местом работы по совместительству'");
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Выборка.ДатаЗавершенияТрудовогоДоговора) Тогда
			ПараметрыТрудовогоДоговора.СрокДействияПредставление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='на срок до %1'"),
				Формат(Выборка.ДатаЗавершенияТрудовогоДоговора, "ДЛФ=DD"));
		Иначе
			ПараметрыТрудовогоДоговора.СрокДействияПредставление = НСтр("ru='на неопределенный срок'");
		КонецЕсли;
		
		Если Не ПустаяСтрока(СтрокаФИО) Тогда 
			ПараметрыТрудовогоДоговора.ФамилияИО = СтрокаФИО;
		КонецЕсли;		
		МассивПараметров.Добавить(ПараметрыТрудовогоДоговора);
		
	КонецЦикла;
	
	Возврат МассивПараметров;
	
КонецФункции

Функция ПараметрыТрудовогоДоговора()
	
	Параметры = Новый Структура;
	Параметры.Вставить("Ссылка", 								Неопределено);
	Параметры.Вставить("ПриказОПриемеНомер", 					"");
	Параметры.Вставить("ПриказОПриемеДата", 					'00010101');
	Параметры.Вставить("ОрганизацияНаименованиеПолное", 		"");
	Параметры.Вставить("ОрганизацияАдресЮридический", 			"");
	Параметры.Вставить("ОрганизацияАдресФактический", 			"");
	Параметры.Вставить("ОрганизацияГородФактическогоАдреса", 	"");
	Параметры.Вставить("Сотрудник", 							Справочники.Сотрудники.ПустаяСсылка());
	Параметры.Вставить("Подразделение", 						Справочники.ПодразделенияОрганизаций.ПустаяСсылка());
	Параметры.Вставить("Должность", 							Справочники.Должности.ПустаяСсылка());
	Параметры.Вставить("ВидЗанятостиПоДоговору", 				"");
	Параметры.Вставить("ТрудовойДоговорНомер", 					"");
	Параметры.Вставить("ТрудовойДоговорДата", 					'00010101');
	Параметры.Вставить("СрокДействияПредставление", 			"");
	Параметры.Вставить("РуководительФамилияИО", 				"");
	Параметры.Вставить("РуководительФИОПолные", 				"");
	Параметры.Вставить("РуководительДолжность", 				Справочники.Должности.ПустаяСсылка());
	Параметры.Вставить("ДатаПриема", 							'00010101');
	Параметры.Вставить("ФИОПолные", 							"");
	Параметры.Вставить("ФамилияИО", 							"");
	Параметры.Вставить("Пол",									Неопределено);
	Параметры.Вставить("АдресПоПропискеПредставление", 			"");
	Параметры.Вставить("ДокументПредставление", 				"");
	Параметры.Вставить("ДлительностьИспытательногоСрока", 		"");
	Параметры.Вставить("Организация",							"");
	Параметры.Вставить("Местонахождение",						"");
	Параметры.Вставить("ПодразделениеАгентство",				"");
	Параметры.Вставить("РК",									"");
	Параметры.Вставить("СН",									"");
	Параметры.Вставить("ДопОтпуск",								"");  
		
	Возврат Параметры;
	
КонецФункции

Функция СформироватьДанныеПоСотрудникуИОрганизации(Сотрудник, ФизЛицо, Дата)
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	Сотрудники.Код КАК ТабНомер,
	               |	ДокументыФизическихЛицСрезПоследних.Серия,
	               |	ДокументыФизическихЛицСрезПоследних.Номер,
	               |	ДокументыФизическихЛицСрезПоследних.ДатаВыдачи,
	               |	ДокументыФизическихЛицСрезПоследних.КемВыдан,
	               |	ЕСТЬNULL(ФизическиеЛица.Ссылка.ДатаРождения, ДАТАВРЕМЯ(1, 1, 1)) КАК ДатаРождения,
	               |	ЕСТЬNULL(ФизическиеЛица.Ссылка.ИНН, """") КАК ИНН,
	               |	ЕСТЬNULL(ФизическиеЛица.Ссылка.СтраховойНомерПФР, """") КАК СтраховойНомерПФР,
	               |	ЕСТЬNULL(ЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудниковСрезПоследних.Значение, 0) КАК Сумма
	               |ИЗ
	               |	Справочник.Сотрудники КАК Сотрудники
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДокументыФизическихЛиц.СрезПоследних(
	               |				&ДатаДокумента,
	               |				Физлицо = &ФизЛицо
	               |					И ВидДокумента = &ВидДокумента) КАК ДокументыФизическихЛицСрезПоследних
	               |		ПО Сотрудники.ФизическоеЛицо = ДокументыФизическихЛицСрезПоследних.Физлицо
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ФизическиеЛица КАК ФизическиеЛица
	               |		ПО Сотрудники.ФизическоеЛицо = ФизическиеЛица.Ссылка
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудников.СрезПоследних(
	               |				&ДатаДокумента,
	               |				Сотрудник = &Сотрудник
	               |					И Показатель = &Показатель) КАК ЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудниковСрезПоследних
	               |		ПО Сотрудники.Ссылка = ЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудниковСрезПоследних.Сотрудник
	               |ГДЕ
	               |	Сотрудники.Ссылка = &Сотрудник";
	Запрос.УстановитьПараметр("ДатаДокумента",КонецДня(Дата));
	Запрос.УстановитьПараметр("ФизЛицо",ФизЛицо);
	Запрос.УстановитьПараметр("Сотрудник",Сотрудник);
	Запрос.УстановитьПараметр("ВидДокумента",Справочники.ВидыДокументовФизическихЛиц.ПаспортРФ);
	Запрос.УстановитьПараметр("Показатель",Справочники.ПоказателиРасчетаЗарплаты.Оклад);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка;

КонецФункции

Функция СформироватьДанныеПоОрганизации(Организация)
	
	Запрос = Новый Запрос;
	Запрос.Текст ="ВЫБРАТЬ
	|	Организации.НаименованиеСокращенное КАК ОрганизацияСокр,
	|	Организации.ИНН КАК ИННОрг
	|ИЗ
	|	Справочник.Организации КАК Организации
	|ГДЕ
	|	Организации.Ссылка = &Организация";
	
	Запрос.УстановитьПараметр("Организация",Организация);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Выборка.Следующий();
	
	Возврат Выборка;
	
КонецФункции

Функция ПолучитьНадбавку(Сотрудник, ВидНадбавки)
	ЗапросПоНадбавкам = Новый Запрос;
	ЗапросПоНадбавкам.Текст = "ВЫБРАТЬ
	                          |	ЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудниковСрезПоследних.Значение
	                          |ИЗ
	                          |	РегистрСведений.ЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудников.СрезПоследних КАК ЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудниковСрезПоследних
	                          |ГДЕ
	                          |	ЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудниковСрезПоследних.Сотрудник = &Сотрудник
	                          |	И ЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудниковСрезПоследних.Показатель = &Показатель";
	ЗапросПоНадбавкам.УстановитьПараметр("Сотрудник",Сотрудник);							  
	ЗапросПоНадбавкам.УстановитьПараметр("Показатель",ВидНадбавки);
	Выборка = ЗапросПоНадбавкам.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда 
		Возврат Выборка.Значение;
	Иначе 
		Возврат 0;
	КонецЕсли;
КонецФункции

Функция ПолучитьДанныеОДопОтпуске(Сотрудник)
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	ПоложенныеВидыЕжегодныхОтпусковСрезПоследних.КоличествоДнейВГод
	               |ИЗ
	               |	РегистрСведений.ПоложенныеВидыЕжегодныхОтпусков.СрезПоследних КАК ПоложенныеВидыЕжегодныхОтпусковСрезПоследних
	               |ГДЕ
	               |	ПоложенныеВидыЕжегодныхОтпусковСрезПоследних.Сотрудник = &Сотрудник
	               |	И ПоложенныеВидыЕжегодныхОтпусковСрезПоследних.ВидЕжегодногоОтпуска = &ВидЕжегодногоОтпуска";
	Запрос.УстановитьПараметр("Сотрудник",Сотрудник);				   
	Запрос.УстановитьПараметр("ВидЕжегодногоОтпуска",Справочники.ВидыОтпусков.НайтиПоНаименованию("Дополнительный ежегодный отпуск")); 
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда 
		Возврат Выборка.КоличествоДнейВГод;
	Иначе 
		Возврат 0;
	КонецЕсли;
КонецФункции
/////////////////////////////////////////////////////////////////////////

