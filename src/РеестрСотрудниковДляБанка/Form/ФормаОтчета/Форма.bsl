﻿
&НаСервере
Процедура СформироватьНаСервере()
	ЭтаФорма.ТабДок.Очистить();
	Объект1 = РеквизитФормыВЗначение("Отчет");
	ДокументРезультат = Объект1.СформироватьОтчет();
	Если Не ДокументРезультат=Неопределено Тогда 
		ЭтаФорма.ТабДок.Вывести(ДокументРезультат);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
	СформироватьНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЭтотОбъект.Отчет.НачалоПериода = ТекущаяДата();
КонецПроцедуры
