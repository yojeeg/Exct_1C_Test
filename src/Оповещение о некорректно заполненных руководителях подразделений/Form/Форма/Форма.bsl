﻿
&НаСервере
Процедура ПроверитьНаСервере()
	РеквизитФормыВЗначение("Объект").ВыполнитьКоманду();
КонецПроцедуры

&НаКлиенте
Процедура Проверить(Команда)
	ПроверитьНаСервере();
КонецПроцедуры
