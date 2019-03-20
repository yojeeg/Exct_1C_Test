﻿
&НаКлиенте
Процедура СкрытьУволенныхСотрудников(Команда)
	СкрытьУволенныхСотрудниковНаСервере();
КонецПроцедуры

&НаСервере
Процедура СкрытьУволенныхСотрудниковНаСервере()
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Период", Объект.Дата);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СостоянияСотрудниковСрезПоследних.Сотрудник КАК Сотрудник
	|ИЗ
	|	РегистрСведений.СостоянияСотрудников.СрезПоследних(
	|			,
	|			Сотрудник В
	|				(ВЫБРАТЬ
	|					Сотрудники.Ссылка
	|				ИЗ
	|					Справочник.Сотрудники КАК Сотрудники
	|				ГДЕ
	|					Сотрудники.ВАрхиве = ЛОЖЬ)) КАК СостоянияСотрудниковСрезПоследних
	|ГДЕ
	|	СостоянияСотрудниковСрезПоследних.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияСотрудника.Увольнение)
	|	И СостоянияСотрудниковСрезПоследних.Период <= &Период
	|
	|УПОРЯДОЧИТЬ ПО
	|	Сотрудник
	|АВТОУПОРЯДОЧИВАНИЕ";
	
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		Выгрузка = Результат.Выгрузить();
		Для Каждого Строка Из Выгрузка Цикл
			СпрСотрудник = Строка.Сотрудник.ПолучитьОбъект();
			СпрСотрудник.ВАрхиве = Истина;
			СпрСотрудник.ОбменДанными.Загрузка = Истина;
			СпрСотрудник.Записать();
		КонецЦикла;
	КонецЕсли; 
КонецПроцедуры
