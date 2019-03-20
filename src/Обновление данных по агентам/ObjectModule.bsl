﻿Функция СведенияОВнешнейОбработке() Экспорт
	
   РегистрационныеДанные = Новый Структура;
   
   РегистрационныеДанные.Вставить("Наименование", 		НСтр("ru = 'Обновление данных по агентам'"));
   РегистрационныеДанные.Вставить("БезопасныйРежим", 	Ложь);
   РегистрационныеДанные.Вставить("Версия", 			"3.0");
   РегистрационныеДанные.Вставить("Вид", 				"ДополнительнаяОбработка");
   РегистрационныеДанные.Вставить("Информация", 		НСтр("ru = 'Обновление данных по агентам'"));
   
   Команды = Новый ТаблицаЗначений;
   Команды.Колонки.Добавить("Идентификатор");
   Команды.Колонки.Добавить("Представление");
   Команды.Колонки.Добавить("Модификатор");
   Команды.Колонки.Добавить("ПоказыватьОповещение");
   Команды.Колонки.Добавить("Использование");
   
   Команда 						= Команды.Добавить();
   Команда.Идентификатор 		= "1";
   Команда.Представление 		= НСтр("ru = 'Обновление данных по агентам'");
   Команда.ПоказыватьОповещение = Истина;
   Команда.Использование 		= "ВызовСерверногоМетода";
   
   РегистрационныеДанные.Вставить("Команды", Команды);
   
   Возврат РегистрационныеДанные;
   
КонецФункции

Процедура ВыполнитьКоманду(ИдентификаторКоманды = Неопределено) Экспорт

	ВыполнитьОбновление();	
	
КонецПроцедуры

Процедура ВыполнитьОбновление() Экспорт
	
	Соединение = ППФ_Сервер.УстановитьСоединение("RP1");
	Если Соединение = Неопределено Тогда
		ЗаписьЖурналаРегистрации("Синхронизация с RP1", УровеньЖурналаРегистрации.Ошибка,,,"Не удалось установить соединение с RP1. Данные по агентам не могут быть обновлены");										
		ОтправитьПисьмо(Истина, "Не удалось установить соединение с RP1. Данные по агентам не могут быть обновлены");
		Возврат;
	КонецЕсли;
		
		ОбновитьСправочникКаналыПродаж(Соединение);
		
		ВсеСотрудникиОрганизации 		= ПолучитьВсехСотрудниковОрганизации();
		ЗарплатныйПроект 				= Константы.ППФ_ЗарплатныйПроектАгентов.Получить();
		Организация 	 				= Справочники.Организации.ОрганизацияПоУмолчанию();
		ВсеСтраныМира 					= ПолучитьВсеСтраныМира();
		ПаспортРФ 						= Справочники.ВидыДокументовФизическихЛиц.ПаспортРФ;
		ВсеКаналыПродаж 				= ПолучитьВсеКаналыПродаж();		
		ВсеЗарплатныеПроектыПоБИКБанков = ПолучитьВсеЗарплатныеПроектыПоБИКБанков();
	
		Если ВсеСотрудникиОрганизации <> Неопределено И ТипЗнч(ВсеСотрудникиОрганизации) = Тип("ТаблицаЗначений") И ВсеСотрудникиОрганизации.Количество() > 0 Тогда			
			
			РезультатОчисткиТаблицы = ППФ_Сервер.RP1_ВыполнитьЗапрос("DELETE FROM t_dealer_1c_txt", Соединение);
			
			//////////////////////////////////////////////////
			// Получение данных и заполнение таблиц для записи
			////////////////////////////////////////////////// 
			
			ИнформацияПоАгентам = ППФ_Сервер.RP1_ПолучитьРезультатЗапроса("exec p_dealer_1c_delta2", Соединение);
			Если ТипЗнч(ИнформацияПоАгентам) = Тип("ТаблицаЗначений") И ИнформацияПоАгентам.Количество()>0 Тогда
				
				//////////////////////////////////////////////////
				// Очистка таблиц
				////////////////////////////////////////////////// 						
				ЛицевыеСчетаАгентскаяСеть.Очистить();
				МестаВыплатыЗарплатыСотрудников.Очистить();
				РолиСотрудников.Очистить();
				ФИОФизическихЛиц.Очистить();
				ГражданствоФизическихЛиц.Очистить();
				ДокументыФизическихЛиц.Очистить();
				ППФ_СоответствиеАгентовиМВЗ.Очистить();
				ППФ_СоответствиеАгентовИКаналовПродаж.Очистить();
				
				#Область ПолучениеДанныхДляЗаписи
				Для Каждого Агент Из ИнформацияПоАгентам Цикл
					
					ДанныеСотрудника 		= ПолучитьДанныеСотрудникаПоКоду(СокрЛП(Агент.number), ВсеСотрудникиОрганизации);							
					Если ДанныеСотрудника = Неопределено Тогда								
						Продолжить;                           								
					КонецЕсли;
					
					ТекущееФизическоеЛицо 	= ДанныеСотрудника.ФизическоеЛицо;
					ТекущийСотрудник 		= ДанныеСотрудника.Сотрудник;
					АгентЯвляетсяШтатником  = ППФ_Сервер.АгентЯвляетсяШтатником(ТекущийСотрудник, ТекущееФизическоеЛицо);
					
					Если Не ПустаяСтрока(СокрЛП(Агент.acc_num)) И Не ПустаяСтрока(СокрЛП(Агент.bik)) И ЗначениеЗаполнено(ТекущееФизическоеЛицо) Тогда								
						Если Агент.channel_id = 2 Тогда	                                                       									
							НоваяСтрокаЛицевыеСчетаАгентскаяСеть = ЛицевыеСчетаАгентскаяСеть.Добавить();
							НоваяСтрокаЛицевыеСчетаАгентскаяСеть.ФизическоеЛицо = ТекущееФизическоеЛицо;
							НоваяСтрокаЛицевыеСчетаАгентскаяСеть.НомерЛицевогоСчета = СокрЛП(Агент.acc_num);   									
							Если ЗначениеЗаполнено(ТекущийСотрудник) Тогда                                     									
								НоваяСтрокаМестаВыплатыЗарплатыСотрудников = МестаВыплатыЗарплатыСотрудников.Добавить();
								НоваяСтрокаМестаВыплатыЗарплатыСотрудников.Сотрудник = ТекущийСотрудник;
								НоваяСтрокаМестаВыплатыЗарплатыСотрудников.ФизическоеЛицо = ТекущееФизическоеЛицо;
								НоваяСтрокаМестаВыплатыЗарплатыСотрудников.ЗарплатныйПроект = ЗарплатныйПроект;										
							КонецЕсли;									
						Иначе									
							НоваяСтрокаЛицевыеСчетаПрочие = ЛицевыеСчетаПрочие.Добавить();
							НоваяСтрокаЛицевыеСчетаПрочие.ФизическоеЛицо = ТекущееФизическоеЛицо;
							НоваяСтрокаЛицевыеСчетаПрочие.НомерЛицевогоСчета = СокрЛП(Агент.acc_num);
							НоваяСтрокаЛицевыеСчетаПрочие.ЗарплатныйПроект = ПолучитьЗарплатныйПроектПоБИКБанка(СокрЛП(Агент.bik), ВсеЗарплатныеПроектыПоБИКБанков);									
							Если ЗначениеЗаполнено(ТекущийСотрудник) Тогда									
								НоваяСтрокаМестаВыплатыЗарплатыСотрудников = МестаВыплатыЗарплатыСотрудников.Добавить();
								НоваяСтрокаМестаВыплатыЗарплатыСотрудников.Сотрудник = ТекущийСотрудник;
								НоваяСтрокаМестаВыплатыЗарплатыСотрудников.ФизическоеЛицо = ТекущееФизическоеЛицо;
								НоваяСтрокаМестаВыплатыЗарплатыСотрудников.ЗарплатныйПроект = НоваяСтрокаЛицевыеСчетаПрочие.ЗарплатныйПроект;										
							КонецЕсли;									
						КонецЕсли;    									
					КонецЕсли;
					
					//////////////////////////////////////////////////
					// Роли сотрудников
					////////////////////////////////////////////////// 
					
					Если ЗначениеЗаполнено(ТекущийСотрудник) Тогда             								
						НоваяСтрокаРольСотрудника = РолиСотрудников.Добавить();
						НоваяСтрокаРольСотрудника.Сотрудник = ТекущийСотрудник;								
					КонецЕсли;	
					
					//////////////////////////////////////////////////
					// Гражданство
					////////////////////////////////////////////////// 
					
					Если ЗначениеЗаполнено(ТекущееФизическоеЛицо) И Не ПустаяСтрока(Агент.nationality) И Не АгентЯвляетсяШтатником Тогда								
						СтранаМира = ПолучитьСтрануМираПоКодуАльфа3(СокрЛП(Агент.nationality), ВсеСтраныМира);			
						Если ЗначениеЗаполнено(ТекущееФизическоеЛицо) Тогда          									
							НоваяСтрокаГражданство = ГражданствоФизическихЛиц.Добавить();
							НоваяСтрокаГражданство.Страна 			= СтранаМира;
							НоваяСтрокаГражданство.ФизическоеЛицо 	= ТекущееФизическоеЛицо;
							НоваяСтрокаГражданство.Период 			= Агент.doc_date;									
						КонецЕсли;                                                   								
					КонецЕсли;
					
					//////////////////////////////////////////////////
					// ФИО физических лиц
					//////////////////////////////////////////////////
					
					Если ЗначениеЗаполнено(ТекущееФизическоеЛицо) И Не ПустаяСтрока(СокрЛП(Агент.surname)) И Не ПустаяСтрока(СокрЛП(Агент.forename)) И Не АгентЯвляетсяШтатником Тогда								
						НоваяСтрокаФИОФизическихЛиц = ФИОФизическихЛиц.Добавить();
						НоваяСтрокаФИОФизическихЛиц.ФизическоеЛицо 	= ТекущееФизическоеЛицо;
						НоваяСтрокаФИОФизическихЛиц.Имя 			= СокрЛП(Агент.forename);
						НоваяСтрокаФИОФизическихЛиц.Фамилия 		= СокрЛП(Агент.surname);
						НоваяСтрокаФИОФизическихЛиц.Отчество 		= СокрЛП(Агент.middle);  								
						Если Агент.doc_date <> Дата(1,1,1) Тогда									
							НоваяСтрокаФИОФизическихЛиц.Период = Агент.doc_date; 									
						Иначе                                                    									
							НоваяСтрокаФИОФизическихЛиц.Период = Агент.born_date;									
						КонецЕсли;                                               								
					КонецЕсли;
					
					//////////////////////////////////////////////////
					// Соответствие сотрудника и МВЗ
					//////////////////////////////////////////////////
					
					Если ЗначениеЗаполнено(ТекущийСотрудник) И Не ПустаяСтрока(СокрЛП(Агент.kostl)) Тогда    								
						МВЗ = Справочники.ППФ_МВЗ.НайтиПоКоду(СокрЛП(Агент.kostl));								
						Если ЗначениеЗаполнено(МВЗ) Тогда                          									
							НоваяСтрокаСоответствиеАгентовиМВЗ  			= ППФ_СоответствиеАгентовиМВЗ.Добавить();
							НоваяСтрокаСоответствиеАгентовиМВЗ.Сотрудник 	= ТекущийСотрудник;
							НоваяСтрокаСоответствиеАгентовиМВЗ.МВЗ			= МВЗ;
							НоваяСтрокаСоответствиеАгентовиМВЗ.Период		= НачалоМесяца(Агент.start_date);									
						КонецЕсли;                                                                           
					КонецЕсли;
					
					//////////////////////////////////////////////////
					// Документы физических лиц
					//////////////////////////////////////////////////
					
					Если ЗначениеЗаполнено(ТекущееФизическоеЛицо) И Строка(Агент.doc_type) = "5" И Не ПустаяСтрока(СокрЛП(Агент.doc_number)) И Не АгентЯвляетсяШтатником Тогда								
						НоваяСтрокаДокументыФизическихЛиц 					= ДокументыФизическихЛиц.Добавить();
						НоваяСтрокаДокументыФизическихЛиц.Период 			= Агент.doc_date;
						НоваяСтрокаДокументыФизическихЛиц.Физлицо 			= ТекущееФизическоеЛицо;
						НоваяСтрокаДокументыФизическихЛиц.Серия 			= Лев(Лев(СокрЛП(Агент.doc_number),4),2) + " " + Прав(Лев(СокрЛП(Агент.doc_number),4), 2);
						НоваяСтрокаДокументыФизическихЛиц.Номер				= Прав(СокрЛП(Агент.doc_number),6);
						НоваяСтрокаДокументыФизическихЛиц.ДатаВыдачи 		= Агент.doc_date;          
						НоваяСтрокаДокументыФизическихЛиц.КемВыдан			= СокрЛП(Агент.doc_author);
						НоваяСтрокаДокументыФизическихЛиц.КодПодразделения 	= СокрЛП(Агент.unit_code);								
					КонецЕсли;
					
					//////////////////////////////////////////////////
					// Соответствие агентов и каналов продаж 
					////////////////////////////////////////////////// 
					
					Если ЗначениеЗаполнено(ТекущееФизическоеЛицо) И Не ПустаяСтрока(СокрЛП(Агент.channel_id)) Тогда								
						КаналПродаж = ПолучитьКаналПродажПоКоду(СокрЛП(Агент.channel_id), ВсеКаналыПродаж);     								
						Если ЗначениеЗаполнено(КаналПродаж) Тогда									
							НоваяСтрокаСоответствиеАгентовИКаналовПродаж = ППФ_СоответствиеАгентовИКаналовПродаж.Добавить();
							НоваяСтрокаСоответствиеАгентовИКаналовПродаж.КаналПродаж = КаналПродаж;
							НоваяСтрокаСоответствиеАгентовИКаналовПродаж.ФизическоеЛицо = ТекущееФизическоеЛицо;									
						КонецЕсли;							
					КонецЕсли;    						
				КонецЦикла;
				
				#КонецОбласти
				
				#Область ЗаписьДанных
				//////////////////////////////////////////////////
				// Запись данных
				////////////////////////////////////////////////// 
				
				Если ЗначениеЗаполнено(ЗарплатныйПроект) И ЗначениеЗаполнено(Организация) Тогда
												
						
						ОчисткаЛицевыхСчетовАгентов();
						//////////////////////////////////////////////////
						// Лицевые счета
						////////////////////////////////////////////////// 
						
						ДанныеЛицевыеСчетаАгентскаяСеть = ЛицевыеСчетаАгентскаяСеть.Выгрузить();
						ДанныеЛицевыеСчетаАгентскаяСеть.Свернуть("ФизическоеЛицо,НомерЛицевогоСчета");
						ДанныеЛицевыеСчетаАгентскаяСеть.Сортировать("ФизическоеЛицо Возр");								
						
						Для Каждого Строка Из ДанныеЛицевыеСчетаАгентскаяСеть Цикл								
							Запись = РегистрыСведений.ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.СоздатьМенеджерЗаписи();
							ЗаполнитьЗначенияСвойств(Запись, Строка);
							Запись.Активность 			= Истина;
							Запись.ЗарплатныйПроект 	= ЗарплатныйПроект;
							Запись.Период 				= Дата(2010,1,1);
							Запись.Организация			= Организация;
							Запись.Банк 				= ЗарплатныйПроект.Банк;
							Попытка
								Запись.Записать(Истина);
							Исключение
								ЗаписьЖурналаРегистрации("Синхронизация с RP1", УровеньЖурналаРегистрации.Ошибка,,,"Ошибка записи лицевого счета " + Строка.НомерЛицевогоСчета + " для физ.лица " + Строка.ФизическоеЛицо + Строка.ФизическоеЛицо.Код);										
								ОтправитьПисьмо(Истина, "Ошибка записи лицевого счета " + Строка.НомерЛицевогоСчета + " для физ.лица " + Строка.ФизическоеЛицо + Строка.ФизическоеЛицо.Код);
							КонецПопытки;                                         																		
						КонецЦикла;
						
						ДанныеЛицевыеСчетаПрочие = ЛицевыеСчетаПрочие.Выгрузить();
						ДанныеЛицевыеСчетаПрочие.Свернуть("ФизическоеЛицо,НомерЛицевогоСчета,ЗарплатныйПроект");
						ДанныеЛицевыеСчетаПрочие.Сортировать("ФизическоеЛицо Возр");
						
						Для Каждого Строка Из ДанныеЛицевыеСчетаПрочие Цикл									
							Запись = РегистрыСведений.ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.СоздатьМенеджерЗаписи();
							ЗаполнитьЗначенияСвойств(Запись, Строка);
							Запись.Активность 			= Истина;
							Запись.Период 				= Дата(2010,1,1);
							Запись.Организация			= Организация;
							Запись.Банк 				= Строка.ЗарплатныйПроект.Банк;									
							Попытка
								Запись.Записать(Истина);
							Исключение
								ЗаписьЖурналаРегистрации("Синхронизация с RP1", УровеньЖурналаРегистрации.Ошибка,,,"Ошибка записи лицевого счета " + Строка.НомерЛицевогоСчета + " для физ.лица " + Строка.ФизическоеЛицо + Строка.ФизическоеЛицо.Код);										
								ОтправитьПисьмо(Истина, "Ошибка записи лицевого счета " + Строка.НомерЛицевогоСчета + " для физ.лица " + Строка.ФизическоеЛицо + Строка.ФизическоеЛицо.Код);
							КонецПопытки;                                  								
						КонецЦикла;  								
						
						//////////////////////////////////////////////////
						// Места выплаты зарплаты 
						////////////////////////////////////////////////// 
						
						ДанныеМестаВыплатыЗарплатыСотрудников = МестаВыплатыЗарплатыСотрудников.Выгрузить();
						ДанныеМестаВыплатыЗарплатыСотрудников.Свернуть("Сотрудник,ФизическоеЛицо,ЗарплатныйПроект");								
						
						Для Каждого Строка Из ДанныеМестаВыплатыЗарплатыСотрудников Цикл									
							Запись2 = РегистрыСведений.МестаВыплатыЗарплатыСотрудников.СоздатьМенеджерЗаписи();
							ЗаполнитьЗначенияСвойств(Запись2, Строка);
							Запись2.Активность 		= Истина;
							Запись2.Вид 			= Перечисления.ВидыМестВыплатыЗарплаты.ЗарплатныйПроект;
							Запись2.МестоВыплаты 	= Строка.ЗарплатныйПроект;
							Запись2.Записать(Истина);                      								
						КонецЦикла;  								
						
						//////////////////////////////////////////////////
						// Роли сотрудников
						//////////////////////////////////////////////////
						
						РольДоговорник = Перечисления.РолиСотрудников.Договорник;
						
						ДанныеРолиСотрудников = РолиСотрудников.Выгрузить();
						ДанныеРолиСотрудников.Свернуть("Сотрудник");
						
						Для Каждого Строка Из ДанныеРолиСотрудников Цикл
							МенеджерЗаписей = РегистрыСведений.РолиСотрудников.СоздатьМенеджерЗаписи();
							МенеджерЗаписей.Сотрудник 		= Строка.Сотрудник;
							МенеджерЗаписей.РольСотрудника 	= РольДоговорник;
							МенеджерЗаписей.Записать(Истина);  
						КонецЦикла;
						
						//////////////////////////////////////////////////
						// Текущие кадровые данные сотрудников
						//////////////////////////////////////////////////
						Для Каждого Строка Из ДанныеРолиСотрудников Цикл
							МенеджерЗаписей = РегистрыСведений.ТекущиеКадровыеДанныеСотрудников.СоздатьМенеджерЗаписи();
							МенеджерЗаписей.Сотрудник						 = Строка.Сотрудник;
							МенеджерЗаписей.ФизическоеЛицо					 = Строка.Сотрудник.ФизическоеЛицо;
							МенеджерЗаписей.ОсновноеРабочееМестоВОрганизации = Истина;
							МенеджерЗаписей.ГоловнаяОрганизация				 = Организация;
							МенеджерЗаписей.ТекущаяОрганизация				 = МенеджерЗаписей.ГоловнаяОрганизация;
							МенеджерЗаписей.Записать(Истина);  
						КонецЦикла;
						
						//////////////////////////////////////////////////
						// Гражданство физических лиц
						////////////////////////////////////////////////// 
						
						ДанныеГражданствоФизическихЛиц = ГражданствоФизическихЛиц.Выгрузить();
						ДанныеГражданствоФизическихЛиц.Свернуть("Страна,ФизическоеЛицо,Период");
						
						Для Каждого Строка Из ДанныеГражданствоФизическихЛиц Цикл									
							Запись4 = РегистрыСведений.ГражданствоФизическихЛиц.СоздатьМенеджерЗаписи();
							ЗаполнитьЗначенияСвойств(Запись4, Строка);
							Запись4.Записать(Истина);                 								
						КонецЦикла;  								
						
						//////////////////////////////////////////////////
						// ФИО Физических лиц
						////////////////////////////////////////////////// 
						
						ДанныеФИОФизическихЛиц = ФИОФизическихЛиц.Выгрузить();
						ДанныеФИОФизическихЛиц.Свернуть("ФизическоеЛицо,Период,Фамилия,Имя,Отчество");								
						
						Для Каждого Строка Из ДанныеФИОФизическихЛиц Цикл									
							Запись5 = РегистрыСведений.ФИОФизическихЛиц.СоздатьМенеджерЗаписи();
							ЗаполнитьЗначенияСвойств(Запись5, Строка);
							Запись5.Записать(Истина);                    								
						КонецЦикла;  																					
						
						//////////////////////////////////////////////////
						// Соответствие сотрудника и МВЗ
						////////////////////////////////////////////////// 
						
						ДанныеСоответствиеАгентовИМВЗ = ППФ_СоответствиеАгентовиМВЗ.Выгрузить();
						ДанныеСоответствиеАгентовИМВЗ.Свернуть("Сотрудник,Период,МВЗ");
						
						Для Каждого Строка Из ДанныеСоответствиеАгентовИМВЗ Цикл									
							Запись6 = РегистрыСведений.ППФ_СоответствиеАгентовиМВЗ.СоздатьМенеджерЗаписи();
							ЗаполнитьЗначенияСвойств(Запись6, Строка);
							Запись6.Записать(Истина);                           								
						КонецЦикла;  								
						
						//////////////////////////////////////////////////
						// Документы физических лиц
						//////////////////////////////////////////////////
						
						ДанныеДокументыФизическихЛиц = ДокументыФизическихЛиц.Выгрузить();
						ДанныеДокументыФизическихЛиц.Свернуть("Период,Физлицо,Серия,Номер,ДатаВыдачи,КемВыдан,КодПодразделения");
						
						Для Каждого Строка Из ДанныеДокументыФизическихЛиц Цикл									
							Запись7 = РегистрыСведений.ДокументыФизическихЛиц.СоздатьМенеджерЗаписи();
							ЗаполнитьЗначенияСвойств(Запись7, Строка);
							Запись7.ВидДокумента = ПаспортРФ;
							Запись7.ЯвляетсяДокументомУдостоверяющимЛичность = Истина;
							Запись7.Записать(Истина);								
						КонецЦикла;  								
						
						//////////////////////////////////////////////////
						// Соответствие агентов и каналов продаж  
						//////////////////////////////////////////////////
						
						ДанныеСоответствиеАгентовИКаналовПродаж = ППФ_СоответствиеАгентовИКаналовПродаж.Выгрузить();
						ДанныеСоответствиеАгентовИКаналовПродаж.Свернуть("ФизическоеЛицо,КаналПродаж");
						
						Для Каждого Строка Из ДанныеСоответствиеАгентовИКаналовПродаж Цикл									
							Запись8 = РегистрыСведений.ППФ_СоответствиеАгентовИКаналовПродаж.СоздатьМенеджерЗаписи();
							ЗаполнитьЗначенияСвойств(Запись8, Строка);
							Запись8.Записать(Истина);								
						КонецЦикла;  																
						ЗафиксироватьТранзакцию();
					
				КонецЕсли;
				
				#КонецОбласти
				
			КонецЕсли;      									
			
		КонецЕсли;
		
КонецПроцедуры // ВыполнитьОбновлениеЛицевыхСчетовАгентов()

Процедура ОбновитьСправочникКаналыПродаж(Соединение)
	
	ТекстЗапроса =  "select
					|	tdc_id as id, 
					|	tdc_name as name 
					|from 
					|	dbo.t_distribution_channel";
	
	КаналыПродаж = ППФ_Сервер.RP1_ПолучитьРезультатЗапроса(ТекстЗапроса, Соединение);	
	Если ТипЗнч(КаналыПродаж) = Тип("ТаблицаЗначений") Тогда                         		
		Если КаналыПродаж.Количество() > 0 Тогда                                     			
			Для Каждого Строка Из КаналыПродаж Цикл                                  				
				НайденныйОбъект = Справочники.ППФ_КаналыПродаж.НайтиПоКоду(СокрЛП(Строка.id));				
				Если Не НайденныйОбъект.Пустая() Тогда	
					ТекущийОбъет = НайденныйОбъект.ПолучитьОбъект();
				Иначе	
					ТекущийОбъет = Справочники.ППФ_КаналыПродаж.СоздатьЭлемент();
				КонецЕсли; 				
				ТекущийОбъет.Код 			= СокрЛП(Строка.id);
				ТекущийОбъет.Наименование 	= СокрЛП(Строка.name);
				ТекущийОбъет.Записать();			
			КонецЦикла; 			
		КонецЕсли;      		
	КонецЕсли;	
	
КонецПроцедуры // ОбновитьСправочникКаналыПродаж()

Функция ПолучитьВсехСотрудниковОрганизации()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Сотрудники.Код КАК Код,
	|	Сотрудники.ФизическоеЛицо КАК ФизическоеЛицо,
	|	Сотрудники.Ссылка КАК Сотрудник
	|ИЗ
	|	Справочник.Сотрудники КАК Сотрудники
	|ГДЕ
	|	Сотрудники.ППФ_Агент";        	
	Результат = Запрос.Выполнить();   	
	Если Не Результат.Пустой() Тогда		
		Возврат Результат.Выгрузить();		
	КонецЕсли; 
	
	Возврат Неопределено;
	
КонецФункции // ПолучитьВсехСотрудниковОрганизации()

Функция ПолучитьДанныеСотрудникаПоКоду(Код, ВсеСотрудникиОрганизации) 

	НайденныйСотрудник = ВсеСотрудникиОрганизации.НайтиСтроки(Новый Структура("Код", СокрЛП(Код)));
	Если НайденныйСотрудник.Количество() > 0 Тогда		
		Возврат Новый Структура("ФизическоеЛицо,Сотрудник", НайденныйСотрудник[0].ФизическоеЛицо, НайденныйСотрудник[0].Сотрудник);			
	КонецЕсли;                                                                                                                      	
	Возврат Неопределено;
	
КонецФункции // ПолучитьДанныеСотрудникаПоКоду()

Функция ПолучитьВсеСтраныМира()

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СтраныМира.Ссылка,
	|	СтраныМира.КодАльфа3
	|ИЗ
	|	Справочник.СтраныМира КАК СтраныМира";	
	Результат = Запрос.Выполнить(); 	
	Если Не Результат.Пустой() Тогда		
		Выгрузка = Результат.Выгрузить();
		Для Каждого Строка Из Выгрузка Цикл
			Строка.КодАльфа3 = СокрЛП(Строка.КодАльфа3);
		КонецЦикла;                 		
		Возврат Выгрузка;           		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

Функция ПолучитьСтрануМираПоКодуАльфа3(КодАльфа3, ВсеСтраныМира)
	
	Если ТипЗнч(ВсеСтраныМира) = Тип("ТаблицаЗначений") И ВсеСтраныМира.Количество() > 0 Тогда		
		НайденнаяСтранаМира = ВсеСтраныМира.НайтиСтроки(Новый Структура("КодАльфа3", СокрЛП(КодАльфа3)));
		Если НайденнаяСтранаМира.Количество() > 0 Тогда   					
			Возврат НайденнаяСтранаМира[0].Ссылка; 					
		КонецЕсли;    				
	КонецЕсли;
	
	Возврат Неопределено;	
	
КонецФункции

Функция ПолучитьПодразделениеОрганизацииПоКоду(Код, ВсеПодразделенияОрганизации) 	
	Если ТипЗнч(ВсеПодразделенияОрганизации) = Тип("ТаблицаЗначений") И ВсеПодразделенияОрганизации.Количество() > 0 Тогда				
		НайденноеПодразделениеОрганизации = ВсеПодразделенияОрганизации.НайтиСтроки(Новый Структура("Код", СокрЛП(Код)));
		Если НайденноеПодразделениеОрганизации.Количество() > 0 Тогда				
			Возврат НайденноеПодразделениеОрганизации[0].Ссылка;     				
		КонецЕсли;                                                   			
	КонецЕсли;
	
	Возврат Неопределено;	
КонецФункции

Функция ПолучитьВсеКаналыПродаж() 
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ППФ_КаналыПродаж.Ссылка,
	|	ППФ_КаналыПродаж.Код
	|ИЗ
	|	Справочник.ППФ_КаналыПродаж КАК ППФ_КаналыПродаж";	
	Результат = Запрос.Выполнить();                       	
	Если Не Результат.Пустой() Тогда
		Выгрузка = Результат.Выгрузить();                 		
		Для Каждого Строка Из Выгрузка Цикл               			
			Строка.Код = СокрЛП(Строка.Код);              		
		КонецЦикла;                                       		
		Возврат Выгрузка;                                  
	КонецЕсли; 
	
	Возврат Неопределено;	
	
КонецФункции

Функция ПолучитьКаналПродажПоКоду(Код, ВсеКаналыПродаж)
	                                                      
	Если ТипЗнч(ВсеКаналыПродаж) = Тип("ТаблицаЗначений") И ВсеКаналыПродаж.Количество() > 0 Тогда				
		НайденныйКаналПродаж = ВсеКаналыПродаж.НайтиСтроки(Новый Структура("Код", СокрЛП(Код)));
		Если НайденныйКаналПродаж.Количество() > 0 Тогда				
			Возврат НайденныйКаналПродаж[0].Ссылка;     				
		КонецЕсли;                                      			
	КонецЕсли;
	
	Возврат Неопределено;	
	
КонецФункции

Функция ПолучитьВсеЗарплатныеПроектыПоБИКБанков()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗарплатныеПроекты.Ссылка,
	|	ЗарплатныеПроекты.Банк.Код КАК Код
	|ИЗ
	|	Справочник.ЗарплатныеПроекты КАК ЗарплатныеПроекты";	
	Результат = Запрос.Выполнить();                         	
	Если Не Результат.Пустой() Тогда                        		
		Выгрузка = Результат.Выгрузить();
		Для Каждого Строка Из Выгрузка Цикл
			Строка.Код = СокрЛП(Строка.Код);	
		КонецЦикла;		
		Возврат Выгрузка;		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции // ПолучитьВсеЗарплатныеПроектыПоБИКБанков()

Функция ПолучитьЗарплатныйПроектПоБИКБанка(БИКБанка, ВсеЗарплатныеПроектыПоБИКБанков)
	
	Если ТипЗнч(ВсеЗарплатныеПроектыПоБИКБанков) = Тип("ТаблицаЗначений") И ВсеЗарплатныеПроектыПоБИКБанков.Количество() > 0 Тогда				
		НайденныйЗарплатныйПроект = ВсеЗарплатныеПроектыПоБИКБанков.НайтиСтроки(Новый Структура("Код", СокрЛП(БИКБанка)));              		
		Если НайденныйЗарплатныйПроект.Количество() > 0 Тогда                                                                           			
			Возврат НайденныйЗарплатныйПроект[0].Ссылка;                                                                                			
		КонецЕсли;                                                                                                                      		
	КонецЕсли;
	
	НовыйЗарплатныйПроект = СоздатьЗарплатныйПроектПоБИКБанка(БИКБанка);	
	ВсеЗарплатныеПроектыПоБИКБанков = ПолучитьВсеЗарплатныеПроектыПоБИКБанков();	
	Возврат НовыйЗарплатныйПроект;
	
КонецФункции // ПолучитьЗарплатныйПроектПоБИКБанка()

Функция СоздатьЗарплатныйПроектПоБИКБанка(БИКБанка) 
	
	НовыйЗарплатныйПроектОбъект = Справочники.ЗарплатныеПроекты.СоздатьЭлемент();
	НовыйЗарплатныйПроектОбъект.Банк = Справочники.КлассификаторБанковРФ.НайтиПоКоду(СокрЛП(БИКБанка));
	НовыйЗарплатныйПроектОбъект.Валюта = Справочники.Валюты.НайтиПоКоду("643");
	НовыйЗарплатныйПроектОбъект.ДатаДоговора = Дата(2010,1,1);
	НовыйЗарплатныйПроектОбъект.ИспользоватьЭлектронныйДокументооборотСБанком = Истина;
	НовыйЗарплатныйПроектОбъект.КодировкаФайла = Перечисления.КодировкаФайловОбменаПоЗарплатномуПроекту.UTF8;
	НовыйЗарплатныйПроектОбъект.НомерДоговора = "1";
	НовыйЗарплатныйПроектОбъект.Организация = Справочники.Организации.ОрганизацияПоУмолчанию();
	
	Если ЗначениеЗаполнено(НовыйЗарплатныйПроектОбъект.Банк) Тогда		
		НовыйЗарплатныйПроектОбъект.Наименование = НовыйЗарплатныйПроектОбъект.Банк.Наименование + " " + СокрЛП(БИКБанка);		
	Иначе                                                                                                                 		
		НовыйЗарплатныйПроектОбъект.Наименование = "Банк не найден! БИК: " + СокрЛП(БИКБанка);	                          		
	КонецЕсли;
	НовыйЗарплатныйПроектОбъект.ОбменДанными.Загрузка = Истина;	
	НовыйЗарплатныйПроектОбъект.Записать();
	
	Возврат НовыйЗарплатныйПроектОбъект.Ссылка;
	
КонецФункции

Процедура ОтправитьПисьмо(ЕстьОшибка = Ложь, КомментарийОбОшибке = Неопределено)
	
	ПараметрыПисьма = Новый Структура;
	ПараметрыПисьма.Вставить("Кому",  "RArtamonov@ppfinsurance.ru;MPonomarev@ppfinsurance.ru");
	ПараметрыПисьма.Вставить("Тема",  "Оповещение: Обновление лицевых счетов агентов");	
	
	Если Не ЕстьОшибка Тогда		
		ПараметрыПисьма.Вставить("Тело", "Выполнено успешно!");		
	Иначе                                                      		
		ПараметрыПисьма.Вставить("Тело", "Выполнено с ошибкой! " + КомментарийОбОшибке);		
	КонецЕсли;
	
	ДоступныеУчетныеЗаписи = РаботаСПочтовымиСообщениями.ДоступныеУчетныеЗаписи(Истина);
	Если ДоступныеУчетныеЗаписи.Количество() > 0 Тогда  
		РаботаСПочтовымиСообщениями.ОтправитьПочтовоеСообщение(ДоступныеУчетныеЗаписи[0].Ссылка, ПараметрыПисьма);		
	КонецЕсли;
	
КонецПроцедуры // ОтправитьПисьмо()

Процедура ОчисткаЛицевыхСчетовАгентов()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ТекущиеКадровыеДанныеСотрудников.ФизическоеЛицо КАК ФизическоеЛицо
	               |ПОМЕСТИТЬ ВТ_ФизикиШтатники
	               |ИЗ
	               |	РегистрСведений.ТекущиеКадровыеДанныеСотрудников КАК ТекущиеКадровыеДанныеСотрудников
	               |ГДЕ
	               |	(ТекущиеКадровыеДанныеСотрудников.ДатаУвольнения = ДАТАВРЕМЯ(1, 1, 1)
	               |			ИЛИ ТекущиеКадровыеДанныеСотрудников.ДатаУвольнения >= &ТекущаяДата)
	               |	И ТекущиеКадровыеДанныеСотрудников.ДатаПриема <> ДАТАВРЕМЯ(1, 1, 1)
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	Сотрудники.ФизическоеЛицо КАК ФизическоеЛицо
	               |ИЗ
	               |	Справочник.Сотрудники КАК Сотрудники
	               |ГДЕ
	               |	Сотрудники.ППФ_Агент
	               |	И НЕ Сотрудники.ФизическоеЛицо В
	               |				(ВЫБРАТЬ
	               |					ВТ_ФизикиШтатники.ФизическоеЛицо
	               |				ИЗ
	               |					ВТ_ФизикиШтатники КАК ВТ_ФизикиШтатники)
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |УНИЧТОЖИТЬ ВТ_ФизикиШтатники";
	Запрос.УстановитьПараметр("ТекущаяДата",ТекущаяДата());
	МассивФизиков = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ФизическоеЛицо");
	
	НачатьТранзакцию();
	
	НаборЗаписей = РегистрыСведений.ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.СоздатьНаборЗаписей();
	НаборЗаписей.Прочитать();
	Для Каждого Запись Из НаборЗаписей Цикл 
		Если Не МассивФизиков.Найти(Запись.ФизическоеЛицо) = Неопределено Тогда 
			НаборЗаписей.Удалить(Запись);
		КонецЕсли;
	КонецЦикла;
	НаборЗаписей.Записать();
	
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры
 