﻿/////////////////////////////////////////////////////////////////////////////
// ОПИСАНИЕ ИНТЕРФЕЙСОВ
Функция СведенияОВнешнейОбработке() Экспорт
	
	ПараметрыРегистрации = ДополнительныеОтчетыИОбработки.СведенияОВнешнейОбработке();
	ПараметрыРегистрации.Вид = ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиДополнительнаяОбработка();
	ПараметрыРегистрации.Наименование = ЭтотОбъект.Метаданные().Синоним;
	ПараметрыРегистрации.Версия = "1.01";
	ПараметрыРегистрации.Информация = ЭтотОбъект.Метаданные().Синоним;
	ПараметрыРегистрации.БезопасныйРежим = Ложь;
	
	Команда = ПараметрыРегистрации.Команды.Добавить();
	Команда.Использование = ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыОткрытиеФормы();
	Команда.Представление = ЭтотОбъект.Метаданные().Синоним;
	Команда.Идентификатор = ЭтотОбъект.Метаданные().Имя;
	
	Возврат ПараметрыРегистрации;	
	
КонецФункции
