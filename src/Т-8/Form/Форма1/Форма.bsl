﻿
&НаСервере
Процедура ПечатьДНаСервере()
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	МассивОбъектов = Новый Массив;
	МассивОбъектов.Добавить(Объект.СсылкаНаОбъект);
	ОбъектыПечати =Новый СписокЗначений;
	ОбъектыПечати.ЗагрузитьЗначения(МассивОбъектов);
	КоллекцияПечатныхФорм = УправлениеПечатью.ПодготовитьКоллекциюПечатныхФорм("ПФ_MXL_Т8");
	ОбработкаОбъект.Печать(МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, Неопределено);

КонецПроцедуры

&НаКлиенте
Процедура ПечатьД(Команда)
	ПечатьДНаСервере();
КонецПроцедуры
