﻿
&НаКлиенте
Процедура ПечатьДокумента(Команда)
	ПечатьДокумента_Сервер();
КонецПроцедуры

&НаСервере
Процедура ПечатьДокумента_Сервер()
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	МассивОбъектов = Новый Массив;
	МассивОбъектов.Добавить(Объект.СсылкаНаОбъект);
	ОбъектыПечати =Новый СписокЗначений;
	ОбъектыПечати.ЗагрузитьЗначения(МассивОбъектов);
	ОбработкаОбъект.Печать(МассивОбъектов, Неопределено, ОбъектыПечати, Неопределено);
КонецПроцедуры
