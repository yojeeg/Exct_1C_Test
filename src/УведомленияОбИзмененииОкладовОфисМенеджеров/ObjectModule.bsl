﻿////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область ПрограммныйИнтерфейс

// Возвращает сведения о внешней обработке.
Функция СведенияОВнешнейОбработке() Экспорт
	
	РегистрационныеДанные = Новый Структура;
	РегистрационныеДанные.Вставить("Наименование", "Уведомление об изменении окладов Офис-менеджеров");
	РегистрационныеДанные.Вставить("БезопасныйРежим", Ложь);
	РегистрационныеДанные.Вставить("Версия", "1.0");
	РегистрационныеДанные.Вставить("Вид", "ДополнительнаяОбработка");
	РегистрационныеДанные.Вставить("Информация", "Уведомление об изменении окладов Офис-менеджеров");
	
	Команды = Новый ТаблицаЗначений;
	Команды.Колонки.Добавить("Идентификатор");
	Команды.Колонки.Добавить("Представление");
	Команды.Колонки.Добавить("Модификатор");
	Команды.Колонки.Добавить("ПоказыватьОповещение");
	Команды.Колонки.Добавить("Использование");
	
	Команда = Команды.Добавить();
	Команда.Идентификатор = "1";
	Команда.Представление = "Уведомление об изменении окладов Офис-менеджеров";
	Команда.ПоказыватьОповещение = Истина;
	Команда.Использование = "ВызовСерверногоМетода";
	
	РегистрационныеДанные.Вставить("Команды", Команды);
	
	Возврат РегистрационныеДанные;
	
	
КонецФункции

Процедура ВыполнитьКоманду(ИдентификаторКоманды = Неопределено) Экспорт

	РазослатьУведомление();
	
КонецПроцедуры

#КонецОбласти
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
#Область ОсновныеПроцедурыИФункции

Процедура РазослатьУведомление()
	
	Если Не ЗначениеЗаполнено(ДатаОтправки) Тогда 
		
		ДатаОтправки = НачалоДня(ТекущаяДата() + 14*24*60*60); // плюс 2 недели от текущей даты
		
	КонецЕсли;
		
	ДанныеСотрудников = ПолучитьДанныеПоСотрудникамДляОтправкиУведомления(ДатаОтправки);
	
	Если ДанныеСотрудников.Количество()>0 Тогда 
		
		СформироватьШаблоныИзмененияУсловийТД(ДанныеСотрудников);	
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьДанныеПоСотрудникамДляОтправкиУведомления(ДатаОтправки)

	МассивДолжностейОфисМенеджеров = Новый Массив;
	МассивДолжностейОфисМенеджеров.Добавить(Справочники.Должности.НайтиПоНаименованию("Специалист по сопровождению продаж"));
	МассивДолжностейОфисМенеджеров.Добавить(Справочники.Должности.НайтиПоНаименованию("Старший специалист по сопровождению продаж"));
	МассивДолжностейОфисМенеджеров.Добавить(Справочники.Должности.НайтиПоНаименованию("Ведущий специалист по сопровождению продаж"));
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ОфисМенеджеры",МассивДолжностейОфисМенеджеров);
	Запрос.УстановитьПараметр("ДатаОтправки",ДатаОтправки);
	Запрос.Текст = "ВЫБРАТЬ
	               |	СостоянияСотрудников.Сотрудник КАК Сотрудник,
	               |	МАКСИМУМ(СостоянияСотрудников.Период) КАК Период
	               |ПОМЕСТИТЬ ВТ_ПериодыСостояний
	               |ИЗ
	               |	РегистрСведений.СостоянияСотрудников КАК СостоянияСотрудников
	               |ГДЕ
	               |	СостоянияСотрудников.Период <= &ДатаОтправки
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	СостоянияСотрудников.Сотрудник
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВТ_ПериодыСостояний.Сотрудник КАК Сотрудник,
	               |	ВТ_ПериодыСостояний.Период КАК Период,
	               |	СостоянияСотрудников.Состояние КАК Состояние
	               |ПОМЕСТИТЬ ВТ_СОСТОЯНИЯ_СОТРУДНИКОВ
	               |ИЗ
	               |	ВТ_ПериодыСостояний КАК ВТ_ПериодыСостояний
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостоянияСотрудников КАК СостоянияСотрудников
	               |		ПО ВТ_ПериодыСостояний.Сотрудник = СостоянияСотрудников.Сотрудник
	               |			И (СостоянияСотрудников.Период = ВТ_ПериодыСостояний.Период)
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	КадроваяИсторияСотрудниковСрезПоследних.Сотрудник КАК Сотрудник,
	               |	КадроваяИсторияСотрудниковСрезПоследних.ДолжностьПоШтатномуРасписанию КАК ДолжностьПоШтатномуРасписанию,
	               |	КадроваяИсторияСотрудниковСрезПоследних.Должность КАК Должность,
	               |	КадроваяИсторияСотрудниковСрезПоследних.Подразделение КАК Подразделение
	               |ПОМЕСТИТЬ ВТ_КадровыеДанные
	               |ИЗ
	               |	РегистрСведений.КадроваяИсторияСотрудников.СрезПоследних(&ДатаОтправки, ) КАК КадроваяИсторияСотрудниковСрезПоследних
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	ТекущиеКадровыеДанныеСотрудников.Сотрудник КАК Сотрудник,
	               |	ТекущиеКадровыеДанныеСотрудников.ДатаПриема КАК ДатаПриема,
	               |	ЕСТЬNULL(Оклад.Значение, 0) КАК Оклад,
	               |	ЕСТЬNULL(РайонныйКоэффициент.Значение, 0) КАК РК,
	               |	ЕСТЬNULL(ПроцентыСевернойНадбавкиФизическихЛицСрезПоследних.ПроцентСевернойНадбавки, 0) КАК СН,
	               |	ВТ_КадровыеДанные.Должность КАК ТекущаяДолжность,
	               |	ВТ_КадровыеДанные.Подразделение КАК ТекущееПодразделение,
	               |	ВТ_КадровыеДанные.Подразделение.Родитель КАК ТекущееПодразделениеРодитель,
	               |	ВТ_КадровыеДанные.Подразделение.Родитель.Родитель КАК ТекущееПодразделениеРодительРодитель,
	               |	ППФ_ДанныеПремированияСотрудниковСрезПоследних.ЦелеваяПремия КАК ЦелеваяПремия,
	               |	ВТ_СОСТОЯНИЯ_СОТРУДНИКОВ.Состояние КАК Состояние
	               |ПОМЕСТИТЬ ВТ_ДанныеНачислений
	               |ИЗ
	               |	РегистрСведений.ТекущиеКадровыеДанныеСотрудников КАК ТекущиеКадровыеДанныеСотрудников
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудников.СрезПоследних(&ДатаОтправки, Показатель = ЗНАЧЕНИЕ(Справочник.ПоказателиРасчетаЗарплаты.Оклад)) КАК Оклад
	               |		ПО ТекущиеКадровыеДанныеСотрудников.Сотрудник = Оклад.Сотрудник
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудников.СрезПоследних(&ДатаОтправки, Показатель = ЗНАЧЕНИЕ(Справочник.ПоказателиРасчетаЗарплаты.РайонныйКоэффициент)) КАК РайонныйКоэффициент
	               |		ПО ТекущиеКадровыеДанныеСотрудников.Сотрудник = РайонныйКоэффициент.Сотрудник
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ППФ_ДанныеПремированияСотрудников.СрезПоследних КАК ППФ_ДанныеПремированияСотрудниковСрезПоследних
	               |		ПО ТекущиеКадровыеДанныеСотрудников.Сотрудник = ППФ_ДанныеПремированияСотрудниковСрезПоследних.Сотрудник
	               |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_СОСТОЯНИЯ_СОТРУДНИКОВ КАК ВТ_СОСТОЯНИЯ_СОТРУДНИКОВ
	               |		ПО ТекущиеКадровыеДанныеСотрудников.Сотрудник = ВТ_СОСТОЯНИЯ_СОТРУДНИКОВ.Сотрудник
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПроцентыСевернойНадбавкиФизическихЛиц.СрезПоследних(&ДатаОтправки, ) КАК ПроцентыСевернойНадбавкиФизическихЛицСрезПоследних
	               |		ПО ТекущиеКадровыеДанныеСотрудников.ФизическоеЛицо = ПроцентыСевернойНадбавкиФизическихЛицСрезПоследних.ФизическоеЛицо
	               |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_КадровыеДанные КАК ВТ_КадровыеДанные
	               |		ПО ТекущиеКадровыеДанныеСотрудников.Сотрудник = ВТ_КадровыеДанные.Сотрудник
	               |ГДЕ
	               |	ТекущиеКадровыеДанныеСотрудников.ДатаУвольнения = ДАТАВРЕМЯ(1, 1, 1)
	               |	И ВТ_КадровыеДанные.Должность В(&ОфисМенеджеры)
	               |	И ВТ_КадровыеДанные.ДолжностьПоШтатномуРасписанию.КоличествоСтавок >= 1
	               |	И НЕ(ВТ_СОСТОЯНИЯ_СОТРУДНИКОВ.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияСотрудника.ОтпускПоУходуЗаРебенком)
	               |				ИЛИ ВТ_СОСТОЯНИЯ_СОТРУДНИКОВ.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияСотрудника.ОтпускПоБеременностиИРодам))
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	ТекущиеКадровыеДанныеСотрудников.Сотрудник,
	               |	ТекущиеКадровыеДанныеСотрудников.ДатаПриема,
	               |	ЕСТЬNULL(Оклад.Значение, 0),
	               |	ЕСТЬNULL(РайонныйКоэффициент.Значение, 0),
	               |	ЕСТЬNULL(ПроцентыСевернойНадбавкиФизическихЛицСрезПоследних.ПроцентСевернойНадбавки, 0),
	               |	ВТ_КадровыеДанные.Должность,
	               |	ВТ_КадровыеДанные.Подразделение,
	               |	ВТ_КадровыеДанные.Подразделение.Родитель,
	               |	ВТ_КадровыеДанные.Подразделение.Родитель.Родитель,
	               |	ППФ_ДанныеПремированияСотрудниковСрезПоследних.ЦелеваяПремия,
	               |	ВТ_СОСТОЯНИЯ_СОТРУДНИКОВ.Состояние
	               |ИЗ
	               |	РегистрСведений.ТекущиеКадровыеДанныеСотрудников КАК ТекущиеКадровыеДанныеСотрудников
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудников.СрезПоследних(&ДатаОтправки, Показатель = ЗНАЧЕНИЕ(Справочник.ПоказателиРасчетаЗарплаты.Оклад)) КАК Оклад
	               |		ПО ТекущиеКадровыеДанныеСотрудников.Сотрудник = Оклад.Сотрудник
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудников.СрезПоследних(&ДатаОтправки, Показатель = ЗНАЧЕНИЕ(Справочник.ПоказателиРасчетаЗарплаты.РайонныйКоэффициент)) КАК РайонныйКоэффициент
	               |		ПО ТекущиеКадровыеДанныеСотрудников.Сотрудник = РайонныйКоэффициент.Сотрудник
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ППФ_ДанныеПремированияСотрудников.СрезПоследних КАК ППФ_ДанныеПремированияСотрудниковСрезПоследних
	               |		ПО ТекущиеКадровыеДанныеСотрудников.Сотрудник = ППФ_ДанныеПремированияСотрудниковСрезПоследних.Сотрудник
	               |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_СОСТОЯНИЯ_СОТРУДНИКОВ КАК ВТ_СОСТОЯНИЯ_СОТРУДНИКОВ
	               |		ПО ТекущиеКадровыеДанныеСотрудников.Сотрудник = ВТ_СОСТОЯНИЯ_СОТРУДНИКОВ.Сотрудник
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПроцентыСевернойНадбавкиФизическихЛиц.СрезПоследних(&ДатаОтправки, ) КАК ПроцентыСевернойНадбавкиФизическихЛицСрезПоследних
	               |		ПО ТекущиеКадровыеДанныеСотрудников.ФизическоеЛицо = ПроцентыСевернойНадбавкиФизическихЛицСрезПоследних.ФизическоеЛицо
	               |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_КадровыеДанные КАК ВТ_КадровыеДанные
	               |		ПО ТекущиеКадровыеДанныеСотрудников.Сотрудник = ВТ_КадровыеДанные.Сотрудник
	               |ГДЕ
	               |	ТекущиеКадровыеДанныеСотрудников.ДатаУвольнения = ДАТАВРЕМЯ(1, 1, 1)
	               |	И ВТ_КадровыеДанные.Должность В(&ОфисМенеджеры)
	               |	И ВТ_КадровыеДанные.ДолжностьПоШтатномуРасписанию.Наименование = ""Ведущий специалист по сопровождению продаж /Агентство №351 в городе Абакан/""
	               |	И НЕ(ВТ_СОСТОЯНИЯ_СОТРУДНИКОВ.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияСотрудника.ОтпускПоУходуЗаРебенком)
	               |				ИЛИ ВТ_СОСТОЯНИЯ_СОТРУДНИКОВ.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияСотрудника.ОтпускПоБеременностиИРодам))
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВТ.Сотрудник КАК Сотрудник,
	               |	ВТ.ДатаПриема КАК ДатаПриема,
	               |	ВТ.Оклад КАК Оклад,
	               |	ВЫБОР
	               |		КОГДА ВТ.РК > 1
	               |			ТОГДА (ВТ.РК - 1) * 100
	               |		ИНАЧЕ 0
	               |	КОНЕЦ КАК РК,
	               |	ВТ.СН КАК СН,
	               |	ВЫБОР
	               |		КОГДА ВТ.РК > 0
	               |			ТОГДА (ВТ.РК - 1) * ВТ.Оклад
	               |		ИНАЧЕ 0
	               |	КОНЕЦ КАК РКСумма,
	               |	ВЫБОР
	               |		КОГДА ВТ.СН > 0
	               |			ТОГДА ВТ.СН / 100 * ВТ.Оклад
	               |		ИНАЧЕ 0
	               |	КОНЕЦ КАК СНСумма,
	               |	ВТ.ТекущаяДолжность КАК ТекущаяДолжность,
	               |	ВТ.ТекущееПодразделение КАК ТекущееПодразделение,
	               |	ВТ.ТекущееПодразделениеРодитель КАК ТекущееПодразделениеРодитель,
	               |	ВТ.ТекущееПодразделениеРодительРодитель КАК ТекущееПодразделениеРодительРодитель,
	               |	ВТ.ЦелеваяПремия КАК ЦелеваяПремия
	               |ПОМЕСТИТЬ ВТ_ВычислениеСуммыНадбавок
	               |ИЗ
	               |	ВТ_ДанныеНачислений КАК ВТ
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВТ_ВычислениеСуммыНадбавок.Сотрудник КАК Сотрудник,
	               |	ВТ_ВычислениеСуммыНадбавок.ДатаПриема КАК ДатаПриема,
	               |	СУММА(ВТ_ВычислениеСуммыНадбавок.Оклад + ВТ_ВычислениеСуммыНадбавок.РКСумма + ВТ_ВычислениеСуммыНадбавок.СНСумма) КАК ФОТ,
	               |	ЕСТЬNULL(РАЗНОСТЬДАТ(ВТ_ВычислениеСуммыНадбавок.ДатаПриема, &ДатаОтправки, МЕСЯЦ), 0) КАК ПрошлоМесяцев,
	               |	ВЫРАЗИТЬ(ЕСТЬNULL(РАЗНОСТЬДАТ(ВТ_ВычислениеСуммыНадбавок.ДатаПриема, &ДатаОтправки, ДЕНЬ), 0) / 365 - 0.5 КАК ЧИСЛО(15, 0)) КАК ПрошлоЛет,
	               |	ВТ_ВычислениеСуммыНадбавок.ТекущаяДолжность КАК ТекущаяДолжность,
	               |	ВТ_ВычислениеСуммыНадбавок.ТекущееПодразделение КАК ТекущееПодразделение,
	               |	ВТ_ВычислениеСуммыНадбавок.ТекущееПодразделениеРодитель КАК ТекущееПодразделениеРодитель,
	               |	ВТ_ВычислениеСуммыНадбавок.ТекущееПодразделениеРодительРодитель КАК ТекущееПодразделениеРодительРодитель,
	               |	ВТ_ВычислениеСуммыНадбавок.РК КАК РК,
	               |	ВТ_ВычислениеСуммыНадбавок.СН КАК СН,
	               |	ВТ_ВычислениеСуммыНадбавок.ЦелеваяПремия КАК ЦелеваяПремия
	               |ПОМЕСТИТЬ ВТ_ПродолжительностьРаботы
	               |ИЗ
	               |	ВТ_ВычислениеСуммыНадбавок КАК ВТ_ВычислениеСуммыНадбавок
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ВТ_ВычислениеСуммыНадбавок.Сотрудник,
	               |	ВТ_ВычислениеСуммыНадбавок.ДатаПриема,
	               |	ВТ_ВычислениеСуммыНадбавок.ТекущаяДолжность,
	               |	ВТ_ВычислениеСуммыНадбавок.ТекущееПодразделение,
	               |	ВТ_ВычислениеСуммыНадбавок.ТекущееПодразделениеРодитель,
	               |	ВТ_ВычислениеСуммыНадбавок.ТекущееПодразделениеРодительРодитель,
	               |	ВТ_ВычислениеСуммыНадбавок.РК,
	               |	ВТ_ВычислениеСуммыНадбавок.СН,
	               |	ВТ_ВычислениеСуммыНадбавок.ЦелеваяПремия
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВТ_ПродолжительностьРаботы.Сотрудник КАК Сотрудник,
	               |	ВТ_ПродолжительностьРаботы.ФОТ КАК ФОТ,
	               |	ВТ_ПродолжительностьРаботы.ДатаПриема КАК ДатаПриема,
	               |	ВЫБОР
	               |		КОГДА ВТ_ПродолжительностьРаботы.ПрошлоМесяцев < 3
	               |				И ВТ_ПродолжительностьРаботы.ФОТ + 10 < 18000
	               |			ТОГДА ""1""
	               |		ИНАЧЕ ВЫБОР
	               |				КОГДА ВТ_ПродолжительностьРаботы.ПрошлоМесяцев >= 3
	               |						И ВТ_ПродолжительностьРаботы.ПрошлоЛет < 1
	               |						И ВТ_ПродолжительностьРаботы.ФОТ + 10 < 20000
	               |					ТОГДА ""2""
	               |				ИНАЧЕ ВЫБОР
	               |						КОГДА ВТ_ПродолжительностьРаботы.ПрошлоЛет >= 1
	               |								И ВТ_ПродолжительностьРаботы.ПрошлоЛет < 2
	               |								И ВТ_ПродолжительностьРаботы.ФОТ + 10 < 21000
	               |							ТОГДА ""3""
	               |						ИНАЧЕ ВЫБОР
	               |								КОГДА ВТ_ПродолжительностьРаботы.ПрошлоЛет >= 2
	               |										И ВТ_ПродолжительностьРаботы.ПрошлоЛет < 3
	               |										И ВТ_ПродолжительностьРаботы.ФОТ + 10 < 22500
	               |									ТОГДА ""4""
	               |								ИНАЧЕ ВЫБОР
	               |										КОГДА ВТ_ПродолжительностьРаботы.ПрошлоЛет >= 3
	               |												И ВТ_ПродолжительностьРаботы.ПрошлоЛет < 4
	               |												И ВТ_ПродолжительностьРаботы.ФОТ + 10 < 24000
	               |											ТОГДА ""5""
	               |										ИНАЧЕ ВЫБОР
	               |												КОГДА ВТ_ПродолжительностьРаботы.ПрошлоЛет >= 4
	               |														И ВТ_ПродолжительностьРаботы.ФОТ + 10 < 25000
	               |													ТОГДА ""6""
	               |												ИНАЧЕ ""0""
	               |											КОНЕЦ
	               |									КОНЕЦ
	               |							КОНЕЦ
	               |					КОНЕЦ
	               |			КОНЕЦ
	               |	КОНЕЦ КАК Уровень,
	               |	ВТ_ПродолжительностьРаботы.ПрошлоМесяцев КАК ПрошлоМесяцев,
	               |	ВТ_ПродолжительностьРаботы.ПрошлоЛет КАК ПрошлоЛет,
	               |	ВТ_ПродолжительностьРаботы.ТекущаяДолжность КАК ТекущаяДолжность,
	               |	ВТ_ПродолжительностьРаботы.ТекущееПодразделение КАК ТекущееПодразделение,
	               |	ВТ_ПродолжительностьРаботы.ТекущееПодразделениеРодитель КАК ТекущееПодразделениеРодитель,
	               |	ВТ_ПродолжительностьРаботы.ТекущееПодразделениеРодительРодитель КАК ТекущееПодразделениеРодительРодитель,
	               |	ВТ_ПродолжительностьРаботы.РК КАК РК,
	               |	ВТ_ПродолжительностьРаботы.СН КАК СН,
	               |	ВТ_ПродолжительностьРаботы.ЦелеваяПремия КАК ЦелеваяПремия
	               |ПОМЕСТИТЬ ВТ_Уровни
	               |ИЗ
	               |	ВТ_ПродолжительностьРаботы КАК ВТ_ПродолжительностьРаботы
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВТ_Уровни.Сотрудник КАК Сотрудник,
	               |	ВТ_Уровни.ФОТ КАК ФОТ,
	               |	ВТ_Уровни.ДатаПриема КАК ДатаПриема,
	               |	ВТ_Уровни.Уровень КАК Уровень,
	               |	ВТ_Уровни.ПрошлоМесяцев КАК ПрошлоМесяцев,
	               |	ВТ_Уровни.ПрошлоЛет КАК ПрошлоЛет,
	               |	ВЫБОР
	               |		КОГДА ВТ_Уровни.Уровень = ""2""
	               |			ТОГДА НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(ВТ_Уровни.ДатаПриема, МЕСЯЦ, 4), МЕСЯЦ)
	               |		ИНАЧЕ ВЫБОР
	               |				КОГДА ВТ_Уровни.Уровень = ""3""
	               |					ТОГДА НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(ДОБАВИТЬКДАТЕ(ВТ_Уровни.ДатаПриема, ГОД, 1), МЕСЯЦ, 1), МЕСЯЦ)
	               |				ИНАЧЕ ВЫБОР
	               |						КОГДА ВТ_Уровни.Уровень = ""4""
	               |							ТОГДА НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(ДОБАВИТЬКДАТЕ(ВТ_Уровни.ДатаПриема, ГОД, 2), МЕСЯЦ, 1), МЕСЯЦ)
	               |						ИНАЧЕ ВЫБОР
	               |								КОГДА ВТ_Уровни.Уровень = ""5""
	               |									ТОГДА НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(ДОБАВИТЬКДАТЕ(ВТ_Уровни.ДатаПриема, ГОД, 3), МЕСЯЦ, 1), МЕСЯЦ)
	               |								ИНАЧЕ ВЫБОР
	               |										КОГДА ВТ_Уровни.Уровень = ""6""
	               |											ТОГДА НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(ДОБАВИТЬКДАТЕ(ВТ_Уровни.ДатаПриема, ГОД, 4), МЕСЯЦ, 1), МЕСЯЦ)
	               |										ИНАЧЕ ДАТАВРЕМЯ(1, 1, 1)
	               |									КОНЕЦ
	               |							КОНЕЦ
	               |					КОНЕЦ
	               |			КОНЕЦ
	               |	КОНЕЦ КАК ДатаПеревода,
	               |	ВЫБОР
	               |		КОГДА ВТ_Уровни.Уровень = ""2""
	               |			ТОГДА 20000
	               |		ИНАЧЕ ВЫБОР
	               |				КОГДА ВТ_Уровни.Уровень = ""3""
	               |					ТОГДА 21000
	               |				ИНАЧЕ ВЫБОР
	               |						КОГДА ВТ_Уровни.Уровень = ""4""
	               |							ТОГДА 22500
	               |						ИНАЧЕ ВЫБОР
	               |								КОГДА ВТ_Уровни.Уровень = ""5""
	               |									ТОГДА 24000
	               |								ИНАЧЕ ВЫБОР
	               |										КОГДА ВТ_Уровни.Уровень = ""6""
	               |											ТОГДА 25000
	               |										ИНАЧЕ 0
	               |									КОНЕЦ
	               |							КОНЕЦ
	               |					КОНЕЦ
	               |			КОНЕЦ
	               |	КОНЕЦ КАК ПланиуремыйФОТ,
	               |	ВТ_Уровни.ТекущаяДолжность КАК ТекущаяДолжность,
	               |	ВТ_Уровни.ТекущееПодразделение КАК ТекущееПодразделение,
	               |	ВТ_Уровни.ТекущееПодразделениеРодитель КАК ТекущееПодразделениеРодитель,
	               |	ВТ_Уровни.ТекущееПодразделениеРодительРодитель КАК ТекущееПодразделениеРодительРодитель,
	               |	ВТ_Уровни.РК КАК РК,
	               |	ВТ_Уровни.СН КАК СН,
	               |	ВТ_Уровни.РК + ВТ_Уровни.СН КАК СуммаНадбавокВПроцентах,
	               |	ВТ_Уровни.ЦелеваяПремия КАК ЦелеваяПремия
	               |ПОМЕСТИТЬ ВТ_БезВычисляемыхПолей
	               |ИЗ
	               |	ВТ_Уровни КАК ВТ_Уровни
	               |ГДЕ
	               |	ВТ_Уровни.Уровень <> ""0""
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВТ_БезВычисляемыхПолей.Сотрудник КАК Сотрудник,
	               |	ВТ_БезВычисляемыхПолей.ФОТ КАК ФОТ,
	               |	ВТ_БезВычисляемыхПолей.ДатаПриема КАК ДатаПриема,
	               |	ВТ_БезВычисляемыхПолей.Уровень КАК Уровень,
	               |	ВТ_БезВычисляемыхПолей.ПрошлоМесяцев КАК ПрошлоМесяцев,
	               |	ВТ_БезВычисляемыхПолей.ПрошлоЛет КАК ПрошлоЛет,
	               |	ВТ_БезВычисляемыхПолей.ДатаПеревода КАК ДатаПеревода,
	               |	ВТ_БезВычисляемыхПолей.ПланиуремыйФОТ КАК ПланиуремыйФОТ,
	               |	ВТ_БезВычисляемыхПолей.ТекущаяДолжность КАК ТекущаяДолжность,
	               |	ВТ_БезВычисляемыхПолей.ТекущееПодразделение КАК ТекущееПодразделение,
	               |	ВТ_БезВычисляемыхПолей.ТекущееПодразделениеРодитель КАК ТекущееПодразделениеРодитель,
	               |	ВТ_БезВычисляемыхПолей.ТекущееПодразделениеРодительРодитель КАК ТекущееПодразделениеРодительРодитель,
	               |	ВТ_БезВычисляемыхПолей.РК КАК РК,
	               |	ВТ_БезВычисляемыхПолей.СН КАК СН,
	               |	ВТ_БезВычисляемыхПолей.СуммаНадбавокВПроцентах КАК СуммаНадбавокВПроцентах,
	               |	ВТ_БезВычисляемыхПолей.ЦелеваяПремия КАК ЦелеваяПремия,
	               |	ВТ_БезВычисляемыхПолей.ФОТ / (ВТ_БезВычисляемыхПолей.СуммаНадбавокВПроцентах / 100 + 1) КАК Оклад,
	               |	ВТ_БезВычисляемыхПолей.ПланиуремыйФОТ / (ВТ_БезВычисляемыхПолей.СуммаНадбавокВПроцентах / 100 + 1) КАК ПланируемыйОклад,
	               |	0 КАК ПроцентУвеличенияОклада
	               |ИЗ
	               |	ВТ_БезВычисляемыхПолей КАК ВТ_БезВычисляемыхПолей
	               |ГДЕ
	               |	ВТ_БезВычисляемыхПолей.ДатаПеревода <= &ДатаОтправки
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |УНИЧТОЖИТЬ ВТ_ПериодыСостояний
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |УНИЧТОЖИТЬ ВТ_СОСТОЯНИЯ_СОТРУДНИКОВ
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |УНИЧТОЖИТЬ ВТ_КадровыеДанные
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |УНИЧТОЖИТЬ ВТ_ДанныеНачислений
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |УНИЧТОЖИТЬ ВТ_ВычислениеСуммыНадбавок
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |УНИЧТОЖИТЬ ВТ_ПродолжительностьРаботы
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |УНИЧТОЖИТЬ ВТ_Уровни
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |УНИЧТОЖИТЬ ВТ_БезВычисляемыхПолей";
	//Запрос.УстановитьПараметр("ДатаПеревода",КонецМесяца(КонецМесяца(ТекущаяДата())+1));				   
	
	Результат = Запрос.Выполнить();	
	Выгрузка = Результат.Выгрузить();
		
	Возврат Выгрузка;
	
КонецФункции

Процедура СформироватьШаблоныИзмененияУсловийТД(ДанныеСотрудников)
	
	Макет 				= ПолучитьМакет("Макет");
	
	ТаблицаДокументов 	= Новый ТаблицаЗначений;
	ТаблицаДокументов.Колонки.Добавить("Сотрудник");
	ТаблицаДокументов.Колонки.Добавить("ТабДок");
	
	МассивТабличныхДокументов = Новый Массив;
	
	Для Каждого СтрокаДанных Из ДанныеСотрудников Цикл 
		
		СтрокаДанных.Оклад = ИсправитьОклад(СтрокаДанных.Оклад);
		СтрокаДанных.ПланируемыйОклад = ИсправитьОклад(СтрокаДанных.ПланируемыйОклад);
		Если СтрокаДанных.СуммаНадбавокВПроцентах>0 И СтрокаДанных.ПланируемыйОклад * (1+ СтрокаДанных.СуммаНадбавокВПроцентах/100)<СтрокаДанных.ПланиуремыйФОТ Тогда 
			СтрокаДанных.ПланируемыйОклад = СтрокаДанных.ПланируемыйОклад + 5; // у нас округление до 5 рублей
		КонецЕсли;
		СтрокаДанных.ПроцентУвеличенияОклада = Окр((СтрокаДанных.ПланируемыйОклад / СтрокаДанных.Оклад - 1) * 100,2);
		ТабДок = Новый ТабличныйДокумент;
		ОбластьОтчета = Макет.ПолучитьОбласть("Отчет");
		ЗаполнитьЗначенияСвойств(ОбластьОтчета.Параметры,СтрокаДанных); 
		ОбластьОтчета.Параметры.ПроцентУвеличенияОклада = "" + Окр(ОбластьОтчета.Параметры.ПроцентУвеличенияОклада,2) + "%";
		ОбластьОтчета.Параметры.СуммаНадбавокВПроцентах = "" + ОбластьОтчета.Параметры.СуммаНадбавокВПроцентах + "%";
		ТабДок.Вывести(ОбластьОтчета);
		ТабДок.АвтоМасштаб = Истина;
		
		МассивТабличныхДокументов.Добавить(ТабДок);
		
		НоваяСтрока = ТаблицаДокументов.Добавить();
		НоваяСтрока.Сотрудник 	= СтрокаДанных.Сотрудник;
		НоваяСтрока.ТабДок 		= ТабДок;
		
	КонецЦикла;
	
	ОтправитьФайлПоПочте(ТаблицаДокументов);	
	
КонецПроцедуры

Процедура ОтправитьФайлПоПочте(ТаблицаДокументов)
	
	Вложения = Новый ТаблицаЗначений;
	Вложения.Колонки.Добавить("Представление");
	Вложения.Колонки.Добавить("АдресВоВременномХранилище");
	Вложения.Колонки.Добавить("Кодировка");
	Вложения.Колонки.Добавить("ПутьКФайлу");
	
	Кому = Новый СписокЗначений;
	Кому.Добавить("OtdKadrovogoAdm@ppfinsurance.ru");
	//Копии = Новый СписокЗначений;
	//Копии.Добавить("rartamonov@ppfinsurance.ru");
	
	ФорматыСохранения = Новый Массив;
	ФорматыСохранения.Добавить(ТипФайлаТабличногоДокумента.XLSX);	
	ПараметрыОтправки = Новый Структура;
	ПараметрыОтправки.Вставить("Тема", "Уведомления об изменении окладов офис-менеджеров");
	ПараметрыОтправки.Вставить("Вложения", ПоместитьТабличныеДокументыВоВременноеХранилище(ФорматыСохранения,ТаблицаДокументов));
	ПараметрыОтправки.Вставить("УдалятьФайлыПослеОтправки", Истина);	
	ПараметрыОтправки.Вставить("Кому", Кому);
	//ПараметрыОтправки.Вставить("Копии",Копии);
	
	Для Каждого Вложение Из ПараметрыОтправки.Вложения Цикл
		
		ОписаниеВложения = Вложения.Добавить();
		Если ТипЗнч(ПараметрыОтправки.Вложения) = Тип("СписокЗначений") Тогда
			ОписаниеВложения.Представление = Вложение.Представление;
			Если ТипЗнч(Вложение.Значение) = Тип("ДвоичныеДанные") Тогда
				ОписаниеВложения.АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(Вложение.Значение, Новый УникальныйИдентификатор);
			Иначе
				Если ЭтоАдресВременногоХранилища(Вложение.Значение) Тогда
					ОписаниеВложения.АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(ПолучитьИзВременногоХранилища(Вложение.Значение), Новый УникальныйИдентификатор);
				Иначе
					ОписаниеВложения.ПутьКФайлу = Вложение.Значение;
				КонецЕсли;
			КонецЕсли;
		Иначе // ТипЗнч(Параметры.Вложения) = "массив структур"
			ЗаполнитьЗначенияСвойств(ОписаниеВложения, Вложение);
			Если Не ПустаяСтрока(ОписаниеВложения.АдресВоВременномХранилище) Тогда
				ОписаниеВложения.АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(
				ПолучитьИзВременногоХранилища(ОписаниеВложения.АдресВоВременномХранилище), Новый УникальныйИдентификатор);
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
		ПриведенныйПочтовыйАдресКому = ОбщегоНазначенияКлиентСервер.РазобратьСтрокуСПочтовымиАдресами(ПочтовыйАдресПолучателя);
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
		КраткоеПредставлениеОшибки(ИнформацияОбОшибке()), ,
		ПочтовыйАдресПолучателя);
		Возврат;
	КонецПопытки;
	
	//Если ТипЗнч(ПараметрыОтправки.Копии) = Тип("СписокЗначений") Тогда
	//	ПочтовыйАдресПолучателя = "";
	//	Для Каждого ЭлементПочтовыйАдрес Из ПараметрыОтправки.Копии Цикл
	//		Если ЗначениеЗаполнено(ЭлементПочтовыйАдрес.Представление) Тогда 
	//			ПочтовыйАдресПолучателя = ПочтовыйАдресПолучателя
	//			+ ЭлементПочтовыйАдрес.Представление
	//			+ " <"
	//			+ ЭлементПочтовыйАдрес.Значение
	//			+ ">; "
	//		Иначе
	//			ПочтовыйАдресПолучателя = ПочтовыйАдресПолучателя 
	//			+ ЭлементПочтовыйАдрес.Значение
	//			+ "; ";
	//		КонецЕсли;
	//	КонецЦикла;
	//ИначеЕсли ТипЗнч(ПараметрыОтправки.Копии) = Тип("Строка") Тогда
	//	ПочтовыйАдресПолучателя = ПараметрыОтправки.Копии;
	//ИначеЕсли ТипЗнч(ПараметрыОтправки.Копии) = Тип("Массив") Тогда
	//	Для Каждого СтруктураПолучателя Из ПараметрыОтправки.Копии Цикл
	//		МассивАдресов = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтруктураПолучателя.Адрес, ";");
	//		Для Каждого Адрес Из МассивАдресов Цикл
	//			Если ПустаяСтрока(Адрес) Тогда 
	//				Продолжить;
	//			КонецЕсли;
	//			ПочтовыйАдресПолучателя = ПочтовыйАдресПолучателя + СтруктураПолучателя.Представление + " <" + СокрЛП(Адрес) + ">; ";
	//		КонецЦикла;
	//	КонецЦикла;
	//КонецЕсли;
	//
	//Попытка
	//	ПриведенныйПочтовыйАдресКопии = ОбщегоНазначенияКлиентСервер.РазобратьСтрокуСПочтовымиАдресами(ПочтовыйАдресПолучателя);
	//Исключение
	//	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
	//	КраткоеПредставлениеОшибки(ИнформацияОбОшибке()), ,
	//	ПочтовыйАдресПолучателя);
	//	Возврат;
	//КонецПопытки;
	
	
	ПараметрыПисьма = Новый Структура;
	ПараметрыПисьма.Вставить("Кому",  ПриведенныйПочтовыйАдресКому);
	//ПараметрыПисьма.Вставить("Копии", ПриведенныйПочтовыйАдресКопии);
	ПараметрыПисьма.Вставить("Тема", "Уведомления об изменении окладов офис-менеджеров");	
	ПараметрыПисьма.Вставить("Вложения", Вложения(Вложения));
	ПараметрыПисьма.Вставить("Тело", "Во вложении находятся уведомления об изменении окладов офис-менеджеров. Сообщение сформировано автоматически из системы 1С:ЗУП. Отвечать на письмо не требуется.");
	
	УчетнаяЗапись = ПолучитьУчетнуюЗапись();
	
	Попытка
		ОтправитьПочтовоеСообщение(УчетнаяЗапись, ПараметрыПисьма);
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		Возврат;
	КонецПопытки;


КонецПроцедуры

Функция ИсправитьОклад(ОкладДляИсправления)
	
	Оклад = 0;    	
	Оклад = Окр(ОкладДляИсправления/100,1,РежимОкругления.Окр15как20)*100;
	
	Возврат Оклад;
	
КонецФункции

Функция ПоместитьТабличныеДокументыВоВременноеХранилище(ВыбранныеФорматыСохранения, ТаблицаДокументов)
	
	Результат = Новый СписокЗначений;
	
	// Каталог временных файлов
	ИмяВременнойПапки = ПолучитьИмяВременногоФайла();
	СоздатьКаталог(ИмяВременнойПапки);
	ПолныйПутьКФайлу = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ИмяВременнойПапки);
	
	// Сохранение табличных документов.
	Для Каждого  СтрокаДанных Из ТаблицаДокументов Цикл 	
		//Если ТабличныйДокумент.Значение.Вывод = ИспользованиеВывода.Запретить Тогда
		//	Продолжить;
		//КонецЕсли;
		
		Для Каждого ТипФайла Из ВыбранныеФорматыСохранения Цикл
			
			ИмяФайла = "" + СтрокаДанных.Сотрудник + "." + Строка(ТипФайла);
			ПолноеИмяФайла = ПолныйПутьКФайлу + ИмяФайла;
			
			СтрокаДанных.ТабДок.Записать(ПолноеИмяФайла, ТипФайла);
			
			Результат.Добавить(ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ПолноеИмяФайла), Новый УникальныйИдентификатор), ИмяФайла);
		КонецЦикла;
		
	КонецЦикла;
	
	УдалитьФайлы(ИмяВременнойПапки);
	
	Возврат Результат;
	
КонецФункции

Функция Вложения(Вложения)
	
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

Функция ПолучитьУчетнуюЗапись()
	ДоступныеУчетныеЗаписи = РаботаСПочтовымиСообщениями.ДоступныеУчетныеЗаписи(Истина);
	Если ДоступныеУчетныеЗаписи.Количество() = 0 Тогда
		ТекстСообщения = НСтр("ru = 'Не обнаружены доступные учетные записи электронной почты, обратитесь к администратору системы.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,,);
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ДоступныеУчетныеЗаписи[0].Ссылка;
	
КонецФункции

Функция ОтправитьПочтовоеСообщение(Знач УчетнаяЗапись, Знач ПараметрыПисьма)
	
	Возврат РаботаСПочтовымиСообщениями.ОтправитьПочтовоеСообщение(УчетнаяЗапись, ПараметрыПисьма);
	
КонецФункции

#КонецОбласти