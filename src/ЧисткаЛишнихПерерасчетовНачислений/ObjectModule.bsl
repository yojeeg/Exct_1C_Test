﻿////////////////////////////////////////////////////////
//РЕГИСТРАЦИЯ ОБРАБОТКИ
////////////////////////////////////////////////////////

Функция СведенияОВнешнейОбработке() Экспорт
	
	Назначения = Новый Массив ;
	Назначения.Добавить("Документ.НачислениеЗарплаты") ;
	
	ПараметрыРегистрации = Новый Структура ;
	ПараметрыРегистрации.Вставить("Вид","ЗаполнениеОбъекта");
	ПараметрыРегистрации.Вставить("Назначение",Назначения);
	ПараметрыРегистрации.Вставить("Наименование","Удалить лишние перерасчеты начислений");
	ПараметрыРегистрации.Вставить("Версия","1.0");
	ПараметрыРегистрации.Вставить("Информация","Удаление лишних перерасчетов начислений в Начислении зарплаты");
	ПараметрыРегистрации.Вставить("БезопасныйРежим",Истина);
	
	Команды = ПолучитьТаблицуКоманд() ;
	ДобавитьКоманду(Команды, "Удалить лишние перерасчеты начислений","УдалитьЛишниеПерерасчетыНачислений","ВызовКлиентскогоМетода",Ложь,) ;
	
	ПараметрыРегистрации.Вставить("Команды",Команды) ;
	
	Возврат ПараметрыРегистрации;
	
КонецФункции

Функция ПолучитьТаблицуКоманд()
	Команды = Новый ТаблицаЗначений ;
	Команды.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка")) ;
	Команды.Колонки.Добавить("Идентификатор", Новый ОписаниеТипов("Строка")) ;
	Команды.Колонки.Добавить("Использование", Новый ОписаниеТипов("Строка")) ;
	Команды.Колонки.Добавить("ПоказыватьОповещение", Новый ОписаниеТипов("Булево")) ;
	Команды.Колонки.Добавить("Модификатор", Новый ОписаниеТипов("Строка")) ;
	Возврат Команды ;
КонецФункции	

Процедура ДобавитьКоманду(ТаблицаКоманд, Представление, Идентификатор, Использование, ПоказыватьОповещение = Ложь, Модификатор = "")
	НоваяКоманда = ТаблицаКоманд.Добавить() ;
	НоваяКоманда.Представление = Представление ;
	НоваяКоманда.Идентификатор = Идентификатор ;
	НоваяКоманда.Использование = Использование ;
	НоваяКоманда.ПоказыватьОповещение = ПоказыватьОповещение ;
	НоваяКоманда.Модификатор = Модификатор ;
КонецПроцедуры	

////////////////////////////////////////////////////////