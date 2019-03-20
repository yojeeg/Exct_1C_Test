﻿Функция СведенияОВнешнейОбработке() Экспорт
	
	ПараметрыРегистрации = ДополнительныеОтчетыИОбработки.СведенияОВнешнейОбработке();
	ПараметрыРегистрации.Вид = ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиДополнительнаяОбработка();
	ПараметрыРегистрации.Наименование = ЭтотОбъект.Метаданные().Синоним;
	ПараметрыРегистрации.Версия = "1.00";
	ПараметрыРегистрации.Информация = ЭтотОбъект.Метаданные().Синоним;
	ПараметрыРегистрации.БезопасныйРежим = Ложь;
	
	Команда = ПараметрыРегистрации.Команды.Добавить();
	Команда.Использование = ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыВызовСерверногоМетода();
	Команда.Представление = ЭтотОбъект.Метаданные().Синоним;
	Команда.Идентификатор = ЭтотОбъект.Метаданные().Имя;
	
	Возврат ПараметрыРегистрации;	
	
КонецФункции

Процедура ВыполнитьКоманду(ИдентификаторКоманды = Неопределено, СотрудникКПриему = Неопределено) Экспорт
	ППФ_КапиталОбменДаннымиСRP1.КапиталЗагрузкаДанныхИзRP1();
КонецПроцедуры