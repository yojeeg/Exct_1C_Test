﻿////////////////////////////////////////////
//ПРОЦЕДУРЫ И ФУНКЦИИ ФОРМЫ
////////////////////////////////////////////

&НаКлиенте
Процедура Запустить(Команда)
	ЗапуститьНаСервере();
КонецПроцедуры

////////////////////////////////////////////

////////////////////////////////////////////
//СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
////////////////////////////////////////////

&НаСервере
Процедура ЗапуститьНаСервере()
	Обработка().ВыполнитьКоманду();
КонецПроцедуры


&НаСервере
Функция Обработка() 
	Возврат РеквизитФормыВЗначение("Объект");
КонецФункции

////////////////////////////////////////////
