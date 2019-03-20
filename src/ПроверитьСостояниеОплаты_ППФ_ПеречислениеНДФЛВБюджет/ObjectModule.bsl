﻿Функция СведенияОВнешнейОбработке() Экспорт
	
   РегистрационныеДанные = Новый Структура;
   РегистрационныеДанные.Вставить("Наименование", "Проверить состояние оплаты  по документу ППФ перечисление НДФЛ в Бюджет");
   РегистрационныеДанные.Вставить("БезопасныйРежим", Ложь);
   РегистрационныеДанные.Вставить("Версия", "1.0");
   РегистрационныеДанные.Вставить("Вид", "ДополнительнаяОбработка");
   РегистрационныеДанные.Вставить("Информация", "Проверить состояние оплаты  по документу ППФ перечисление НДФЛ в Бюджет");
   
   Команды = Новый ТаблицаЗначений;
   Команды.Колонки.Добавить("Идентификатор");
   Команды.Колонки.Добавить("Представление");
   Команды.Колонки.Добавить("Модификатор");
   Команды.Колонки.Добавить("ПоказыватьОповещение");
   Команды.Колонки.Добавить("Использование");
   
   Команда = Команды.Добавить();
   Команда.Идентификатор = "1";
   Команда.Представление = "Проверить состояние оплаты  по документу ППФ перечисление НДФЛ в Бюджет";
   Команда.ПоказыватьОповещение = Истина;
   Команда.Использование = "ВызовСерверногоМетода";
   
   РегистрационныеДанные.Вставить("Команды", Команды);
   
   Возврат РегистрационныеДанные;
   
КонецФункции

Процедура ВыполнитьКоманду(ИдентификаторКоманды = Неопределено) Экспорт
	
	//ИдентификаторПроцесса = НачатьПроцесс("");
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ППФ_ПеречислениеНДФЛВБюджет.Номер КАК Номер,
	|	ППФ_ПеречислениеНДФЛВБюджет.ДатаПлатежа КАК ДатаПлатежа,
	|	ППФ_ПеречислениеНДФЛВБюджет.Сумма КАК Сумма,
	|	ППФ_ПеречислениеНДФЛВБюджет.РегистрацияВНалоговомОргане.КодПоОКТМО КАК ОКТМО,
	|	ППФ_ПеречислениеНДФЛВБюджет.РегистрацияВНалоговомОргане.КПП КАК КПП
	|ИЗ
	|	Документ.ППФ_ПеречислениеНДФЛВБюджет КАК ППФ_ПеречислениеНДФЛВБюджет
	|ГДЕ
	|	ППФ_ПеречислениеНДФЛВБюджет.Проведен
	|	И НЕ ППФ_ПеречислениеНДФЛВБюджет.Состояние В (""Оплачено"", ""Отклонено"")
	|	И ППФ_ПеречислениеНДФЛВБюджет.Дата > &ДатаПроверки";
	
	ДатаПроверки = ТекущаяДата() - 7*24*60*60; // за 7 дней
	Запрос.УстановитьПараметр("ДатаПроверки",ДатаПроверки);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		ТЗЗУП = РезультатЗапроса.Выгрузить();
		ППФ_Сервер.ПроверитьСостояниеОплаты_ППФ_ПеречислениеНДФЛВБюджет(ТЗЗУП);
	КонецЕсли;
	
КонецПроцедуры

