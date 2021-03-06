﻿Функция СведенияОВнешнейОбработке() Экспорт
	
	ПараметрыРегистрации = ДополнительныеОтчетыИОбработки.СведенияОВнешнейОбработке();
	ПараметрыРегистрации.Вид = ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиДополнительнаяОбработка();
	ПараметрыРегистрации.Наименование = ЭтотОбъект.Метаданные().Синоним;
	ПараметрыРегистрации.Версия = "1.02";
	ПараметрыРегистрации.Информация = ЭтотОбъект.Метаданные().Синоним;
	ПараметрыРегистрации.БезопасныйРежим = Ложь;
	
	Команда = ПараметрыРегистрации.Команды.Добавить();
	Команда.Использование = ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыВызовСерверногоМетода();
	Команда.Представление = ЭтотОбъект.Метаданные().Синоним;
	Команда.Идентификатор = ЭтотОбъект.Метаданные().Имя;
	
	Возврат ПараметрыРегистрации;	
	
КонецФункции

Процедура ВыполнитьКоманду(ИдентефикаторКоманды = Неопределено) Экспорт 
	
	ПодразделениеАГЕНТЫ_ШТАТ = Новый Массив;
	ПодразделениеАГЕНТЫ_ШТАТ.Добавить(Справочники.ПодразделенияОрганизаций.НайтиПоКоду("Агенты"));
	ПодразделениеАГЕНТЫ_ШТАТ.Добавить(Справочники.ПодразделенияОрганизаций.НайтиПоКоду("Штат"));
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ПодразделенияОрганизацийДополнительныеРеквизиты.Ссылка КАК Подразделение,
	               |	ПодразделенияОрганизацийДополнительныеРеквизиты.Свойство.Наименование КАК СвойствоНаименование,
	               |	ПодразделенияОрганизацийДополнительныеРеквизиты.Значение КАК Значение
	               |ПОМЕСТИТЬ ВТ_СВОЙСТВА
	               |ИЗ
	               |	Справочник.ПодразделенияОрганизаций.ДополнительныеРеквизиты КАК ПодразделенияОрганизацийДополнительныеРеквизиты
	               |ГДЕ
	               |	(ПодразделенияОрганизацийДополнительныеРеквизиты.Свойство.Наименование = ""Руководитель (Подразделения)""
	               |			ИЛИ ПодразделенияОрганизацийДополнительныеРеквизиты.Свойство.Наименование = ""Куратор (Подразделения)"")
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ПодразделенияОрганизаций.Ссылка КАК Подразделение,
	               |	ВЫБОР
	               |		КОГДА ПодразделенияОрганизаций.Расформировано = ИСТИНА
	               |			ТОГДА 0
	               |		ИНАЧЕ ВЫБОР
	               |				КОГДА ПодразделенияОрганизаций.ДатаСоздания = ДАТАВРЕМЯ(1, 1, 1)
	               |					ТОГДА 0
	               |				ИНАЧЕ 1
	               |			КОНЕЦ
	               |	КОНЕЦ КАК Закрыто,
	               |	ВТ_СВОЙСТВА1.Значение КАК Руководитель,
	               |	ВТ_СВОЙСТВА2.Значение КАК Куратор
	               |ПОМЕСТИТЬ ВТ_ПредварительныеДанные
	               |ИЗ
	               |	Справочник.ПодразделенияОрганизаций КАК ПодразделенияОрганизаций
	               |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_СВОЙСТВА КАК ВТ_СВОЙСТВА1
	               |		ПО ПодразделенияОрганизаций.Ссылка = ВТ_СВОЙСТВА1.Подразделение
	               |			И (""Руководитель (Подразделения)"" = ВТ_СВОЙСТВА1.СвойствоНаименование)
	               |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_СВОЙСТВА КАК ВТ_СВОЙСТВА2
	               |		ПО ПодразделенияОрганизаций.Ссылка = ВТ_СВОЙСТВА2.Подразделение
	               |			И (""Куратор (Подразделения)"" = ВТ_СВОЙСТВА2.СвойствоНаименование)
	               |ГДЕ
	               |	НЕ ПодразделенияОрганизаций.Наименование ПОДОБНО ""%Агентство%""
	               |	И НЕ ПодразделенияОрганизаций.Наименование ПОДОБНО ""Представительство Общества с ограниченной ответственностью """"ЧЕШСКАЯ СТРАХОВАЯ КОМПАНИЯ""""%""
	               |	И НЕ ПодразделенияОрганизаций.Наименование ПОДОБНО ""Представительство%""
	               |	И НЕ ПодразделенияОрганизаций.Наименование ПОДОБНО ""Дополнительный офис в городе%""
	               |	И НЕ ПодразделенияОрганизаций.Наименование ПОДОБНО ""Дополнительный офис %""
	               |	И НЕ ПодразделенияОрганизаций.Наименование ПОДОБНО ""%ЧЕШСКАЯ СТРАХОВАЯ КОМПАНИЯ%""
	               |	И НЕ ПодразделенияОрганизаций.Ссылка В
	               |				(ВЫБРАТЬ
	               |					ПодразделенияОрганизаций.Ссылка
	               |				ИЗ
	               |					Справочник.ПодразделенияОрганизаций КАК ПодразделенияОрганизаций
	               |				ГДЕ
	               |					ПодразделенияОрганизаций.Родитель.Наименование ПОДОБНО ""%Агентство%"")
	               |	И НЕ ПодразделенияОрганизаций.Ссылка В
	               |				(ВЫБРАТЬ
	               |					ПодразделенияОрганизаций.Ссылка
	               |				ИЗ
	               |					Справочник.ПодразделенияОрганизаций КАК ПодразделенияОрганизаций
	               |				ГДЕ
	               |					ПодразделенияОрганизаций.Родитель.Наименование = ""Представительство г.Уфа"")
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВТ_ПредварительныеДанные.Подразделение КАК Подразделение,
	               |	ВТ_ПредварительныеДанные.Руководитель КАК Руководитель,
	               |	ТекущиеКадровыеДанныеСотрудников.ДатаУвольнения КАК ДатаУвольнения
	               |ИЗ
	               |	ВТ_ПредварительныеДанные КАК ВТ_ПредварительныеДанные
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ТекущиеКадровыеДанныеСотрудников КАК ТекущиеКадровыеДанныеСотрудников
	               |		ПО ВТ_ПредварительныеДанные.Руководитель = ТекущиеКадровыеДанныеСотрудников.Сотрудник
	               |ГДЕ
	               |	ВТ_ПредварительныеДанные.Закрыто = 1
	               |	И ТекущиеКадровыеДанныеСотрудников.ДатаУвольнения < &ТекущаяДата
	               |	И ТекущиеКадровыеДанныеСотрудников.ДатаУвольнения <> ДАТАВРЕМЯ(1, 1, 1)
	               |	И НЕ ВТ_ПредварительныеДанные.Подразделение В (&ПодразделениеАГЕНТЫ_ШТАТ)
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВТ_ПредварительныеДанные.Подразделение КАК Подразделение
	               |ИЗ
	               |	ВТ_ПредварительныеДанные КАК ВТ_ПредварительныеДанные
	               |ГДЕ
	               |	ВТ_ПредварительныеДанные.Закрыто = 1
	               |	И ВТ_ПредварительныеДанные.Руководитель ЕСТЬ NULL
	               |	И НЕ ВТ_ПредварительныеДанные.Подразделение В (&ПодразделениеАГЕНТЫ_ШТАТ)
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |УНИЧТОЖИТЬ ВТ_СВОЙСТВА
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |УНИЧТОЖИТЬ ВТ_ПредварительныеДанные";
	Запрос.УстановитьПараметр("ТекущаяДата",ТекущаяДата());
	Запрос.УстановитьПараметр("ПодразделениеАГЕНТЫ_ШТАТ", ПодразделениеАГЕНТЫ_ШТАТ);
	
	Результат = Запрос.ВыполнитьПакет();
	Если НЕ Результат.Количество()= 0 Тогда 
		ТекстПисьма = "";
		// Уволенные руководители
		УволенныеРуководители = Результат[2].Выгрузить();
		Если УволенныеРуководители.Количество()>0 Тогда 
			ТекстПисьма = ТекстПисьма + "В следующих подразделениях указаны руководители, которые были уволены на текущий момент: " + Символы.ПС;
			сч = 1;
			Для Каждого СтрокаДанных Из УволенныеРуководители Цикл 
				ТекстПисьма = ТекстПисьма + Символы.ВТаб +?(сч=1, "", Символы.ПС)+ сч + ". " + СтрокаДанных.Подразделение + "; " + СтрокаДанных.Руководитель + "; Дата увольнения: " + Формат(СтрокаДанных.ДатаУвольнения,"ДФ=dd.MM.yyyy");
				сч = сч + 1;
			КонецЦикла;			
			
			ТекстПисьма = ТекстПисьма + Символы.ПС + Символы.ВТаб + Символы.ВК;
		КонецЕсли;
		
		НезаполненныеРуководители = Результат[3].Выгрузить();
		Если НезаполненныеРуководители.Количество()>0 Тогда 
			ТекстПисьма = ТекстПисьма + "Для следующих подразделений не указаны руководители:" + Символы.ПС;
			сч = 1;
			Для Каждого СтрокаДанных Из НезаполненныеРуководители Цикл 
				ТекстПисьма = ТекстПисьма + Символы.ВТаб + сч + ". " +СтрокаДанных.Подразделение + Символы.ПС;
				сч = сч + 1;
			КонецЦикла;
		КонецЕсли;
		
		Если ПустаяСтрока(ТекстПисьма) Тогда 
			Возврат;
		КонецЕсли;
				
		ТемаПисьма = "Необходимо скорректировать руководителей подразделений";
		
		ДолжностьЗаместителяНачальникаОтделаКадров = ОпределитьДолжность("Заместитель начальника отдела /Отдел кадрового администрирования/");
		
		ПолучателиКопииПисьма = Новый Массив;
		ПолучателиКопииПисьма.Добавить("rartamonov@ppfinsurance.ru");
		ПолучателиКопииПисьма.Добавить("mponomarev@ppfinsurance.ru");
		
		ПолучателиПисьма = Новый Массив;
		
		ЗапросПочта = Новый Запрос;
		ЗапросПочта.Текст = "ВЫБРАТЬ
		|	КадроваяИсторияСотрудниковСрезПоследних.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ФизическиеЛицаКонтактнаяИнформация.АдресЭП КАК АдресЭП
		|ИЗ
		|	РегистрСведений.КадроваяИсторияСотрудников.СрезПоследних КАК КадроваяИсторияСотрудниковСрезПоследних
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ФизическиеЛица.КонтактнаяИнформация КАК ФизическиеЛицаКонтактнаяИнформация
		|		ПО КадроваяИсторияСотрудниковСрезПоследних.ФизическоеЛицо = ФизическиеЛицаКонтактнаяИнформация.Ссылка
		|ГДЕ
		|	КадроваяИсторияСотрудниковСрезПоследних.ДолжностьПоШтатномуРасписанию = &Должность
		|	И ФизическиеЛицаКонтактнаяИнформация.Вид = &EmailРабочий";
		ЗапросПочта.УстановитьПараметр("Должность",ДолжностьЗаместителяНачальникаОтделаКадров);
		ЗапросПочта.УстановитьПараметр("EmailРабочий",Справочники.ВидыКонтактнойИнформации.НайтиПоНаименованию("Email (рабочий)"));
		Результат = ЗапросПочта.Выполнить();
		Если Не Результат.Пустой() Тогда 
			Выборка = Результат.Выбрать();
			Если Выборка.Следующий() Тогда  
				ПолучателиПисьма.Добавить(Выборка.АдресЭП);
			КонецЕсли;
		КонецЕсли;  
		
		ППФ_Сервер.ОтправитьПисьмо(ПолучателиПисьма, ТемаПисьма, ТекстПисьма, ПолучателиКопииПисьма);
		
	КонецЕсли;
	
КонецПроцедуры

Функция ОпределитьДолжность(Должность)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ШтатноеРасписание.Ссылка КАК Ссылка
	               |ИЗ
	               |	Справочник.ШтатноеРасписание КАК ШтатноеРасписание
	               |ГДЕ
	               |	ШтатноеРасписание.Наименование = &Должность
	               |	И ШтатноеРасписание.Утверждена
	               |	И НЕ ШтатноеРасписание.Закрыта";
	Запрос.УстановитьПараметр("Должность",Должность);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл 
		Возврат Выборка.Ссылка;
	КонецЦикла;
	
	Возврат Неопределено;
КонецФункции